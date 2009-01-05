// Accept javascript in response
//jQuery.ajaxSetup({ beforeSend: function(xhr) { xhr.setRequestHeader("Accept", "text/javascript"); } });

// Redirect to correct location based on anchor/hash if it starts with an underscore
if(location.hash && location.hash.match(/^#__/)) {
  window.location = anchorToPath(location.hash);
}

// Setup history listener
var firstPage = true;
var loadingPage = false;

// This function is called when:
//   1. after calling $.historyInit();
//   2. after calling $.historyLoad();
//   3. after pushing "Go Back" button of a browser
function historyListener(hash) {
	if(hash) {
	  var href = hash.replace(/__/g, '/')
	  firstPage = false;
	  $('#overview a.history-back').fadeIn('fast');
	} else {
	  // If we've got here directly i.e. fresh page load then return
	  if(firstPage == true) { return; }
	  // Start page
	  var href = window.location.pathname + window.location.search;
	  $('#overview a.history-back').fadeOut('fast');
  }
  // The click event must have loaded the page
  if(loadingPage) { return; }
  // If we get here then the back or forward buttons were pushed
  var anchor = $(document.createElement('a'));
  anchor.attr('rel', 'prev'); // TODO: work out if back or forward pressed
  anchor.attr('href', href);
  loadNewPage(anchor);
}
// end Setup history listener

function anchorToPath(anchor_string) {
  return anchor_string.replace(/__/g, '/').substr(1);
}

function goBack() {
  history.go(-1);
  return false;
}

function pxToEm(pixels) { return ((parseInt(pixels) / parseFloat($('#wrapper').css('font-size'))).toFixed(3) + 'em'); }

$(function() {
  loadPng($('#viewer .image img')[0]);
  $('#subcol ul').css('position', 'absolute');
  initPageClickEvent($('#subcol'));
  initPageClickEvent($('#viewer .pagination'));
  initPageClickEvent($('#nav'));
  
  // Accordion
  $('#summary').append('<a class="toggle" title="Toggle image panel">Toggle</a>').find('a.toggle').click(function() {
    $('#viewer').slideToggle('normal');
    $(this).toggleClass('collapsed');
    return false;
  });
  $('#overview').append('<a class="toggle" title="Toggle info panel">Toggle</a>').find('a.toggle').click(function() {
    $('#info').slideToggle('fast');
    $(this).toggleClass('collapsed');
    return false;
  });
  
  // Back button
  var overview = $('#overview');
  overview.append('<a class="history-back" title="Go back">&laquo; Back</a>');
  overview.find('a.history-back').click(goBack).hide();
  
  // Hide the non-history back button
  overview.find('p:first a.back').hide();
  
  // Home button
  $('#header').append('<a href="/" class="home" title="Homepage">Home</a>');
  
  // Create an info div if it doesn't already exist
  var info = $('#info');
  if(!info.length) {
    var div = $(document.createElement('div'));
    div.attr('id', 'info');
    $('#overview').before(div).find('a.toggle').hide();
    div.hide();
  }
  
  // Initialize history plugin.
	$.historyInit(historyListener);
	
	// Create piclens links for the current page
	initPicLensLinks();
  updatePicLensLinks(window.location.pathname);
	
  // Setup FancyZoom
  setupZoom();
});

$(window).load(function() {
  setTimeout(scrollTo, 0, 0, 1);
  // This needs to be in onload so we can be sure that #subcol has a height.
  $('#subcol').css('overflow', 'hidden').css('height', pxToEm($('#subcol ul').height()));
});

function initPageClickEvent(element) {
  element.unbind('click').click(function(e) {
    if(!e.target.pathname) { return; }
    var target    = $(e.target);
    var pathname  = e.target.pathname;

    if(target.attr('rel') == 'external') {
      target.attr('target', '_blank');
      return true;
    }
    
    // Do the 'actual' request when on session or subscription pages
    var body_id = $('body').attr('id');
    if(body_id == 'subscriptions' || body_id == 'sessions') { return true };
    
    // Generate hash from url
    var hash = pathname.replace(/\//g, '__');
  	if(hash.substr(0, 2) != '__') { hash = '__' + hash; } // ensure it starts with double hash (for IE)

    // Start the page loading here, before the history change is made as
    // otherwise the historyListener will load the page also.
    loadNewPage(target);
		$.historyLoad(hash);
    return false;
  });
}

function showInfo(info) {
  $('#info').slideUp('slow', function() {
    if(info) {
      $(this).html(info).slideDown('slow');
      $('#overview a.toggle').removeClass('collapsed').fadeIn('fast');
    } else {
      $('#overview a.toggle').fadeOut('fast');
    }
  });
}
 
function slideNavPanels(from, dest, direction) {
  switch(direction) {
    case 'next': var percentage =  100; break;
    case 'prev': var percentage = -100; break;
  }
  dest.css('left', percentage + '%' ).animate(
    { left: '0%' },
    { duration: 1000, easing: 'easeInOutQuint', complete: function() {
      // Get an array of all ul's with a class matching dest ul's class.
      var matches = $('#subcol ul.' + dest.attr('class'));
      // Get second from last match and remove it and all preceding ul's.
      if(matches.length > 1) $(matches[matches.length - 2]).prevAll().andSelf().remove();
    } }
  );
  from.css('left', '0%' ).animate(
    { left: (-percentage) + '%' },
    { duration: 1000, easing: 'easeInOutQuint' }
  );

  $('#subcol').animate(
    { height: pxToEm(dest.height()) },
    { duration: 500, easing: 'easeInOutQuint', complete: function() { $(this).css('overflow', 'hidden'); } }
  );
}

function initPicLensLinks() {
  var links = $('#viewer .links ul');
	if(!links.length) { var links = $('#viewer').append('<div class="links"><ul></ul></div>').find('div.links ul'); }
	
	if(!PicLensLite.hasClient()) {
		links.append(
	    '<li class="iris-install" rel="external"><a title="Install Cooliris for a better experience" href="http://www.cooliris.com">Install Cooliris for a better experience</a></li>'
	  );
		return;
	}
	
  var event = function() {
    PicLensLite.start({ feedUrl: '/rss' + $(this).attr('href') });
    return false;
  };
	
	// Add the view all in cooliris link
	if($('#subcol ul:last li.view-all-iris').length == 0) {
		$('#subcol ul:last').prepend(
		  '<li class="view-all-iris"><a>View all search results</a>'
		).find('li.view-all-iris a').click(event).parent().hide();
	}

  links.append(
    '<li class="iris-item"><a title="View current item in Cool Iris">Cool Iris for current item</a>'
  ).find('li.iris-item a').click(event).parent().hide();
  links.append(
    '<li class="iris"><a title="View current section in Cool Iris">Cool Iris for current section</a>'
  ).find('li.iris a').click(event).parent().hide();
  $('#header').append(
    '<a title="View current section in Cool Iris" class="iris">Cool Iris for current section</a>'
  ).find('a.iris').click(event).hide();
}

function updatePicLensLinks(loaded_url) {
  var body = $('body');

  var links = $('#viewer .links ul');

	// Note: setting the href to nothing so that it's link doesn't get hijacked by the zoom script.
	links.find('li.zoom a').attr('href', null).click(function() {
		// Trigger the image link click event.
    $('#viewer .image:last > a').click();
    return false;
  }).mouseover(function() {
  	// Preload the image on mouseover.
	  $('#viewer .image:last > a').mouseover();
  }).parent().fadeIn('slow');

  var back_url = $('#overview p a.back').attr('href');

  var zoom = links.find('li.zoom a');
  var item = links.find('li.iris-item a');
  var header = $('#header a.iris');
  var section = links.find('li.iris a');
	var view_all = $('#subcol ul:last li.view-all-iris a');

  if(body.attr('id') == 'resources') {
    
    // Resource index page
    if(((back_url == undefined) || (back_url.length == 0)) && body.hasClass('index')) {
      item.parent().fadeOut('fast'); // No item since we are on index page
      header.attr('href', loaded_url); // should be loaded page
      section.attr('href', loaded_url); // should be loaded page
			view_all.attr('href', loaded_url); // should be loaded page
  		if(PicLensLite.hasClient()) {
				header.fadeIn('slow');
	      section.parent().fadeIn('slow');
				view_all.parent().show();
			}
      zoom.parent().fadeOut('fast');
    } 
    
    // Resource & Associated Resource show page
    if((back_url != undefined) && (back_url.length > 0) && body.hasClass('show')) {
      item.attr('href', loaded_url); // should show items inside item
      //item.parent().fadeIn('slow'); // show item or associated item
      header.attr('href', back_url); // should be back url since a show page back url is always the index
      section.attr('href', back_url); // should be back url since a show page back url is always the index
			view_all.attr('href', back_url); // should be back url since a show page back url is always the index
			if(PicLensLite.hasClient()) {
      	header.fadeIn('slow');
      	section.parent().fadeIn('slow');
				view_all.parent().show();
			}

      if($('#viewer .image:last > a').length > 0) {
        zoom.parent().fadeIn('slow');
      }
    }
    
    // Associated Resource index page
    if((back_url != undefined) && (back_url.length > 0) && body.hasClass('index')) {
      item.attr('href', back_url); // will be resource show since you can only get here via one
      //item.parent().fadeIn('slow'); // No item since we are on index page
      header.attr('href', loaded_url); // should be loaded page
      section.attr('href', loaded_url); // should be loaded page
			view_all.attr('href', loaded_url); // should be loaded page
			if(PicLensLite.hasClient()) {
      	header.fadeIn('slow');
      	section.parent().fadeIn('slow');
				view_all.parent().show();
			}

      if($('#viewer .image:last > a').length > 0) {
        zoom.parent().fadeIn('slow');
      }   
    }
    
		var install_button_width = PicLensLite.hasClient() ? 0 : 120;
		
    $('#viewer div.links ul').width(($('#viewer div.links ul li:visible').length * 40) + install_button_width);
  } else {
    if(body.attr('id') != 'filters') {
      zoom.parent().fadeOut('fast');
      item.parent().fadeOut('fast');
      header.fadeOut('fast');
      section.parent().fadeOut('fast');
			view_all.parent().hide();
    }
  }
}

function loadNewPage(anchor) {
  var page_to = anchor.attr('rel') || anchor.attr('rev');
  if((!page_to) || anchor.hasClass('loading') || $('#viewer').hasClass('sliding')) return false;
  
  loadingPage = true;
  anchor.addClass('loading');
  var current_panel = $('#subcol ul:last');
  current_panel.click(function() { return false; });
    
  $.get(anchor.attr('href'), function(html) {
    var dom = $(html);
    
    var body_class = html.match(/<body\sid="[\w\-\_]*"\sclass=".*(index|show).*"/);
    if(body_class!=null) {
      body_class = body_class[1];
    }
    
    var data = {
      header:     dom.find('#header h1').html(),
      title:      $(html.match(/<title>.*<\/title>/)[0]).text(), // If a better solution is found change this
      body_id:    html.match(/<body\sid="([\w\-\_]*)"/)[1],
      body_class: body_class,
      nav:        dom.find('#nav').html(),
      viewer:     dom.find('#viewer .image'),
      links:      dom.find('#viewer .links ul'),
      pagination: dom.find('#viewer .pagination').html(),
      subcol:     dom.find('#subcol').html(),
      heading:    dom.find('#summary h2').html(),
      summary:    dom.find('#summary h3').html(),
      overview:   dom.find('#overview p:first').html(),
      info:       dom.find('#info').html()
    };
    
    $('body').attr('id', data.body_id); // If a better solution is found change this
    $('body').removeClass('show index');
    $('body').addClass(data.body_class);
    
    if(page_to == 'next' || page_to == 'prev') {
      var direction = page_to;
    } else {
      var direction = 'next';
    }    

    document.title = data.title;
    if(data.header) $('#header h1').html(data.header);
    $('#nav').html(data.nav);
    
    // Hide the image if it is just an icon
    if(page_to == 'divisions') {
      var toggle = $('#summary a.toggle:first');
      toggle.addClass('collapsed');
      $('#viewer').slideUp('fast');
    }
    
    // As long as the new image different to the old one, slide it in
    if($('#viewer .image:first img:first').attr('src') != $(data.viewer).find('img:first').attr('src')) {
      $('#viewer').append(data.viewer);
      if(page_to != 'divisions') { 
        $('#viewer').slideDown('slow');
        $('#summary a.toggle').removeClass('collapsed');
      }
      slideImages(direction);
    }

    var pagination = $('#viewer .pagination span a');
    function newContent() {
      $('#viewer .pagination').html(data.pagination);
      $('#viewer .pagination span a').hide().fadeIn('slow');
    };
    (pagination.length > 0) ? pagination.fadeOut('slow', newContent) : newContent();
    
    // Find or create links div
    var links = $('#viewer div.links ul')
    if(!links.length) { var links = $('#viewer').append('<div class="links"><ul></ul></div>').find('div.links ul'); }
    
    links.html(data.links.length ? data.links.html() : '');


    $('#subcol').append(data.subcol.replace(/\s+/g, '') ? data.subcol : document.createElement('ul'));
    $('#summary h2').html(data.heading);
    $('#summary h3').html(data.summary);
    $('#overview p:first').html(data.overview);
    
    if(dom.find('#overview').hasClass('call-to-action')) {
      $('#overview').addClass('call-to-action');
    } else {
      $('#overview').removeClass('call-to-action');
    }
    
    showInfo(data.info);
    
    anchor.removeClass('loading');
    $('#subcol ul').css('position', 'absolute');
    var child = $('#subcol ul:last');

   	// Add the view all in cooliris link
		if($('#subcol ul:last li.view-all-iris').length == 0) {
			$('#subcol ul:last').prepend(
			  '<li class="view-all-iris"><a>View all search results</a>'
			).find('li.view-all-iris a').click(function() {
			    PicLensLite.start({ feedUrl: '/rss' + $(this).attr('href') });
			    return false;
			}).parent().hide();
		}

    
    // Back button from markup (this is not the button on display so re-hide it)
    var href = dom.find('#overview p a.back').attr('href');
    if(href) $('#overview p a.back').attr('href', href).hide();
    
    initPicLensLinks();

    // Passing in new url
    updatePicLensLinks(anchor.attr('href'));
    
    slideNavPanels(current_panel, child, direction);

    loadingPage = false;
  });
}

function slideImages(rel) {
  var prev = $('#viewer .image:eq(0)');
  var next = $('#viewer .image:eq(1)');
  var viewer = $('#viewer');
  var pic_width = 300;
  var pad_width = ((viewer.width() - pic_width) / 2);
  
  if (rel == 'next') {
    var move = (pic_width + pad_width);
  } else if (rel == 'prev') {
    var move = -(pic_width + pad_width);
  }
  
  if(image = next.find('a img')[0]) {
    var enlarge = next.find('.enlarge');
    enlarge.hide();
    $(next.addClass('loading').find('a img')[0]).hide().load(function() {
      loadPng(this);
    
      // Fade in image if it is inside the viewport otherwise just show it
      if(next.position().left < next.width()) {
        $(this).fadeIn('normal');
        enlarge.fadeIn('normal');
      } else {
        $(this).show();
        enlarge.show();
      }
 
      initZoomyImage(next.find('a:first'));
      next.removeClass('loading');
    });
  }
  
  viewer.addClass('sliding');
  next.css('left', move).animate({ left: 0 }, { duration: 1000, easing: 'easeInOutQuint' });
  prev.css('left', 0).animate(
    { left: -move },
    { duration: 1000, easing: 'easeInOutQuint', complete: function() {
      $(this).remove();
      viewer.removeClass('sliding');
    } }
  );
}

function initZoomyImage(link) {
  link.click(function (event) { 
		return zoomClick(this, event); 
	});
  link.mouseover(function () { zoomPreload(this); });
}

/* IE PNG Fix */
function loadPng(obj, image, mode) {
  if (!obj) return;
  
  if (navigator.platform != "Win32" || navigator.appName != "Microsoft Internet Explorer") return;
  var result = navigator.appVersion.match(/MSIE (\d+\.\d+)/, '');
  if (!(result != null && Number(result[1]) >= 5.5 && Number(result[1]) < 7)) return;
  
  var filter = 'DXImageTransform.Microsoft.AlphaImageLoader';
  var spacer = '/images/bg_1x1.gif';
  var ok = false;
    
  if (obj.tagName == 'IMG') {
    if (obj.currentStyle.width == 'auto' && obj.currentStyle.height == 'auto') {
      obj.style.width  = obj.offsetWidth  + 'px';
      obj.style.height = obj.offsetHeight + 'px';
    }
    if (!image) image = obj.src;
    if (!mode) mode = 'crop';
    obj.src = spacer;
    var ok = true;
  } else if (obj.currentStyle.backgroundImage.match(/\.png/i) != null) {
    var bg = obj.currentStyle.backgroundImage;
    if (!image) image = bg.substring(5, bg.length-2);
    if (!mode) mode = 'scale';
    obj.style.backgroundImage = 'url(' + spacer + ')';
    // IE link fix.
    for (var n = 0; n < obj.childNodes.length; n++) {
      if (obj.childNodes[n].style) obj.childNodes[n].style.position = 'relative';
    }
    var ok = true
  }
  
  if (ok) obj.style.filter = 'progid:' + filter + '(src="' + image + '", sizingMethod="' + mode + '")';
}