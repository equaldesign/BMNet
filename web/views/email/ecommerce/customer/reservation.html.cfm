<cfoutput><cfset products = getModel("modules.eunify.model.ProductService")><cfset totalProductCost = 0><cfset totalDeliveryCost = 0>
<p>Thank you for your recent reservation (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)</p>
<p>The reservation reference is #args.orderID#.</p>
<p style="color:##800000; font-weight:bold">This is not an invoice. You will recieve an official VAT document on collection</p>
<h3>Your Information</h3>
<p>#args.order.invoice.name#<br />

<p>Email: #args.order.invoice.email#<br />
Phone: #args.order.invoice.phone#<br />
<cfif args.order.invoice.mobile NEQ ''>Mobile: #args.order.invoice.mobile#</cfif>
</p>

<h2>Order Details</h2>
<table>
  <thead>
    <tr>
      <th>Item</th>
      <th>Quantity</th>
      <th>Description</th>
      <th>Total</th>
    </tr>
  </thead>
  <tbody>
    <cfset totalProductCost = 0>
    <cfloop array="#args.basket.items#" index="item">
      <cfset rc.product = products.getProduct(item.productID,request.siteID)>
        <cfset totalProductCost = totalProductCost + item.itemcost*item.quantity>

      <tr>
        <td>#rc.product.product_code#</td>
        <td>#item.quantity#</td>
        <td>#rc.product.Full_Description#</td>
        <td>&pound;#DecimalFormat(VatPrice(item.itemcost*item.quantity))#</td>
      </tr>
    </cfloop>
  </tbody>
</table>
<h4>Total including VAT due on collection: &pound;#VatPrice(totalProductCost)#</h4>

<h5>Your click and collect order has been sent to:</h5>
<cfloop array="#args.basket.items#" index="item">
  <cfif NOT item.delivered>
        <cfset thisBranch = getModel("modules.eunify.model.BranchService").getBranchByRef(item.collectionbranch)>
      #thisBranch.name#<br />
      #thisBranch.address1#<br />
      #thisBranch.town#<br />
      #thisBranch.county#<br />
      #thisBranch.postcode#
    </p>
    <cfbreak>
  </cfif>
</cfloop>
<p>Once we have processed this order we will telephone you to confirm your details and take full payment.</p>
<p>If you have any queries about the order confirmation please telephone the branch #thisBranch.tel# or e mail <a href="mailto:customerservices@turnbullsonline.co.uk">customerservices@turnbullsonline.co.uk</a>.</p>
<p>Please ring to ensure your order is ready for collection before travelling.</p>
<p>Thank you once again for shopping with Turnbulls</p>
</p>
</cfoutput>