$(function(){
	$("#getBuyingGroupInfo").click(function(){
		var contents = $(this).html();
		$(this).text("Searching....");
		$(this).addClass("disabled");
		$.ajax({
			url: "/signup/eGroupSearch",
			data: {
				eGroup_username: $("#eGroup_username").val(),
				eGroup_password: $("#eGroup_password").val(),
				eGroup_datasource: $("#eGroup_datasource").val()
			},
			dataType: "json",
			success: function(data) {				
			    var message = '<button class="close" data-dismiss="alert">&times;</button><h3 class="alert-heading">Excellent!</h3><p>We found your information, and have populated the majority of the form for you</p>';
					var theDiv = $("#getBuyingGroupInfo").closest(".form-actions"); 
					$(theDiv).removeClass("form-actions").addClass("alert alert-success");
					$(theDiv).html(message);
					// populate all the data for them
					$("#full_name").val(data.DATA.first_name[0] + " " + data.DATA.surname[0]);					
					$("#email").val($("#eGroup_username").val());
					$("#password").val($("#eGroup_password").val());
					$("#password2").val($("#eGroup_password").val());
					
					$("#company_name").val(data.DATA.name[0]);
					$("#siteName").val(data.DATA.bvsiteid[0]);
					
					$("#companyAddress").val(data.DATA.address1[0] + "\n" + data.DATA.address2[0]);
					$("#postcode").val(data.DATA.postcode[0]);
					$("#web").val(data.DATA.web[0]);
					$("#switchboard").val(data.DATA.switchboard[0]);				
			},
			error: function() {
				$(this).removeClass("disabled");
        $(this).html(contents);
			}
		})
	})
	$('a.lightbox').lightBox({fixedNavigation:true});
})
