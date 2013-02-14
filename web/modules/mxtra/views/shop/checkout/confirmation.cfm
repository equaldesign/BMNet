<cfset getMyPlugin(plugin="jQuery").getDepends("form,validate","shop/checkout","#request.siteID#/checkout")>
<cfset products = getModel("eunify.ProductService")>
<cfset totalProductCost = 0>
<cfset totalDeliveryCost = 0>
<div id="checkout">
<cfoutput>#renderView("shop/checkout/stages")#</cfoutput>

  <div class="alert alert-success">
  	<h3>Confirmation</h3>
		<p>Please review and confirm your <cfif rc.delivered>order<cfelse>reservation</cfif> below</p>
  </div>
  <div class="row">
  	<div style="margin-bottom:10px;" class="pull-right">
  <form action="/mxtra/shop/checkout/finish" method="post">
    <cfoutput>
    <input type="hidden" name="accountNumber" value="#request.mxtra.order.accountnumber#" />
    </cfoutput>
    <cfif rc.delivered>
		  <input type="submit" value="CONFIRM <cfif request.mxtra.order.quote>YOUR QUOTE<cfelse>&amp; COMMIT YOUR ORDER</cfif> &raquo;" class="btn btn-success">
		<cfelse>
			<input type="submit" value="CONFIRM YOUR RESERVATION &raquo;" class="btn btn-success">
	  </cfif>
	</form>
		</div>
  </div>
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
          <input type="hidden" name="refURL" value="/mxtra/shop/checkout" />
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
<cfoutput>
<div>
<div class="page-header">
  <h2 style="text-align:right">Total <cfif rc.delivered>including delivery<cfelse>due on collection</cfif>: &pound;#DecimalFormat(rc.basketTotal)#</h2>
</div>
<table width="100%">
<tr>
  <td colspan="2" valign="top">
  <cfif isUserInRole("trade") OR request.mxtra.order.quote eq false AND rc.delivered>
		  <table class="table table-striped table-bordered">
        <thead>
          <tr>
            <th colspan="2">Payment information (<a href="/mxtra/shop/checkout?stage=3">change...</a>)</th>
          </tr>
        </thead>
        <tbody>
			    <tr>
			      <td>Card Type:</td>
			      <td>#request.mxtra.order.card.cardType#</td>
			    </tr>
			    <tr>
			      <td>Card name:</td>
			      <td>#request.mxtra.order.card.name#</td>
			    </tr>
			    <tr>
			      <td>Card Number:</td>
			      <td>xxxx-xxxx-xxxx-#right(request.mxtra.order.card.CARDNUMBER,4)#  </td>
			    </tr>
			    <cfif request.mxtra.order.card.validFrom neq "" AND DateFormat(request.mxtra.order.card.validFrom,"YYYYMM") neq DateFormat(now(),"YYYYMM")>
			    <tr>
			      <td>Start Date:</td>
			      <td>#Month(request.mxtra.order.card.validFrom)#/#Year(request.mxtra.order.card.validFrom)#</td>
			    </tr>
			    </cfif>
			    <tr>
			      <td>Expiry Date:</td>
			      <td>#Month(request.mxtra.order.card.validTo)#/#YEAR(request.mxtra.order.card.validTo)#</td>
			    </tr>
			    <cfif request.mxtra.order.card.issueNumber NEQ ''>
			    <tr>
			      <td>Issue Number:</td>
			      <td>#request.mxtra.order.card.issueNumber#</td>
			    </tr>
			    </cfif>
			    <tr>
			      <td>Security Code:</td>
			      <td>#request.mxtra.order.card.securityCode#</td>
			    </tr>
        </tbody>
		  </table>
	  </div>
	</cfif>
  </td>
</tr>
<cfif rc.delivered>
<tr>
  <td valign="top">
  <div class="summary">
	  <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th colspan="2">Billing Information (<a href="/mxtra/shop/checkout?stage=1">change...</a>)</th>
        </tr>
      </thead>
      <tbody>
	      <tr>
	        <td>Name:</td>
	        <td>#request.mxtra.order.invoice.name#</td>
	      </tr>
	      <tr>
	        <td>Address:</td>
	        <td>#request.mxtra.order.invoice.address1#</td>
	      </tr>
        <tr>
          <td>Town:</td>
          <td>#request.mxtra.order.invoice.town#</td>
        </tr>
        <tr>
          <td>County:</td>
          <td>#request.mxtra.order.invoice.county#</td>
        </tr>
	      <tr>
	        <td>Postcode:</td>
	        <td>#request.mxtra.order.invoice.postCode#</td>
	      </tr>
	      <tr>
	        <td>Phone:</td>
	        <td>#request.mxtra.order.invoice.phone#</td>
	      </tr>
	      <tr>
	        <td>Email:</td>
	        <td>#request.mxtra.order.invoice.email#</td>
	      </tr>
	      <tr>
	        <td>Mobile:</td>
	        <td>#request.mxtra.order.invoice.mobile#</td>
	      </tr>
      </tbody>
    </table>
  </div>
  </td>
  <td valign="top">
  <div class="summary">
    <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th colspan="2">Delivery Information (<a href="/mxtra/shop/checkout?stage=2">change...</a>)</th>
        </tr>
      </thead>
      <tbody>
	      <tr>
	        <td>Name:</td>
	        <td>#request.mxtra.order.delivery.name#</td>
	      </tr>
	      <tr>
	        <td>Address:</td>
	        <td>#request.mxtra.order.delivery.address1#</td>
	      </tr>
        <tr>
          <td>Town:</td>
          <td>#request.mxtra.order.delivery.town#</td>
        </tr>
        <tr>
          <td>County:</td>
          <td>#request.mxtra.order.delivery.county#</td>
        </tr>
	      <tr>
	        <td>Postcode:</td>
	        <td>#request.mxtra.order.delivery.postCode#</td>
	      </tr>
	      <tr>
	        <td>Phone:</td>
	        <td>#request.mxtra.order.delivery.phone#</td>
	      </tr>
	      <tr>
	        <td>Email:</td>
	        <td>#request.mxtra.order.delivery.email#</td>
	      </tr>
	      <tr>
	        <td>Mobile:</td>
	        <td>#request.mxtra.order.delivery.mobile#</td>
	      </tr>
      </tbody>
    </table>
  </div>
  </td>
</tr>
</cfif>
</table>
</div>
  <div class="pull-right">
    <form action="/mxtra/shop/checkout/finish" method="post">
    <cfoutput>
    <input type="hidden" name="accountNumber" value="#request.mxtra.order.accountnumber#" />
    </cfoutput>
      <cfif rc.delivered>
      <input type="submit" value="CONFIRM <cfif request.mxtra.order.quote>YOUR QUOTE<cfelse>&amp; COMMIT YOUR ORDER</cfif> &raquo;" class="btn btn-success">
    <cfelse>
      <input type="submit" value="CONFIRM YOUR RESERVATION &raquo;" class="btn btn-success">
    </cfif>
  </form>
  </div>
</form>
</div>
</cfoutput>
