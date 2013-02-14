         
$(document).ready(function() {
  if ($.fn.cssOriginal!=undefined)   // CHECK IF fn.css already extended
  $.fn.css = $.fn.cssOriginal;
  $('.banner').revolution(
    {    
        delay:9000,                                                
        startheight:400,                            
        startwidth:1170,
        
        hideThumbs:200,
        
        thumbWidth:100,                            
        thumbHeight:50,
        thumbAmount:5,
        
        navigationType:"both",                  
        navigationArrows:"verticalcentered",        
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
});