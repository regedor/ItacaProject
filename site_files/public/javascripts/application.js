
function add_comments_to(div_id, post_id){
  var skin = {};
  skin['FONT_FAMILY']                  = 'verdana,sans-serif';
  skin['BORDER_COLOR']                 = '#cccccc';
  skin['ENDCAP_BG_COLOR']              = "transparent";
  skin['ENDCAP_TEXT_COLOR']            = '#333333';
  skin['ENDCAP_LINK_COLOR']            = '#5577FF';
  skin['ALTERNATE_BG_COLOR']           = '#ffffff';
  skin['CONTENT_BG_COLOR']             = '#ffffff';
  skin['CONTENT_LINK_COLOR']           = '#5577FF';
  skin['CONTENT_TEXT_COLOR']           = '#333333';
  skin['CONTENT_SECONDARY_LINK_COLOR'] = '#5577FF';
  skin['CONTENT_SECONDARY_TEXT_COLOR'] = '#666666';
  skin['CONTENT_HEADLINE_COLOR']       = '#333333';
  skin['DEFAULT_COMMENT_TEXT']         = '- escreve aqui o teu coment\xe1rio -';
  skin['HEADER_TEXT']                  = 'Coment\xe1rios';
  skin['POSTS_PER_PAGE']               = '5';
  google.friendconnect.container.setParentUrl('/' /* location of rpc_relay.html and canvas.html */);
  google.friendconnect.container.renderWallGadget({ 
    id: div_id, 
    site: '05392788619253766326',
    'view-params': {
      "disableMinMax":"true",
      "scope":"ID",
      "features":"video,comment",
      "docId":post_id,
      "startMaximized":"true"
    }
  },skin);
  void 0
}

