<cfcomponent name="bvRegistered" extends="coldbox.system.interceptor">

  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="UserService" inject="id:bv.UserService">
    <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cffunction name="preProcess">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
	  <cfset logger.debug("BV Interceptor")>
    <cfset request.buildingVine = UserStorage.getVar("buildingVine")>
    <cfif isUserLoggedIn()>
      <cfif isDefined("request.buildingVine.active") AND request.buildingVine.active OR isDefined("request.BMNet")>
        <cfif NOT isDefined("request.buildingVine.ticketTimeOut") OR dateDiff("n", request.buildingVine.ticketTimeOut, now()) gte 10>
          <cfset logger.debug("ticket has timed out")>      
          <!--- validate their current ticket --->
    		  <cfset request.user_ticket = UserService.getUserTicket()>
    		  <cfset rc.buildingVine = request.buildingVine>
    		  <cfif event.getCurrentModule() eq "bv">
            <cfif event.getValue("showBVMenu","") neq "">
              <cfset event.setLayout("Layout.#rc.showBVMenu#")>
            </cfif>
    			  <cfset rc.siteID = paramValue("url.siteID",request.bvsiteID)>
    			  <cfif rc.siteID neq rc.buildingVine.siteID>
    			  	<cfset rc.buildingVine.siteID = rc.siteID>
    				  <cfset UserStorage.setVar("buildingVine",rc.buildingVine)>
    			  </cfif>
    			  <cfset rc.buildingVine.site = siteService.getSite(rc.siteID)>
    			  <cfset request.siteID = rc.siteID>
    		  </cfif>
    		  <cfset rc.maxRows = 10>
          <cfset request.buildingVine.ticketTimeOut = dateAdd("n", 20, now())>
          <cfset UserStorage.setVar("buildingVine",request.buildingVine)>        
        </cfif>
  	  <cfelse>
  	  	<cfset logger.debug("requesting BV handler")>
  		  <cfif event.getCurrentModule() eq "bv">
  	    <cfif event.getCurrentHandler() neq "bv:admin">
  	      <cfset setNextEvent(uri="/bv/admin/suggest")>
  	    </cfif>
  		  </cfif>
      </cfif> 
      
    </cfif>
  </cffunction>
    <cfscript>
    function paramValue(value,def) {
    if (isDefined('#value#')) {
      return evaluate("#value#");
    } else {
      return def;
    }
  }
    </cfscript>
</cfcomponent>