<cfoutput><cfset products = getModel("modules.eunify.model.ProductService")><cfset totalProductCost = 0><cfset totalDeliveryCost = 0>
An online order has been placed (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)

The order reference is #args.orderID#.

<cfif args.order.accountnumber NEQ 0>
The customer account number is #args.order.accountnumber#
</cfif>
<cfif args.order.accountnumber EQ 0>
Billing Information
--------------------
#args.order.invoice.name#
#args.order.invoice.address#
#args.order.invoice.postcode#

Email: #args.order.invoice.email#
Phone: #args.order.invoice.phone#
<cfif args.order.invoice.mobile NEQ ''>Mobile: #args.order.invoice.mobile#
</cfif></cfif>
Delivery Information
--------------------
#args.order.delivery.name#
#args.order.delivery.address#
#args.order.delivery.postcode#

<cfif #args.order.delivery.phone# NEQ ''>Phone: #args.order.delivery.phone# </cfif>
<cfif #args.order.delivery.mobile# NEQ ''>Mobile: #args.order.delivery.mobile#</cfif>

Item  Quantity    Description                               Delivery Total*
--------------------------------------------------------------------------
<cfloop array="#args.basket.items#" index="item">
    <cfset args.product = products.getProduct(item.productID,request.siteID)>

        <cfset args.product = products.getProduct(item.productID,request.siteID)>
        <cfset totalProductCost = totalProductCost + item.itemcost*item.quantity>
        <cfset totalDeliveryCost = totalDeliveryCost + item.deliverycost>
        #args.product.Product_Code# #CJustify(item.quantity,10)# #LJustify(args.product.Full_Description,40)# #RJustify(item.deliverycost,6)# #RJustify(item.itemcost*item.quantity*.2,6)#
</cfloop>


Total including delivery and VAT: GBP:#(totalProductCost*.2)+totalDeliveryCost#

Card details are stored online at http://#cgi.HTTP_HOST#/eunify/ecommeargse/detail/id/#args.orderid#
</cfoutput>