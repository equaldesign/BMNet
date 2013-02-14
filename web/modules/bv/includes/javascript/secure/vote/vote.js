$(function() {
  $(".badge").click(function(){
    var c = $(this).prev();
    if ($(c).is(":checked")) {
      var v = $(this).text();
      $(this).text(v--);
      $(this).removeClass("badge-success");
      $(this).prev().prop('checked', false);
    } else {
      var v = $(this).text();
      $(this).text(v++);
      $(this).addClass("badge-success");
      $(this).prev().prop('checked', true);
    }
  })
})