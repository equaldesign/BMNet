$(function(){
	 $("#file").change(function(){
    $("#ssUpload").attr("action","/eunify/products/uploadSpreadsheet?type=stock");
    $("#ssUpload").submit();
  })
  $('#ssUpload').ajaxForm({
        beforeSubmit: function(a,f,o) {               
          $("#file").attr("disabled","disabled"); 
          if ($("#ssUpload").attr("action") == "/eunify/products/uploadSpreadsheet?type=stock") {
            o.dataType = "html";
            $('#beforeUpload').html('Checking your spreadsheet, please wait...'); 
          }            
        },
        success: function(data) {
          if ($("#ssUpload").attr("action") == "/eunify/products/uploadSpreadsheet?type=stock") {
            // we're at stage one
            $('#ssUpload').attr("action","/eunify/products/doImport?importobject=stock&importTable=stock");
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
