$(document).ready(function(){		
	$("#signUpForm").validate({
    rules: {
      surname: "required",
      first_name: "required",
      email: {
        required: true,
        email: true
      },
      password1: { 
        required: true
      },
      password2: {
        required: true,
        equalTo: "#password1"       
      },
      companyName: {
        required: true
      },

      postcode: {
        required: true
      },
      switchboard: {
        required: true
      },      
			web: {
        required: true
      },
      termsconfirm: {
				required: true
			},
			captcha: {
        required: true,
        remote: "/signup/checkCaptcha?captcha_check=" + $("#captcha_check").val()
      }
    },
		messages: {
      captcha: "The correct code is required. You entered an incorrect code!",
			termsconfirm: "You must agree to the terms within the confirmation section."
    },
		errorLabelContainer: "#formmessage",
		errorElement: "b",
		wrapper: "li",
    submitHandler: function(form) {
        form.submit();
      }          
  })
})
function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}