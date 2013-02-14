$(function(){
	$(".showbranch").mouseover(function(){
		$("#branch_" + $(this).attr("rel")).show();
	})
	$(".showbranch").mouseout(function(){
    $("#branch_" + $(this).attr("rel")).hide();
  })
})
