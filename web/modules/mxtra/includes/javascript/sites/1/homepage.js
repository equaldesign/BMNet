$(document).ready(function(){
	var accordion = $("#accordion");
  var index = $.cookie("accordion");
  var active;
  if (index !== null) {
          active = accordion.find("h3:eq(" + index + ")");
  } else {
          active = 0
  }
  
  accordion.accordion({
          header: "h3",
          autoHeight: false,
          active: active,
          change: function(event, ui) {
                  var index = $(this).find("h3").index ( ui.newHeader[0] );
                  $.cookie("accordion", index, {
                          path: "/"
                  });
          }
  
  }); 
  var showcase = $('#showcase').cycle({ 
      fx:     'scrollRight',
      easing: 'easeInCirc',
      speed:  400, 
      timeout: 8000, 
      pager:  '#showcasenav',
      //after: onAfter,
      slideExpr: 'a.hlink'
   
  });   

});