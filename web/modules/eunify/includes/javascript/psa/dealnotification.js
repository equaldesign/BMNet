$(document).ready(function(){
  $("#dealNotification").validate({
    errorClass: "invalid",
    rules: {
      title: "required",
			importance: "required"
    },
    messages: {
      title: "We need a title",
			importance: "A type is required"
	 }
  })
})
