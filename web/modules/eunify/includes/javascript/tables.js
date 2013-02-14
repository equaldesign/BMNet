$(document).ready(function(){
		
	$('.dataTable').dataTable({
    "bJQueryUI": true,
    "sPaginationType": "full_numbers",
    "sDom": '<"reload"r><""l>t<"F"fp>',
    "oLanguage": {
      "sLengthMenu": "_MENU_ records per page"
    }  
  });
	$('select').select2();
})
