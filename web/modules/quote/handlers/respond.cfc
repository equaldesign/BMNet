<cfcomponent>

	<cfproperty name="QuoteService" inject="model:modules.quote.model.QuoteService" />

  <cfproperty name="CompanyService" inject="id:eunify.CompanyService" />
  <cfproperty name="BranchService" inject="id:eunify.BranchService" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />

	<cffunction name="index">
		<cfargument name="event">
		<cfset var rc = event.getCollection()>
		<cfset rc.id = event.getValue("id",0)>
		<cfset rc.sentID = event.getValue("sentID",0)>
		<cfset rc.quote = QuoteService.getQuoteRequest(rc.id)>
		<cfset rc.company = CompanyService.getCompany(request.bmnet.companyID,request.siteID)>
    <cfset event.setView("quote/respond/accept")>
	</cffunction>

	<cffunction name="decline">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
  </cffunction>

  <cffunction name="do">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset getMyPlugin("FormUtils").buildFormCollections(rc)>
	  <cfset rc.response = QuoteService.commitResponse(rc.id,rc.sentID,rc.product,rc.paymentMethod,rc.paypalEmail,rc.deliveryCharge,rc.deliveryDate,rc.deadline,rc.validUntil)>

  </cffunction>

  <cffunction name="view">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
	  <cfset rc.response = QuoteService.getQuoteResponse(rc.id)>
	  <cfset event.setView("quote/respond/view")>
  </cffunction>

  <cffunction name="reject">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset QuoteService.rejectResponse(rc.id,rc.comment)>
    <cfset event.setView("quote/respond/rejected")>
  </cffunction>

  <cffunction name="accept">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset QuoteService.acceptResponse(rc.id)>
    <cfset event.setView("quote/respond/accepted")>
  </cffunction>

  <cffunction name="pay">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.response = QuoteService.getQuoteResponse(rc.id)>
    <cfset event.setView("quote/respond/pay")>
  </cffunction>
</cfcomponent>