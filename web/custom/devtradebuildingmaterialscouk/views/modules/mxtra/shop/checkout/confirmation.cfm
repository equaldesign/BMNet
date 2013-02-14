<cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/turnbull","#request.siteID#/checkout")>
<cfset products = getModel("modules.eunify.model.ProductService")>
<cfset totalProductCost = 0>
<cfset totalDeliveryCost = 0>
<div id="checkout">
  <div class="page-header">
    <h1>Checkout</h1>
  </div>	
	<div id="checkOutStage">
	  <ul class="breadcrumb">
	    <li><a class="active" href="/mxtra/shop/checkout">1. Login or guest</a><span class="divider">/</span></li>
	    <li><a class="active" href="/mxtra/shop/checkout?stage=1">2. Billing</a><span class="divider">/</span></li>
	    <li><a class="active" href="/mxtra/shop/checkout?stage=2">3. Delivery</a><span class="divider">/</span></li>
	    <li><a class="active" href="/mxtra/shop/checkout?stage=3">4. Payment Information</a><span class="divider">/</span></li>
	    <li><a class="active" href="/mxtra/shop/checkout?stage=4">5. Confirmation</a></li>
	  </ul>
	</div>  
  
  <div class="alert alert-success">
  	<h3>Confirmation</h3>
		<p>Please review and confirm your <cfif rc.order.quote>quotation<cfelse>order</cfif></a> below</p>
  </div>
  <div class="row">
  	<div style="margin-bottom:10px;" class="pull-right">
  <form action="/mxtra/shop/checkout/finish" method="post">
    <cfoutput>
    <input type="hidden" name="accountNumber" value="#rc.order.accountnumber#" />
    </cfoutput>    
			<input type="submit" value="CONFIRM <cfif rc.order.quote>YOUR QUOTE<cfelse>&amp; COMMIT YOUR ORDER</cfif> &raquo;" class="btn btn-success &raquo;">
	</form>
		</div>
  </div>
      <table class="table table-striped table-bordered">
        <thead>
				<tr>
          <th>Product</th>
          <th>QTY</th>
          <th>Total</th>
          <th>Delivery</th>
        </tr>
				</thead>
        <cfoutput>
        <cfloop array="#rc.basket.items#" index="item">
        <cfset rc.product = products.getProduct(item.productID,request.siteID)>
        <cfset totalProductCost = totalProductCost + item.itemcost*item.quantity>
        <cfset totalDeliveryCost = totalDeliveryCost + item.deliverycost>
        <tr>
          <td>
            <a href="/mxtra/shop/product?productID=#rc.product.product_code#">#rc.product.Full_Description#</a>
          </td>
          <td>
          	<form class="form-inline" action="/mxtra/shop/basket/update" id="updateBasket" method="post">
              <input type="hidden" name="product_code" value="#item.productID#" />
              <input class="input-mini" type="text" width="2" size="1" maxlength="3" name="quantity" value="#item.quantity#">
              <input type="submit" class="btn btn-info" value="update">
            </form>
					</td>
          <td nowrap>&pound;#DecimalFormat(VatPrice(item.itemcost*item.quantity))#</td>
          <td>&pound;#DecimalFormat(VatPrice(item.deliverycost))#</td>
        </tr>
        </cfloop>

        <tr>
          <th class="bold" colspan="2" align="right">TOTAL including Delivery</th>
          <th>&pound;#VatPrice(totalProductCost)#</th>
          <th>&pound;#VatPrice(totalDeliveryCost)#</th>
        </tr>
        </cfoutput>
      </table>
<cfoutput>
<div>
<div class="page-header">
  <h2 style="text-align:right">Total including delivery: &pound;#Trim(VatPrice(totalDeliveryCost+totalProductCost))#</h2>
</div>
<table width="100%">
<tr>
  <td colspan="2" valign="top">
  <cfif isUserInRole("trade") OR rc.order.quote eq false>	  
		  <table class="table table-striped table-bordered">
        <thead>
          <tr>
            <th colspan="2">Payment information (<a href="/mxtra/shop/checkout?stage=3">change...</a>)</th>
          </tr>
        </thead>
        <tbody>
			    <tr>
			      <td>Card Type:</td>
			      <td>#rc.order.card.cardType#</td>
			    </tr>
			    <tr>
			      <td>Card name:</td>
			      <td>#rc.order.card.name#</td>
			    </tr>
			    <tr>
			      <td>Card Number:</td>
			      <td>xxxx-xxxx-xxxx-#right(rc.order.card.CARDNUMBER,4)#  </td>
			    </tr>
			    <cfif rc.order.card.validFrom neq "" AND DateFormat(rc.order.card.validFrom,"YYYYMM") neq DateFormat(now(),"YYYYMM")>
			    <tr>
			      <td>Start Date:</td>
			      <td>#Month(rc.order.card.validFrom)#/#Year(rc.order.card.validFrom)#</td>
			    </tr>
			    </cfif>
			    <tr>
			      <td>Expiry Date:</td>
			      <td>#Month(rc.order.card.validTo)#/#YEAR(rc.order.card.validTo)#</td>
			    </tr>
			    <cfif rc.order.card.issueNumber NEQ ''>
			    <tr>
			      <td>Issue Number:</td>
			      <td>#rc.order.card.issueNumber#</td>
			    </tr>
			    </cfif>
			    <tr>
			      <td>Security Code:</td>
			      <td>#rc.order.card.securityCode#</td>
			    </tr>
        </tbody>
		  </table>
	  </div>
	</cfif>
  </td>
</tr>
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
	        <td>#rc.order.invoice.name#</td>
	      </tr>
	      <tr>
	        <td>Address:</td>
	        <td>#rc.order.invoice.address#</td>
	      </tr>
	      <tr>
	        <td>Postcode:</td>
	        <td>#rc.order.invoice.postCode#</td>
	      </tr>
	      <tr>
	        <td>Phone:</td>
	        <td>#rc.order.invoice.phone#</td>
	      </tr>
	      <tr>
	        <td>Email:</td>
	        <td>#rc.order.invoice.email#</td>
	      </tr>
	      <tr>
	        <td>Mobile:</td>
	        <td>#rc.order.invoice.mobile#</td>
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
	        <td>#rc.order.delivery.name#</td>
	      </tr>
	      <tr>
	        <td>Address:</td>
	        <td>#rc.order.delivery.address#</td>
	      </tr>
	      <tr>
	        <td>Postcode:</td>
	        <td>#rc.order.delivery.postCode#</td>
	      </tr>
	      <tr>
	        <td>Phone:</td>
	        <td>#rc.order.delivery.phone#</td>
	      </tr>
	      <tr>
	        <td>Email:</td>
	        <td>#rc.order.delivery.email#</td>
	      </tr>
	      <tr>
	        <td>Mobile:</td>
	        <td>#rc.order.delivery.mobile#</td>
	      </tr>
      </tbody>
    </table>
  </div>
  </td>
</tr>
</table>
</div>
  <div class="pull-right">
    <form action="/mxtra/shop/checkout/finish" method="post">
    <cfoutput>
    <input type="hidden" name="accountNumber" value="#rc.order.accountnumber#" />
    </cfoutput>    
      <input type="submit" value="CONFIRM <cfif rc.order.quote>YOUR QUOTE<cfelse>&amp; COMMIT YOUR ORDER</cfif> &raquo;" class="btn btn-success &raquo;">
  </form>
  </div>
</form>
</div>
</cfoutput>
