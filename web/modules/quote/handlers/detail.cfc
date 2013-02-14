<cfcomponent output="false"  cache="false">

	<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
	<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
	<cfproperty name="QuoteService" inject="model:modules.quote.model.QuoteService" />
	<cfproperty name="CompanyService" inject="id:eunify.CompanyService" />
	<cfproperty name="BranchService" inject="id:eunify.BranchService" />
	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
	<cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />

	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfset rc.quote = QuoteService.getQuoteRequest(rc.id)>
		<cfset event.setView("quote/respond/accept")>
	</cffunction>

	<cffunction name="merchant" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.quote = QuoteService.getQuoteRequest(rc.id)>
	  <cfset rc.nearestBranch = BranchService.getBranchesFromAddress('#rc.quote.quoteRequest.deliveryPostCode#',300,2,request.BMNet.companyID)>
	  <cfset rc.company = CompanyService.getCompany(request.bmnet.companyID,request.siteID)>
    <cfset event.setView("quote/detail/2/index")>
  </cffunction>

  <cffunction name="trade" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.quote = QuoteService.getQuoteRequest(rc.id)>
    <cfset event.setView("quote/detail/1/index")>
  </cffunction>
</cfcomponent>