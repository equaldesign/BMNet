$(document).ready(function(){
	$("#editContact").validate({
		errorClass: "invalid",
		rules: {
			first_name: "required",
			surname: "required",
			email: {
				required: true,
				email: true
			},
			password: {
        required: true,
        minlength: 5
      }
		},
		messages: {
			first_name: "We need a contact first name",
			surname: "We need a contact surname",
			password: {
        required: "Please provide a password",
        minlength: "Password must be at least 5 characters"
      },
			email: {
				required: "We need a valid email address",
				email: "This doesn't appear valid"
			}
		}
	})
	$("#company_id").change(function(){
		var text = $("#company_id :selected").attr("class");
		if (text == "member") {
			$("#memberpermissions").show();
			$("#cbapermissions").show();
			$("#supplierpermissions").hide();
		} else if (text == "supplier") {
			$("#memberpermissions").hide();
			$("#cbapermissions").hide();
			$("#supplierpermissions").show();
		} else {
			$("#memberpermissions").hide();
			$("#cbapermissions").hide();
			$("#supplierpermissions").hide();
		}
	})
	$("#setupBV").click(function(){
		$.ajax({
			url: "/bv/admin/eGroupUserCreation",
			data: {
				id: $(this).attr("rel")
			},
			success: function(){
				document.location.reload();
			}
		})
	})
})
