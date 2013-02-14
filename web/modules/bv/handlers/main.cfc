
<cfcomponent output="false">

	<!--- dependencies --->
	<cfproperty name="userService" inject="id:bv.UserService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="faceBook" inject="id:bv.FacebookService">
  <cfproperty name="documentService" inject="id:bv.DocumentService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">
	<!--- preHandler --->


  <cffunction name="onAppInit" access="public" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var buildingVine = {}>
    <cfset productImport = {}>
    <cfset perm = structnew()>
    <cfset perm.group = "all">
    <cfset perm.permission = "read">
    <cfset perm1 = structnew()>
    <cfset perm1.id = "1a437f9d7cebe54b5c2948cb4eda05740cf560b2e7e5e2e538fba5543c0ca31a">
    <cfset perm1.permission = "FULL_CONTROL">
    <cfset myarrray = arrayNew(1)>
    <cfset s3permissions = [perm,perm1]>
    <cfset ApplicationStorage.setVar("s3permissions",s3permissions)>
		<cfset buildingVine.defaultSite = "buildingVine">
		<cfset buildingVine.layout = "grid">
		<cfset buildingVine.siteID = "buildingVine">
		<cfset buildingVine.sitesManaged = ["speng"]>
    <cfset buildingVine.defaultSearch = "products">
		<cfset buildingVine.myProfile = "">
		<cfset buildingVine.userProfile.userName = "guest">
		<cfset buildingVine.preferences.defaultSite = "buildingVine">
		<cfset buildingVine.productLayout = "grid">
		<cfset buildingVine.username = "guest">
		<cfset buildingVine.siteDB = siteService.siteDB("buildingVine")>
		<cfset buildingVine.maxRows = 10>		
    <cfset buildingVine.guest_ticket = UserService.getTicket("website@buildingvine.com","f4ck5t41n")>
	  <cfset buildingVine.user_ticket = UserService.getTicket("website@buildingvine.com","f4ck5t41n")>
    <cfset buildingVine.admin_ticket = UserService.getTicket("admin","bugg3rm33")>
		<cfset ApplicationStorage.setVar("buildingVine",buildingVine)>
		<cfset ApplicationStorage.setVar("profileEmail","guest")>
    <cfset ApplicationStorage.setVar("buildingVine",buildingVine)>
    <cfset ApplicationStorage.setVar("productImport",productImport)>
    <cfset ApplicationStorage.setVar("appRoot",expandPath("./"))>

  </cffunction>

  <cffunction name="onRequestStart" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
	  <cfset rc.app = ApplicationStorage.getStorage()>
  </cffunction>



  <cffunction name="onRequestEnd" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- ON Request End Here --->


  </cffunction>

  <cffunction name="onSessionStart" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
  </cffunction>

  <cffunction name="onSessionEnd" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- ON session End Here --->
    <cfset var sessionScope = event.getValue("sessionReference")>
    <cfset var applicationScope = event.getValue("applicationReference")>

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
    <cfif CookieStorage.getVar("clusterUser","public") eq "public">
		  <cfabort>
	 </cfif>
    <cfsavecontent variable="flash">
      <h2>Session Information</h2>
      <cfdump var="#request.buildingVine#">
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
        <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CookieStorage.getVar("clusterUser","public")#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="buildingVine">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.siteID#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
    </cfquery>
    <cfset arguments.event.setLayout("Layout.Main")>
    <cfset arguments.event.setView("debug")>
  </cffunction>

  <cffunction name="onInvalidEvent" returntype="void" output="false">
    <cfargument name="event">

    <cfset var e = arguments.event.getValue(name="invalidEvent",private="true")>
    <cfset arguments.event.setLayout("Layout.Main")>
    <cfset arguments.event.setView("invalidEvent")>
  </cffunction>
</cfcomponent>