$(function(){
  	$(".emulate").click(function(){
			var device = $(this).attr("data-emulation");
			var orientation = $(this).attr("data-orientation");
			$.blockUI();
			$.ajax({
				url: "/sums/admin/emulate",
				data: {
					device: device,
					orientation: orientation,
					address: document.location.href
				},
				success: function(data) {
					$.unblockUI();
					$("body").append('<div class="modal-backdrop fade in"></div>');
          $("body").append('<div id="emulator"></div>');
					$("#emulator").html(data);
					runEmulator(device,orientation);
					
				}
			})
		})
		$("body").keyup(function(e) {
			if (e.which == 27) {
				$(".modal-backdrop").remove();
				$("#emulator").remove();
			} 
		})
  $('#weburl').livequery("keyup",function(e) {
		
		if (e.which == 13) {
        document.getElementById('mobileframe').src= getPrefix($('#weburl').val()) + $('#weburl').val();
      } 
	})
	$('.refresh').livequery("click",function() {    
    document.getElementById('mobileframe').src= getPrefix($('#weburl').val()) + $('#weburl').val();
    return false;
  })	
	$('.mobileframe a').livequery("click",function() {
		$('#weburl').val($(".mobileframe").get(0).contentWindow.location.href);
	})
	$('.mobileframe').livequery("mouseenter",function(){
    $(this).attr('scrolling','yes');   
  });
	$('.mobileframe').livequery("mouseleave",function(){
    $(this).attr('scrolling','no');   
  });
})
function runEmulator(device,orientation) {
	if (device == "iphone") {
		if (orientation == "vertical") {
			$("#emulator").css({
        "position": "fixed",
        "top": "50%",
				"left": "50%",
				"height": "744px",
				"width": "393px",
				"margin": "-372px 0 0 -196px",
				"z-index": "1050"
			})
		} else {
			$("#emulator").css({
        "position": "fixed",
        "top": "50%",
        "left": "50%",
        "height": "387px",
        "width": "752px",
        "margin": "-193px 0 0 -376px",
        "z-index": "1050"
      })
		}
		$("#mobileframe").attr("src",document.location.href);
	} else {
		if (orientation == "vertical") {
      
    } else {
      
    }
	}
}
function getPrefix(string){
  
  var prefix = 'http://';
  
  if(string.substring(0,7) == 'http://')
  {
    prefix = '';
  }
  else if(string.substring(0,8) == 'https://')
  {
    prefix = '';
  }
  else if(string.substring(0,7) == 'file://')
  {
    prefix = '';
  }

  else
  {
    prefix = 'http://';
  }

  return prefix;
}