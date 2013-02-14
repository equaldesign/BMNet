$(document).ready(function(){
	var alf_ticket = $("#alf_ticket").val();
	var securityNodeRef = $("#securityNodeRef").val();
	$("#userSearch").autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: "/alfresco/service/api/search/person.json?alf_ticket=" + alf_ticket,             
        dataType: "json",
        data: {            
          q: $("#userSearch").val()
        },
				success: function(data) {         
          response($.map(data.people, function(person){
            return {
              label: person.name,
              value: person.userName
            }
          }));
        }
      });
    },    
    delay: 2,
    minLength: 3,
    select: function( event, ui ) {
      
      $.ajax({
        url: "/alfresco/service/slingshot/doclib/permissions/" + securityNodeRef + "?alf_ticket=" + alf_ticket,
        dataType: "json",
        type: "POST",
        contentType: 'application/json',
        data: JSON.stringify(
          {
              "permissions":
               [{"authority":ui.item.value,"role":$("#newUserLevel").val()}]
          }
          
        ),                  
        success: function(data) {
					$("#userSearch").val("");
					var newElement = '<tr class="userItem"> ' +          
          '<td class="authName authority_user">' + ui.item.label + '</td>' +
          '<td width="40%">' + $("#newUserLevel").val() + '</td>' +
          '<td nowrap="nowrap"><a rev="Site_ + ' + $("#newUserLevel").val() + '" rel="' + ui.item.label + '" href="##" class="removeUser"></a></td>' +
          '</tr>';
         $("#direct tbody").append(newElement);              
        }
     })
      
    }
  })
	
	$("#groupSearch").autocomplete({
    source: function( request, response ) {
      $.ajax({
        url: "/alfresco/service/api/groups?zone=APP.DEFAULT&shortNameFilter=" + $("#groupSearch").val() + "&alf_ticket=" + alf_ticket,             
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
      
      $.ajax({
        url: "/alfresco/service/slingshot/doclib/permissions/" + securityNodeRef + "?alf_ticket=" + alf_ticket,
        dataType: "json",
        type: "POST",
        contentType: 'application/json',
        data: JSON.stringify(
          {
              "permissions":
               [{"authority":ui.item.value,"role":$("#newUserLevel").val()}]
          }
          
        ),                  
        success: function(data) {
          $("#groupSearch").val("");
          var newElement = '<tr class="userItem"> ' +          
          '<td class="authName authority_group">' + ui.item.label + '</td>' +
          '<td width="40%">' + $("#newUserLevel").val() + '</td>' +
          '<td nowrap="nowrap"><a rev="Site_' + $("#newUserLevel").val() + '" rel="' + ui.item.label + '" href="##" class="removeUser"></a></td>' +
          '</tr>';
         $("#direct tbody").append(newElement);              
        }
     })
      
    }
  })
	
	$(".secureResource").click(function(){			
		doSecurity(false);
  });
	$(".unsecureResource").click(function(){    
    doSecurity(true);
  });
	function doSecurity(isInhert) {		
	 $.ajax({
        url: "/alfresco/service/slingshot/doclib/permissions/" + securityNodeRef + "?alf_ticket=" + alf_ticket,
        dataType: "json",
        type: "POST",
        contentType: 'application/json',
        data: JSON.stringify(
          {
              "permissions": [],
							"isInherited": isInhert
          }          
        ),
			 success: function(data) {
	       $.get("/security/getSecurity?node=" + securityNodeRef, function(data){
				   $("#dialog").html(data);
				 })   
       }
     })
	}	
	$(".removeUser").live("click",function(){
		/*
		 * Remove the user 
		 */
		  var authority = $(this).attr("rel");
			var role = $(this).attr("rev");
			var el = $(this).parent().parent();
			$.ajax({
            url: "/alfresco/service/slingshot/doclib/permissions/" + securityNodeRef + "?alf_ticket=" + alf_ticket,
            dataType: "json",
            type: "POST",
            contentType: 'application/json',
            data: JSON.stringify({
								"permissions":
                   [
									   {
										 	  "authority":authority,
												"role":role,
												"remove": true
										 }
									]
              })
						,                  
            success: function(data) {
              $(el).remove(); 
            }
         })
		
	});
});

