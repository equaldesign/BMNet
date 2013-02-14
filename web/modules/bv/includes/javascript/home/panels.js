$(document).ready(function(){
  $("#homeQuickNav").localScroll({
    target: '#homePages', // could be a selector or a jQuery object too.
    queue:true,
    duration:400,		
    hash:false,
    onBefore:function( e, anchor, $target ){
      // The 'this' is the settings object, can be modified			
    },
    onAfter:function( anchor, settings ){
      // The 'this' contains the scrolled element (#content)
    }
  });
	$(".navit").click(function(){
		$(".navit").each(function(){
			$(this).removeClass("active");
		})
		$(this).addClass("active");
	})
	$(".showthematrix").click(function(){
		$("#featuresBox").slideToggle("fast");
	})
});
