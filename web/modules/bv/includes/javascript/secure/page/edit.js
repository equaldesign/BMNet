$(document).ready(function(){
	$("#title").change(function(){
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
	$(".show").click(function(){
		$(".hidden").each(function(){
			$(this).toggle();
			$(this).css("visibility","visible");
		})
	})
	
	$(".save_page").click(function(e){
		var fields = {};
		e.preventDefault();
		fields.PageData = {}
		$(".pageMeta").each(function(){
			fields.PageData[$(this).attr("name")] = $(this).val();
		});
		$(".ckeditor").each(function(){
      fields.PageData[$(this).attr("name")] = $(this).val();
    });
		return $.ajax({
			url: "/sums/page?parentNodeRef=" + $("#parentNodeRef").val() + "&nodeRef=" + $("#nodeRef").val(),
			contentType: "application/json",
			data: JSON.stringify(fields),
			dataType: "json",
			type: "post",
			success: function(data){
				document.location.href="/sums/page/" + data.page.name; 
			}
		})		
	})
})
 