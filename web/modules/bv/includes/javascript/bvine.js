$(document).ready(function(){
   
  $(".dialog").livequery("click",function(e){
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
	
  $(".dialogOK").livequery("click",function(e){
    var url = $(this).attr("href");
      $("#dialog").dialog({
        title: $(this).attr("name"),      
				modal: false,  
        buttons: {
          "Save": {
						"class": "btn btn-success",
						"text": "Save",
						"click": function() { 
              $("#dialog").find("form").submit();
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
	  $("#dialog").empty();
		$("#dialog").html('<img src="/includes/images/secure/ajax-loader.gif" style="postion:relative;margin-top:200px:margin-left:50px" />')
	  $("#dialog").dialog("open");
		    
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);		       
      }
    })
    e.preventDefault();
    return false;
  })
	
	$("a[href='#']").live("click",function(event) {  
     event.preventDefault();
  })  
  $(".ttip").tipsy({
    live: true,
    gravity: "se"

  });
  $(".show").live("click",function(event){
    $("#" + $(this).attr("rev")).toggle();
     event.preventDefault();
     return false;
  });
	
	$(".helptip").tipsy({
    trigger: "focus"
  });
  $('#dialog').dialog({
    autoOpen: false,
    width: 700,
    height: 600,
    zIndex: 3999,
    buttons: {      
      "Cancel": {
        "class": "btn",
        "text": "Cancel",
        "click": function(){
          $(this).dialog("close");
        } 
       
      } 
    },
    modal: true
  });
     
	
	
	$(".accordionNested").accordion('destroy').accordion({ navigation: true, autoHeight: false, collapsible: true,active: false, header: 'h5'});
		
})
function Left(str, n){
  if (n <= 0)
      return "";
  else if (n > String(str).length)
      return str;
  else
      return String(str).substring(0,n);
}
function isSecure()
{
   return window.location.protocol == 'https:';
}
	