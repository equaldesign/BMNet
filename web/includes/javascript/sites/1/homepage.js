$(window).load(function(){   
$('.fullwidthbanner').revolution(
    {    
        delay:9000,                                                
        startheight:490,                            
        startwidth:890,
        
        hideThumbs:200,
        
        thumbWidth:100,                            
        thumbHeight:50,
        thumbAmount:5,
        
        navigationType:"both",                  
        avigationArrows:"verticalcentered",         
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