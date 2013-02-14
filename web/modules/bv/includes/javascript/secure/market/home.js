$(document).ready(function(){
	$(".carousel").carousel();
	var min = parseInt($("#pricerange").attr("data-min"));
  var max = parseInt($("#pricerange").attr("data-max")); 
  var from = $("#price_from").val();
  var to = $("#price_to").val();
  $("#pricerange").slider({
    range: true,
    min: min,
    max: max,
    values: [from,to],
    slide: function(event,ui) {
      $("#amount").html("&pound;" + ui.values[0] + " - &pound;" + ui.values[1]);
    },
    change: function( event, ui ) {        
      $("#price_from").val(ui.values[0]);
      $("#price_to").val(ui.values[1]);     
      doFilter();
    }
  }); 
})
function doFilter() {
  var brands = [];
  $(".siteFilter").each(function(){
    if ($(this).hasClass("active")) {
      brands.push($(this).attr("data-brandID"));
    }
  })
  var priceFrom = $("#price_from").val();
  var priceTo = $("#price_to").val();
  var currentQString = $.deparam.querystring(); 
  var currentFragment = $.deparam.fragment();
  if ($.isEmptyObject(currentFragment)) {
    // there isn't a fragment, so build on the qString
    currentQString["brands"] = brands.join(','); 
    currentQString["priceFrom"] = priceFrom
    currentQString["priceTo"] = priceTo;
    $.bbq.pushState($.param.querystring("!marketListing!/bv/market/list",currentQString,0));
  } else {
    // there isn't a fragment, so build on the qString
    currentFragment["siteID"] = brands.join(',');
    currentFragment["priceFrom"] = priceFrom
    currentFragment["priceTo"] = priceTo;
    $.bbq.pushState(currentFragment);
    console.log(currentFragment);
  }
  
}
window.onscroll = function(){
  var scrollTop = $(window).scrollTop();
  if(scrollTop>90){
        $("#marketLeftMenu").css("position","fixed");
        $("#marketLeftMenu").css("top",10);
    }else{
        $("#marketLeftMenu").css("position","inherit");
        $("#marketLeftMenu").css("top",0);
    }
}
