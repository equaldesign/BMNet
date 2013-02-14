<cfoutput>
  <form class="form-horizontal doBasket" action="/mxtra/shop/quote/add" method="post">
    <input type="hidden" name="productID" value="#rc.productID#" />
    <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/product?productID=#rc.productID#')#" />
    <div class="input-prepend input-append">
      <span class="add-on">QTY.</span><input type="text" class="input-micro" maxlength="3" name="quantity" value="1"><input class="btn btn-info" type="submit" value="Add to quotation &raquo;">
    </div>            
  </form>  
  <div class="clear"></div>
</cfoutput>

