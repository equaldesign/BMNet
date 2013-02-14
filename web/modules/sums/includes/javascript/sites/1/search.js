$(document).ready(function(){
	var cache = {},
      lastXhr;
	$("#searchQuery").autocomplete({
		source: function( request, response ) {
        var term = request.term;
        if ( term in cache ) {
          response( cache[ term ] );
          return;
        }

        lastXhr = $.getJSON( "/mxtra/shop/search/jsonsearch", request, function( data, status, xhr ) {
          cache[ term ] = data;
          if ( xhr === lastXhr ) {
            response( data );
          }
        });
      },    
    minLength: 2,
    select: function(event, ui){
      document.location.href = "/mxtra/shop/product?productID=" + ui.item.id;
    }       
  })
})
