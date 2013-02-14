$(document).ready(function(){
	$("#changePassword").validate({
		rules: {
		  newPassword1: {
				required: true,
				minlength: 5
			},
			newPassword2: {
				required: true,
				minlength: 5,
				equalTo: "#newPassword1"
			},
			currentPassword: "required"
		},
		messages: {
			newPassword1: {
				required: "Please provide a password",
				minlength: "Your password must be at least 5 characters long"
			},
			newPassword2: {
				required: "Please provide a password",
				minlength: "Your password must be at least 5 characters long",
				equalTo: "Please enter the same password as above"
			},
			currentPassword: "Please enter your existing password"			
		},
		submitHandler: function() {
		
			//wrap it up and submit via ajax
			jsonObject = new Object();
			$("#ajaxMain").block();
			jsonObject.oldpw = $("#currentPassword").val();
			jsonObject.newpw = $("#newPassword1").val();
			jsonObject.newpassword2 = $("#newPassword2").val();
			$.ajax({
		      url: "/alfresco/service/api/person/changepassword/" + $("#userName").val() + "?alf_ticket=" + $("#alf_ticket").val(),
		      contentType: "application/json",
		      data: JSON.stringify(jsonObject),
		      dataType: "json",
		      type: "post",
		      success: function (data) {
			  	if (data.success) {
				  $("#ajaxMain").unblock();
				  $("#message").html("Your password has been changed!");	
				}	               				
		      },
			  error: function(){
			   $("#ajaxMain").unblock();
				  $("#message").html("Your original password was incorrect");	
			  }     
		    });
			return false;
		}
	})
})
