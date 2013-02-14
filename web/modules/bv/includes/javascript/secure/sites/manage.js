$(document).ready(function(){  
  $("#tabs").tabs();
  $(".deleteAuthority").live("click",function(e){
    e.preventDefault();
		$.ajax({
      type:"DELETE",
      dataType: "json",
      url: $(this).attr("href"),
      success: function(data) { 
        $(this).closest(".trow").parent().remove(); 
      },
			error: function(data) {
				$(this).closest(".trow").parent().remove();
			}
      
    })
    return false;
  })	
});

