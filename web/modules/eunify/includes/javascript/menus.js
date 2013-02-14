$(function() {
	var tab_cookie_id = parseInt($.cookie("the_tab_cookie")) || 0; 	
	$(".accordion").livequery(function(){
		$(this).accordion({ autoHeight: false,collapsible: true,active: false, header: 'h5' });
	});
    
  $(".accordionopen").accordion('destroy').accordion({ autoHeight: false, header: 'h5'}); 
  $(".accordionopen2").accordion('destroy').accordion({ autoHeight: false, header: 'h5', active: 1});
  $("#accordion2").accordion('destroy').accordion({ 
    icons: false,     
    autoHeight: false, 
    collapsible: true, 
    active: false, 
    header: 'h3'
  });
	$(".tabs").livequery(function(){
		var thisTabs = this;
		var contentBox = $(this).parent().parent().find(".widget-content");
		var contentNavs = $(this).parent();
		$(this).tabs({			
		  activate: function(e, ui) { 			   
        var tab_id = ui.index; 
        $.cookie("the_tab_cookie", tab_id, { 
	        expires: 30,
	        path: "/" 
        }); 
	    },
			hide: false,
	    selected: tab_cookie_id,
	    spinner: '<img hspace="10" src="/includes/images/spinner.gif" border="0" />',
	    cache: true
		})
	});
	$(".tabs-vertical").livequery(function(){
    var thisTabs = this;    
    $(this).tabs({      
		  beforeActivate: function(e,ui) {
				if ($(ui.newPanel).hasClass("tab-content")) {
					
				} else {
				  $(ui.newPanel).addClass("tab-content");	
				}
				
			},
			create: function(e,ui) {
        if ($(ui.panel).hasClass("tab-content")) {
          
        } else {
          $(ui.panel).addClass("tab-content"); 
        }
        
      },
      activate: function(e, ui) {    
			        
        var tab_id = ui.index; 
        $.cookie("the_tab_cookie", tab_id, { 
          expires: 30,
          path: "/" 
        }); 
      },
      hide: false,
      selected: tab_cookie_id,
      spinner: '<img hspace="10" src="/includes/images/spinner.gif" border="0" />',
      cache: true
    })
  });
	$(".do_hash").click(function(){
		var ref = $(this).attr("href"); 
    var noAjax = $(this).hasClass("noAjax");
    if (ref == undefined || ref == "#") {
      ref = $(this).attr("rel");
    }
    if (ref == "" || ref == "#" || ref == undefined) {
      return false;
    }
    if (!noAjax) {
			if (ref.substring(0,8) == "#ui-tabs") {
				ref = $.data(this, 'href.tabs');
			}
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
      var uri = windowName + "!" + ref;           
      document.location.href = "#!" + uri;    
      return false;
    }
	})
})
