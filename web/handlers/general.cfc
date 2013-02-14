<cfcomponent name="general" output="false"  cache="true"  autowire="true">
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
<cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
<cfproperty name="logger" inject="logbox:root">

<!------------------------------------------- PUBLIC EVENTS ------------------------------------------>

	<!--- Default Action --->
	<cffunction name="index" cache="true" returntype="void" output="false" hint="My main event">
		<cfargument name="event">

		<cfscript>
		  var rc = arguments.event.getCollection();

		  rc.startRow = arguments.event.getValue('f',1);
		  rc.perPage = arguments.event.getValue('pp',15);
		  rc.sPage = arguments.event.getValue('sPage',1);
		  rc.filter = arguments.event.getValue('filter',0);
		  if (isUserInRole("staff") AND paramValue("rc.layoutMode","public") eq "intranet") {
  		  setNextEvent(uri="/eunify/feed/index");
		  } else {
		    setNextEvent(uri="/html/homepage.html");
		  }


		</cfscript>
	</cffunction>

	<cffunction name="heartbeat" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfquery name="heartBeat" datasource="BMNet">
      select name from site where lastmodified < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('h',-1,now())#">
      AND
      id NOT in (2,3,4)
    </cfquery>
    <cfif heartBeat.recordCount neq 0>
      <cfmail from="no-reply@buildersmerchant.net" to="tom.miller@ebiz.co.uk" subject="BMNet Micro Server Down!">
        <cfmailparam name="X-Priority" value="1">
A micro server is down!
      </cfmail>
    </cfif>
    <cfset event.noRender()>
  </cffunction>

	<cffunction name="debug" returntype="void" cache="true">
		<cfargument name="event" required="true" />
		<cfscript>
			var rc = arguments.event.getCollection();
		</cfscript>
		<cfset arguments.event.setLayout('Layout.Main')>
	  <cfset arguments.event.setView('admin/debug')>
	</cffunction>
<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>

  <cffunction name="sethomepage" returntype="void" output="false" hint="My main event">
    <cfargument name="event" required="true" type="any">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.homepage = arguments.event.getValue("page","feed")>
    <cfset CookieStorage.setVar("homePage",rc.homepage,365)>
    <cfset rc.sess.eGroup.homepage = rc.homepage>
    <cfset setNextEvent(uri="/#rc.sess.eGroup.homepage#")>
  </cffunction>

  <cffunction name="test" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
    </cfscript>
    <cfset arguments.event.setLayout('Layout.Temp')>
    <cfset arguments.event.setView('temp')>
  </cffunction>
</cfcomponent>