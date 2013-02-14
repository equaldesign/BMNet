$(document).ready(function(){
  $("head").append("<link>");
  css = $("head").children(":last");
  css.attr({
    rel:  "stylesheet",
    type: "text/css",
    href: "https://www.buildingvine.com/includes/style/jQuery/jQuery.ratings.css"
  });
  $.getScript("https://www.buildingvine.com/includes/javascript/jQuery/jQuery.ratings.js",function(){    
      var dataString = $("#bv_extra_data").attr("rel");
      if (dataString != "" && dataString != null) {
       var apiString = $("#bv_extra_data").attr("rel");
       $("body").append("<div id='bvdialog'></div>");
       $.ajax({
         url:"https://www.buildingvine.com/api/getProductRating?" + dataString,
         dataType: "jsonp",
         success: function(data) {
          $('#bv_extra_data').attr("id","disqus_thread");
					$.getScript("https://buildingvine.disqus.com/embed.js",function(){
						var disqus_shortname = 'buildingvine';
            var disqus_identifier = data;
            var disqus_url = "http://www.buildingvine.com/products/productDetail?nodeRef=" + data;
					})
          
         }
       })      
       //$.getJSON(apiString,function(data) {
       //  $("#bv_extra_data").html(data.html);
       // })
       // $(".ills").append('<div id="fb-root"><iframe src="http://www.facebook.com/widgets/like.php?href=http://www.buildingvine.com" scrolling="no" frameborder="0" style="border:none; width:450px; height:80px"></iframe></div>');
      }      
  })  
});
