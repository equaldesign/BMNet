<cfset getMyPlugin(plugin="jQuery").getDepends("","","#request.siteID#/basket,#request.siteID#/shop")>
<cfset products = getModel("modules.eunify.model.ProductService")>
<div class="page-heading">
  <h1 class="basket">Your Quotation</h1>
</div>
<cfif ArrayLen(rc.quote.items) gte 1>
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
    <cfoutput>
    <cfloop array="#rc.quote.items#" index="item">
    <cfset rc.product = products.getProduct(item.productID,request.siteID)>    
    <tr>
      <td class="productInfo">      
        <a href="/mxtra/shop/product?productID=#rc.product.product_code#">#rc.product.Full_Description#</a></h2>
      </td>
      <td>
      	<cfif rc.id eq request.quote.id>
        <form class="form-inline" action="/mxtra/shop/quote/update" id="updateBasket" method="post">
          <input type="hidden" name="product_code" value="#rc.product.product_code#" />
          <input class="input-mini" type="text" width="2" size="1" maxlength="3" name="quantity" value="#item.quantity#">
          <input type="submit" class="btn btn-info" value="update">
          <cfif rc.product.collectable>
            
          </cfif>
        </form>
				<cfelse>
					#item.quantity#
				</cfif>
      </td>
      <td nowrap>&pound;#DecimalFormat(VATPrice(item.itemcost*item.quantity))#</td>
    </tr>
    </cfloop>
    </cfoutput>
    </tbody>
  </table>
  <cfif NOT rc.isAjax>
  <form class="pull-right" action="/mxtra/shop/quote/email">
  	<cfoutput><input type="hidden" name="id" value="#rc.id#" /></cfoutput>
  <cfif rc.id neq request.quote.id>
  	 <cfoutput><a href="/mxtra/shop/quote/continue?id=#rc.id#" class="btn btn-success">&laquo; Continue with this Quote</a></cfoutput>
  <cfelse>
    <cfif rc.refURL neq ""><cfoutput><a href="#rc.refURL#" style="font-weight:normal;color:white" class="btn btn-success">&laquo; Continue Shopping</a></cfoutput></cfif>
  </cfif>
  <input class="btn btn-success" type="submit" value="Save and email quotation &raquo;">
  </cfif>
</form>
<cfelse>
<p>Your quotation is currently empty</p>
</cfif>