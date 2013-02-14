$(document).ready(function(){
	$("#changeSite").change(function(){
		var siteID = $(this).val();
		$.get("/tools/switchSite?siteID=" + siteID,function(){
			window.history.go(0);
		})
	})
})
