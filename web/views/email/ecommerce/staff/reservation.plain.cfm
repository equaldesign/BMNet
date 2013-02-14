<cfoutput><cfset products = getModel("modules.eunify.model.ProductService")><cfset totalProductCost = 0><cfset totalDeliveryCost = 0>
An online reservation has been placed (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)

The reservation reference is #args.orderID#.

<cfif args.order.accountnumber NEQ 0>
The customer account number is #args.order.accountnumber#
</cfif>
<cfif args.order.accountnumber EQ 0>
Customer Information
--------------------
#args.order.invoice.name#

Email: #args.order.invoice.email#
Phone: #args.order.invoice.phone#
<cfif args.order.invoice.mobile NEQ ''>Mobile: #args.order.invoice.mobile#
</cfif></cfif>
<cfloop array="#args.basket.items#" index="item"><cfif NOT item.delivered>
Collection from:<cfset thisBranch = getModel("modules.eunify.model.BranchService").getBranchByRef(item.collectionbranch)>
#thisBranch.name#
#thisBranch.address1#
#thisBranch.town#
#thisBranch.county#
#thisBranch.postcode#<cfbreak></cfif></cfloop>

Item  Quantity    Description                                       Total*
--------------------------------------------------------------------------
<cfloop array="#args.basket.items#" index="item"><cfsilent>
    <cfset args.product = products.getProduct(item.productID,request.siteID)>

        <cfset args.product = products.getProduct(item.productID,request.siteID)>
        <cfset totalProductCost = totalProductCost + item.itemcost*item.quantity>
        <cfset totalDeliveryCost = totalDeliveryCost + item.deliverycost>
        #args.product.Product_Code# #CJustify(item.quantity,10)# #LJustify(args.product.Full_Description,40)# #RJustify(item.deliverycost,6)# #RJustify(item.itemcost*item.quantity*.2,6)#</cfsilent>
</cfloop>


Total including VAT due on collection: GBP:#(totalProductCost*.2)+totalDeliveryCost#

</cfoutput>