<cfcomponent name="checkout" hint="Deals with MerchantXtra Checkout" cache="false" cachetimeout="0">
  <cfproperty name="basket" inject="id:mxtra.basket" scope="instance" />
  <cfproperty name="orders" inject="id:mxtra.orders" scope="instance" />

  <cffunction name="do" returntype="any" output="false">
    <cfargument name="basket" required="true">
    <cfargument name="order" required="true">
    <cfargument name="isDelivered" required="true">
    <cfset var rc = {}>
    <cfset var totalProductCost = 0>
    <cfset var totalDeliveryCost = 0>
    <cfset rc.basket = arguments.basket>
    <cfset rc.order = arguments.order>


    <cfquery name="insertOrder" datasource="BMNet">
      INSERT INTO shopOrder
        (billingContact,
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
         <cfif rc.order.card.validFrom neq "">
         paymentStartMonth,
         paymentStartYear,
         </cfif>
               <cfif rc.order.card.issuenumber neq "">
         paymentIssueNumber,
         </cfif>
         deliveryContact,
         deliveryAddress,
         deliveryPostCode,
         deliveryPhone,
         deliveryMobile,
         account_number,
         quote,
         siteID,
         delivered)
      VALUES
        (<cfqueryparam value="#rc.order.invoice.name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.invoice.address#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.invoice.postcode#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.invoice.email#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.invoice.phone#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.invoice.mobile#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.card.cardType#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.card.CARDNUMBER#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.card.name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#month(rc.order.card.validto)#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#year(rc.order.card.validto)#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#rc.order.card.securityCode#" cfsqltype="cf_sql_varchar">,
        <cfif rc.order.card.validFrom neq "">
          <cfqueryparam value="#month(rc.order.card.validfrom)#" cfsqltype="cf_sql_varchar">,
          <cfqueryparam value="#year(rc.order.card.validfrom)#" cfsqltype="cf_sql_varchar">,
        </cfif>
        <cfif rc.order.card.issuenumber neq "">
        <cfqueryparam value="#rc.order.card.issuenumber#" cfsqltype="cf_sql_integer">,
        </cfif>
        <cfqueryparam value="#rc.order.delivery.name#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.delivery.address#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.delivery.postcode#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.delivery.phone#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.delivery.mobile#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="#rc.order.accountnumber#" cfsqltype="cf_sql_varchar">,
        <cfqueryparam value="false" cfsqltype="cf_sql_varchar">, <!--- TODO: fix --->
        <cfqueryparam value="#request.siteID#" cfsqltype="cf_sql_integer">,
        <cfqueryparam value="#arguments.isDelivered#" cfsqltype="cf_sql_varchar">)
    </cfquery>

    <cfquery name="order" datasource="BMNet">
      SELECT LAST_INSERT_ID() AS id
    </cfquery>

    <cfset orderID = "WEB" & NumberFormat(order.id,"000000")>
    <cfset ohash = createUUID()>

    <cfquery name="updateHash" datasource="BMNet">
      UPDATE shopOrder SET hash = '#ohash#' WHERE id = '#order.id#'
    </cfquery>

    <cfloop array="#rc.basket.items#" index="item">
      <cfquery name="insertOrderLine" datasource="BMNet">
        INSERT INTO shopOrderLine
          (shopOrderId,itemNo,quantity,quotedPriceEach,quotedPriceTotal,deliveryCharge,collectionBranch,delivered)
        VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#order.id#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#item.productID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#item.quantity#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#item.itemcost#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#((item.itemcost*item.quantity)+item.deliverycost)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#item.deliverycost#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#item.collectionbranch#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(item.delivered)#">
          )
      </cfquery>
    </cfloop>
    <cfset totalItems = 0>
    <cfset totalDelivery = 0>
    <cfloop array="#rc.basket.items#" index="item">
        <cfset totalItems += item.itemcost*item.quantity>
        <cfset totalDelivery += item.deliveryCost>
    </cfloop>
    <cfquery name="updateOrder" datasource="BMNet">
      update shopOrder set
        totalPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#totalItems+totalDelivery#">,
        totalItemsPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#totalItems#">,
        totalVATPrice = <cfqueryparam cfsqltype="cf_sql_float" value="#(totalItems+totalDelivery)*.2#">
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#order.id#">
    </cfquery>
    <cfreturn orderID>
  </cffunction>

<cfscript>
function checkPostcode(pc){
    return (REFindNoCase("^[a-z]{1,2}([0-9]{1,2}|[0-9][a-z]?)\s*[0-9][a-z]{2}$",pc) NEQ 0);
  }
  function checkEmail(email){
    return (REFindNoCase("^['_a-z0-9-+]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name))$",email) NEQ 0);
  }
  function checkPhone(phone){
    return (REFind("^(\+44|0)[0-9]{9,10}$",phone) NEQ 0);
  }
  function checkMobile(mobile){
    return (REFind("^(\+44|0)7[0-9]{9}$",mobile) NEQ 0);
  }
  function stripSpaces(str){
    return REReplace(str,"\s","","All");
  }
  function maskCard(c){
    var m = '';
    var shown = 0;
    for (i = Len(c);i GTE 1;i=i-1){
      if (Mid(c,i,1) EQ ' '){
        m = ' ' & m;
      } else if (shown LT 4){
        m = Mid(c,i,1) & m;
        shown = shown + 1;
      } else {
        m = 'X' & m;
      }
    }
    return m;
  }
  function checkCard(ccNumber,ccType){
    if (ReFind("[^[:digit:] ]",ccNumber)){
      return false;
    }
    ccNum = Replace(ccNumber," ","","All");
    ccLen = Len(ccNum);
    if (((ccType IS "Mastercard" OR ccType IS "Visa") AND ccLen IS NOT 16) OR ccType IS "Switch" AND NOT (ccLen IS 16 OR ccLen IS 18 OR ccLen IS 19)){
      return false;
    }
    if (ccType IS "Mastercard"){
      if (NOT (Left(ccNum,2) GTE 51 AND Left(ccNum,2) LTE 55)){
        return false;
      }
    }
    ccNum = Reverse(ccNum);
    cs = 0;
    for (i=1;i LTE ccLen;i=i+1){
      if (i MOD 2 EQ 0){
        csP = Mid(ccNum,i,1) * 2;
        if (Len(csP) IS 2){
          cs = cs + Mid(csP,1,1) + Mid(csP,2,1);
        } else {
          cs = cs + csP;
        }
      } else {
        cs = cs + Mid(ccNum,i,1);
      }
    }
    if (cs MOD 10 IS NOT 0){
      return false;
    }
    return true;
  }
</cfscript>

</cfcomponent>