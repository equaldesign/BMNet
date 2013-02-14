$(document).ready(function(){
	$("#send2supplier").validate({
    errorClass: "invalid",
    rules: {
      recipient: "required",
      subject: "required",
			from_name: "required",
      from_email: {
        required: true,
        email: true
      }
    },
    messages: {
      recipient: "We need a recipient",
      subject: "We must have a subject",
			from_name: "We need a from Name",
      from_email: {
        required: "We need a valid email address",
        email: "This doesn't appear valid"
      }
    }
  })
})
