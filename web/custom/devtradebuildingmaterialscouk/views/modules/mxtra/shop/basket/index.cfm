<cfset getMyPlugin(plugin="jQuery").getDepends("","","#request.siteID#/basket,#request.siteID#/shop")>
<cfset products = getModel("modules.eunify.model.ProductService")>
<div class="page-heading">
  <h1 class="basket">Your Shopping List</h1> 
</div>
<div class="alert alert-info">
	<a class="close" data-dismiss="alert">&times;</a>
	<h3 class="alert-heading">We'll get you the best price</h3>
	<p>Once you're done shopping, we'll send your shopping list to Merchants within your area so they can fight for your business - getting you the best possible quote and lowering your costs.</p>
	<p>If you've shopped with us before, we can optionally send a summary of your previous purchase history which may give you an even better quotation.</p>
</div>

<cfif ArrayLen(rc.basket.items) gte 1>
<cfoutput><input type="hidden" name="refURL" value="#rc.refURL#"></cfoutput>
<div id="basketDetailHeader"> </div>
  <table class="table table-striped table-bordered">
    <thead>
    <tr>
      <th width="60%">Product Detail</th>
      <th>QTY</th>
      <th>Approx</th>
    </tr>
    </thead>
    <tbody>
    <cfoutput>
		<cfset approxTotal = 0>
    <cfloop array="#rc.basket.items#" index="item">
    <cfset rc.product = products.getProduct(item.productID,request.siteID)>
    <tr>
      <td class="productInfo">      
        <a href="/mxtra/shop/product?productID=#rc.product.product_code#">#rc.product.Full_Description#</a></h2>
      </td>
      <td>
        <form class="form-inline" action="/mxtra/shop/basket/update" id="updateBasket" method="post">
          <input type="hidden" name="product_code" value="#rc.product.product_code#" />
          <input class="input-mini" type="text" width="2" size="1" maxlength="3" name="quantity" value="#item.quantity#">
          <input type="submit" class="btn btn-info" value="update">
        </form>
      </td>
      <td style="text-align:right" nowrap>&pound;#DecimalFormat(VATPrice(item.itemcost*item.quantity))#</td>
    </tr>
		<cfset approxTotal+=VATPrice(item.itemcost*item.quantity)>
    </cfloop>
    </cfoutput>
    </tbody>
		<tfoot>
			<tr>
				<th></th>
				<th style="text-align:right">Approx Total*</th>
				<th style="text-align:right"><cfoutput>&pound;#DecimalFormat(approxTotal)#</cfoutput></th>
			</tr>
		</tfoot>
  </table>
	<cfoutput>#renderView("shop/estimates")#</cfoutput>
  <form class="pull-right" action="/mxtra/shop/checkout">  
	<cfoutput><a href="#rc.refURL#" style="font-weight:normal;color:white" class="btn btn-success">&laquo; Continue Shopping</a></cfoutput>
	<input class="btn btn-info" type="submit" value="Get my costs &raquo;">
</form>
<cfelse>
<p>Your shopping list is currently empty</p>
<a href="/mxtra/shop/category?categoryID=0" class="btn btn-info">Lets go shopping!</a>
</cfif>