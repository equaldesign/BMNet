$(document).ready(function(){
  $("#toggleFavourites").live("click",function(){
    if ($(this).hasClass("disabled")) {
      $(this).text("filter using my favourites");
    } else {
      $(this).text("remove favourites filter");
    }
    $(this).toggleClass("disableit");
    $.get( $.buildLink("favourites.toggle"),function(){
      window.location.reload(); 
    });      
  });
	$(".selectAll").live("click",function(){
		if ($(this).is(":checked")) {
			$(".filterCheck").each(function() {
        this.checked = true;
      });
		} else {
			$(".filterCheck").each(function() {
        this.checked = false;
      });
		}
	})
});
