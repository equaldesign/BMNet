<cfcomponent output="false" autowire="true" cache="true" cacheTimeout="30" >
	<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
	<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
<cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
<cfproperty name="contact" inject="id:eGroup.contact" />
<cfproperty name="ContactService" inject="id:eunify.ContactService" />
<cfproperty name="moduleSettings" inject="coldbox:setting:modules" />
<cfproperty name="bvUserService" inject="model:modules.bv.model.UserService">
<cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
<cfproperty name="dsn" inject="coldbox:datasource:eGroup" />
<cfproperty name="dsnRead" inject="coldbox:datasource:eGroupRead" />

			<cfscript>
		instance = structnew();
		</cfscript>
	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event">

		<cfset setNextEvent(getSetting('DefaultEvent'))>
	</cffunction>

	<cffunction name="onAppInit" returntype="void" output="false">
		<cfargument name="event">

		<cfset var app = ApplicationStorage>
    <cfset var appUsers = StructNew()>
		<cfset app.setVar("appRoot","#ExpandPath("../")#")>
    <cfset app.setVar("dmsRoot","#ExpandPath("../../shared/dms/cemco/")#")>
		<cfset app.setVar("appUsers",appUsers)>
    <cfset var eGroup = {
        sessionReference = "#createUUID()#",
        userName = "",
        name = "",
        datasource="eGroup_acme",
        companyID = "",
        branchID = "",
        siteName = "BuildersMerchant",
        editMode = false,
        companyknown_as = "",
        companyName = "",
        newsFilter = 0,
        bmnet = false,
        cacheDisabled = false,
        cacheKey = createUUID(),
        roles = "public",
        rolesids = 89,
        showFavouritesOnly = false,
        homePage = "/general",
        contactID = 0,
        isMemberContact = false
      }>
    <cfset var BMNet = {
            sessionReference = "#createUUID()#",
            userName = "",
            name = "",
            companyID = "",
            branchID = "",
            bmnet = false,
            showFavouritesOnly = false,
            homepage = CookieStorage.getVar("homepage","feed"),
            editMode = false,
            cacheDisabled = false,
            companyknown_as = "",
            newsFilter = CookieStorage.getVar("filter",0),
            contactID = "",
            siteName = "buildersMerchant.net",
            isMemberContact = false
          }>
    <cfset var buildingVine = {
        active = false,
        username = "",
        password = false,
        company = false,
        siteList = "",
        siteID = "",
        user_ticket = "",
        guest_ticket = bvUserService.getTicket("guest",""),
        admin_ticket = bvUserService.getTicket("admin","bugg3rm33")
      }>
    <cfset app.setVar("eGroup",eGroup)>
    <cfset app.setVar("BMNet",BMNet)>
    <cfset app.setVar("buildingVine",buildingVine)>
	</cffunction>

	<cffunction name="onSessionStart" returntype="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
		<cfset var sess = UserStorage>
		<cfscript>
			sess.setVar("alf_ticket","");
			sess.setVar("paging", getMyPlugin("Paging"));
			sess.setVar("defaultSearch",CookieStorage.getVar("defaultSearch","products"));
      sess.setVar("productLayout",CookieStorage.getVar("productLayout","standard"));
		</cfscript>
	</cffunction>

	<cffunction name="onRequestStart" returntype="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
    <cfset var prc = arguments.event.getCollection( private=true )>
		<cfset var filter = getPlugin("CookieStorage").getVar("filter",0)>
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfset var logUser = "">
    <cfscript>

      if (isDefined("rc.remember")) {
        throw("boo");
        CookieStorage.setVar(name="eGroupLogin",value="#rc.username#;#rc.password#",expires=365,secure=true);
      }
      rc.filter = arguments.event.getValue("filter",0);
      rc.logEvent = true;
      rc.moduleSettings = moduleSettings;
      rc.filterColumn = event.getValue("filterColumn","");
      rc.filterValue = event.getValue("filterValue","");
      rc.type_id = event.getValue("type_id",1);
      rc.t = event.getValue("t","Invoice_Header");
    </cfscript>
    <cfset rc.cookie = CookieStorage>
    <cfset rc.showMenu = true>
    <cfset rc.layoutStyle = rc.cookie.getVar("layoutStyle","Main")>
    <cfif getAuthUser() eq "">
      <cfset rc.layoutStyle = "Main">
    </cfif>
    <cfif isUserInRole("SimpleMode")>
      <cfset rc.layoutStyle = "Simple">
    </cfif>
    <cfif event.getCurrentModule() eq "" OR event.getCurrentModule() eq "eGroup" OR event.getCurrentModule() eq "bv">

    </cfif>
    <cfset rc.resetKey = arguments.event.getValue("resetckey","")>
		<cfset SetLocale("English (UK)")>
		<cfset rc.app = ApplicationStorage.getStorage()>
    <cfset rc.sess = {}>
    <cfset rc.app = ApplicationStorage.getStorage()>
    <cfset rc.sess.eGroup = UserStorage.getVar("eGroup")>
    <cfset rc.sess.buildingVine = UserStorage.getVar("buildingVine")>
    <cfset rc.sess.BMNet = UserStorage.getVar("BMNet")>
    <cfset rc.siteID = arguments.event.getValue("siteID",rc.sess.buildingVine.siteID)>
		<cfset rc.sessP = UserStorage>
    <cfif NOT rc.isAjax>
      <cfset rc.tickCount = getTickCount()>
      <cfset rc.cookieID = rc.cookie.getVar("mxtra_basket","")>
      <cfset rc.showFavouritesOnly = rc.cookie.getVar("showFavouritesOnly",false)>
      <cfset rc.changeHomepage = arguments.event.getValue("changeHomepage","false")>
      <cfif rc.changeHomepage neq "false">
       <cfset getPlugin("CookieStorage").setVar("homepage",rc.changeHomepage)>
       <cfif isDefined('rc.sess.eGroup')>
         <cfset rc.sess.eGroup.homepage = rc.changeHomepage>
       </cfif>
      </cfif>
    </cfif>
    <cfif rc.sess.BMNet.username neq "">
    <cfset CookieStorage.setVar(name="clusterUser",value=rc.sess.BMNet.username,expires=DateAdd("n", 20, now()))>
    </cfif>
	</cffunction>

	<cffunction name="onRequestEnd" returntype="void" output="false">
		<cfargument name="event">

			<cfset var rc = arguments.event.getCollection()>
      <cfset var eGroup = UserStorage.getVar("eGroup")>
	</cffunction>

	<cffunction name="onSessionEnd" returntype="void" output="false">
		<cfargument name="event">

		<cfset var sessionScope = arguments.event.getValue("sessionReference")>
		<cfset var applicationScope = arguments.event.getValue("applicationReference")>
		<cfset var sessionRef = sessionScope.eGroup.sessionReference>
		<cfset StructDelete(applicationScope.appUsers,"#sessionRef#")>

	</cffunction>

	<cffunction name="onException" returntype="void" output="true">
		<cfargument name="event">

		<cfscript>
      var rc = arguments.event.getCollection();
      var exceptionBean = arguments.event.getValue("ExceptionBean");
      var exceptionStruct = exceptionBean.GETEXCEPTIONSTRUCT();
      var i = "";
      var arrayTagContext = "";
      var bugLog = "";
      var flash = "";
		</cfscript>
    <cfsavecontent variable="flash">
      <h2>Session Information</h2>
      <cfdump var="#rc.sess#">
      <h2>Form Information</h2>
      <cfdump var="#form#">
      <h2>Error Information</h2>
			<cfoutput>
			<!--- StyleSheets --->
			<style type="text/css"><cfinclude template="/coldbox/system/includes/css/cbox-debugger.pack.css"></style>
			<table border="0" cellpadding="0" cellspacing="3" class="fw_errorTables" align="center">

			  <!--- TAG CONTEXT --->
			  <cfif ArrayLen(exceptionBean.getTagContext()) >
			      <cfset arrayTagContext = exceptionBean.getTagContext()>
			      <tr >
			      <th colspan="2" >Tag Context:</th>
			      </tr>
			      <cfloop from="1" to="#arrayLen(arrayTagContext)#" index="i">
			      <tr >
			      <td align="right" class="fw_errorTablesTitles">ID:</td>
			        <td ><cfif not structKeyExists(arrayTagContext[i], "ID")>??<cfelse>#arrayTagContext[i].ID#</cfif></td>
			      </tr>
			       <tr >
			      <td align="right" class="fw_errorTablesTitles">LINE:</td>
			        <td >#arrayTagContext[i].LINE#</td>
			       </tr>
			       <tr >
			      <td align="right" class="fw_errorTablesTitles">Template:</td>
			        <td >#arrayTagContext[i].Template#</td>
			       </tr>
			      </cfloop>
			  </cfif>

			  <tr>
			     <th colspan="2" >Framework Snapshot</th>
			  </tr>

			  <cfif exceptionBean.getErrorType() eq "Application">
			    <tr>
			      <td width="75" align="right" class="fw_errorTablesTitles">Current Event: </td>
			      <td width="463" ><cfif arguments.event.getCurrentEvent() neq "">#arguments.event.getCurrentEvent()#<cfelse>N/A</cfif></td>
			    </tr>
			    <tr>
			      <td align="right" class="fw_errorTablesTitles">Current Layout: </td>
			      <td ><cfif arguments.event.getCurrentLayout() neq "">#arguments.event.getCurrentLayout()#<cfelse>N/A</cfif></td>
			    </tr>
			    <tr>
			      <td align="right" class="fw_errorTablesTitles">Current View: </td>
			      <td ><cfif arguments.event.getCurrentView() neq "">#arguments.event.getCurrentView()#<cfelse>N/A</cfif></td>
			    </tr>
			  </cfif>

			   <tr>
			     <td align="right" class="fw_errorTablesTitles">Bug Date:</td>
			     <td >#dateformat(now(), "MM/DD/YYYY")# #timeformat(now(),"hh:MM:SS TT")#</td>
			   </tr>

			   <tr>
			     <td align="right" class="fw_errorTablesTitles">Coldfusion ID: </td>
			     <td >
			      <cftry>
			      <cfif isDefined("session") and structkeyExists(session, "cfid")>
			      CFID=#session.CFID# ;
			      <cfelseif isDefined("client") and structkeyExists(client,"cfid")>
			      CFID=#client.CFID# ;
			      </cfif>
			      <cfif isDefined("session") and structkeyExists(session,"CFToken")>
			      CFToken=#session.CFToken# ;
			      <cfelseif isDefined("client") and structkeyExists(client,"CFToken")>
			      CFToken=#client.CFToken# ;
			      </cfif>
			      <cfif isDefined("session") and structkeyExists(session,"sessionID")>
			      JSessionID=#session.sessionID#
			      </cfif>
			      <cfcatch>
			        <!--- ignore, in case there is no session id available --->
			        N/A
			      </cfcatch>
			    </cftry>
			    </td>
			   </tr>
			   <tr>
			     <td align="right" class="fw_errorTablesTitles">Template Path : </td>
			     <td >#htmlEditFormat(CGI.CF_TEMPLATE_PATH)#</td>
			   </tr>
			    <tr>
			     <td align="right" class="fw_errorTablesTitles">Path Info : </td>
			     <td >#htmlEditFormat(CGI.PATH_INFO)#</td>
			   </tr>
			   <tr>
			     <td align="right" class="fw_errorTablesTitles"> Host &amp; Server: </td>
			     <td >#htmlEditFormat(cgi.http_host)# #controller.getPlugin("JVMUtils").getInetHost()#</td>
			   </tr>
			   <tr>
			     <td align="right" class="fw_errorTablesTitles">Query String: </td>
			     <td >#htmlEditFormat(cgi.QUERY_STRING)#</td>
			   </tr>

			  <cfif len(cgi.HTTP_REFERER)>
			   <tr>
			     <td align="right" class="fw_errorTablesTitles">Referrer:</td>
			     <td >#htmlEditFormat(cgi.HTTP_REFERER)#</td>
			   </tr>
			  </cfif>

			  <tr>
			     <td align="right" class="fw_errorTablesTitles">Browser:</td>
			     <td >#htmlEditFormat(cgi.HTTP_USER_AGENT)#</td>
			  </tr>

			   <cfif isStruct(exceptionBean.getExceptionStruct()) >

			    <cfif exceptionBean.getmissingFileName() neq  "">
			      <tr>
			       <th colspan="2" >Missing Include Exception</th>
			      </tr>
			      <tr >
			      <td colspan="2" class="fw_errorTablesTitles">Missing File Name:</td>
			      </tr>
			      <tr>
			      <td colspan="2" >#exceptionBean.getmissingFileName()#</td>
			      </tr>
			    </cfif>

			    <cfif findnocase("database", exceptionBean.getType() )>
			      <tr >
			      <th colspan="2" >Database Exception Information:</th>
			      </tr>
			      <tr >
			      <td colspan="2" class="fw_errorTablesTitles">NativeErrorCode & SQL State:</td>
			      </tr>
			      <tr>
			      <td colspan="2" >#exceptionBean.getNativeErrorCode()# : #exceptionBean.getSQLState()#</td>
			      </tr>
			      <tr >
			      <td colspan="2" class="fw_errorTablesTitles">SQL Sent:</td>
			      </tr>
			      <tr>
			      <td colspan="2" >#exceptionBean.getSQL()#</td>
			      </tr>
			      <tr >
			      <td colspan="2" class="fw_errorTablesTitles">Database Driver Error Message:</td>
			      </tr>
			      <tr>
			      <td colspan="2" >#exceptionBean.getqueryError()#</td>
			      </tr>
			      <tr >
			      <td colspan="2" class="fw_errorTablesTitles">Name-Value Pairs:</td>
			      </tr>
			      <tr>
			      <td colspan="2" >#exceptionBean.getWhere()#</td>
			      </tr>
			    </cfif>
			  </cfif>

			   <tr >
			    <th colspan="2" >Stack Trace:</th>
			   </tr>
			   <tr>
			    <td colspan="2" >
			      <div class="fw_stacktrace"><pre>#exceptionBean.getstackTrace()#</pre></div>
			    </td>
			   </tr>

			   <tr>
			     <th colspan="2" >Extra Information Dump </th>
			   </tr>

			   <tr>
			      <td colspan="2" >
			      <cfif isSimpleValue(exceptionBean.getExtraInfo())>
			        <cfif not len(exceptionBean.getExtraInfo())>[N/A]<cfelse>#exceptionBean.getExtraInfo()#</cfif>
			      <cfelse>
			        <cfdump var="#exceptionBean.getExtraInfo()#" expand="false">
			    </cfif>
			      </td>
			   </tr>

			</table>
			</cfoutput>
    </cfsavecontent>
    <cfquery name="bugLog" datasource="bugs">
      insert into bug
      (ticket,request,type,title,description,status,priority,reproduce,url,username,email,system,site,created)
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#">,
        <cfqueryparam cfsqltype="cf_sql_clob" value="#flash#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="server">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#exceptionStruct.Message#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#exceptionStruct.detail#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="open">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#exceptionStruct.StackTrace#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="http://#cgi.HTTP_HOST##htmlEditFormat(CGI.PATH_INFO)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.sess.eGroup.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.sess.eGroup.username#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="intranet">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#getSetting('siteName')#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
    </cfquery>
		<cfset arguments.event.setLayout("Layout.Main")>
		<cfset arguments.event.setView("debug")>
	</cffunction>

	<cffunction name="onInvalidEvent" returntype="void" output="false">
		<cfargument name="event">

    <cfset var e = arguments.event.getValue(name="invalidEvent",private="true")>
    <cfset arguments.event.setView("beta")>
	</cffunction>

</cfcomponent>