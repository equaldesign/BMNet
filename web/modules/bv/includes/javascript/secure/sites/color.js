$(document).ready(function(){
	$('#colorPicker').colorpicker().on('changeColor', function(ev){    
		$(".navbar-inner").css("background",ev.color.toHex() + " !important");
  });	
})
