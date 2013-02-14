$(function(){
  var snippet = '<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>';
  snippet += '<div data-show-video="true" id="bvinfo" data-use-accordion="false" data-accordion-target="" data-use-tabs="false" data-tab-target="" data-tab-type="" data-showdocuments="true" data-showdata="true" data-src="nodeRef=' + $(".showModal").attr("data-nodeRef") + '"></div>';
  $("#snippetCode").val(snippet);
  
});