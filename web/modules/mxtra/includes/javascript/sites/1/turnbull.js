


$(document).ready(function(){
	$(".tooltip").tipsy({
    live: true,
    gravity: "se"

  });
	$("a[rel=popover]")
        .popover({
            offset: 10
        })
        .click(function(e) {
            e.preventDefault()
        })
	$(".updateB").click(function(){
		$("#updateBasket").submit();
	}) 
	
	 var accordion = $("#accordion");
  var index = $.cookie("accordion");
  var active;
  if (index !== null) {
          active = accordion.find("h3:eq(" + index + ")");
  } else {
          active = 0
  }
  
  accordion.accordion({
          header: "h3",
          autoHeight: false,
		  clearStyle: true,
          active: active,
          change: function(event, ui) {
                  var index = $(this).find("h3").index ( ui.newHeader[0] );
                  $.cookie("accordion", index, {
                          path: "/"
                  });
          },
		  create: function(event, ui) {
		  	accordion.css("visiblity","visible");
		  }
  
  }); 
  $(".accordion").accordion({
          header: "h3",
          autoHeight: false,
          active: active,
					icons: false
      });
//$("a.screenshot").screenshotPreview();
	$("label.hint").labelOver('over');
	$(".updateB").click(function() {
		$("#basketForm").submit();
	})
	$("#pT").change(function() {
		var v = $(this).val();
		if (v == "Switch") {
			$("#div_issueNumber").show();
			$("#div_startDate").show();
		} else {
			$("#div_issueNumber").hide();
      $("#div_startDate").hide();
		}
	})
	
	

	
});