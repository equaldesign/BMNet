<cfcomponent name="account" hint="Creates a template code" cache="true" cachetimeout="90">
  <cfproperty name="SessionStorage" inject="coldbox:plugin:SessionStorage" />
  <cfproperty name="basket" inject="id:mxtra.basket" scope="instance" />
  <cfproperty name="products" inject="id:mxtra.products" scope="instance" />

  <cffunction name="getOrders" returntype="query">
    <cfargument name="quote" default="false" required="true">
    <cfargument name="status" default="" required="true">
    <cfargument name="accountNumber" default="" required="true">
    <cfargument name="siteID" required="true">
    <cfquery name="orders" datasource="BMNet">
      select * from shopOrder where quote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#quote#"><cfif status neq ""> AND status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#"></cfif>
      <cfif accountNumber neq "">
      AND account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#accountNumber#">
      </cfif>
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
    </cfquery>
    <cfreturn orders>
  </cffunction>

  <cffunction name="getBasketOrder" returntype="any">
    <cfreturn instance.basket.getVar("order")>
  </cffunction>

  <cffunction name="getOrder" returntype="query">
    <cfargument name="id">
    <cfset var mxtra = SessionStorage.getVar("mxtra")>
    <cfset var siteID = SessionStorage.getVar("siteID")>
    <cfquery name="order" datasource="BMNet">
      select
        shopOrder.*,
        shopOrderLine.id as lineID,
        shopOrderLine.*,
        Products.*
      from
        shopOrder,
        shopOrderLine,
        Products
      where
        shopOrder.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
        AND
        shopOrder.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mxtra.siteID#">
        AND
        shopOrderLine.shopOrderID = shopOrder.id
        AND
        Products.Product_Code = shopOrderLine.itemNo

    </cfquery>
    <cfreturn order>
  </cffunction>

  <cffunction name="changeStatus" returntype="query">
    <cfargument name="id">
    <cfargument name="status">
    <cfset var mxtra = SessionStorage.getVar("mxtra")>
    <cfset var siteID = SessionStorage.getVar("siteID")>
    <cfquery name="order" datasource="BMNet">
      update
        shopOrder
      set status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
            AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mxtra.siteID#">
    </cfquery>
    <cfset order = getOrder(id)>
    <cfswitch expression="#status#">
      <cfcase value="confirmed">
<cfmail from="no-reply@turnbull24-7.co.uk" to="#order.billingContact# <#order.billingEmail#>" subject="Your Turnbull 24-7 Order">
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND OR REPLY TO THIS EMAIL

===============================

Dear #order.billingContact#,

Thank you for your recent order with Turnbull 24-7.

We are writing to inform you that your payment has been processed.

You will receive a further email once your order has been shipped.

Thank you.

-------------------------------
Turnbull 24-7

http://www.turnbull24-7.co.uk

</cfmail>
      </cfcase>
      <cfcase value="shipped">
<cfmail from="no-reply@turnbull24-7.co.uk" to="#order.billingContact# <#order.billingEmail#>" subject="Your Turnbull 24-7 Order">
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND OR REPLY TO THIS EMAIL

===============================

Dear #order.billingContact#,

Thank you for your recent order with Turnbull 24-7.

We are writing to inform you that your order has now been shipped.

You should receive your item shortly.

Thank you.

-------------------------------
Turnbull 24-7

http://www.turnbull24-7.co.uk

</cfmail>
      </cfcase>
      <cfcase value="cancelled">
<cfmail from="no-reply@turnbull24-7.co.uk" to="#order.billingContact# <#order.billingEmail#>" subject="Your Turnbull 24-7 Order">
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND OR REPLY TO THIS EMAIL

===============================

Dear #order.billingContact#,

Thank you for your recent order with Turnbull 24-7.

Your order status has been changed to "cancelled."

Thank you.

-------------------------------
Turnbull 24-7

http://www.turnbull24-7.co.uk

