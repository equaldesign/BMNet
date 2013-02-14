$(document).ready(function(){
	$("#setpostcode").ajaxForm({
		beforeSubmit:function(){
			$("#locationsFound").html("Updating, please wait...");
		},
		success:function(data){
			$("#locationsFound").html(data);			
		}
	})
})
