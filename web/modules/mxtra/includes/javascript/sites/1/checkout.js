$(document).ready(function(){
	$("#pT").change(function(){
		if ($(this).val() == "Switch") {
			$("#div_startDate").show().css("visibility","visible");
			$("#div_issueNumber").show().css("visibility","visible");
		} else {
			$("#div_startDate").hide();
      $("#div_issueNumber").hide();
		}
	})
	$(".helptip").tooltip({
		trigger: "focus"
	})
})
