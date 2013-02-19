$(document).ready(function(){
	$("#dialog").dialog({
        title: $(this).attr("name"),
        buttons: {}
    });
    $("#dialog").dialog("close"); 
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
  $(".date").livequery(function(){
    $(this).datepicker({
      dateFormat: 'dd/mm/yy'
    })
  }); 
	$("#dialog").dialog( "option", "buttons",{
	"Create Element": function() {
	    $("#elementForm").submit();          
	    $(this).dialog("close"); 
	 } 
	});
	$(".modaldialog").live("click",function(e){
    
    var url = $(this).attr("href");
      var theD = $("#dialog");
      $("#dialog").dialog({
        title: $(this).attr("name"),
        width: 600,
        height: 400,
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
})
