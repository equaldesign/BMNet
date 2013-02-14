$(document).ready(function(){
	var searchURL = "/alfresco/service/api/search/person.json?alf_ticket=" + $("#alf_ticket").val();
  $("#sQ").autocomplete({
     source: function( request, response ) {
        if ($("#sType").val() == "user") {
			     searchURL = "/alfresco/service/api/search/person.json?alf_ticket=" + $("#alf_ticket").val();		
				} else if ($("#sType").val() == "site") {
           searchURL = "/alfresco/service/api/groups?zone=APP.SHARE&alf_ticket=" + $("#alf_ticket").val() + "&shortNameFilter=" + request.term;        
				} else {
					 searchURL = "/alfresco/service/api/groups?zone=APP.DEFAULT&alf_ticket=" + $("#alf_ticket").val() + "&shortNameFilter=" + request.term;
				}
				$.ajax({
          url: searchURL,
          dataType: "json",
          data: {            
            q: request.term
          },
          success: function(data) {
						console.log(data);
						if ($("#sType").val() == "user") {
							response($.map(data.people, function(person){
								return {
									label: person.name,
									value: person.userName
								}
							}));
						} else if ($("#sType").val() == "site") {
              response($.map(data.data, function(group){								
                return {
                  label: group.fullName,
                  value: group.fullName
                }
              }));            
						} else {
							response($.map(data.data, function(group){
                return {
                  label: group.displayName,
                  value: group.fullName
                }
              }));
						}
          }
        });
      },
     select: function( event, ui ) {      
        console.log(ui.item.value);  
        $("#userList").append("<option selected='selected' value='" + ui.item.value + "'>" + ui.item.label + "</option>")              
      },
     minLength: 3   
  });
	var newUserValidator = $("#inviteNew").validate({
		rules: {
			first_name: "required",
			surname: "required",
			subject: "required",
			email: {
        required: true,
        email: true,
        remote: "/signup/emailCheck"
      }
		},
		messages: {
			first_name: "Enter your firstname",
      surname: "Enter your lastname",
			subject: "You need to enter a subject",
      email: {
        required: "Enter an email address", 
				email: "This needs to be a valid email!",       
        remote: jQuery.format("this user already exits!")
      }
		},
		errorClass: "help-inline",
		submitHandler: function(form) {
		 $("#ajaxMain").block();
     $(form).ajaxSubmit({
		 	 success: function(){
			 	$("#ajaxMain").unblock();
			 	$("#inviteAlert").removeClass("alert-info");
				$("#inviteAlert").addClass("alert-success");
				$("#inviteBody").html('<h3>Invite Sent!</h3><p>Your invitation to ' + $("#first_name").val() + ' has been sent!</p>');
			 }
		 });
    },
		highlight: function(element, errorClass, validClass) {
     $(element).closest(".control-group").addClass("error").removeClass(validClass);     
	  },
	  unhighlight: function(element, errorClass, validClass) {
	     $(element).closest(".control-group").removeClass("error").addClass(validClass);	     
	  }
	});  
	$("#invite").submit(function(){
		$("#ajaxMain").block();
      $("#invite").attr("action","/alfresco/service/bv/sites/addUser?alf_ticket=" + $("#alf_ticket").val());  
      $.ajax({
        url: $("#invite").attr("action"),
        type: "POST",
        dataType: "json",
        data: {          
          siteID: $("#siteID").val(),
          userList: $("#userList").val().join(","),
          siteRole: $("#siteRole").val()
        },
        success: function(data) {
          $("#ajaxMain").unblock();
        }        
      })    
    return false;
  })
});

