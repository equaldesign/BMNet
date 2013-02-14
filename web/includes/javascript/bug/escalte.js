$(function(){
  $(".escalate").click(function(){
    var thisLink = $(this).attr("href");
    $.get(thisLink, function(data){
      $("#info").html(data);
      $("#other").remove();     
    });
    return false;
  })
})
