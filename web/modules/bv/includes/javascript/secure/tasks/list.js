$(document).ready(function(){
	$('#taskFilter').selectmenu({style:'dropdown'});
	$("#taskFilter").change(function(){
		$.address.value("/tasks?filter=" + $(this).val());
	})
	$(".submitTask").click(function() {
		var t = $(this).parentsUntil(".task").parent();
		$.ajax({
      url: "/alfresco/service/api/workflow/task/end/" + $(this).attr("rev") + "/" + $(this).attr("rel") + "?alf_ticket=" + $("#alf_ticket").val(),
      type: "POST",
      dataType: "json",
      data: {
        taskID: $(this).attr("rev"),
        transitionID: $(this).attr("rel")
      },
      success: function(data) {
        $(t).remove();
      }
    });
	});
});
