$(document).ready(function () {
  var col_formats = new Array();
  var search_items = new Array();
  var table = $('#crudify-table');
  table.find('thead tr th').each(function () {
    var th = $(this);
    th.attr('width',th.width());
  });
  table.flexigrid();

  //    showToggleBtn: true,
//    colModel: col_formats,
//    searchitems: search_items,
//    sortname: col_formats[0].name,
//    sortorder: 'asc'
//  }); //colModel: col_formats, 
});
