$(document).ready(function(){
	 $(".permissions").live("click",function(event){
		var url = $(this).attr("href");
		event.preventDefault();
		$("#dialog").dialog({
			modal: true,
			title: "Edit resource permissions",
			width: 600,
			height: 600
		});
		$("#dialog").html("<img style='margin-top: 200px; margin-left: 190px' src='/includes/images/secure/ajax-loader.gif' />")
		$.get(url, function(data){
      $("#dialog").html(data);
      $("#dialog").dialog("open");
    });
		
	});
});

