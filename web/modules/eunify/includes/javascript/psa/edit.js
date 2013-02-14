$(document).ready(function(){
// pre-submit callback 
	$(".date").datepicker({
		dateFormat: 'dd/mm/yy'
	});
	
	// elements sorting
	$('.comp').each(function(){
   var el = this;
   var nn = $(el).attr("id");
   var nNArray = nn.split("_");
   var nodeName = nNArray[0];
   $(el).sortable({    
       placeholder: 'dragging',
       containment: 'document',
       items: 'div.realtd',
       helper: 'clone',
       opacity: 0.6,
       scroll: true,
       cursor: 'move',
       axis: 'y',
     update: function(event,ui) {           
      var option = $(el).sortable('serialize', { expression: '(.+)[_](.+)'  });     
      var psaID = $("#psaID").val();     
			$(el).block(); 
        $.ajax({
            url: "/eunify/psa/moveElement", 
            type: "POST",
            data: {
				      option: option,
				      psaID: psaID,
				      nodeName: nodeName
			      },
            success: function(data) {
              $(el).unblock();
            }
        });     
     },
     delay: 500,
     handle: 'img.handle',
     revert: true
    });
  });
	$(".addComponent").live("click",function(){
		var componentType = $(this).attr("rel");
		var section = $(this).attr("rev");
		var psaID = $("#psaID").val();
		$.blockUI();
		$.ajax({ 
	      url: "/eunify/psa/createElement?psaID=" + psaID + "&type=" + componentType + "&group=" + section, 
	      dataType: "html",
	      success: function(data){
					$("#dialog").dialog({
						width: 700,
            height: 600,
						autoOpen: false
					});
	        $("#dialog").dialog("option", "title", "Edit this element ");
	        $("#dialog").html(data);
	        $("#dialog").addClass("Aristo");
	        $("#dialog").dialog( "option", "buttons",{});
	        $.unblockUI();
	        // bind form using 'ajaxForm' 
	        $('#dialog').dialog('open');      
	        //loadingWindow(false);
	      }});
		return false;
	})
	$(".deleteComponent").live("click",function(){    
    var div = $(this).parentsUntil(".realtd").parent();
		var id = $(this).attr("rel");
    var psaID = $("#psaID").val();		
    var conf = window.confirm("Are you sure you wish to delete this element?");
		if (conf) {
			$(div).block();
			$.ajax({
				url: "/eunify/psa/deleteElement?psaID=" + psaID + "&rebateID=" + id,
				dataType: "html",
				success: function(data){
					$(div).unblock();
					$(div).remove();					
				}
			});
	  }
    return false;
  })
	$(".cloneComponent").live("click",function(){
		var div = $(this).parent().parent().parent().parent();
    var id = $(this).attr("rev");
    var psaID = $("#psaID").val();  
		$(div).block();
		$.ajax({
        url: "/eunify/psa/cloneElement?psaID=" + psaID + "&id=" + id,
        dataType: "html",
        success: function(data){
          $(div).unblock();
          $(div).append(data);          
        }
      });
	})
	$(".editStep").live("click",function(){
		var tr = $(this).parentsUntil("tr").parent();
		var x = $(tr).attr("id").split("_");
		var id = x[1];
		var step = x[2];
		var from = $(tr).find(".from");
		var button = $(tr).find(".editStepButtonTD");
		var to = $(tr).find(".to");
		var value = $(tr).find(".value");
		var fromValue = $(from).attr("rel");
		var toValue = $(to).attr("rel");
		var valueValue = $(value).attr("rel");
		$(from).html('<input type="text" size="6" class="input_from" value="' + fromValue + '">');
		$(to).html('<input type="text" size="6" class="input_to" value="' + toValue + '">');
		$(value).html('<input type="text" size="6" class="input_value" value="' + valueValue + '">');
		$(button).html('<img class="tooltip doEditStep" title="confirm changes to step" src="/images/icons/tick-circle-frame.png" />');
		return false;
	})
	$(".doEditStep").live("click",function(){
		var tr = $(this).parentsUntil("tr").parent();
    var x = $(tr).attr("id").split("_");
		var psaID = $("#psaID").val();
    var id = x[1];
    var step = x[2];
    var from = $(tr).find(".from");
    var button = $(tr).find(".editStepButtonTD");
    var to = $(tr).find(".to");
    var value = $(tr).find(".value");		
    var fromValue = $(tr).find(".input_from").val();
    var toValue = $(tr).find(".input_to").val()
    var valueValue = $(tr).find(".input_value").val();
		$(tr).block();
		$.ajax({ 
      url: "/eunify/psa/editStep?psaID=" + psaID + "&rebateID=" + id + "&step=" + step, 
      dataType: "json",
			data: {
	      from: fromValue,
	      to: toValue,
	      value: valueValue
      },
      success: function(jsonData){
        $(to).html(jsonData.to);
				$(to).attr("rel",jsonData.to.replace(/[^0-9\.]+/g, ''));
        $(from).html(jsonData.from);
        $(from).attr("rel",jsonData.from.replace(/[^0-9\.]+/g, ''));
				$(value).html(jsonData.value.replace(/[^0-9\.]+/g, ''));    
				$(value).attr("rel",jsonData.value);
				$(button).empty();
				$(tr).unblock();    
      }
		});
		return false;
	})
	$(".doAddStep").live("click",function(){
    var tr = $(this).parentsUntil("tr").parent();
    var x = $(tr).attr("id").split("_");
    var psaID = $("#psaID").val();
    var id = x[1];
    var fromValue = $(tr).find(".from").val();
    var toValue = $(tr).find(".to").val()
    var valueValue = $(tr).find(".value").val();
    $(tr).block();
    $.ajax({ 
      url: "/eunify/psa/addStep?psaID=" + psaID + "&rebateID=" + id, 
      dataType: "html",
      data: {
        from: fromValue,
        to: toValue,
        value: valueValue
      },
      success: function(data){
        $(tr).before(data);
				$(tr).unblock();    
      }
    });
    return false;
  })
	$('#coreInfo').validate({
    errorClass: "invalid",
    rules: {
      contact_id: "required",
      id: "required",
			name: "required",
			company_id: "required",
			buyingTeamID: "required",
			period_from: {
	  	  required: true,
	  	  date: false
	    },
			period_to: {
        required: true,
        date: false
      },
			signedbysupplierdate: {
        required: false,
        date: false
      }
    },
    messages: {
      contact_id: "Negotiator is required",
			name: "Product Range required",
			buyingTeamID: "Category is required",
      id: "An ID must be entered",
			company_id: "Supplier is required",
			period_from: "You must choose a from date",
			period_to: "You must choosen an expiry date"
    }
  })
	$(".deleteStep").live("click",function(){
    var tr = $(this).parentsUntil("tr").parent();
    var x = $(tr).attr("id").split("_");
    var psaID = $("#psaID").val();
    var id = x[1];
    var step = x[2];   
		var conf = window.confirm("Are you sure you wish to delete this step?");
		if (conf) {
			$(tr).block();
			$.ajax({
				url:  "/eunify/psa/deleteStep?psaID=" + psaID + "&rebateID=" + id + "&step=" + step,
				dataType: "html",
				success: function(jsonData){
					$(tr).unblock();
					$(tr).remove();
				}
			});
	  }
    return false;
  })
	$(".editComponent").live("click" ,function(){
		var psaID = $(this).attr("rel");
		var index = $(this).attr("rev");
		$.ajax({ 
	      url: "/eunify/psa/editElement?psaID=" + psaID + "&index=" + index, 
	      dataType: "html",
				
	      success: function(data){
					$("#dialog").dialog({
            width: 700,
            height: 600,
            autoOpen: false
          });
	        $("#dialog").dialog("option", "title", "Edit this element");
	        $("#dialog").html(data);
	        $("#dialog").addClass("Aristo");
	        $("#dialog").dialog( "option", "buttons",{});
	          // bind form using 'ajaxForm' 
	        $('#dialog').dialog('open');      
	        //loadingWindow(false);
	       }
		   });
		return false;
	});
})