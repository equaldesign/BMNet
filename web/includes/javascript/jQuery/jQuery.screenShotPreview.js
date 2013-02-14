(function($) {
  $.fn.screenshotPreview = function() {
		var xOffset = 150;
    var yOffset = 30;
		var stillOver = false;
    this.each(function() {

      // element-specific code here
      $(this).hover(function(e){
				stillOver = true;
				var imgSrc = this.rel;
				var title = $(this).attr("title");
        var img = new Image();				
        var caption = (title != "") ? "<br/>" + title : "";
				$(img).load(function() {
					if (stillOver) {
				  	$(this).hide();
				  	$("#screenshot").animate({
				  		width: this.width,
				  		height: this.height + 35
				  	}).append(this).append(caption);
				  	$(this).fadeIn();
				  }
				}).error(function() {
					// do something about unloaded images
				}).attr("src",imgSrc);       
		    $("#screenshot")
		      .css("top",(e.pageY - xOffset) + "px") 
		      .css("left",(e.pageX + yOffset) + "px")
		      .fadeIn("fast");            
		    },
		  function(){
				$("#screenshot").fadeOut("fast").html("");
				stillOver = false;;
		    }); 
		  $("a.screenshot").mousemove(function(e){
		    $("#screenshot")
		      .css("top",(e.pageY - xOffset) + "px")
		      .css("left",(e.pageX + yOffset) + "px");
		  });  
    });
    return this; 
  };
})(jQuery);

