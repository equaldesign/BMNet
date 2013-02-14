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
      $('<tr><td><input type="hidden" name="quantity" value="' + $("#quantity").val() + '" />' + $("#quantity").val() + '</td><td><input type="hidden" name="unit" value="' + $("#unit").val() + '" />' + $("#unit").val() + '</td><td><input type="hidden" name="product_name" value=""/><input type="hidden" name="product_code" value="' + ui.item.id + '"/>' + ui.item.label + '</td><td><a href="#" class="removeItem"><i class="icon-delete"></i></a></td></tr>').appendTo($("#shoppingList tbody"));
			$("#quantity").val("");
			$("#searchQuery").val("");
    }       
  })
	$("#searchQuery").bind('keypress', function(e) {
		var code = (e.keyCode ? e.keyCode : e.which);
		 if(code == 13) { //Enter keycode
		   $('<tr><td><input type="hidden" name="quantity" value="' + $("#quantity").val() + '" />' + $("#quantity").val() + '</td><td><input type="hidden" name="unit" value="' + $("#unit").val() + '" />' + $("#unit").val() + '</td><td><input type="hidden" name="product_code" value=""/><input type="hidden" name="product_name" value="' + $("#searchQuery").val() + '"/>' + $("#searchQuery").val() + '</td><td><a href="#" class="removeItem"><i class="icon-delete"></i></a></td></tr>').appendTo($("#shoppingList tbody"));
       $("#quantity").val("");
       $("#searchQuery").val("");
			 return false;
		 }
	});
})
