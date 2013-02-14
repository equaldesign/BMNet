$(document).ready(function(){
	$(".deleteItem").click(function(){
		$.ajax({
			url: $(this).attr("href"),
			type: "delete",
			success: function(){
				window.history.go(0);
			}
		})
		return false;
	})
})
