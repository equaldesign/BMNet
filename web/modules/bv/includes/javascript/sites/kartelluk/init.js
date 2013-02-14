$(document).ready(function(){
  $('label.over').labelOver('over');
  $('.tooltip').tipsy({
    live: true,
    gravity: "se"
  });
  $(".helptip").tipsy({
    live: true,
    gravity: "w",
    trigger: "focus"
  });
  //$("#DOB").datepicker({ dateFormat: 'dd/mm/yy',changeMonth: true, changeYear: true,yearRange: '-90Y:-16Y' });
  
  var showcase = $("#showcase").cycle({ 
      fx:     'scrollHorz',
      easing: 'easeInCirc',
      speed:  400, 
      cleartype: true, 
      cleartypeNoBg: true,
      timeout: 10000, 
      prev:    '#prev', 
      next:    '#next', 
      slideExpr: 'img'
   
  });   
  var supporters = $(".supporterCycle").cycle({ 
      fx:     'fade',
      easing: 'easeInCirc',
      speed:  600, 
      cleartype: true, 
      cleartypeNoBg: true,
      timeout: 15000,       
      slideExpr: 'div.supporter'
   
  });   
  
  
  $(".accordionNested").accordion('destroy').accordion({ navigation: true, autoHeight: false, collapsible: true,active: false, header: 'h3'});
    
})


  