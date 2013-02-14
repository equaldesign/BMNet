$(document).ready(function(){
	$(".deleteContact").click(function(){
		var x = window.confirm("Are you sure you wish to delete this contact? This cannot be undone!");
		if (x) {
			var link = $(this).attr("rel");
			document.location.href = link;
		}
		
	})
})
