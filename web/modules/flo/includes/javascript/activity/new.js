$(function(){
	var formObject = $(".form");
	var formContainer = $(formObject).closest(".widget-box").parent();
  $(formObject).ajaxForm({
    target: formContainer,    
    dataType: "html",
    success:       function(responseText, statusText, xhr, $form) {
      $(formContainer).html(responseText);
      $(formContainer).unblock();
    }      
  }); 
})