</cfmail>
      </cfcase>
    </cfswitch>
    <cfreturn order>
  </cffunction>

  <cffunction name="doQuote" returntype="query">
    <cfargument name="orderID" required="true">
    <cfargument name="deliveryCost" required="true">
    <cfargument name="elements" required="true">
    <cfscript>
      var totalItemsCost = 0;
      var totalItemsPlusDel = 0;
      var totalCost = 0;
      var siteID = SessionStorage.getVar("siteID");
      var mxtra = SessionStorage.getVar("mxtra");
    </cfscript>
    <cfloop list="#elements.fieldnames#" index="fieldN">
      <cfif left(fieldN,4) eq "line">
        <cfset dataset = ListToArray(fieldN,"_")>
        <cfset lineID = dataset[2]>
        <cfquery name="updateLine" datasource="BMNet">
          update shopOrderLine set quotedPriceTotal = <cfqueryparam cfsqltype="cf_sql_decimal" value="#elements[fieldN]#">
          where id =  <cfqueryparam cfsqltype="cf_sql_integer" value="#lineID#">
          AND
          siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mxtra.siteID#">
        </cfquery>
      </cfif>
    </cfloop>
    <!--- get the line total --->
    <cfquery name="lineTotal" datasource="BMNet">
      select SUM(quotedPriceTotal) as totals from shopOrderLine where shopOrderID = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderID#">
            AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mxtra.siteID#">
    </cfquery>
    <cfset totalItemsCost = lineTotal.totals>
    <cfset totalItemsPlusDel = totalItemsCost+deliveryCost>
    <cfset totalCost = ((totalItemsPlusDel/100)*20)+totalItemsPlusDel>
    <cfquery name="u" datasource="BMNet">
      update
        shopOrder
      set
        totalItemsPrice = <cfqueryparam cfsqltype="cf_sql_decimal" value="#lineTotal.totals#">,
        totalPrice = <cfqueryparam cfsqltype="cf_sql_decimal" value="#totalItemsPlusDel#">,
        totalVATPrice = <cfqueryparam cfsqltype="cf_sql_decimal" value="#totalCost#">,
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="quoted">
      where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderID#">
            AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mxtra.siteID#">
    </cfquery>
    <cfquery name="order" datasource="BMNet">
      select
        shopOrder.*,
        shopOrderLine.id as lineID,
        shopOrderLine.*,
        Products.*
      from
        shopOrder,
        shopOrderLine,
        Products
      where
        shopOrder.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#orderID#">
        AND
        shopOrder.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mxtra.siteID#">
        AND
        shopOrderLine.shopOrderID = shopOrder.id
        AND
        Products.Product_Code = shopOrderLine.itemNo

    </cfquery>
    <cfreturn order>
  </cffunction>

  <cffunction name="doOrder" returntype="void">
    <cfset var mxtra = SessionStorage.getVar("mxtra")>
    <cfset var basketItems = instance.basket.getItems()>
    <cfset var totalProductCost = 0>
    <cfset var totalDeliveryCost = 0>
    <cfquery name="insertOrder" datasource="BMNet">
      INSERT INTO shopOrder (
        billingContact,
        billingAddress,
        billingPostCode,
        billingEmail,
        billingPhone,
        billingMobile,
        paymentType,
        paymentNumber,
        paymentName,
        paymentExpireMonth,
        paymentExpireYear,
        paymentSecurityCode,
        <cfif rc.sess.mxtra.order.card.validFrom neq "">
          paymentStartMonth,
          paymentStartYear,
        </cfif>
        <cfif rc.sess.mxtra.order.card.issuenumber neq "">
          paymentIssueNumber,
        </cfif>
        deliveryContact,
        deliveryAddress,
        deliveryPostCode,
        deliveryPhone,
        deliveryMobile,
        account_number,
        quote
      )
      VALUES
      (
        <cfqueryparam value="#rc.sess.mxtra.order.invoice.name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.invoice.address#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.invoice.postcode#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.invoice.email#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.invoice.phone#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.invoice.mobile#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.card.cardType#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.card.creditcardnum#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.card.name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#month(rc.sess.mxtra.order.card.validto)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#year(rc.sess.mxtra.order.card.validto)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.card.securityCode#" cfsqltype="cf_sql_varchar">,
        <cfif rc.sess.mxtra.order.card.validFrom neq "">
          <cfqueryparam value="#month(rc.sess.mxtra.order.order.card.validfrom)#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#year(rc.sess.mxtra.order.card.validfrom)#" cfsqltype="cf_sql_varchar">,
        </cfif>
        <cfif rc.sess.mxtra.order.card.issuenumber neq "">
          <cfqueryparam value="#rc.sess.mxtra.order.card.issuenumber#" cfsqltype="cf_sql_integer">,
        </cfif>
        <cfqueryparam value="#rc.sess.mxtra.order.delivery.name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.delivery.address#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.delivery.postcode#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.delivery.phone#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.sess.mxtra.order.delivery.mobile#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.accountNumber#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="false" cfsqltype="cf_sql_varchar">)
    </cfquery>

    <cfquery name="order" datasource="mxtra_#rc.sess.siteid#">
      SELECT LAST_INSERT_ID() AS id
    </cfquery>

    <cfset orderID = "WEB" & NumberFormat(order.id,"000000")>
    <cfset ohash = createUUID()>

    <cfquery name="updateHash" datasource="mxtra_#rc.sess.siteid#">
      UPDATE shopOrder SET hash = '#ohash#' WHERE id = '#order.id#'
    </cfquery>

    <cfloop query="basketItems">
        <cfset stockAvailable = instance.products.getavailableBranchStock(Product_Code)>
        <cfif instance.basket.productDelivered(Product_Code)>
          <cfset deliveryInfo = instance.products.getProductCalculated(Product_Code)>

        <cfelse>
          <cfset deliveryInfo = structNew()>
          <cfset deliveryInfo.deliveryCost = 0>
        </cfif>
        <cfset totalProductCost = price*quantity>
        <cfset totalDeliveryCost = deliveryInfo.deliveryCost>
    <cfquery name="insertOrderLine" datasource="mxtra_#rc.sess.siteid#">
      INSERT INTO shopOrderLine
        (shopOrderId,itemNo,quantity,quotedPriceEach,quotedPriceTotal)
      VALUES
        ('#order.id#','#Product_Code#','#quantity#',
         '#price#','#price*quantity+deliveryInfo.deliveryCost#')
    </cfquery>
  </cfloop>
    <cfset totalItems = 0>
    <cfset totalDelivery = 0>
    <cfloop query="rc.basketItems">
        <cfif getModel("shop.basket").productDelivered(Product_Code)>
          <cfset deliveryInfo = getModel("shop.products").getDeliveryCost(StatusCode,Weight,stockAvailable.recordCount)>
        <cfelse>
          <cfset deliveryInfo = structNew()>
          <cfset deliveryInfo.deliveryCost = 0>
        </cfif>
        <cfset totalItems = totalItems + price*quantity>
        <cfset totalDelivery = totalDelivery + deliveryInfo.deliveryCost>
    </cfloop>
    <cfquery name="updateOrder" datasource="mxtra_#rc.sess.siteid#">
      update shopOrder set
        totalPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#totalItems+totalDelivery#">,
        totalItemsPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#totalItems#">,
        totalVATPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#VatPrice(totalItems+totalDelivery)#">
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#order.id#">
    </cfquery>
  <!--- now send an email to L&S --->
 <cfmail to="weborder@turnbullsonline.co.uk" from="Turnbull24-7 Website <website@turnbull24-7.co.uk>" subject="Turnbull Online order">
    <cfoutput>
An online order has been placed (on #DateFormat(Now(),'medium')# at #TimeFormat(Now(),'short')#)

The order reference is #orderID#.<cfif rc.sess.mxtra.account.number NEQ 0>
The customer account number is #rc.sess.mxtra.account.number#</cfif>
<!---<cfif Session.MXTRA_SHOP_DELIVERY_TYPE EQ 'Delivered'>The order needs to be shipped ASAP.<cfelse>They have chosen to collect the order.</cfif>--->
<cfif rc.sess.mxtra.account.number EQ 0>
Billing Information
--------------------
#rc.sess.mxtra.order.invoice.name#
#rc.sess.mxtra.order.invoice.address#
#rc.sess.mxtra.order.invoice.postcode#

Email: #rc.sess.mxtra.order.invoice.email#
Phone: #rc.sess.mxtra.order.invoice.phone#
<cfif rc.sess.mxtra.order.invoice.mobile NEQ ''>Mobile: #rc.sess.mxtra.order.invoice.mobile#
</cfif></cfif>
Delivery Information
--------------------
#rc.sess.mxtra.order.delivery.name#
#rc.sess.mxtra.order.delivery.address#
#rc.sess.mxtra.order.delivery.postcode#

<cfif #rc.sess.mxtra.order.delivery.phone# NEQ ''>Phone: #rc.sess.mxtra.order.delivery.phone# </cfif>
<cfif #rc.sess.mxtra.order.delivery.mobile# NEQ ''>Mobile: #rc.sess.mxtra.order.delivery.mobile#</cfif>
Item  Quantity    Description                               Delivery Total*
--------------------------------------------------------------------------
<cfloop query="rc.basketItems"><cfsilent>
        <cfset stockAvailable = getMyPlugin("mxtra/shop/products").getavailableBranchStock(Product_Code)>
        <cfset deliveryInfo = getMyPlugin("mxtra/shop/products").getDeliveryCost(StatusCode,Weight,stockAvailable.recordCount)>
        <cfset totalProductCost = totalProductCost + price*quantity>
        <cfset totalDeliveryCost = totalDeliveryCost + deliveryInfo.deliveryCost>
        #Product_Code# #CJustify(quantity,10)# #LJustify(Full_Description,40)# #RJustify(deliveryInfo.deliveryCost,6)# #RJustify(VATPrice(price*quantity),6)#</cfsilent>
</cfloop>


Total including delivery and VAT: GBP:#VatPrice(totalDeliveryCost+totalProductCost)#

Card details are stored online at http://#cgi.HTTP_HOST#/admin/mxtra/?action=orderDetails&orderID=#order.id#


</cfoutput>
  </cfmail>

  <!--- send an email to the customer --->
  <cfmail to="#rc.sess.mxtra.order.invoice.email#" from="Turnbull 24-7 <website@turnbulls24-7.co.uk>" subject="Turnbull Online Order #orderID#">
Dear #rc.sess.mxtra.order.invoice.name#,

Thank you for shopping online with Turnbull.
We have recieved and are processing your order.

Your internet order reference is #orderID#.
The order will be delivered to you soon.
Billing Information
--------------------
#rc.sess.mxtra.order.invoice.name#
#rc.sess.mxtra.order.invoice.address#
#rc.sess.mxtra.order.invoice.postcode#

Email: #rc.sess.mxtra.order.invoice.email#
Phone: #rc.sess.mxtra.order.invoice.phone#
<cfif rc.sess.mxtra.order.invoice.mobile NEQ ''>Mobile: #rc.sess.mxtra.order.invoice.mobile#
</cfif>
Delivery Information
--------------------
#rc.sess.mxtra.order.delivery.name#
#rc.sess.mxtra.order.delivery.address#
#rc.sess.mxtra.order.delivery.postcode#

<cfif #rc.sess.mxtra.order.delivery.phone# NEQ ''>Phone: #rc.sess.mxtra.order.delivery.phone# </cfif>
<cfif #rc.sess.mxtra.order.delivery.mobile# NEQ ''>Mobile: #rc.sess.mxtra.order.delivery.mobile#</cfif>
Item  Quantity    Description                               Delivery Total*
--------------------------------------------------------------------------
<cfloop query="rc.basketItems"><cfsilent>
        <cfset stockAvailable = getMyPlugin("mxtra/shop/products").getavailableBranchStock(Product_Code)>
        <cfset deliveryInfo = getMyPlugin("mxtra/shop/products").getDeliveryCost(StatusCode,Weight,stockAvailable.recordCount)>
        <cfset totalProductCost = totalProductCost + price*quantity>
        <cfset totalDeliveryCost = totalDeliveryCost + deliveryInfo.deliveryCost>
        #Product_Code# #CJustify(quantity,10)# #LJustify(Full_Description,40)# #RJustify(deliveryInfo.deliveryCost,6)# #RJustify(VATPrice(price*quantity),6)#</cfsilent>
</cfloop>


Total including delivery and VAT: GBP:#VatPrice(totalDeliveryCost+totalProductCost)#


If you have any queries about your order, please visit our website at
www.turnbull24-7.co.uk.  Alternatively, call the sales department
on 01529 303025, or email them on sales@turnbull24-7.co.uk.

Sincerely,

Turnbull 24-7

Tunbull
95 Southgate
Sleaford
Lincolnshire
NG34 7RQ


* Please note that all prices are quotes only and may be subject to change.
  If the actual prices differ for some reason, we will contact you.
  </cfmail>
  </cffunction>

<cffunction name="getCustomers" returntype="query">
     <cfset mxtra = SessionStorage.getVar("mxtra")>
     <cfset siteID = SessionStorage.getVar("siteID")>
    <cfquery name="customerDetails" datasource="BMNet">
      select * from Customer
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#mxtra.siteID#">
    </cfquery>
    <cfreturn customerDetails>
  </cffunction>
</cfcomponent>