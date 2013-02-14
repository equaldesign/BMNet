$(function(){
   if ($.fn.cssOriginal!=undefined)   // CHECK IF fn.css already extended
  $.fn.css = $.fn.cssOriginal;
  $('.banner').revolution(
    {    
        delay:9000,                                                
        startheight:490,                            
        startwidth:890,
        
        hideThumbs:200,
        
        thumbWidth:100,                            
        thumbHeight:50,
        thumbAmount:5,
        
        navigationType:"both",                  
        navigationArrows:"nexttobullets",        
        navigationStyle:"round",                
        touchenabled:"on",                      
        onHoverStop:"on",                        
        
        navOffsetHorizontal:0,
        navOffsetVertical:20,
        
        hideCaptionAtLimit:0,
        hideAllCaptionAtLilmit:0,
        hideSliderAtLimit:0,
        
        stopAtSlide:-1,
        stopAfterLoops:-1,
        
        shadow:1,
        fullWidth:"off"    
                                    
    });
	
	// Bind event to every .btn-navbar button
 $('.btn-navbar').click(function(){
     // Select the .nav-collapse within the same .navbar as the current button
     var nav = $(this).closest('.navbar').find('.nav-collapse');
     // If it has a height, hide it
     if (nav.height() != 0) {
         nav.height(0);
     // If it's collapsed, show it
     } else {
         nav.height('auto');
     }
 });
});