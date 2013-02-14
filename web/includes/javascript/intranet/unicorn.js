/**
 * Unicorn Admin Template
 * Diablo9983 -> diablo9983@gmail.com
**/

var tabsSmall = false;

$(document).ready(function(){

	
	
	// === Sidebar navigation === //
	
	$('.submenu > a').click(function(e)
	{
		e.preventDefault();
		var submenu = $(this).next('ul');
		var li = $(this).closest('li');
		var submenus = $(this).closest("ul").find("li.submenu > ul");		
		var submenus_parents = $(this).closest("ul").find("li.submenu");
		if(li.hasClass('open'))
		{
			if(($(window).width() > 768) || ($(window).width() < 479)) {
				submenu.slideUp();
			} else {
				submenu.fadeOut(250);
			}
			li.removeClass('open');
			li.removeClass('active');
		} else {
			if(($(window).width() > 768) || ($(window).width() < 479)) {
				submenus.slideUp();			
				submenu.slideDown();
			} else {
				submenus.fadeOut(250);			
				submenu.fadeIn(250);
			}
			submenus_parents.removeClass('open');		
			submenus_parents.removeClass('active');    
			li.addClass('open');	
			li.addClass('active');
		}
	});
  $('#sidebar a').click(function(){
		if ($(this).attr("rev") == "maincontent") {
			var sidebar = $('#sidebar');
		  if (sidebar.hasClass('open')) {
				sidebar.removeClass('open');
				ul.slideUp(250);
			}
		}
	})	
	$('#sidebar > a').click(function(e)
  {
    e.preventDefault();
    var sidebar = $('#sidebar');
    if(sidebar.hasClass('open'))
    {
      sidebar.removeClass('open');
      ul.slideUp(250);
    } else 
    {
      sidebar.addClass('open');
      ul.slideDown(250);
    }
  });
	
	var ul = $('#sidebar > ul');
	
	function resizeTabs() {
		var selected = $(".tabs").tabs('option', 'selected');
	    if (selected == undefined || selected == "") {
	      // no tabs on page
	    } else {			
	      if ($(window).width() < 600 && !tabsSmall) {
	        console.log("resize to small");
	        $(".tabs ul.ui-tabs-nav > li > a").each(function(){
	          var theDiv = $(this).attr("href");            
						// console.log(theDiv);
	          // find the matching div and move it
	          $(theDiv).appendTo($(this).parent());           
	        })
	        tabsSmall = true;        
	      } else if ($(window).width() >= 600 && tabsSmall) {
					console.log("resize to large");        
	        $(".tabs ul.ui-tabs-nav > li > a").each(function(){
	          var theDiv = $(this).attr("href");            
	          // find the matching div and move it
						// console.log(theDiv);
	          $(theDiv).appendTo($(this).closest(".tabs"));            
	        })
	        tabsSmall = false;        
	      }  
	    }    
	}
	

	// === Resize window related === //
	$(window).resize(function()
	{		
	  resizeTabs();
		if($(window).width() > 479)
		{
			ul.css({'display':'block'});	
			$('#content-header .btn-group').css({width:'auto'});		
		}
		if($(window).width() < 479)
		{
			ul.css({'display':'none'});
			fix_position();
		}
		if($(window).width() > 768)
		{
			$('#user-nav > ul').css({width:'auto',margin:'0'});
            $('#content-header .btn-group').css({width:'auto'});
		}
	}).resize();
	
	if($(window).width() < 468)
	{
		ul.css({'display':'none'});
		fix_position();
	}
	if($(window).width() > 479)
	{
	   $('#content-header .btn-group').css({width:'auto'});
		ul.css({'display':'block'});
	}
	
	// === Tooltips === //
	$('.tip').tooltip();	
	$('.tip-left').tooltip({ placement: 'left' });	
	$('.tip-right').tooltip({ placement: 'right' });	
	$('.tip-top').tooltip({ placement: 'top' });	
	$('.tip-bottom').tooltip({ placement: 'bottom' });	
	
	// === Search input typeahead === //
	$('#search input[type=text]').typeahead({
		source: ['Dashboard','Form elements','Common Elements','Validation','Wizard','Buttons','Icons','Interface elements','Support','Calendar','Gallery','Reports','Charts','Graphs','Widgets'],
		items: 4
	});
	
	// === Fixes the position of buttons group in content header and top user navigation === //
	function fix_position()
	{
		var uwidth = $('#user-nav > ul').width();
		$('#user-nav > ul').css({width:uwidth,'margin-left':'-' + uwidth / 2 + 'px'});
        
        var cwidth = $('#content-header .btn-group').width();
        $('#content-header .btn-group').css({width:cwidth,'margin-left':'-' + uwidth / 2 + 'px'});
	}
	
  resizeTabs();
});
