$(document).ready(function(){
	$("#checkout").validate({
    errorClass: "invalid",
    rules: {
      bN: "required",
      bA: "required",
      bPC: "required",
      bP: "required",
      bE: {
        required: true,
        email: true
      },
			password: {
				required: true,
				minlength: 5
			},
			password2: {
				required: true,
				minlength: 5,
				equalTo: "#password"
			}
    },
    messages: {
      bN: " ",
      bA: " ",
			bP: " ",
			bPC: " ",
      password: {
				required: " ",
        minlength: " "
			}, 
			password2: {
				required: " ",
        minlength: " ",
        equalTo: "doesn't match"
			},
      bE: {
        required: " ",
        email: "invalid"
      }
    }
  })
})
