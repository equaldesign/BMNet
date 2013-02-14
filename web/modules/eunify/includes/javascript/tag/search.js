$(document).ready(function(){
  $('.tagSearch').autocomplete({
      delay: 1,
      source: $.buildLink("search.tags"),
      minLength: 3,
      select: function( event, ui ) {
        $("#tags").append('<span><span class="label"><i class="icon-tag"></i>' + ui.item.value + ' </span><a href="#" class="icon-trash deleteTempTag"></a></span>');
        $("#newTags").val($("#newTags").val() + "," + ui.item.value);
        $(".tagSearch").val("");  
      }			
  });
	$(".tagSearch").bind("keydown",function(e){
		var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 13) { //Enter keycode
		   var tagName = $(this).val();
			  $("#tags").append('<span><span class="label label-info"><i class="icon-tag"></i>' + tagName + '</span><a href="#" class="icon-trash deleteTempTag"></a></span>');
		   $("#newTags").val($("#newTags").val() + "," + tagName);
			 $(".tagSearch").val("");      
			 return false;
		 }
	})
	$(".deleteTempTag").live("click",function(){
		var tag = $(this).parent().text();
		$(this).parent().remove();
		$("#newTags").val($("#newTags").val().replace("," + tag,""));
	})
})
