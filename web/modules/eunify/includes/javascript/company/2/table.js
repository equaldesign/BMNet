var oTable2;
var giRedraw = false;

$(function() {

   oTable2 =  $('#company_2_List').dataTable( {
      "bJQueryUI": true,
      "sPaginationType": "full_numbers",
      "sDom": '<"reload"r><""l>t<"F"fp>',   
			"bAutoWidth":false,     
			"bProcessing": true,
      "bServerSide": true,				
      "sAjaxSource": "/eunify/company/list/type_id/2",								
			"bStateSave": true,
			"iDisplayLength": 25,
			"aoColumnDefs": [ 
        {
					  "bVisible": false, "aTargets": [ 0 ] 
				}
      ]
   });		 
	 $('select').select2();
} );
