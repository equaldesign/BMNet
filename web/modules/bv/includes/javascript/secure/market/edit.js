
$(document).ready(function(){
  $("#validFrom, #validTo, #price, #billboard, #feature").change(function(){
		// we need to calculate the credits used
		var credits = 0;
		var price = parseInt($("#price").val()); 
		$(".date").datepicker({
      dateFormat: 'dd/mm/yy'
    });
		credits = Math.ceil(price/100);
		if ($("#feature").is(":checked")) {
			credits += 10;
		} 
		if ($("#billboard").is(":checked")) {
      credits += 20;
    }
		var noOfWeeks = weeks($("#validFrom").val(),$("#validTo").val());
		credits = credits * noOfWeeks;				
		$("#creditsUsed").text(credits);
		if (credits > $("#creditsAvailable").text()) {
			$("#creditsAvailable").removeClass("label-success");
			$("#creditsAvailable").addClass("label-important");
			$("#creditWarning").show();
		} else {
			$("#creditsAvailable").removeClass("label-important");
      $("#creditsAvailable").addClass("label-success");
      $("#creditWarning").hide();
		}
		
	})
	$(".delI").live("click",function(){
		$(this).parent().remove();
	})
	$("#securitySearch").autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: "/alfresco/service/api/groups?zone=APP.DEFAULT&shortNameFilter=" + $("#securitySearch").val() + "&alf_ticket=" + $("#alf_ticket").val(),          
        dataType: "json",        
        success: function(data) {                   
          response($.map(data.data, function(group){
            return {
              label: group.displayName,
              value: group.fullName
            }
          }));
        }
      });
    },    
    delay: 2,
    minLength: 3,
    select: function( event, ui ) {
      $("#securityUsers").append('<span name="security" class="lab label" rel="' + ui.item.value + '"><a href="#" title="remove this group" class="tooltip delI"><i class="icon-delete"></i></a> ' + ui.item.label + '</span>');
      $("#securitySearch").val("");            
    }
  })
	
	
	$("#BVSearch").autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: "/alfresco/service/bvine/search/products?maxrows=50" + "&q=" + $("#BVSearch").val() + "*&alf_ticket=" + $("#alf_ticket").val(),        
        dataType: "json",
				success: function( data ) {
          response( $.map( data.items, function( item ) {
            return {
              label: item.title + " "  + item.eancode,
              value: item.nodeRef
            }
          }));
        }
      });
    },    
    delay: 1,
    minLength: 3,
    select: function( event, ui ) {
      $("#bvnodes").append('<span name="BVNode" class="lab label" rel="' + ui.item.value + '"><a href="#" title="remove this product" class="tooltip delI"><i class="icon-delete"></i></a> ' + ui.item.label + '</span>');
			$("#BVSearch").val("");
      return false;
    }
  }) 	
	$('#fileUpload').submit(function() {       
      $(this).ajaxSubmit({
		  	dataType: "json",
		  	success: function(responseText, statusText, xhr, $form){
		  		$("#imageNodeRef").val(responseText.nodeRef);
		  		console.log(responseText);
		  	}
	    }); 
      return false; 
  }); 
	
	$("#image").change(function(){
    $("#image").appendTo("#fileUpload");
		$("#fileUpload").submit();	
	})
	
	$("#itemForm").validate({
    rules: {
      
			validFrom: {
				required: false,
				date: false
			},
			validTo: {
        required: false,
        date: false
      }
    }, 

    submitHandler: function() {
    
      //wrap it up and submit via ajax
      jsonObject = new Object();			
      $("#itemForm").block();
      
      $(".js").each(function(){
				if ($(this).attr("type") == "checkbox") {
		      jsonObject[$(this).attr("id")] = $(this).is(":checked");
				} else {
					jsonObject[$(this).attr("id")] = $(this).val();
				}
      });
			jsonObject["tags"] = [];
			$(".tag").each(function(){        
        jsonObject["tags"].push($(this).text());        
      });
			$(".lab").each(function(){        
        jsonObject[$(this).attr("name")] = $(this).attr("rel");        
      });
      $.ajax({
          url: $("#itemForm").attr("action"),
          contentType: "application/json",
          data: JSON.stringify(jsonObject),
          dataType: "json",
          type: $("#itemForm").attr("method"),
          success: function (data) { 
            $("#itemForm").unblock();
            $("#message").html("Site updated!");                               
          },
          error: function(){
           $("#itemForm").unblock();
             $("#message").html("Site updated!");  
          }     
        });
      return false;
    }
  })	
});
function weeks(date1,date2) {
	var DateO1 = new Date();
	var DateO2 = new Date();
	DateO1.setFullYear(date1.split("/")[2],date1.split("/")[1],date1.split("/")[0]);
	DateO2.setFullYear(date2.split("/")[2],date2.split("/")[1],date2.split("/")[0]);
	var difference = DateO2-DateO1;	
	return Math.round((difference/(1000*60*60*24)/7));
}
