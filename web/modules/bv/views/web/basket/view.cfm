<cfset getMyPlugin(plugin="jQuery").getDepends("lightbox,mousewheel","secure/products/edit,secure/products/detail","secure/basket,jQuery/lightbox/style,secure/products/products,secure/products/admintools")>
<cfoutput>
<h2>Your Basket</h2>
<div id="basket">
  <cfset i = 1>
  <cfloop array="#rc.basket.basketItems#" index="item">
  <div class="item #IIF(i MOD(2) eq 0,'"odd"','"even"')#">
    <div class="image">
      <img src="#item.image#">
    </div>
    <div class="info">
      <h3><a href="/products/az/id/#item.ASIN#">#item.title#</a></h3>
      <p>#item.quotedprice#</p>
    </div>
    <div class="quantity">
      <form action="/basket/update/id.#item.ASIN#">
        <label for="item_#item.ASIN#">QTY</label>
        <input id="item_#item.ASIN#" type="text" name="quantity" value="#item.quantity#" size="3">
        <!--- <input type="submit" value="update"/> --->
      </form>
    </div>
  </div>
  <cfset i++>
  </cfloop>
</div>
  <div id="subTotal">Sub Total: #rc.basket.basket.CartGetResponse.Cart.SubTotal.FormattedPrice.xmlText#
    <a class="roundCorners" id="checkout" href="#rc.basket.basket.CartGetResponse.Cart.PurchaseURL.xmlText#">Proceed to Checkout <span class="arrow"></span></a>
  </div>
<div id="relatedProducts">
  <h2>People also bought the following items...</h2>
  <div id="relatedProductList">
    <cfloop array="#rc.basket.similarItems#" index="relatedProduct">
    <div class="p">
      <a href="/products/az/id/#relatedProduct.ASIN#">
        <h3>#relatedProduct.title#</h3>
        <h4>#relatedProduct.price#</h4>
        <img src="#relatedProduct.image#">
      </a>
    </div>
    </cfloop>
  </div>
</div>
</cfoutput>