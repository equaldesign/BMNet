$(document).ready(function(){
	$(".showsubsection").click(function(){		
    $(".subsection").each(function(){
      $(this).hide();
    })
    $("#" + $(this).attr("rel")).slideToggle();
  });
	$(".section").click(function() {
		$(".section").each(function(){
			$(this).removeClass("active");
		})
		$(this).addClass("active");
	})
	$(".hidesubsections").click(function(){    
    $(".subsection").each(function(){
      $(this).hide();
    })    
  });
})
