$(document).ready(function(){
	var reJustTheNumber = /\s*(\-?\d+(\.\d+)?)\s*/;  
  $("#register").validate({
    invalidHandler: function(e, validator) {
      var errors = validator.numberOfInvalids();
      if (errors) {
        var message = errors == 1
          ? 'You missed 1 field. It has been highlighted below'
          : 'You missed ' + errors + ' fields.  They have been highlighted below';
        $("#formError").html(message);
        $("formError").show();
      } else {
        $("#formError#").hide();
      }
    }
  });
	$(".requirenumeric").change(function(){
		var thisVal = $(this).val();
		if (thisVal.search(reJustTheNumber) > -1){
      $(this).val(RegExp.$1);
    } else {
      alert('Enter just a numeric value!');
      $(this).val("");
    }
	})
	$(".ui-stepper-textbox").each(function(){
		
		$(this).stepper({
      step: parseInt($(this).attr("data-increments")),
			max: parseInt($(this).attr("data-max"))
    });
	});
}) 