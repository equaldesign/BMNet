<cfoutput><cfset products = getModel("modules.eunify.model.ProductService")><cfset totalProductCost = 0><cfset totalDeliveryCost = 0>
<p>An online order has been placed (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)</p>
<p>The order reference is #args.orderID#.</p>

<cfif args.order.accountnumber NEQ 0>
<p>The customer account number is #args.order.accountnumber#</p>
</cfif>
<cfif args.order.accountnumber EQ 0>
<h3>Billing Information</h3>
<p>#args.order.invoice.name#<br />
#args.order.invoice.address#<br />
#args.order.invoice.postcode#</p>

<p>Email: #args.order.invoice.email#<br />
Phone: #args.order.invoice.phone#<br />
<cfif args.order.invoice.mobile NEQ ''>Mobile: #args.order.invoice.mobile#</cfif>
</p></cfif>
<h3>Delivery Information</h3>
<p>
#args.order.delivery.name#<br />
#args.order.delivery.address#<br />
#args.order.delivery.postcode#</p>

<p><cfif #args.order.delivery.phone# NEQ ''>Phone: #args.order.delivery.phone# </cfif>
<cfif #args.order.delivery.mobile# NEQ ''>Mobile: #args.order.delivery.mobile#</cfif>
</p>
<h2>Details</h2>
<table>
  <thead>
    <tr>
      <th>Item</th>
      <th>Quantity</th>
      <th>Description</th>
      <th>Delivery</th>
      <th>Total</th>
    </tr>
  </thead>
  <tbody>
    <cfloop array="#args.basket.items#" index="item">
      <cfset rc.product = products.getProduct(item.productID,request.siteID)>
        <cfset totalProductCost = totalProductCost + item.itemcost*item.quantity>
        <cfset totalDeliveryCost = totalDeliveryCost + item.deliverycost*item.quantity>
      <tr>
        <td>#rc.product.product_code#</td>
        <td>#item.quantity#</td>
        <td>#rc.product.Full_Description#</td>
        <td>&pound;#item.deliverycost*item.quantity#</td>
        <td>&pound;#DecimalFormat(VatPrice(item.itemcost*item.quantity))#</td>
      </tr>
    </cfloop>
  </tbody>
</table>

<h4>Total including delivery and VAT: &pound;#VatPrice(totalDeliveryCost+totalProductCost)#</h4>

<p>Card details are stored online at <a href="http://#cgi.HTTP_HOST#/eunify/ecommeargse/detail/id/#args.orderid#">http://#cgi.HTTP_HOST#/eunify/ecommeargse/detail/id/#args.orderid#</a></p>
</cfoutput>
