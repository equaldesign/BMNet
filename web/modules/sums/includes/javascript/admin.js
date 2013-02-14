var hashHistory = {};
var mediaSource = "";
var sourceType = "input";
var originalContet =  "";
var tab_cookie_id = parseInt($.cookie("the_tab_cookie")) || 0; 
var mediaLinkType = "embed";
$(function(){
	$("#disableInlineEditing").click(function(e){
		if ($(this).hasClass("editable")) {
			$(this).removeClass("editable");
			$(this).find("i").addClass("icon-lock").removeClass("icon-unlock");
		  $(this).find("span").text("Inline editing disabled");
			var myinstances = [];
			CKEDITOR.disableAutoInline = true;
		  for(var i in CKEDITOR.instances) {       
		    CKEDITOR.instances[i].destroy(); 
		  }
			$('[contenteditable]').each(function(){
        $(this).attr("contenteditable",false);
      })
		} else {
			$(this).addClass("editable");
		  var editable=false;
			$(this).find("i").addClass("icon-unlock").removeClass("icon-lock");
			$(this).find("span").text("Inline editing enabled");
			CKEDITOR.disableAutoInline = false;
			$('[contenteditable]').each(function(){
				$(this).attr("contenteditable",true);
				CKEDITOR.inline($(this).attr("id"));
			})
		}   
		e.preventDefault();
		return false;
  });
	$(".save_settings").livequery("click",function(){
		
	})
	$("#BMNetAdmin").click(function(){
		$.ajax({
      url: "/sums/admin/adminBar?show=" + $("#adminBar").is(":visible"),
      datatype: "html",
      success: function(data){
        $("#adminBar").slideToggle('fast'); 
      }
    })		
	})	
	$("#ntitle").livequery("change",function(){
    var input = $(this).val();
    var safeString = input.replace(/[^A-Z a-z0-9\.]/g,"");
    var safeString = safeString.replace(/ /g,"-"); 
    $("#name").val(safeString.toLowerCase() + ".html");
  })
  if ($(".date").length != 0) {
    $(".date").datepicker({
      dateFormat: 'dd/mm/yy'
    });
  }
	$(".modal").each(function(){		  	
			$(this).modal($(this).attr("data-show"));		
	})	
	$("#savePage, .save_settings").click(function(e){
    var fields = {};
    e.preventDefault();
    fields.PageData = {}

    /*  
        This is a bit of a ckeditor bug - we have to disable inline editing before we save otherwise we get a load of crap in the content 
        Once we've saved the page, we have to turn it back on again. Obviously, we only want to do this if inline editing is enabled.
    */
    if ($("#disableInlineEditing").hasClass("editable")) {
      var myinstances = [];
      CKEDITOR.disableAutoInline = true;
      for(var i in CKEDITOR.instances) {       
        CKEDITOR.instances[i].destroy(); 
      }
      $('[contenteditable]').each(function(){
        $(this).attr("contenteditable",false);
      })
    }

    $(".pageMeta").each(function(){
      fields.PageData[$(this).attr("name")] = $(this).val();
    });
    $('[contenteditable]').each(function(){
      fields.PageData[$(this).attr("name")] = $(this).html();
    });
    $.ajax({
      url: "/alfresco/service/sums/page?siteID=" + $("#bvsiteID").val() + "&parentNodeRef=" + $("#parentNodeRef").val() + "&nodeRef=" + $("#nodeRef").val() + "&alf_ticket=" + $("#alf_ticket").val(),
      contentType: "application/json",
      data: $.toJSON(fields),      
      type: "post", 
      dataType: "json",      
      error: function(data,status,et) {

        document.location.href = "/sums/page/" + fields.PageData.name;
      },
      success: function(data){
				document.location.href = "/sums/page/" + fields.PageData.name;        
      }
    })    
  })
	$("#createPage").livequery("click",function(e){
		var fields = {};
    e.preventDefault();
    fields.PageData = {}
		fields.createLink = $("#createLink").is(":checked");		
    $(".npageMeta").each(function(){
      fields.PageData[$(this).attr("name")] = $(this).val();
    });    
    return $.ajax({
      url: "/alfresco/service/sums/page?siteID=" + $("#bvsiteID").val() + "&parentNodeRef=" + $("#parentNodeRef").val() + "&nodeRef=" + $("#nodeRef").val() + "&alf_ticket=" + $("#alf_ticket").val(),
      contentType: "application/json",
      data: $.toJSON(fields),
      dataType: "json",
      type: "post",
      success: function(data){
        if (data.page.name != undefined) {
         document.location.href = "/sums/page/" + data.page.name;
        } 
      }
    }) 
		return false; 
	})
	$('[contenteditable]').live('focus', function() {
	    var $this = $(this);			
	    $this.data('before', $this.html());
	    return $this;
	}).live('blur keyup paste', function() {
	    var $this = $(this);
	    if ($this.data('before') !== $this.html()) {
	        $this.data('before', $this.html());
	        $this.trigger('change');					
	    }
	    return $this;
	});
	$('[contenteditable]').change(function() {    
		$("#saveButton").show();
  });
	$("#newPageSelector").slimScroll({
      height: 590,
      animate: true,
      animateSpeed:0,
      allowDrag: false
  });
  $("#pageTree").slimScroll({
      height: 390,
      animate: true,
      animateSpeed:0,
      allowDrag: false
  });
	$("#pageHistory").slimScroll({
      height: 390,
      animate: true,
      animateSpeed:0,
      allowDrag: false
  });
	$(".dropdown-menu").click(function(e){
		e.stopPropagation();
	});	
	$(".templateDiv").livequery("click",function(e){		
		if ($("#newPageSelector").width() < 380) {
			$("#newPageSelector").animate({ 
				width: '+=500'
			},"fast",function(){
				$("#newpageproperties").show();
			});
		} else {
			$("#newpageproperties").show();
		}
		$("#tDetails").show();
		$("#tDetails").find("h3").html($(this).find("span.title").text());
    $("#tDetails").find("p").html($(this).find("span.summary").text());
		$("#newpageproperties").find("#tmple").val($(this).attr("data-template"));
    $("#newpageproperties").find("#tmple").val($(this).attr("data-template"));
		e.preventDefault();
		return false;
	})
	$("#newPage").click(function(e){
		var url = $(this).attr("href"); 
		var thisEl = this;
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#newPageSelector").html(data);        
				$("#newPageSelector").css({
	        width: '370px'
	      });        		
      }
    })    
	});
	
	$("#pageLinks").click(function(e){
    var url = $(this).attr("href"); 
    var thisEl = this;
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#linkSelector").html(data);                
      }
    })    
  });
	
	
	
  $(".deletepage").click(function(e){
		var c = window.confirm("Are you sure you want to delete this page?");
		if (c) {
			var url = $(this).attr("href"); 	    
	    $.ajax({
	      url: url,
	      datatype: "html",
				type: "delete",
	      success: function(data) {
	        document.location.href="/";
	      }
	    })
		} else {
			return false;
		}
		e.preventDefault();
		return false;
	})
	
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
    if (ref == "" || ref == "#" || ref == undefined) {
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
	$(".doDialog").livequery("click",function(e){
    var url = $(this).attr("href");
      $("#dialog").dialog({
        title: $(this).attr("name"),
        buttons: {},
				width: 750,
				height: 500,
				beforeClose: function(event, ui) { 
		      mediaSource = "";
		    }
      })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);
        $("#dialog").dialog("open");     
				originalContet =  data;   
      }
    })
    e.preventDefault();
    return false;
  });
	var pageTree;
  pageTree = $("#pageTree").jstree({
    "json_data": {
      "ajax": {
        "url": "/alfresco/service/sums/page/tree?siteID=" + $("#siteID").val() + "&alf_ticket=" + $("#alf_ticket").val(),
				contentType: "application/json",
				dataType: "json",
        "data": function(n){
          return { 
            nodeRef: n.attr ? n.attr("id") : ""
          };
        }
      }
    },
    "cookies": {
      "save_opened": "jstree_open",
      "auto_save": "true"
    },
    "plugins": ["json_data", "cookies","crrm","dnd"]
  }).bind("move_node.jstree", function(event, data) {
		var sourceNodeRef = data.rslt.o[0].id;
		var targetNodeRef = data.rslt.r[0].id;
		$.ajax({
      url: "/alfresco/service/sums/link/move?alf_ticket=" + $("#alf_ticket").val(),
      datatype: "json",
      type: "post",
			data: {
				sourceNode: sourceNodeRef,
				targetNode: targetNodeRef
			}
    })
  });
	
	
	$(".delete_link").livequery("click",function(){
      var linkNode = $(this).closest("li");
      $.ajax({
        url: "/alfresco/service/sums/link?nodeRef=" + $(linkNode).attr("rel") + "&alf_ticket=" + $("#alf_ticket").val(),                
        type: "delete",
        success: function(data){
          $(linkNode).remove();
        }
      })
      
  })
  
	$(".edit_link").livequery("click",function(){
      var linkNode = $(this).closest("li");
      $.ajax({
        url: "/alfresco/service/sums/link?nodeRef=" + $(linkNode).attr("rel") + "&alf_ticket=" + $("#alf_ticket").val(),                
        type: "get",
        datatype: "json",
        contentType: "application/json",
        data: $.toJSON(""),
        success: function(data){
          $("#newLinkForm").find("#link_name").val(data.name);
          $("#newLinkForm").find("#linkNodeRef").val(data.nodeRef);
          $("#newLinkForm").find("#link_url").val(data.linkURL);
          $("#newLinkForm").find("#link_page").val(data.linkURL);
          $("#newLinkForm").find("#link_target").val(data.linkTarget);
          $("#newLinkForm").find("legend").text("Edit Link");
          $("#newLinkForm").find("#createLink").text("Edit Link");          
        }
      })
      return false;
    })
	$(".tabs").livequery(function(){
		$(this).tabs({
	    show: function(e, ui) { 
	      var tab_id = ui.index; 	      
	      $.cookie("the_tab_cookie", tab_id, { 
	        expires: 30,
	        path: "/" 
	      }); 
	    },
	    selected: tab_cookie_id,
	    spinner: '<img hspace="10" src="/includes/images/spinner.gif" border="0" />',
	    cache: true
	  }); 
	});

})
function Left(str, n){
  if (n <= 0)
      return "";
  else if (n > String(str).length)
      return str;
  else
      return String(str).substring(0,n);
}