$(document).ready(function(){
	$("#showDialog").live("click",function(){
		$("#dialog").html($("#defaultDiag").html());
    $("#dialog").dialog({
        buttons: {}
      })
    $("#dialog").dialog("open");        
	});
	$("#doChart").click(function(){
			$("#filterColumn").val("");
			$("#filterValue").val("");
			var columnArray = [];
			var columnValues = [];
			$(".filter").each(function(){
				if ($(this).val() != "") {
					columnArray.push($(this).attr("id"));
					columnValues.push($(this).val());
				}
			});
			$("#filterColumn").val(columnArray.join(","));
			$("#filterValue").val(columnValues.join(","));
			initCharts();			
  })
})
