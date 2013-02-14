$(document).ready(function(){
	var alf_ticket = $("#alf_ticket").val();
  $("#file").change(function(){
    $("#plUpload").attr("action","/bv/products/uploadPriceSpreadsheet");
    $("#plUpload").submit();
  })
	$(".removeUser").live("click",function(){
		$(this).closest("tr").remove();
	})
  $('#plUpload').ajaxForm({
    beforeSubmit: function(a,f,o) {               
      $("#file").attr("disabled","disabled"); 
      if ($("#plUpload").attr("action") == "/bv/products/uploadPriceSpreadsheet") {
		  	o.dataType = "html";
		  	$('#beforeUpload').html('Checking your spreadsheet, please wait...');
		  } else {
		  	$("#plUpload").block();
		  }      
    },
    success: function(data) {
      if ($("#plUpload").attr("action") == "/bv/products/uploadPriceSpreadsheet") {
        // we're at stage one
        $('#plUpload').attr("action","/bv/products/doImportPrices");
        $("#mapFields").show();
        $("#beforeUpload").html("");
        $("#file").removeAttr("disabled");
        $("#mapFields").html(data);
      } else {
        $("#ajaxMain").html(data);
				$("#plUpload").unblock();
      }           
    }
  });
	$("#securitySearch").autocomplete({
	  		
    source: function( request, response ) {
			var searchURL = "";
			var sType = $("#searchType").val();
			if (sType == "users") {
				searchURL = "/alfresco/service/api/search/person.json?alf_ticket=" + alf_ticket;
				data = {
					q: $("#securitySearch").val()
				}
			} else if (sType == "groups") {
				searchURL = "/alfresco/service/api/groups?zone=APP.DEFAULT&shortNameFilter=" + $("#securitySearch").val() + "&alf_ticket=" + alf_ticket,
				data = {};        
			} else {
				searchURL = "/alfresco/service/api/groups?zone=APP.SHARE&shortNameFilter=" + $("#securitySearch").val() + "&alf_ticket=" + alf_ticket,
        data = {};  
			}
      $.ajax({
        url: searchURL,         
        dataType: "json",
        data: data,
        success: function(data) {         
          if (sType == "users") {
						response($.map(data.people, function(person){
	            return {
	              label: person.name,
	              value: person.userName
	            }
	          }));	
					} else {
						response($.map(data.data, function(group){
	            return {
	              label: group.displayName,
	              value: group.fullName
	            }
	          }));
					}					
        }
      });
    },    
    delay: 2,
    minLength: 3,
    select: function( event, ui ) {  
		  var sType = $("#searchType").val();
		  if (sType == "users") {
				authType = "user";
			} else {
				authType = "group";
			}        
			$("#currentUsers").show();
      var newElement = '<tr class="userItem"> ' +          
      '<td class="authName authority_' + authType + '">' + ui.item.label + '</td><input type="hidden" name="authority" value="' +  ui.item.value + '" />' +     
      '<td nowrap="nowrap"><a rev="Site_Consumer" rel="' + ui.item.label + '" href="##" class="removeUser"><i class="icon-delete"></i></a></td>' +
      '</tr>';
      $("#currentUsers tbody").append(newElement);     
			$("#securitySearch").val(" ");               
    }
  })	
})
