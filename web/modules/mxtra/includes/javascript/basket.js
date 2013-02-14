$(document).ready(function(){

  $(".doBasket").ajaxForm({
		success: function(responseText, statusText, xhr, $form) {
		  $($form).find(".btn").val("Added...").addClass("disabled");				
			$("#basketO").load("/mxtra/shop/basket/overview");	
		},
		error: function(data) {
			alert(data);
		}
	})
  $("#quantity").change(function(){
		if ($(this).val() < $(this).attr("data-minorder")) {
			$(this).val($(this).attr("data-minorder"));
		}
	})
})