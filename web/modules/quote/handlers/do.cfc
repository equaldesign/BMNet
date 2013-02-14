<cfcomponent output="false"  cache="false">

<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
<cfproperty name="QuoteService" inject="model:quote.QuoteService" />
<cfproperty name="CompanyService" inject="id:eunify.CompanyService" />
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
<cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
<cffunction name="preHandler">
	<cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
	<cfset rc.internalReference = event.getValue("reference","")>
  <cfset rc.delivered = event.getValue("delivered","false")>
  <cfset rc.deliveryDate = event.getValue("deliveryDate",LSDateFormat(now()))>
  <cfset rc.heavyside = event.getValue("heavyside","false")>
  <cfset rc.lightside = event.getValue("lightside","false")>
  <cfset rc.timber = event.getValue("timber","false")>
  <cfset rc.deliveryAddress = event.getValue("deliveryAddress","false")>
  <cfset rc.deliveryPostCode = event.getValue("deliveryPostCode","false")>
  <cfset rc.pickupRadius = event.getValue("pickupRadius","false")>
  <cfset rc.bestQuote = event.getValue("bestQuote","0")>
  <cfset rc.deadline = event.getValue("deadline",LSDateFormat(now()))>
  <cfset rc.stage = event.getValue("stage","1")>
  <cfset rc.showMenu = false>
  <cfset rc.requestData.page.title = "The Trade Source for Building Products and Materials">
  <cfset rc.requestData.page.attributes.customProperties.pagetitle = "You're just a few steps away from getting your quotations...">
  <cfset rc.customer = CompanyService.getCompany(rc.sess.bmnet.companyID,request.siteID)>
</cffunction>


<cffunction name="new" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset event.setView("quote/create/new")>
</cffunction>
<cffunction name="save" returntype="void" output="false">
	<cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset setNextEvent(uri="/quote/do/new",persistStruct=rc)>
</cffunction>
<cffunction name="finish" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.internalReference = event.getValue("reference","")>
  <cfset rc.delivered = event.getValue("delivered","false")>
  <cfset rc.deliveryDate = event.getValue("deliveryDate",LSDateFormat(now()))>
  <cfset rc.deliveryAddress = event.getValue("deliveryAddress","false")>
  <cfset rc.deliveryPostCode = event.getValue("deliveryPostCode","false")>
  <cfset rc.pickupRadius = event.getValue("pickupRadius","false")>
  <cfset rc.bestQuote = event.getValue("bestQuote","0")>
  <cfset rc.deadline = event.getValue("deadline",LSDateFormat(now()))>
  <cfset rc.tradesetup = event.getValue("tradesetup","false")>
  <cfset rc.contact = event.getValue("contact","")>
  <cfset rc.companyName = event.getValue("companyName","")>
  <cfset rc.email = event.getValue("email","")>
  <cfset rc.phone = event.getValue("phone","")>
  <cfset rc.password = event.getValue("password","")>
  <!--- now do the productLines --->
  <cfset linesArray = ArrayNew(1)>
  <cfset quantities = ListToArray(event.getValue("quantity",""))>
  <cfset units = ListToArray(event.getValue("unit",""))>
  <cfset product_names = ListToArray(event.getValue("product_name",""))>
  <cfset product_codes = ListToArray(event.getValue("product_code",""))>
  <cfset nameA = ListToArray(rc.contact," ")>
  <cfif ArrayLen(nameA) gt 1>
  	<cfset rc.contact_firstName = nameA[1]>
	  <cfset rc.contact_surName = nameA[2]>
  <cfelse>
  	<cfset rc.contact_firstName = rc.contact>
	  <cfset rc.contact_surName = "Doe">
  </cfif>
  <cfloop from="1" to="#ArrayLen(product_names)#" index="x">
    <cfset thisO = StructNew()>
	  <cfset thisO.quantity = quantities[x]>
	  <cfset thisO.unit = units[x]>
	  <cfset thisO.product_code = product_codes[x]>
	  <cfset thisO.product_name = product_names[x]>
	  <cfset ArrayAppend(linesArray,thisO)>
  </cfloop>
  <cfif rc.password neq "">
  	<!--- set them up with a contact --->
	  <cfset CompanyService.setname(rc.companyName)>
	  <cfset CompanyService.setaccount_number(0)>
	  <cfset CompanyService.settype_id(1)>
	  <cfset CompanyService.seteGroup_id(0)>
	  <cfset CompanyService.setdoBuildingVine("false")>
	  <cfset CompanyService.setcompany_address_1(rc.deliveryAddress)>
	  <cfset CompanyService.setcompany_postcode(rc.deliveryPostCode)>
	  <cfset CompanyService.setcompany_phone(rc.phone)>
	  <cfset CompanyService.setcompany_email(rc.email)>
		<cfset CompanyService.setdefault_contact_firstname(rc.contact_firstName)>
		<cfset CompanyService.setdefault_contact_surname(rc.contact_surName)>
	  <cfset CompanyService.setdefault_contact_email(rc.email)>
	  <cfset CompanyService.setpassword(rc.password)>
	  <cfset CompanyService.setsendLogin(false)>
	  <cfset CompanyService.save()>
	  <cfset rc.contactID = CompanyService.getcontact_id()>
  <cfelse>
  	<cfset rc.contactID = request.bmnet.contactID>
  </cfif>
  <cfset rc.requestID = QuoteService.createRequest(
    reference = rc.internalReference,
    delivered = rc.delivered,
    deliveryDate = rc.deliveryDate,
    deliveryAddress = rc.deliveryAddress,
    deliveryPostCode = rc.deliveryPostCode,
    pickupRadius = rc.pickupRadius,
    bestQuote = rc.bestQuote,
    deadline = rc.deadline,
    productLines = linesArray,
	  contactID = rc.contactID
  )>
  <cfif rc.password neq "">
  	<!--- they're a new user --->
	  <cfset setNextEvent(uri="/html/welcome.html")>
	<cfelse>
		<cfset setNextEvent(uri="/quote/quote/detail?id=#rc.requestID#")>
  </cfif>
</cffunction>
</cfcomponent>'