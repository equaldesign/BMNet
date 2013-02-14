$(function(){
	$("#templateList").change(function(){
		var templateID = $(this).val();
		var campaignID = $(this).attr("data-id");
		$("#emailTemplateiFrame").attr("src","/marketing/email/template/getTemplate?campaignID=" + campaignID + "&templateid=" + templateID);
	})
})
function onChange()
{
  
  $("#emailTemplateiFrame").contents().find("#mainContent").html(this.getData());
}