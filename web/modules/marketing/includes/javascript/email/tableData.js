$(function() {

  $(".eTable").each(function(){
    $(this).dataTable( {
      "bJQueryUI": true,
      "sPaginationType": "full_numbers",
      "sDom": '<"reload"r><""l>t<"F"fp>',
      "bAutoWidth":false,
      "bProcessing": true,
      "bServerSide": true,
      "iDisplayLength": 50,        
      "bStateSave": true,
      "sAjaxSource": "/marketing/email/chart/table?type=" + $(this).attr("filter-type") + "&campaignID=" + $(this).attr("campaign-id"),
      "aoColumns" : [
            {"bVisible" : false, "aTargets" : [0]},            
            {"bVisible" : false, "bSortable" : false, "aTargets" : [1]},
            {"sTitle" : "Contact Name"},
            {"sTitle" : "Company Name"},
            {"sTitle" : "Email"},
            {"sTitle" : "Date"}]      
    });
    //$(this).dataTable().fnSetColumnVis(0,false);
    //$(this).dataTable().fnSetColumnVis(1,false);
    
  })


});