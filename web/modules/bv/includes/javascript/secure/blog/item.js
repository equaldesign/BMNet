$(document).ready(function(){
	$(".deleteBlog").click(function(event){
		event.preventDefault();
		var conf = window.confirm("Are you sure you wish to delete this item and it's comments?");
		if (conf) {
			$.ajax({
				url: $(this).attr("href"),
				dataType: "json",
				type: "DELETE",
				success: function(data){
					$.address.value("/bv/blog");
				}
			})
	  }
	})
})
