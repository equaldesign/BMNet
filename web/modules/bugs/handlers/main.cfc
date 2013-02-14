<cfcomponent output="false" autowire="true" cache="true" cacheTimeout="30" >
	<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
	<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
<cfproperty name="SessionStorage" inject="coldbox:plugin:SessionStorage" scope="instance" />
<cfproperty name="ApplicationStorage" inject="coldbox:plugin:applicationstorage" scope="instance" />
<cfproperty name="dsn" inject="coldbox:datasource:bugs" scope="instance" />
			<cfscript>
		instance = structnew();
		</cfscript>
	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset setNextEvent(getSetting('DefaultEvent'))>
	</cffunction>

	<cffunction name="onAppInit" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset app = instance.ApplicationStorage>
    <cfset var eGroup = {
      siteName = "eunify"
    }>
    <cfset app.setVar("eGroup",eGroup)>
	</cffunction>

	<cffunction name="onSessionStart" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfset var app = instance.ApplicationStorage.getStorage()>
		<cfset var sess = instance.SessionStorage>
		<cfset var filter = getPlugin("CookieStorage").getVar("filter",0)>

	</cffunction>

	<cffunction name="onRequestStart" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfset var filter = getPlugin("CookieStorage").getVar("filter",0)>
		<cfset SetLocale("English (UK)")>
		<cfset rc.tickCount = getTickCount()>
		<cfset rc.sess = instance.SessionStorage.getStorage()>
		<cfset rc.app = instance.ApplicationStorage.getStorage()>
		<cfset rc.appP = instance.ApplicationStorage>
    <cfif NOT isDefined('rc.sess.bugs.name')>
      <cfif getAuthUser() neq "">
          <cflogout>
          <cfset onSessionStart(event)>
      </cfif>
    </cfif>
	</cffunction>

	<cffunction name="onRequestEnd" returntype="void" output="false">
		<cfargument name="event" required="true">
			<cfset var rc = event.getCollection()>
	</cffunction>

	<cffunction name="onSessionEnd" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var sessionScope = event.getValue("sessionReference")>
		<cfset var applicationScope = event.getValue("applicationReference")>
		<cfset var sessionRef = sessionScope.eGroup.sessionReference>
		<cfset StructDelete(applicationScope.appUsers,"#sessionRef#")>

	</cffunction>

	<cffunction name="onException" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset event.setLayout("Layout.Main")>
		<cfset event.setView("debug")>
	</cffunction>

	<cffunction name="onInvalidEvent" returntype="void" output="false">
		<cfargument name="event" required="true">
    <cfset event.setLayout("Layout.Main")>
    <cfset event.setView("invalidEvent")>
	</cffunction>

</cfcomponent>