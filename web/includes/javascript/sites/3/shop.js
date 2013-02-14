var targetAjax = "";
var hashHistory = {};
$(document).ready(function(){
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
	$(document).delegate('.brandFilter','click',function(e) {
		e.preventDefault();
    doFilter();
  });
  $(window).bind( 'hashchange', function( event ) {
	
  var hash_str = event.fragment,    
    p = location.hash;    
    if (Left(p,8) == "/http://") {
      oldBrowser = true;      
      p = p.replace("/" + $("#httpHost").val(),"");             
    }
    /*
     * End IE 7 fix
     */   
    if (p != "/" && p != "" && p != "#") {
        if (Left(p, 2) == "#!") {          
          var uriArray = p.split("!");
          if (uriArray.length > 1) {
            var windowName = uriArray[1].replace("#","");
            //console.log(windowName);
            var uri = uriArray[2];
          } else {
            var windowName = "mainPanel";
            var uri = uriArray[1];
          }                  
          console.log(hashHistory);   
          if (hashHistory[windowName] != undefined) {
            //console.log("history window exists");
            if (hashHistory[windowName][uri] != "" && hashHistory[windowName][uri] != undefined) {
              $("#" + windowName).html(hashHistory[windowName][uri]);
              // return true;
            }
          } else {
            hashHistory[windowName] = new Array();
          }                   
          $("#" + windowName).block();
          $.get(uri, function(data){
						$("#" + windowName).html("");
            $("#" + windowName).html(data);
            hashHistory[windowName][uri] = data;
            $("#" + windowName).unblock();
          })
      } else {
        //console.log(p);
      }
    }    
  });
	
})
function doFilter() {
	var brands = [];
	$(".brandFilter").each(function(){
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
		$.bbq.pushState($.param.querystring("!mainPanel!/mxtra/shop/category",currentQString,0));
	}	else {
		// there isn't a fragment, so build on the qString
    currentFragment["brands"] = brands.join(',');
    currentFragment["priceFrom"] = priceFrom
    currentFragment["priceTo"] = priceTo;
    $.bbq.pushState(currentFragment);
		console.log(currentFragment);
	}
	
}
function Left(str, n){
  if (n <= 0)
      return "";
  else if (n > String(str).length)
      return str;
  else
      return String(str).substring(0,n);
}