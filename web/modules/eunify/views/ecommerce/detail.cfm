<cfset getMyPlugin(plugin="jQuery").getDepends("","ecommerce/admin","")>
<cfoutput>
<div class="page-header">
  <div class="pull-right">
    <form class="form form-inline">

      <select id="status">
        <cfoutput>
        <option #vm(rc.order.status,"pending")# value="pending">Pending</option>
        <option #vm(rc.order.status,"cancelled")# value="cancelled">Cancelled</option>
        <option #vm(rc.order.status,"declined")# value="declined">Declined</option>
        <option #vm(rc.order.status,"confirmed")# value="confirmed">Confirmed</option>
        <option #vm(rc.order.status,"shipped")# value="shipped">Shipped</option>
        <option #vm(rc.order.status,"quoted")# value="quoted">Quoted</option>
        </cfoutput>
      </select>
      <input id="changestatus" type="button" class="btn btn-success" value="update status" />
      <input id="orderID" type="hidden" value="#rc.order.id#">
    </form>
  </div>
	<h1>Order ###rc.order.id# <cfif rc.order.quote eq "true">Quotation<cfelse>Online Order</cfif></h1>
  <h4><cfif rc.order.delivered>Delivery<cfelse>Click and Collect</cfif></h4>
</div>
<div class="row-fluid">
  <div class="span8">
	 <!--- overview details --->
   <h3>Billing Address</h3>
	 <address>
	 	<strong>#rc.order.billingContact#</strong>
		<p>#rc.order.billingAddress#</p>
		<p>#rc.order.billingPostCode#</p>
		<p>#rc.order.billingEmail#</p>
		<p>#rc.order.billingPhone#</p>
		<p>#rc.order.billingMobile#</p>
	 </address>
	 <h3>Delivery Address</h3>
	 <address>
	 	<strong>#rc.order.deliveryContact#</strong>
		<p>#rc.order.deliveryAddress#</p>
		<p>#rc.order.deliveryPostCode#</p>
		<p>#rc.order.deliveryPhone#</p>
		<p>#rc.order.deliveryMobile#</p>
	 </address>
  </div>
	<div class="span4">
		<!--- order number etc. --->
		<dl class="dl-horizontal">
			<dt>Order Date</dt>
			<dd>#DateFormat(rc.order.date,"DD/MM/YYYY")#</dd>
			<dt>Name on Card</dt>
			<dd>#rc.order.paymentName#</dd>
			<dt>Card Number</dt>
      <dd>#rc.order.paymentNumber#</dd>
			<dt>Type</dt>
      <dd>#rc.order.paymentType#</dd>
			<dt>Start Date</dt>
      <dd>#rc.order.paymentStartMonth#/#rc.order.paymentStartYear#</dd>
      <dt>Expiry</dt>
      <dd>#rc.order.paymentExpireMonth#/#rc.order.paymentExpireYear#</dd>
			<dt>Issue Number</dt>
      <dd>#rc.order.paymentIssueNumber#</dd>
			<dt>Security Code</dt>
      <dd>#rc.order.paymentSecurityCode#</dd>
		</dl>
	</div>
</div>
<table class="table table-bordered table-striped">
	<thead>
		<tr>
			<th>Product Code</th>
			<th>Name</th>
			<th style="text-align:right">Quantity</th>
			<th style="text-align:right">Price</th>
			<th style="text-align:right">Delivery</th>
			<th style="text-align:right">Total</th>
		</tr>
	</thead>
	<tbody>
		<cfset totalPrice = 0>
		<cfset totalDelivery = 0>
		<cfset total = 0>
		<cfloop query="rc.order">
			<tr>
				<td><a href="/eunify/products/detail/id/#product_code#">#product_code#</a></td>
				<td><a href="/eunify/products/detail/id/#product_code#">#full_description#</a></td>
				<td style="text-align:right">#quantity#</td>
				<td style="text-align:right">&pound;#quotedPriceEach#</td>
				<td style="text-align:right">&pound;#deliveryCharge#</td>
				<td style="text-align:right">&pound;#quotedPriceTotal#</td>
			</tr>
			<cfset totalDelivery += deliveryCharge>
			<cfset total += quotedPriceTotal>
	  </cfloop>
	</tbody>
	<tfoot>
		<tr>
      <th style="text-align:right" colspan="5">Delivery</th>
      <th style="text-align:right">&pound;#totalDelivery#</th>
    </tr>
		<tr>
      <th style="text-align:right" colspan="5">Grand Total</th>
      <th style="text-align:right">&pound;#total#</th>
    </tr>
	</tfoot>
</table>
</cfoutput>