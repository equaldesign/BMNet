var $tabs2;
var targetAjax = "";
var hashHistory = {};
function checkDealTools() {
  if ($("#psaID").length === 0) {
    // we're not looking at an agreement.
    // hide the deal tools menu
    $("#psaM").hide();
    $("#left_dealTools").hide(); 
  } else {
    if ($("#psaM").is(":hidden")) {             
      $("#psaM").show();
      $("#left_dealTools").show();     
      $("#left_dealTools").load("/eunify/psa/menu/psaID/" + $("#psaID").val());   
      $(".homeAccordion").accordion("destroy").accordion({ 
        icons: false, 
        navigation: true,     
        autoHeight: false, 
        collapsible: true, 
        header: 'h3'
      }); 
    }
  }
}

$(document).ready(function(){
	
  var targetAjax = "maincontent";
  var originalContet =  $("#" + targetAjax).html();
  var oldBrowser = false;
	/*
	 * 
	var timer = window.setInterval(updateProgress,60000);
  var idleTimeout = window.setInterval(clearTimer,600000);
  */
  p = location.hash;    
  if (Left(p,8) == "/http://") {
    oldBrowser = true;      
    p = p.replace("/" + $("#httpHost").val(),"");             
  }
  if (p.substring(0,1) == "#") {
    if (p.substring(0,2) == "#!") {          
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
          $("#" + windowName).block();
          $.get(uri, function(data){
            $("#" + windowName).html(data);
            hashHistory[windowName][uri] = data;
            $("#" + windowName).unblock();
          })
      }
  }
  /*
  function updateProgress() {
    $.ajax({ 
      url: "/eunify/contact/currentUsers",
      datatype: "html",
      success: function(data) {
        $("#currentUsers").html(data)
        return;
      }
    });
    $.ajax({ 
      url: "/eunify/contact/recentlyViewed",
      datatype: "html",
      success: function(data) {
        $("#recentlyViewed").html(data)
        return;
      }
    });
  }  
	 function clearTimer() {
    clearInterval(timer);
  } 
  */
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
          checkDealTools();
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
	$("#publicmode").live("click",function(){
		$.ajax({
      url: "/eunify/contact/layoutMode?layoutmode=public",
      datatype: "html",
      success: function(data){
        document.location.href="/"
      }
    })
	})
  $(".dialog").live("click",function(e){
    var url = $(this).attr("href");
      $("#dialog").dialog({
        title: $(this).attr("name"),
        buttons: {}
      })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);
        $("#dialog").dialog("open");        
      }
    })
    e.preventDefault();
    return false;
  })
	$(".modaldialog").live("click",function(e){
    var url = $(this).attr("href");
      $("#dialog").dialog({
        title: $(this).attr("name"),
        buttons: {
          "Save": {
            "class": "btn btn-success",
            "text": "Save",
            "click": function() { 
              $("#dialog").find("form").ajaxSubmit({
								success: function(){
					       $("#dialog").dialog("close");
				        }
							});
            }                     
          }, 
          "Cancel": {
            "class": "btn",
            "text": "Cancel",
            "click": function(){
              $(this).dialog("close");
            } 
           
          } 
        } 
      })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);
        $("#dialog").dialog("open");        
      }
    }) 
    e.preventDefault();
    return false;
  })
	$(".dialog").live("click",function(e){
    var url = $(this).attr("href");
      $("#dialog").dialog({
        title: $(this).attr("name"),
        buttons: {}
      })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);
        $("#dialog").dialog("open");        
      }
    })
    e.preventDefault();
    return false;
  })
	
    $("#maincontent a, a.ajax, #sidebar a").live("click",function(event) {
    var ref = $(this).attr("href"); 
    var noAjax = $(this).hasClass("noAjax");
    if (Left(ref,10) == "javascript") {
      noAjax = true;
    }
    if (Left(ref,6) == "mailto") {
      noAjax = true;
    }
    if (ref != undefined && ref.length != 0) {
      if (ref.search("download") > 0) {
        noAjax = true;
      } else if (ref.search("/") < 0) {
        noAjax = true;
      }
    } else {
      noAjax = true;
    }
    if (!noAjax) {
      if ($(this).closest(".noAjax").length != 0) {
        // noAjax = true;
      }
    } 
    if ($(this).attr("target") == "_blank") {
      return true;
    }
    if (ref == undefined || ref == "#") {
      ref = $(this).attr("rel");
    }
    if (ref == "" || ref == "#" || ref == undefined) {
      return;
    }
    if (!noAjax) {
      var targetWin = $(this).attr("rev");
      if (targetWin == "" || targetWin == null) {
        var win = $(this).closest(".ajaxWindow");
        if (win.length == 0) {
          // it wasn't in a window, so assume it's #whiteBox
          var windowName = "maincontent";
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
  $("a[href='#']").live("click",function(event) { 
     event.preventDefault();
  })
  $(".ttip").livequery(function(){
			$(this).tipsy({
	    live: true,
	    gravity: "se"
	
	  });
	});
  $(".show").live("click",function(event){
    $("#" + $(this).attr("rev")).toggle();
     event.preventDefault();
     return false;
  });
  $(".helptip").tipsy({
    live: true,
    gravity: "w",
    trigger: "focus"
  });
  $(".complexTip").tipsy({
    live: true,
    html: true,
    title: function(e) {
      $(e).find(".hidden").html()
    },
    gravity: "se"

  });
  	$(".date").livequery(function(){
  	  $(this).datepicker({
  		  dateFormat: 'dd/mm/yy'
  	  })
  	});
  $(".confirm").live("click",function(){
    var s = window.confirm("Are you sure?");
    if (s) {
      return true;
    } else {
      return false;
    }
  })
   
  $('a.void').click(function(){
      return false;
  });
  
  $("#editmode").click(function(){
    var editMode = $(this).attr("class");
    if (editMode == "on") {
      $(this).addClass("off");
      $(this).removeClass("on");
      $(this).text("turn on edit mode");
    } else {
      $(this).addClass("on");
      $(this).removeClass("off");
      $(this).text("turn off edit mode");
    }
    var existingTabs = $("#tabs");
    if (existingTabs.length>0) {
        $.get("/eunify/psa/editMode?e=" + editMode, function(data){
          try  {
            var selected = $("#tabs").tabs('option', 'selected');
            $("#tabs").tabs('load',selected);
          }
          catch(err) {
            alert("error!");
          }     
      });
   } else {
    $.get("/eunify/psa/editMode?e=" + editMode, function(data){
     window.location.reload();
    });
   } 
  })
  
  $("#cache").click(function(){
    var editMode = $(this).attr("class");
    if (editMode == "true") {
      $(this).addClass("false");
      $(this).removeClass("true");
      $(this).text("enable speed mode");
      var setMode = false;
    } else {
      $(this).addClass("true");
      $(this).removeClass("false");
      $(this).text("disable speed mode");
      var setMode = true;
    }
    var existingTabs = $("#tabs");
    if (existingTabs.length>0) {
        $.get("/contact/cachecontrol?enabled=" + setMode, function(data){
          try  {
            var selected = $("#tabs").tabs('option', 'selected');
            $("#tabs").tabs('load',selected);
          }
          catch(err) {
            alert("error!");
          }     
      });
   } else {
    $.get("/eunify/contact/cachecontrol?enabled=" + setMode, function(data){
     window.location.reload();
    });
   } 
  })    
  $(".moveMonth").live("click",function(){
    url = $(this).attr("href");
    $("#right_calendar").load(url);
    return false;
  })
  $("#flipDisplay").live("click",function(){
    $("#appointmentList").toggleClass("hidden");
    $("#calendarHolder").toggleClass("hidden");
    $(this).toggleClass("list");
  })
	/*
  $.get($.buildLink("calendar.index"), function(data){
      $("#right_calendar").html(data);
  });
  */

   
   $('#dialog').dialog({
    autoOpen: false,
    width: 700,
    height: 600,
    zIndex: 3999,
    buttons: {
      "Ok": function() { 
        //$(this).dialog("close");  
      }, 
      "Cancel": function() { 
        $(this).dialog("close"); 
      } 
    },

    modal: true
  });
  $.widget("custom.catcomplete", $.ui.autocomplete, {
    _renderMenu: function( ul, items ) {
      var self = this,
        currentCategory = "";
      $.each( items, function( index, item ) {
        if ( item.category != currentCategory ) {
          ul.append( "<li class='sresults-"+ item.category +"'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        self._renderItem( ul, item );
      });
    },
    _renderItem: function( ul, item) {
    return $( "<li></li>" )
        .data( "item.autocomplete", item )
        .append( "<a class='sresultitem-" + item.iconclass + "'>" + item.label + "</a>" )
        .appendTo( ul );
    }
  });
  $('#directorySearch').catcomplete({
      delay: 1,
      source: "/eunify/search/index",
      minLength: 3,
      select: function(event, ui){
        document.location.href = ui.item.url;
      } 
    });
      
  // updateProgress();
	
	
	$(".ui-dialog-content a").livequery("click",function(event) {
    var ref = $(this).attr("href"); 
    var noAjax = $(this).hasClass("noAjax");
    var logging = true;
		if (logging) {
      console.log("Starting up...");
    }
    if (Left(ref,10) == "javascript") {
			if (logging) {
        console.log("javascript link - ignore.");
      }
     return;
    }
    if (Left(ref,6) == "mailto") {
			if (logging) {
        console.log("mailto link - ignore.");
      }
      return;
    }
		if (ref == undefined || ref == "#") {
			if (logging) {
        console.log("no href defined.");
      }
		  ref = $(this).attr("rel");
	  }
    if (ref.length != 0) {
      if (ref.search("download") > 0) {
				if (logging) {
          console.log("download link - ignore.");
        }
        return;
      } else if (ref.search("/") < 1) {
        // return;
      }
    } else {
			if (logging) {
        console.log("no target address: ignore");
      }
      return;
    }
    if (!noAjax) {
      if ($(this).closest(".noAjax").length != 0) {
        return;
      }
    } 
    if ($(this).attr("target") == "_blank") {
      return;
    }
    
    if (ref == "" || ref == "#" || ref == undefined) {
      return;
    }
    if (!noAjax) {
      if (logging) {
        console.log("doing ajax");
      }
      var targetWin = $(this).attr("rev");
      if (targetWin == "" || targetWin == null) {
        if (logging) {
          console.log("no target specififed");
        }
        var d = $(this).closest(".ui-dialog-content");
        if (d.length == 0) {
          if (logging) {
            console.log("not in a dialog");
          }
          // not in dialog
          var win = $(this).closest(".ajaxWindow");
          if (win.length == 0) {
            if (logging) {
              console.log("no parent window");
            }
            // it wasn't in an ajax window, so assume it's #whiteBox
            var windowName = "maincontent";
          } else {
            var windowName = $(win).attr("id"); 
          }       
        } else {
          // inside dialog
          if (logging) {
            console.log("inside dialog window");
          }           
          var windowName = $(d).attr("id");
          if (typeof windowName !== 'undefined' && windowName !== false) {
            if (logging) {
              console.log("no id for dialog");
            }
            // dialog doesn't have an id, so give it one
            $(d).attr("id","dialog2");
            windowName = "dialog2";                   
          }
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
 });
function Left(str, n){
  if (n <= 0)
      return "";
  else if (n > String(str).length)
      return str;
  else
      return String(str).substring(0,n);
}