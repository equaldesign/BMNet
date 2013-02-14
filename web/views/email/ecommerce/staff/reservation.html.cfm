<cfoutput><cfset products = getModel("modules.eunify.model.ProductService")><cfset totalProductCost = 0><cfset totalDeliveryCost = 0>
<p>An online reservation has been placed (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)</p>
<p>The reservation reference is #args.orderID#.</p>

<cfif args.order.accountnumber NEQ 0>
<p>The customer account number is #args.order.accountnumber#</p>
</cfif>
<cfif args.order.accountnumber EQ 0>
<h3>Customer Information</h3>
<p>#args.order.invoice.name#<br />
#args.order.invoice.address#<br />
#args.order.invoice.postcode#</p>

<p>Email: #args.order.invoice.email#<br />
Phone: #args.order.invoice.phone#<br />
<cfif args.order.invoice.mobile NEQ ''>Mobile: #args.order.invoice.mobile#</cfif>
</p></cfif>
<cfloop array="#args.basket.items#" index="item">
  <cfif NOT item.delivered>
    <p>Collection from: <br />
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
    <cfloop array="#args.basket.items#" index="item">
      <cfset args.product = products.getProduct(item.productID,request.siteID)>
      <cfset totalProductCost = totalProductCost + item.itemcost*item.quantity>
      <cfset totalDeliveryCost = totalDeliveryCost + item.deliverycost>
      <tr>
        <td>#args.product.product_code#</td>
        <td>#item.quantity#</td>
        <td>#args.product.Full_Description#</td>
        <td>#item.itemcost*item.quantity*.2#</td>
      </tr>
    </cfloop>
  </tbody>
</table>

<h4>Total including VAT due on collection: GBP:#(totalProductCost*.2)+totalDeliveryCost#</h4>

</cfoutput>