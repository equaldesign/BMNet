<cfoutput><cfset products = getModel("modules.eunify.model.ProductService")><cfset totalProductCost = 0><cfset totalDeliveryCost = 0>
Thank you for your recent order (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)

The order reference is #args.orderID#.

Billing Information
--------------------
#args.order.invoice.name#
#args.order.invoice.address#
#args.order.invoice.postcode#

Email: #args.order.invoice.email#
Phone: #args.order.invoice.phone#
<cfif args.order.invoice.mobile NEQ ''>Mobile: #args.order.invoice.mobile#
</cfif>
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

</cfoutput>