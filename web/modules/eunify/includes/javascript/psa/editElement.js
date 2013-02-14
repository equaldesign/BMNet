$(document).ready(function(){  
	$("#dateRange").click(function() {
		if($(this).is(':checked')){
	    $("#dateTo").attr("disabled", false);
			$("#dateFrom").attr("disabled", false);    
	   }
	   else{
	    $("#dateTo").attr("disabled", true);
      $("#dateFrom").attr("disabled", true);
	   }
	})
	$("#targetName").autocomplete({
    source:  "/eunify/chart/psasearch",
    minLength: 2,
      select: function(event, ui) {
        var series = $(this).attr("id");
        $("#targetID").val(ui.item.id);           
        var eLen = ui.item.rebateNodes.length
        for (x=0;x<eLen;x++) {
          if (x==0) { // if it's one, automatically select the first one
            $("#targetElements").append('<option selected="selected" value="' + ui.item.rebateNodes[x].rebateID + '">' + ui.item.rebateNodes[x].detail + '</option>');
          } else {
            $("#targetElements").append('<option value="' + ui.item.rebateNodes[x].rebateID + '">' + ui.item.rebateNodes[x].detail + '</option>');
          }
        }     
      }
  })
	var group = $("#cType").val();
	var options = { 
			        //target:        '#' + group + "_0" ,   // target element(s) to be updated with server response 
			        beforeSubmit:  showRequest,  // pre-submit callback 
			        success:       afterEditElement,  // post-submit callback 
			 
			        // other available options: 
			        //url:       url         // override for form's 'action' attribute 
			        //type:      type        // 'get' or 'post', override for form's 'method' attribute 
			        dataType:  "json"      // 'xml', 'script', or 'json' (expected server response type) 
			        //clearForm: true        // clear all form fields after successful submit 
			        //resetForm: true        // reset the form after successful submit 
			 
			        // $.ajax options can be used here too, for example: 
			        //timeout:   3000 
			    }; 	
	function showRequest(formData, jqForm, options) { 
	    //alert('About to submit: \n\n' + queryString); 
	    // here we could return false to prevent the form from being submitted; 
	    // returning anything other than false will allow the form submit to continue  
	    
			return true; 
	} 
	 
	// post-submit callback 
	function showResponse(responseText, statusText, xhr, $form)  { 
	    // for normal html responses, the first argument to the success callback 
	    // is the XMLHttpRequest object's responseText property 
	    // if the ajaxForm method was passed an Options Object with the dataType 
	    // property set to 'json' then the first argument to the success callback 
	    // is the json data object returned by the server 
	    // alert('status: ' + statusText + '\n\nresponseText: \n' + responseText +  '\n\nThe output div should have already been updated with the responseText.'); 
	}
	function afterEditElement(responseText, statusText, xhr, $form)  { 
			jsonData = responseText;
			arrayIndex = jsonData.arrayIndex;
			if (jsonData.funct == "edit") {
	  	  $("#" + jsonData.cType + "_" + arrayIndex).replaceWith(jsonData.htmlData);
	    } else {
				$("#" + jsonData.cGroup + "_list").append(jsonData.htmlData);
			}
			
			$("#dialog").dialog("close");
	}	
		
	function enableFigures(bool) {
	x = document.getElementById("ftitle");

	if (bool) {
		x.disabled = false;
		alert(x.disabled);
		} else { 
		x.disabled = true;
		}
	}
  $("#rebateType").change(function(){
		var value = $(this).val();
		if (value == "standard") {
			$("#rebate_target_psa").css("display","none");
			$("#rebatevaluediv").css("display","block");
		} else if (value == "stepped") {
			$("#rebate_target_psa").css("display","none");
      $("#rebatevaluediv").css("display","none");
	  } else if (value == "individual") {
			$("#rebate_target_psa").css("display","none");
      $("#rebatevaluediv").css("display","none");
		}	else {
		  $("#rebate_target_psa").css("display", "block");
      $("#rebatevaluediv").css("display","none");
	  }
	})
	$("#memberRestrictions").click(function() { 
		if($(this).is(':checked')) {
			$("#membersParticipating").attr("disabled",false);
		} else {
			$("#membersParticipating").attr("disabled",true);
		}
	})
	$(".accordion").accordion('destroy').accordion({ autoHeight: false,collapsible: true,active: false, header: 'h5',cookie: { expires: 30 } });
	$("#accordion2").accordion('destroy').accordion({ navigation: true, autoHeight: false, collapsible: true,active: false, header: 'h3'});
	$(".accordionopen").accordion('destroy').accordion({ autoHeight: false, header: 'h5'});
	$(".button").button();
	$(".datePicker").datepicker({ dateFormat: 'dd/mm/yy' });
	$('#elementForm').validate({
    errorClass: "invalid",
    rules: {
      cid: "required",
      ctitle: "required"
    },
    messages: {
      cid: "A unique ID is required",
      ctitle: "A title is required"
    },
		
		submitHandler: function(form) {
			//tinyMCE.triggerSave();
        $(form).ajaxSubmit(options);
      }

	})
	
});
function enableCalculation(bool) {
	y = document.getElementById("calculateY");
	n = document.getElementById("calculateN");
	if (bool) {
		y.checked = true;
	} else {
		n.checked = true;
	}
}
function showCompounds(bool) {
	x = document.getElementById("retrospectiveAgainst");
	if (bool) {
		x.disabled = false;
	} else {
		x.disabled = true;
	}
}
function enabledInheritance(bool) {
	z = document.getElementById("inheritFrom");	
	if (bool) {
		z.disabled = false;
	} else {
		z.disabled = true;	
	}
}
