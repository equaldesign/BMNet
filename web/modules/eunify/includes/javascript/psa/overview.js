$(document).ready(function(){
  var showcase = $(".dealPromoList").cycle({ 
      fx:     'scrollRight',
      easing: 'easeInCirc',
      speed:  400, 
      timeout: 8000,
      pager:  '#dealPromoNav',
      pause: true,
      cleartype: true, 
      cleartypeNoBg: true,
      slideExpr: 'div.promotion'
   
  });   
	$(".showPromotion").qtip(
	  {
	    content: {
	      text: $(this).next().html()
	    }
	  }
	)
	
})
