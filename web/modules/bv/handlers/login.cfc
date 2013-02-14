<!-----------------------------------------------------------------------
Author 	 :	Your Name
Date     :	September 25, 2005
Description :
	This is a ColdBox event handler for general methods.

Please note that the extends needs to point to the eventhandler.cfc
in the ColdBox system directory.
extends = coldbox.system.eventhandler

----------------------------------------------------------------------->
<cfcomponent name="login" output="false">
  <cfproperty name="UserService" inject="id:bv.UserService" >
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="faceBook" inject="id:bv.FacebookService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:applicationstorage">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage">
  <cfproperty name="UserCache" inject="cachebox:UserStorage" />
  <cfproperty name="logger" inject="logbox:root">
	<!--- Default Action --->

  <cffunction name="index">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.target = event.getValue("target","/")>
	  <cfset rc.showMenu = false>
    <cfset event.setView("public/login")>
  </cffunction> 
  <cffunction name="doLogin" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.rememberMe = event.getValue("rememberMe","false")>
    <cfset ticket = UserService.logUserIn(rc.username,rc.password,rc.rememberMe)>
    <cfif isBoolean(ticket)>
      <cfset logger.debug(ticket)>
      <cfset logger.debug("#rc.username# #rc.password#")>
      <cfset setNextEvent(uri="/login/error")>
    <cfelse>
		  <cfset UserStorage.setVar("buildingVine",ticket)>
      <cfset setNextEvent(uri="/")>      
    </cfif>
	</cffunction>

  <cffunction name="external" access="public" returntype="void" output="false">
     <cfargument name="Event" type="any">
     <cfset var rc = event.getCollection()>
     <cfset rc.target = event.getValue("target","/login/externalThanks")>
     <cfset event.setLayout('Layout.ajax')>

  </cffunction>
  <cffunction name="externalThanks" access="public" returntype="void" output="false">
     <cfargument name="Event" type="any">
     <cfset event.setLayout('Layout.ajax')>
  </cffunction>
  <cffunction name="getfacebookcredentials" access="remote" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset facebookData = faceBook.getUser()>
    <cfset facebookData.password = hash(facebookData.id)>
    <cfset event.renderData(type="JSON",data=facebookData)>
  </cffunction>

  <cffunction name="logout" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <cfset var rc = event.getCollection()>
    <cfset rc.target = event.getValue("target","/general/index")>
    <!--- RC Reference --->
      <cflogout >
      <cfset UserCache.clear(CookieStorage.getVar("clusterUser",""))>
      <cfset CookieStorage.deleteVar("clusterUser")>   
	    <cfset CookieStorage.deleteVar("clusterUser","buildingvine.com")>      
      <cflogout>	                 
      <cfset setNextEvent(uri="/")>
  </cffunction>

  <cffunction name="reset" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <cfset var rc = event.getCollection()>
	  <cfset rc.error = event.getValue("error","")>
    <cfset rc.showMenu = false>
    <cfset event.setView('public/password/reset')>
  </cffunction>

  <cffunction name="resetDo" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <cfset var rc = event.getCollection()>
    <cfset rc.username = event.getValue("username","")>
	  <cfif rc.username eq "">
	  	<cfset setNextEvent(uri="/login/reset?error=You did not enter a username!")>
	  </cfif>
	  <cfset getUser = UserService.getUser(rc.username)>
	  <cfif isDefined("getUser.status.code") and getUser.status.code eq "404">
	  	<cfset setNextEvent(uri="/login/reset?error=Sorry we could not find that user in our system")>
		</cfif>
		<cfset rc.error = event.getValue("error","")>
	  <cfset rc.newPassword = UserService.resetPassword(rc.username)>
	    <cfmail from="support@buildingvine.com" to="#rc.username#" subject="Password Reset">
Your new password is:
<cfoutput>#rc.newPassword#</cfoutput>

Thank you.

Building Vine.
</cfmail>
    <cfset rc.showMenu = false>
    <cfset event.setView('public/password/resetDone')>
  </cffunction>

  <cffunction name="error" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <cfset var rc = event.getCollection()>
	  <cfset rc.showMenu = false>
    <cfset event.setView('public/loginerror')>
  </cffunction>

<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>


</cfcomponent>