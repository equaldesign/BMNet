<cfoutput><cfset products = getModel("modules.eunify.model.ProductService")><cfset totalProductCost = 0><cfset totalDeliveryCost = 0>
<p>Thank you for your recent order (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)</p>
<p>The order reference is #args.orderID#.</p>
<p style="color:##800000; font-weight:bold">This is not an invoice. You will recieve an official VAT invoice shortly</p>
<h3>Billing Information</h3>
<p>#args.order.invoice.name#<br />
#args.order.invoice.address#<br />
#args.order.invoice.postcode#</p>

<p>Email: #args.order.invoice.email#<br />
Phone: #args.order.invoice.phone#<br />
<cfif args.order.invoice.mobile NEQ ''>Mobile: #args.order.invoice.mobile#</cfif>
</p>
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
        <td>&pound;#VatPrice(item.deliverycost*item.quantity)#</td>
        <td>&pound;#DecimalFormat(VatPrice(item.itemcost*item.quantity))#</td>
      </tr>
    </cfloop>
  </tbody>
</table>

<h4>Total including delivery and VAT: &pound;#VatPrice(totalDeliveryCost+totalProductCost)#</h4>

</cfoutput>