<cfcomponent output="false" cache="true" cacheTimeout="30" >
	<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
	<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
	<cfproperty name="contact" inject="id:eGroup.contact" />
  <cfproperty name="ContactService" inject="id:eunify.ContactService" />
  <cfproperty name="bvUserService" inject="id:bv.UserService">
  <cfproperty name="dsn" inject="coldbox:datasource:eGroup" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="logger" inject="logbox:root" />
	<cfscript>
  	instance = structnew();
  </cfscript>

	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
		<cfset rc.do = arguments.event.getValue("do","login")>
		<cfset rc.cbaLogin = getPlugin("CookieStorage").getVar("cbalogin")>
		<cfset rc.username = arguments.event.getValue("j_username","")>
		<cfset rc.username = arguments.event.getValue("j_password","")>
		<cfset rc.password = "">
		<cfset rc.rem = false>
		<cfif rc.cbaLogin neq "">
			<cfset rc.rem = true>
			<cfset rc.username = listFirst(rc.cbaLogin,";")>
			<cfset rc.password = listLast(rc.cbaLogin,";")>
		</cfif>
		<cfset rc.error = arguments.event.getValue("error","")>
		<cfset arguments.event.setLayout('Layout.Login')>
		<cfset arguments.event.setView('login/#rc.do#')>
	</cffunction>

  <cffunction name="holding" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset arguments.event.setLayout('Layout.Temp')>

  </cffunction>

	<cffunction name="passwordReminder" returntype="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
		<cfset rc.email = arguments.event.getValue("email","")>
		<cfset contact.emailPassword(rc.email)>
		<cfset arguments.event.setLayout('Layout.Login')>
		<cfset arguments.event.setView('login/reminderSent')>
	</cffunction>

	<cffunction name="logout" returntype="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
    <cfset var eGroup = "">
		<cflogout>
		<cfset CookieStorage.deleteVar("clusterUser")>
		<cfset setNextEvent(uri="/")>
	</cffunction>

	<cffunction name="doLogin" returntype="void" output="true">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
		<cfscript>
       rc.username    = arguments.event.getValue('j_username','');
       rc.password = arguments.event.getValue('j_password','');
			 rc._securedURL = arguments.event.getValue("target","/");
       rc.remember = arguments.event.getValue("rememberme","n");
    </cfscript>
		<!--- get the user record --->
    <cfif rc.password neq "" AND rc.username neq "">
      <cfset rc.loggedIn = ContactService.logUserIn(rc.username,rc.password,rc.remember)>      
      <cfif isBoolean(rc.loggedIn)>
        <cfset setNextEvent(uri="/login/index?error=#URLEncodedFormat('Username/password error!')#")>
      </cfif>

      <cfset UserStorage.setVar("BMNet",rc.loggedIn.BMNet)>
      <cfdump var="#rc.loggedIn.BMNet#">
      <cfdump var="#UserStorage.getVar('BMNet')#">
      <cfset UserStorage.setVar("eGroup",rc.loggedIn.eGroup)>

      <cfif rc.loggedIn.buildingVine.active>
        <cfset UserStorage.setVar("buildingVine",rc.loggedIn.buildingVine)>
      <cfelse>
	  	  <cfset UserStorage.setVar("buildingVine",ApplicationStorage.getVar("buildingVine"))>
      </cfif>
      <cfif rc.loggedIn.eGroup.username eq "">
        <cfset eGroup = false>
      <cfelse>
        <cfset eGroup = contact.logUserIn(rc.loggedIn.eGroup.username,rc.loggedIn.eGroup.password)>
      </cfif>

      <cfset allRoles = "#rc.loggedIn.BMNet.roles#">
      <cfif NOT isBoolean(eGroup)>
        <cfset eGroup.eGroup.datasource = rc.loggedIn.eGroup.datasource>
        <cfset UserStorage.setVar("eGroup",eGroup.eGroup)>
        <cfloop list="#eGroup.eGroup.roles#" index="r">
          <cfset allRoles = ListAppend(allRoles,r)>
        </cfloop>
      </cfif>

      <cfset logger.debug("All Roles: #allRoles#")>
      <cflogin>
        <cfloginuser name="#rc.username#" password="#rc.password#" roles="#trim(allRoles)#">
      </cflogin>

    <cfelse>
      <cfset setNextEvent(uri="/login/index?error=#URLEncodedFormat('You need to enter a password!')#")>
    </cfif>
		<cfif NOT isBoolean(rc.loggedIn)>
      <cfif CookieStorage.getVar("basketID","") eq "">
        <cfset CookieStorage.setVar(name="basketID",value=createUUID(),expires=expires=DateAdd("h", 12, now()))>
      </cfif>
      <cfset rc.loginInfo = StructNew()>
      <cfif rc.remember eq "y">

        <cfset rc.loginInfo.username="#rc.username#">
        <cfset rc.loginInfo.password="#rc.password#">
        <cfset rc.loginInfo.remember="#rc.remember#">
      <cfelse>
        <cfset CookieStorage.deleteVar("eGroupLogin")>
      </cfif>
      <cfif rc._securedURL eq "/enuify/index.cfm">
        <cfset rc._securedURL = "/enuify/">
      </cfif>
 			<cfset setNextEvent(uri="#rc._securedURL#",varStruct=rc.loginInfo)>
	  <cfelse>
			<cfset setNextEvent(uri="/enuify/login/index?error=#URLEncodedFormat('Username/password error!')#")>
		</cfif>
	</cffunction>


</cfcomponent>