<cfcomponent output="false" cache="false" cacheTimeout="30" >
	<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
	<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
  <cfproperty name="dsn" inject="coldbox:datasource:bugs" scope="instance" />
	<cfscript>
  	instance = structnew();
  </cfscript>

	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfset rc.do = event.getValue("do","login")>
		<cfset cbaLogin = getPlugin("CookieStorage").getVar("cbalogin")>
		<cfset rc.username = event.getValue("j_username","")>
		<cfset rc.username = event.getValue("j_password","")>
		<cfset rc.password = "">
		<cfset rc.rem = false>
		<cfif cbaLogin neq "">
			<cfset rc.rem = true>
			<cfset rc.username = listFirst(cbaLogin,";")>
			<cfset rc.password = listLast(cbaLogin,";")>
		</cfif>
		<cfset rc.error = event.getValue("error","")>
		<cfset event.setLayout('Layout.Login')>
		<cfset event.setView('login/#rc.do#')>
	</cffunction>

  <cffunction name="holding" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset event.setLayout('Layout.Temp')>

  </cffunction>

	<cffunction name="passwordReminder" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfset rc.email = event.getValue("email","")>
		<cfset instance.contact.emailPassword(rc.email)>
		<cfset event.setLayout('Layout.Login')>
		<cfset event.setView('login/reminderSent')>
	</cffunction>

	<cffunction name="logout" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cflogout>
		<cfSet eGroup = {
			sessionReference = "#createUUID()#",
							userName = "",
							name = "",
							companyID = "",
							editMode = false,
						  companyknown_as = "",
							bvsiteid = "",
						  companyName = "",
						  bvactive = false,
							companyBV = false,
							showFavouritesOnly = getPlugin("CookieStorage").getVar("showFavouritesOnly",false),
							bvusername = "",
							bvpassword = "",
							newsFilter = 0,
							contactID = 0,
							isMemberContact = false
						}>
					<cfscript>
						getPlugin("SessionStorage").setVar("eGroup",eGroup);
					</cfscript>
		<cfset setNextRoute("/")>
	</cffunction>

	<cffunction name="doLogin" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfscript>
       rc.username    = event.getValue('j_username','');
       rc.password = event.getValue('j_password','');
			 rc._securedURL = event.getValue("target","/bugs");

       rc.rememberMe = event.getValue("rememberme","");
       rc.foundUser = false;
       rc.sess.bugs.group = "";
    </cfscript>
		<!--- get the user record --->
    <!--- try cemco --->
		<cfquery name="logindb" datasource="eGroup_cemco">
          	select
					contact.*,
					company.id as companyID,
					company.type_id as companyType,
					company.buildingVine as companyBV,
					company.bvsiteid,
					company.known_as,
					company.name as companyName,
					contact.buildingVine,
					contact.bvusername,
					contact.bvpassword
				from
					contact,
					company
				where
					company.id = contact.company_id
				AND
					contact.email = <cfqueryparam value="#rc.username#" cfsqltype="cf_sql_varchar">
					AND
					contact.password = <cfqueryparam value="#rc.password#" cfsqltype="cf_sql_varchar">
    </cfquery>
    <cfif logindb.recordCount eq 1>
      <cfset rc.foundUser = true>
      <cfset rc.sess.bugs.group = "cemco">
    <cfelse>
	    <cfquery name="logindb" datasource="eGroup_cbagroup">
	            select
	          contact.*,
	          company.id as companyID,
	          company.type_id as companyType,
	          company.buildingVine as companyBV,
	          company.bvsiteid,
	          company.known_as,
	          company.name as companyName,
	          contact.buildingVine,
	          contact.bvusername,
	          contact.bvpassword
	        from
	          contact,
	          company
	        where
	          company.id = contact.company_id
	        AND
	          contact.email = <cfqueryparam value="#rc.username#" cfsqltype="cf_sql_varchar">
	          AND
	          contact.password = <cfqueryparam value="#rc.password#" cfsqltype="cf_sql_varchar">
	    </cfquery>
      <cfif logindb.recordCount eq 1>
        <cfset rc.foundUser = true>
        <cfset rc.sess.bugs.group = "cbagroup">
      <cfelse>
	      <cfquery name="logindb" datasource="eGroup_handbgroup">
	              select
	            contact.*,
	            company.id as companyID,
	            company.type_id as companyType,
	            company.buildingVine as companyBV,
	            company.bvsiteid,
	            company.known_as,
	            company.name as companyName,
	            contact.buildingVine,
	            contact.bvusername,
	            contact.bvpassword
	          from
	            contact,
	            company
	          where
	            company.id = contact.company_id
	          AND
	            contact.email = <cfqueryparam value="#rc.username#" cfsqltype="cf_sql_varchar">
	            AND
	            contact.password = <cfqueryparam value="#rc.password#" cfsqltype="cf_sql_varchar">
	      </cfquery>
	      <cfif logindb.recordCount eq 1>
	        <cfset rc.foundUser = true>
          <cfset rc.sess.bugs.group = "eGroup_handbgroup">
	      </cfif>
      </cfif>
    </cfif>
		<cfif rc.foundUser>
      <cfif rc.username eq "tom.miller@ebiz.co.uk" OR rc.username eq "james.colin@ebiz.co.uk">
        <cfset x = "ebiz,admin,view,egroup_admin">
      <cfelse>
        <cfset x = "view">
      </cfif>
			<cflogin>
				<cfloginuser name="#cflogin.name#"  password="#cflogin.password#" roles="#x#">
			</cflogin>
			<cfset variables.contactID = logindb.id>
			<cfset rc.sess.bugs.username = "#rc.username#">
			<cfset rc.sess.bugs.companyID = "#logindb.companyID#">
			<cfset rc.sess.bugs.companyName = logindb.companyName>
			<cfset rc.sess.bugs.companyknown_as = logindb.known_as>
			<cfset rc.sess.bugs.companyBV = logindb.companyBV>
			<cfset rc.sess.bugs.bvsiteid = logindb.bvsiteid>
			<cfset rc.sess.bugs.bvactive = logindb.buildingVine>
			<cfset rc.sess.bugs.bvusername = logindb.bvusername>
			<cfset rc.sess.bugs.sortBy = getPlugin("CookieStorage").getVar("sortBy","id")>
			<cfset rc.sess.bugs.bvpassword = logindb.bvpassword>
			<cfset rc.sess.bugs.contactID = logindb.id>
			<cfset rc.sess.bugs.roles = x>
			<cfset rc.sess.bugs.name = "#logindb.first_name# #logindb.surname#">
			<cfset setNextEvent(uri="#rc._securedURL#")>
	 <cfelse>
			<cfset setNextEvent(uri="/login/index?error=#URLEncodedFormat('Username/password error!')#")>
		</cfif>
	</cffunction>


</cfcomponent>