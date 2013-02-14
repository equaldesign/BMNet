$(document).ready(function(){
  $(".date").datepicker({
    dateFormat: 'dd/mm/yy'
  })
	$(".updateB").blur(function(){
		$(this).closest(".udq").submit();		
	});
	$("label.over").labelOver("over");
});
