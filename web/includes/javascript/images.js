$(function(){
		var spinnerOptions = {
	    lines: 10, // The number of lines to draw
		  length: 4, // The length of each line
		  width: 2, // The line thickness
		  radius: 10, // The radius of the inner circle
		  corners: 1, // Corner roundness (0..1)
		  rotate: 0, // The rotation offset
		  color: '#000', // #rgb or #rrggbb
		  speed: 1, // Rounds per second
		  trail: 60, // Afterglow percentage
		  shadow: false, // Whether to render a shadow
		  hwaccel: true, // Whether to use hardware acceleration
		  className: 'spinner', // The CSS class to assign to the spinner
		  zIndex: 2e9, // The z-index (defaults to 2000000000)
		  top: '45%', // Top position relative to parent in px
		  left: '50%' // Left position relative to parent in px
	};
	
	$("#productList img, .productPage img").loadNicely({
	    preLoad: function (img) {
	        $(img).parent().spin(spinnerOptions);					
					$(img).css('visibility', 'hidden');
	    },
	    onLoad: function (img) {
			try{
				$(img).parent().data("spinner").stop();        
			  	$(img).css('visibility', 'visible').hide().fadeIn("slow");
			} catch (e) {
				// 
			}
	    }
	});
})
