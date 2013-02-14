$(document).ready(function(){  
  $(".accordion").accordion('destroy').accordion({ autoHeight: false,collapsible: true,active: false, header: 'h5' });
    
  $(".accordionopen").accordion('destroy').accordion({ autoHeight: false, header: 'h5'}); 
  $(".accordionopen2").accordion('destroy').accordion({ autoHeight: false, header: 'h5', active: 1});
  $("#accordion2").accordion('destroy').accordion({ 
    icons: false,     
    autoHeight: false, 
    collapsible: true, 
    active: false, 
    header: 'h3'
  });
	$(".leftAccordion").accordion('destroy').accordion({ 
    icons: false,     
    autoHeight: false, 
    collapsible: true, 
    active: false, 
    header: 'h4'
  });
})
