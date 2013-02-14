$(document).ready(function(){
	var previewContents = "";
	$("#showPreview").click(function(){	  
	  if ($(this).hasClass("hide")) {
			$(this).removeClass("hide");
			$("#documentPreview").animate({
				width: "400px",
				height: "480px"
			}, 500).html(previewContents);
		}	else {
			$(this).addClass("hide");		
			previewContents = $("#documentPreview").html();
			$("#documentPreview").animate({
				width: "640px",
				height: "800px"
			}, 500).empty();
			var pvf = $("#documentPreview").attr("rel");			
			var fp = new FlexPaperViewer('/includes/flash/FlexPaperViewer', 'documentPreview', {
				config: {
					SwfFile: pvf,
					Scale: 0.6,
					ZoomTransition: 'easeOut',
					ZoomTime: 0.5,
					ZoomInterval: 0.2,
					FitPageOnLoad: true,
					FitWidthOnLoad: true,
					PrintEnabled: true,
					FullScreenAsMaxWindow: false,
					ProgressiveLoading: false,
					MinZoomSize: 0.2,
					MaxZoomSize: 5,
					SearchMatchAll: false,
					InitViewMode: 'Portrait',
					
					ViewModeToolsVisible: true,
					ZoomToolsVisible: true,
					NavToolsVisible: true,
					CursorToolsVisible: true,
					SearchToolsVisible: true,
					
					localeChain: 'en_US'
				}
			});
		}
  });
	$("#bc").html($("#breadcrumb").html());
	$("#documentAccordion").accordion({ autoHeight: false, header: 'h3',cookie: { expires: 30 } });
	$(".createFolder").click(function(){
		$("#createFolder").toggle();
		return false;
	})
	$(".docInfo").click(function(){
		$("#folderInfo").toggle();
	})
	$(".docTools").click(function(){
	  $("#folderNav").toggle();
	})
	$("#makeversionable").hover(function(){
		$("#versionInfo").toggle();
	})
	if (typeof(mediaSource) != "undefined" && mediaSource != "") {
    $("#imageOptions").show();
		if (sourceType == "ckeditor") {
		    $("#bv_insertImageANDLink").show();
		}
  }
	$("#bv_insertImageANDLink").click(function(){
		var imageURL = 'https://www.buildingvine.com/api/i?size=' + $("#bv_imageWidth").val() + '&nodeRef=' + $("#imageNodeID").val();
    if ($("#bv_imageCrop").is(":checked")) {
      imageURL += "&crop=true&aspect=" + $("#bv_imageCropAspect").val();
    }
		var thisEditor = CKEDITOR.instances[mediaSource];  
		thisEditor.insertHtml('<a href="' + $("#imageDownloadURL").val() + '" target="_blank"><img src=' + imageURL + '"border="0" class="' + $("#bv_imageStyle").val() + '" border="0" /></a>');
	})
  $("#bv_insertImage").click(function(){   	  
	  var imageURL = 'https://www.buildingvine.com/api/i?size=' + $("#bv_imageWidth").val() + '&nodeRef=' + $("#imageNodeID").val();
		if ($("#bv_imageCrop").is(":checked")) {
			imageURL += "&crop=true&aspect=" + $("#bv_imageCropAspect").val();
		}
    if (sourceType == "ckeditor") { 
			var thisEditor = CKEDITOR.instances[mediaSource];      
      this.imageElement = thisEditor.document.createElement('img');
      this.imageElement.setAttribute('alt', '');
      this.imageElement.addClass($("#bv_imageStyle").val());
      this.imageElement.setAttribute('src', imageURL);
      thisEditor.insertElement(this.imageElement); 
      $("#dialog").dialog("close");
    } else if (typeof(mediaSource) != "undefined" || mediaSource != "") {
			window.prompt ("Copy to clipboard: Ctrl+C, Enter", imageURL);
		} else {
		
      $("#" + mediaSource).val(imageURL);
      $("#dialog").dialog("close");
    }
		return false;
  })	
	var options = {
	      target:        '#ajaxMain',   // target element(s) to be updated with server response
	      beforeSubmit:  showRequest,  // pre-submit callback
	      success:       showResponse  // post-submit callback
	
	      // other available options:
	      //url:       url         // override for form's 'action' attribute
	      //type:      type        // 'get' or 'post', override for form's 'method' attribute
	      //dataType:  null        // 'xml', 'script', or 'json' (expected server response type)
	      //clearForm: true        // clear all form fields after successful submit
	      //resetForm: true        // reset the form after successful submit
	
	      // $.ajax options can be used here too, for example:
	      //timeout:   3000
	  };
		$("#documentSearch").submit(function(){
			$("#documentSearch").ajaxSubmit(options);	
			return false;
		})
		
	// pre-submit callback
	function showRequest(formData, jqForm, options) {
	    // formData is an array; here we use $.param to convert it to a string to display it
	    // but the form plugin does this for you automatically when it submits the data
	    var queryString = $.param(formData);
			$("#ajaxMain").block();
	
	    // jqForm is a jQuery object encapsulating the form element.  To access the
	    // DOM element for the form do this:
	    // var formElement = jqForm[0];
	    
	    // alert('About to submit: \n\n' + queryString);
	
	    // here we could return false to prevent the form from being submitted;
	    // returning anything other than false will allow the form submit to continue
	    return true;
	}
	
	// post-submit callback
	function showResponse(responseText, statusText, xhr, $form)  {
	    // for normal html responses, the first argument to the success callback
	    // is the XMLHttpRequest object's responseText property
			$("#ajaxMain").unblock();
	    // if the ajaxSubmit method was passed an Options Object with the dataType
	    // property set to 'xml' then the first argument to the success callback
	    // is the XMLHttpRequest object's responseXML property
	
	    // if the ajaxSubmit method was passed an Options Object with the dataType
	    // property set to 'json' then the first argument to the success callback
	    // is the json data object returned by the server
	    
	}
	
	$(".checkout").click(function(){
		var nodeRef = $(this).attr("rel").replace(":/","");
		$("#whiteBox").block();
      $.ajax({
        url: "/alfresco/service/slingshot/doclib/action/checkout/node/" + nodeRef + "?alf_ticket=" + $("#alf_ticket").val(),
        type: "POST",				
        dataType: "json",
				processData: false,
				contentType: 'application/json',
				data: '{}',		
        success: function(data) {     				
				    document.body.innerHTML += "<iframe src='https://www.buildingvine.com/alfresco/service/" + data.results[0].downloadUrl + "&alf_ticket=" + $("#alf_ticket").val() + "' style='display: none;' ></iframe>"             
            $.get("/documents/documentDetail?file=" + data.results[0].nodeRef, function(data){         
              $("#whiteBox").html(data);
              $("#whiteBox").unblock();
							//$("#documentTree").jstree("refresh");
            });						      
        }
      })
	});
	$(".cancelcheckout").click(function(){
    var nodeRef = $(this).attr("rel").replace(":/","");
		var parentNode = $(this).attr("rev");
    $("#whiteBox").block();
      $.ajax({
        url: "/alfresco/service/slingshot/doclib/action/cancel-checkout/node/" + nodeRef + "?alf_ticket=" + $("#alf_ticket").val(),
        type: "POST",       
        dataType: "json",
        processData: false,
        contentType: 'application/json',
        data: '{}',   
        success: function(data) {             
          $.get("/documents/documentList?dir=" + parentNode, function(data){         
		        $("#whiteBox").html(data);
		        $("#whiteBox").unblock();
						//$("#documentTree").jstree("refresh");
		      });     
        }
      })
  });	
	$("#button_createFolder").click(function(){
		var folder = $("#nodeRef").val();
		var newFolder = $("#folderName").val();
		if (newFolder == ""){
			return false; 
		} else {
			$("#whiteBox").block();
			$.ajax({
				url: "/alfresco/service/bvine/docs/folders/create.json?alf_ticket=" + $("#alf_ticket").val(),
				type: "GET",
				dataType: "json",
				data: {
					folder: folder,
					name: newFolder
				},
				success: function(data) {
					document.location.reload();
				}
			})	
		}
			
	})	
	$(".delete").click(function(){
		var nodeRef = $(this).attr("rel").replace(":/","");
		var parentNode = $(this).attr("rev");
		var c = window.confirm("Are you sure you wish to delete this file?\n This CANNOT be undone!");
		if (c) {
			$("#whiteBox").block();
			$.ajax({
				url: "/alfresco/service/api/node/" + nodeRef + "?alf_ticket=" + $("#alf_ticket").val(),
				type: "DELETE",
				dataType: "json",				
				success: function(data) {				
			    	document.location.href="/bv/documents/index?dir=" + parentNode;            
				}
			})	
		}
	})	
	$(".deleteFolder").click(function(){
    var nodeRef = $(this).attr("rel").replace(":/","");
    var parentNode = $(this).attr("rev");
    var c = window.confirm("Are you sure you wish to delete this folder and all it's contents?\n This CANNOT be undone!");
    if (c) {
      $("#whiteBox").block();
      $.ajax({
        url: "/alfresco/service/api/node/" + nodeRef + "/descendants?alf_ticket=" + $("#alf_ticket").val(),
        type: "DELETE",
        dataType: "json",       
        success: function(data) {       
            $.get("/bv/documents/index?dir=" + parentNode, function(data){         
              $("#whiteBox").html(data);
              $("#whiteBox").unblock();
							//$("#documentTree").jstree("refresh");
            });
        }
      })  
    }
  })  
	$("#webdavhelp>a").click(function(){
		$.get("/help/index/page/webdav", function(data){
			$("#dialog").html(data);
			$("#dialog").dialog("open");
		});
	})
  $(".setAsSiteBanner").livequery("click",function(){
    var siteID = $(this).attr("data-siteID"); 
    var documentNodeRef = $(this).attr("data-nodeRef");
    jsonObject = new Object();    
    jsonObject.customData = new Object();
    jsonObject.customData["siteBanner"] = documentNodeRef;
    $.ajax({
      url: "/alfresco/service/bvapi/sites/" + siteID + "?alf_ticket=" + $("#alf_ticket").val(),
      contentType: "application/json",
      data: JSON.stringify(jsonObject),
      dataType: "json",
      type: "POST",
      success: function (data) { 
        $.get("/bv/admin/clearCacheKey?cacheKey=siteDetail" + siteID);
        alert("Banner Updated");
      },
      error: function(){
       alert("Error Updating Banner")
      }     
    });
  })
})