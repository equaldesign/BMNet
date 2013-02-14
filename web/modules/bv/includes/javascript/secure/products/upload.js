$(document).ready(function(){
	$("#file").change(function(){
		$("#ssUpload").attr("action","/bv/products/uploadSpreadsheet");
		$("#ssUpload").submit();
	})
	$('#ssUpload').ajaxForm({
        beforeSubmit: function(a,f,o) { 				      
			    $("#file").attr("disabled","disabled"); 
					if ($("#ssUpload").attr("action") == "/bv/products/uploadSpreadsheet") {
						o.dataType = "html";
					  $('#beforeUpload').html('Checking your spreadsheet, please wait...');	
					}            
        },
        success: function(data) {
					if ($("#ssUpload").attr("action") == "/bv/products/uploadSpreadsheet") {
		        // we're at stage one
						$('#ssUpload').attr("action","/bv/products/importProducts");
						$("#afterUpload").show();
						$("#beforeUpload").html("");
						$("#file").removeAttr("disabled");
						$("#afterUpload").html(data);
					} else {
						$("#ajaxMain").html(data);
					}           
        }
    });
})
