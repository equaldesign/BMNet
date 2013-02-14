$(document).ready(function(){
	$(".date").datepicker({
		dateFormat: 'dd/mm/yy'
	})
	$(".emailinvoice").click(function(){
		var anyChecked = false;
		console.log("ok");
		$(".emailinvoice").each(function() {
			if ($(this).is(":checked")) {
				anyChecked = true;
			}
		});
		if (anyChecked) {
			$("#emailInvoices").removeAttr("disabled");
		} else {
			$("#emailInvoices").attr("disabled",true);
		}
	});
});
