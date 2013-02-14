$(function(){
	var qTable =  $('#queryListTable').dataTable( {        
        "bProcessing": true,
        "bServerSide": true,       
        "bJQueryUI": true,
        "sPaginationType": "full_numbers",
        "sDom": '<"reload"r><""l>t<"F"fp>',      
        "sAjaxSource": "/marketing/email/recipient/query?SECHO=1&id=1",
        "bStateSave": true,
        "iDisplayLength": 25
        
     });  
  var recipientTable =  $('#recipientList').dataTable( {
        "bProcessing": true,
        "bServerSide": true,       
        "bJQueryUI": true,
        "sPaginationType": "full_numbers",
        "sDom": '<"reload"r><""l>t<"F"fp>',
        "sAjaxSource": "/marketing/email/recipient/list?campaignID=" + $('#recipientList').attr("data-campaignID"),
        "bStateSave": true,
        "iDisplayLength": 25
        
     });    
	$(".addobject").livequery("click",function(){
		var objectType = $(this).attr("data-type");
		var thisRow = $(this).closest("tr");
		
		$.ajax({
      url: "/marketing/email/recipient/add",
      method: "POST",
      data: {
        id: $(this).attr("data-id"),
        type: objectType,
				campaignID: $('#recipientList').attr("data-campaignID") 
      },
      success: function(data) {
        recipientTable.fnReloadAjax("/marketing/email/recipient/list?SECHO=1&campaignID=" + $('#recipientList').attr("data-campaignID"));
      }   
    })			
	});
	$(".addall").livequery("click",function(){
    $.ajax({
      url: "/marketing/email/recipient/addQuery",
      method: "POST",
      data: {
        queryID: $("#queryList").val(),        
        campaignID: $('#recipientList').attr("data-campaignID") 
      },
      success: function(data) {
        recipientTable.fnReloadAjax("/marketing/email/recipient/list?SECHO=1&campaignID=" + $('#recipientList').attr("data-campaignID"));
      }   
    })      
  });
	$(".removeobject").livequery("click",function(){
		$.ajax({
      url: "/marketing/email/recipient/remove",
      method: "POST",
      data: {
        id: $(this).attr("data-id"),        
        campaignID: $('#recipientList').attr("data-campaignID") 
      },
      success: function(data) {
        recipientTable.fnReloadAjax("/marketing/email/recipient/list?SECHO=1&campaignID=" + $('#recipientList').attr("data-campaignID"));
      }   
    })		
	});
	
	$("#queryList").livequery("change",function(){    
	 console.log("do query?");
    qTable.fnReloadAjax("/marketing/email/recipient/query?SECHO=1&id=" + $(this).val());        
  });
	
	
})


