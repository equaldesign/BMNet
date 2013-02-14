$(document).bind("mobileinit", function ()
  {
      $.mobile.ajaxEnabled = false;
   
      $('#pageTemp').live('pagebeforecreate', function (event) {
          return false;
      });
  })
$(document).ready(function() {	
		 
	prettyPrint();
	$("a[href='#']").live("click",function(){
		return false;
	})
	
	/* Ajax navigation controls */
	var targetAjax = "ajaxMain";	
  var originalContet =  $("#" + targetAjax).html();	
  var hashHistory = {};
	$('.popImg').popover({
		"html": true
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
    if (p == "") {
      $("#maincontent").html(originalContet);
    } else if (p != "/" && p != "" && p != "#" && Left($.address.value(),3) != "/ui") {
        if (Left(p, 2) == "#!") {          
          var uriArray = p.split("!");
          if (uriArray.length > 1) {
            var windowName = uriArray[1].replace("#","");
            //console.log(windowName);
            var uri = uriArray[2];
          } else {
            var windowName = "maincontent";
            var uri = uriArray[1];
          }                  
          //console.log(hashHistory);   
          if (hashHistory[windowName] != undefined) {
            //console.log("history window exists");
            if (hashHistory[windowName][uri] != "" && hashHistory[windowName][uri] != undefined) {
              $("#" + windowName).html(hashHistory[windowName][uri]);
              return true;
            }
          } else {
            hashHistory[windowName] = new Array();
          }         
          /*
          $("#psaM").hide();
          $("#right_dealTools").hide();
          */                        
          $("#" + windowName).block();
          $.get(uri, function(data){
            $("#" + windowName).html(data);
            hashHistory[windowName][uri] = data;
            $("#" + windowName).unblock();
          })
      } else {
        //console.log(p);
      }
    }    
  });
	
	$("#dialog a").live("click",function(event) {
    var ref = $(this).attr("href"); 
    var noAjax = $(this).hasClass("noAjax");
    if ($(this).closest(".cke_editor").length != 0) {
			noAjax = true;
		}
		if (!noAjax) {
      if ($(this).closest(".noAjax").length != 0) {
        noAjax = true;
      }
    } 
    if ($(this).attr("target") == "_blank") {
      return true;
    }
    if (ref == undefined || ref == "#") {
      ref = $(this).attr("rel");
    }
    if (ref == "" || ref == "#" || ref == undefined || Left(ref,10) == "javascript") {
      return;
    }
    if (!noAjax) {
      var targetWin = $(this).attr("rev");
      if (targetWin == "" || targetWin == null) {
        var win = $(this).closest(".ajaxWindow");
        if (win.length == 0) {
          // it wasn't in a window, so assume it's #whiteBox
          var windowName = "dialog";
        } else {
          var windowName = $(win).attr("id"); 
        }
      } else {
        var windowName = targetWin;           
      }
      // now stich the window Name and event together
      var historyObject = [];
      var uri = windowName + "!" + ref;           
      
      if (hashHistory[windowName] == undefined) {
        //console.log(windowName + " is not defined in Array");
        hashHistory[windowName] = new Array();
      }
      hashHistory[windowName][ref] = "";
      document.location.href = "#!" + uri;
      return false;
    }
  });
	

	$(".show").click(function(){
		$(".tree").each(function(){
			$(this).hide();
		})
		$("#" + $(this).attr("rel")).slideToggle();
		$(".w.pageheading h1").text($(this).attr("title"));
	})
	$(".popUp").live("click",function(event){
		var uri = $(this).attr("href");		
    $("#dialog").dialog({
      modal: true,
      title: "Message",
      width: 800,
      height: 600
    });
    $("#dialog").html("<img style='margin-top: 200px; margin-left: 190px' src='/includes/images/secure/ajax-loader.gif' />")
    $.get(uri, function(data){
      $("#dialog").html(data);
      $("#dialog").dialog("open");
    });	
		return false;	
	});
	$("a.main").live("click",function(){		
		$("a.main").each(function(){
			$(this).removeClass("active");
		})
		$(this).addClass("active");
	})

})
function Left(str, n){
  if (n <= 0)
      return "";
  else if (n > String(str).length)
      return str;
  else
      return String(str).substring(0,n);
}


