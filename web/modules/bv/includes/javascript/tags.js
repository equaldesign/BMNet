$(function(){
  $(".deleteTag").click(function(e){
    e.preventDefault();
    var thisElement = this;
    var uri = $(this).attr("href");
    $(this).closest("li").remove();
    
    $.ajax({
      url: uri,
      type: "DELETE"   
    });
    return false;
  })
})