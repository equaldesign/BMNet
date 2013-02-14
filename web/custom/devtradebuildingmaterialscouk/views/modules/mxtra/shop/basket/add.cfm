<cfoutput>
  <form class="form-horizontal" action="/mxtra/shop/basket/add" method="post"> 
    <input type="hidden" name="productID" value="#rc.productID#" />
    <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/product?productID=#rc.productID#')#" />
    <div class="input-prepend input-append">
      <span class="add-on">QTY.</span>
			<input type="text" class="input-micro" maxlength="3" name="quantity" value="1">
			<button type="submit" class="btn btn-info">Add to list <i class="icon-list"></i></button>
    </div>            
  </form>  
  <div class="clear"></div>
</cfoutput>

