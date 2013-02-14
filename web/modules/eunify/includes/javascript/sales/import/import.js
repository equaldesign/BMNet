$(function(){
	 $("#file").change(function(){
    $("#ssUpload").attr("action","/eunify/sales/uploadSpreadsheet");
    $("#ssUpload").submit();
  })
  $('#ssUpload').ajaxForm({
        beforeSubmit: function(a,f,o) {               
          $("#file").attr("disabled","disabled"); 
          if ($("#ssUpload").attr("action") == "/eunify/sales/uploadSpreadsheet") {
            o.dataType = "html";
            $('#beforeUpload').html('Checking your spreadsheet, please wait...'); 
          }            
        },
        success: function(data) {
          if ($("#ssUpload").attr("action") == "/eunify/sales/uploadSpreadsheet") {
            // we're at stage one
            $('#ssUpload').attr("action","/eunify/sales/doImport");
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
