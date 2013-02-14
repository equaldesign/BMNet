<cfcomponent output="false"  cache="true">

<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
<cfproperty name="quote" inject="id:mxtra.quote" scope="instance" />
<cfproperty name="EcommerceService" inject="id:eunify.EcommerceService" scope="instance" />
<cfproperty name="CompanyService" inject="id:eunify.CompanyService" scope="instance" />
<cfproperty name="eGroupLookup" inject="id:mxtra.eGroupLookup" scope="instance" />
<cfproperty name="product" inject="id:eunify.ProductService" scope="instance" />
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
<cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
<cffunction name="add" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset quantity = event.getValue('quantity',1)>
  <cfset productID = event.getValue('productID',0)>
  <cfset currentQuantity = 0>
  <cfset rc.refURL = event.getValue('refURL','/mxtra/shop/category?categoryID=0')>
  <cfset instance.quote.add(productID,quantity,request.siteID)>
  <cfset setNextEvent(uri="/mxtra/shop/quote")>  
</cffunction>
<cffunction name="continue" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.id = event.getValue("id")>
  <cfset instance.quote.continue(rc.id)>
  <cfset setNextEvent(uri="/mxtra/shop/quote")>  
</cffunction>
<cffunction name="index" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset var totalProductCost = 0>
  <cfset var totalDeliveryCost = 0>
  <cfset rc.id = event.getValue("id",request.quote.id)>  
  <cfset rc.refURL = event.getValue('refURL','/mxtra/shop/category?categoryID=0')>
  <cfset rc.quote = instance.quote.getQuote(rc.id)>  
  <cfset event.setView("shop/quote/detail")>
</cffunction>

<cffunction name="update" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.product_code = event.getValue("product_code","")>
  <cfset rc.quantity = event.getValue("quantity",0)>
  <cfset rc.refURL = event.getValue('refURL','')>
  <cfset rc.quote = instance.quote.getVar("quote")>
  <cfloop from="1" to="#ArrayLen(rc.quote.items)#" index="b">
    <cfset item = rc.quote.items[b]>
    <cfif item.productID eq rc.product_code>
      <cfif rc.quantity eq 0>
        <cfset ArrayDeleteAt(rc.quote.items,b)>
        <cfbreak>
      <cfelse>      
        <cfset item.quantity = rc.quantity>
        <cfbreak>
      </cfif>
    </cfif>
  </cfloop>
  <cfset instance.quote.setVar("quote",rc.quote)>
  <cfset setNextEvent(uri="/mxtra/shop/quote?refURL=#rc.refURL#")>
</cffunction>

<cffunction name="new" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.requestData.page.attributes.customProperties.pagetitle = "You're just a few minutes away from getting your quotations...">
  <cfset rc.customer = instance.CompanyService.getCompany(rc.sess.bmnet.companyID,request.siteID)>
  <cfset event.setView("shop/quote/new")>
</cffunction>
<cffunction name="save" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.delivered = event.getValue("delivered","false")>
  <cfset qID = instance.quote.startQuote(
      reference = rc.reference,
      deliverydate = rc.deliverydate,
      contact = rc.contact,
      deliveryAddress = rc.deliveryAddress,
      postCode = rc.postCode,
      phone = rc.phone,
      delivered = rc.delivered
      )>
  <cfset rc.sess.mxtra.quote.id = qID>
  <cfset setNextEvent(uri="/")>
</cffunction>
<cffunction name="email" returntype="void" output="false">
  <cfargument name="event" required="true">
'  <cfset var rc = event.getCollection()>
  <cfset rc.id = event.getValue("id",request.quote.id)>  
  <cfset event.setView("invoicing/emailQuote")>
</cffunction>
<cffunction name="doEmail" returntype="void" output="false">
  <cfargument name="event" required="true">
'  <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",request.quote.id)>
	  <cfset instance.quote.setItems()>
	  <cfset rc.order = instance.EcommerceService.getOrder(rc.id)> 	     
    <cfset rc.fromName = event.getValue("fromName","")>
    <cfset rc.fromemail = event.getValue("fromEmail","")>
    <cfset rc.toEmail = event.getValue("toEmail","")>
    <cfset rc.toName = event.getValue("toName","")>
    <cfset rc.message = event.getValue("message","")>
      <cfset rc.overage = event.getValue("overage",0)>
      <cfoutput>#renderView("admin/quotePDF")#</cfoutput>
      <cfoutput>
      <cfmail to="#rc.toName# <#rc.toEmail#>" from="#rc.fromName# <#rc.fromEmail#>" subject="Your Turnbull 24-7 Quotation">
#rc.message#
  <cfmailparam file="#rc.app.appRoot#/quotations/#rc.id#.pdf" disposition="attachment">
      </cfmail>
      </cfoutput>  
  <cfset UserStorage.setVar("quote",ApplicationStorage.getVar("quote"))>
  <cfset event.setView("shop/quote/emailSent")>
</cffunction>
</cfcomponent>'