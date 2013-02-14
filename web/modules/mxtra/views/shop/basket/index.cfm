<cfset getMyPlugin(plugin="jQuery").getDepends("","","#request.siteID#/basket,#request.siteID#/shop")>
<cfset products = getModel("eunify.ProductService")>
<div class="page-heading">
  <h1>Your <cfif rc.order.quote>Quotation<cfelse>Basket</cfif></h1>
</div>
<cfif rc.order.quote>
<div id="basketHeader">
  <div id="intro">
    <h2>Quotations</h2>
    <div><p>You are logged in as an account customer. Therefore, your products are added to a quotation instead of a retail "basket".</p>
    <p> Once you have all the items you need in your quotation, it will be sent to Turnbull, who will apply any trade terms that may or may not be applicable.</p></div>
  </div>
  <div id="grandTotal">
   <h2>Cost Estimate</h2>
   <h1><cfoutput>&pound;#Trim(VatPrice(rc.basketTotal.totalDeliveryCost+rc.basketTotal.totalProductCost))#</cfoutput></h1>
   <p>Including VAT and delivery</p><p>(this cost may change once your trade terms are applied)</p>
  </div>
  <br class="clear" />
</div>
</cfif>
<cfif rc.order.quote>
<form action="/mxtra/shop/checkout">

<input type="submit" class="doIt" value="proceed to quote confirmation &raquo;">

</form>
</cfif>
<cfif request.basket.recordCount gte 1>
<cfoutput><input type="hidden" name="refURL" value="#rc.refURL#"></cfoutput>
<div id="basketDetailHeader"> </div>
  <table class="table table-striped table-bordered">
    <thead>
    <tr>
      <th width="60%">Product Detail</th>
      <th>QTY</th>
      <th>Total</th>
    </tr>
    </thead>
    <tbody>
    <cfoutput query="request.basket">
    <cfset rc.product = products.getProduct(product_code,request.siteID)>
    <cfset stockAvailable = products.getavailableBranchStock(rc.product.Product_Code,request.siteID)>
    <tr>
      <td class="productInfo">
        <a href="#bsl('/mxtra/shop/product?productID=#rc.product.product_code#')#">#rc.product.Full_Description#</a></h2>
      </td>
      <td>
        <form class="form-inline" action="/mxtra/shop/basket/update" id="updateBasket" method="post">
          <input type="hidden" name="product_code" value="#rc.product.product_code#" />
          <div class="input-append">
            <input class="input-mini" type="text" width="2" size="1" maxlength="3" name="quantity" value="#quantity#">
            <input type="submit" class="btn btn-info" value="update">
          </div>
					<cfif rc.product.collectable>

					</cfif>
        </form>
      </td>
      <td nowrap><cftry>&pound;#DecimalFormat(VATPrice(item_cost*quantity))#<cfcatch type="any">no price?</cfcatch></cftry></td>
    </tr>
    <cfif delivery_cost neq 0>
    <tr>
      <td colspan="2">Delivery</td>
      <td>&pound;#DecimalFormat(delivery_cost*quantity)#</td>
    </tr>
    </cfif>
    </cfoutput>
    </tbody>
    <tfoot>
      <tr>
        <th colspan="2" style="text-align: right;">TOTAL</th>
        <th>&pound;<cfoutput>#DecimalFormat(rc.basketTotal)#</cfoutput></th>
      </tr>
    </tfoot>
  </table>
	<cfif NOT rc.isAjax>
  <form class="pull-right" action="/mxtra/shop/checkout">
  <cfif rc.refURL neq ""><cfoutput><a href="#rc.refURL#" class="btn">Continue Shopping</a></cfoutput></cfif>
  <button class="btn" type="submit"><i class="icon-tick-circle-frame"></i> Proceed to checkout</button>
	</cfif>
</form>
<cfelse>
<p>Your basket is currently empty</p>
</cfif>
