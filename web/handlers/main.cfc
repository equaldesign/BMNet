<cfcomponent output="false" autowire="true" cache="true" cacheTimeout="30" >
	<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
	<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
<cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
<cfproperty name="contact" inject="id:eGroup.contact" />
<cfproperty name="ContactService" inject="id:eunify.ContactService" />
<cfproperty name="moduleSettings" inject="coldbox:setting:modules" />
<cfproperty name="bvUserService" inject="id:bv.UserService">
<cfproperty name="groupService" inject="id:eunify.GroupsService">
<cfproperty name="geoService" inject="id:eunify.geoService">
<cfproperty name="bugService" inject="id:bugs.BugService">
<cfproperty name="SiteService" inject="id:eunify.SiteService">
<cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
<cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
<cfproperty name="dsnRead" inject="coldbox:datasource:eGroupRead" />
<cfproperty name="logger" inject="logbox:root">

			<cfscript>
		instance = structnew();
		</cfscript>
	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event">

		<cfset setNextEvent(getSetting('DefaultEvent'))>
	</cffunction>

	<cffunction name="onAppInit" returntype="void" output="false">
		<cfargument name="event">
    <cfset var appUsers = StructNew()>
		<cfset ApplicationStorage.setVar("appRoot","#ExpandPath("../")#")>
    <cfset ApplicationStorage.setVar("dmsRoot","#ExpandPath("../../shared/dms/cemco/")#")>
		<cfset ApplicationStorage.setVar("appUsers",appUsers)>    
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
    <cfset var basket = {
        items = [],
        id = createUUID(),
        total=0,
        type="order",
        contactID=0,
        deliveryPostCode = "",
        deliveryCoOrdinates = [],
        type="basket"
    }>
    <cfset var quote = {
        items = [],
        total=0,
        type="quote",
        id = 0,
        contactID=0
    }>
    <cfset var order = {
      stage = 1,
      quote = false,
      guest=false,
      accountNumber=0,
      delivered=false,
      email = "",
      delivery = {
        name = "",
        address1 = "",
        address2 = "",
        address3 = "",
        town = "",
        county = "",
        postCode = "",
        phone = "",
        mobile = "",
        email = ""
      },
      invoice = {
        name = "",
        address1 = "",
        address2 = "",
        address3 = "",
        town = "",
        county = "",
        postCode = "",
        phone = "",
        mobile = "",
        email = ""
      },
      card = {
        name = "",
        cardType = "",
        cardNumber = "",
        validFrom = now(),
        validTo = now(),
        securityCode = "",
        issueNumber = ""
      }
    }>
    <cfset var mxtra = {}>
    <cfset mxtra.order = order>
    <cfset mxtra.quote = quote>
    <cfset mxtra.basket = basket>
    <cfset mxtra.filter = {
      priceFrom = "",
      priceTo = "",
      brands = "",
      collectable = "true",
      delivery_charge = "none,fixed",
      delivery_locations = "radius,postcode,nationwide,collectonly",
      orderBy = "price",
      orderDir = "asc",
      itemsPerPage = 13,
      viewMode = "grid"
    }>
    <cfset var BMNet = {
      sessionReference = "#createUUID()#",
      userName = "",
      name = "",
      companyID = 0,
      branchID = "",
      account_number = 0,
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
      productLayout = "grid",
      siteID = "",
      ticketTimeOut = dateAdd("n", 15, now()),
      ticketTimeOutAdmin = dateAdd("n", 15, now()),
      ticketTimeOutGuest = dateAdd("n", 15, now()), 
      user_ticket = bvUserService.getTicket("website@buildingvine.com","f4ck5t41n"),
      guest_ticket = bvUserService.getTicket("guest",""),
      admin_ticket = bvUserService.getTicket("admin","bugg3rm33")
    }>
    <cfset ApplicationStorage.setVar("eGroup",eGroup)>
    <cfset ApplicationStorage.setVar("mxtra",mxtra)>
    <cfset ApplicationStorage.setVar("BMNet",BMNet)>
    <cfset ApplicationStorage.setVar("buildingVine",buildingVine)>
	</cffunction>

	<cffunction name="onSessionStart" returntype="void" output="false">
		<cfargument name="event">

		<cfset var rc = arguments.event.getCollection()>
		<cfset var sess = UserStorage>
		<cfscript>
			sess.setVar("alf_ticket","");
			//sess.setVar("paging", getMyPlugin("Paging"));
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

    <cfheader statuscode="200">
    <cfscript>
      if (isDefined("rc.remember")) {
        CookieStorage.setVar(name="eGroupLogin",value="#rc.username#;#rc.password#",expires=365,secure=true);
      }
      rc.filter = arguments.event.getValue("filter",0);
      rc.logEvent = true;
      rc.moduleSettings = moduleSettings;
      rc.appRoot = ApplicationStorage.getVar("appRoot");
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
    <cfset rc.resetKey = arguments.event.getValue("resetckey","")>
		<cfset SetLocale("English (UK)")>
		<cfset rc.app = ApplicationStorage.getStorage()>
    <cfset rc.isAjax = event.getValue("useAjax",rc.isAjax)>
    <cfset rc.app = ApplicationStorage.getStorage()>
    <cfset rc.sess.eGroup = UserStorage.getVar("eGroup")>
    <cfset rc.sess.buildingVine = UserStorage.getVar("buildingVine")>
    <cfset rc.sess.BMNet = UserStorage.getVar("BMNet")>
    <cfset rc.siteID = arguments.event.getValue("siteID",rc.siteID)>
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
    <cfif CookieStorage.getVar("basketID","") neq "">
      <cfset geoInfo = UserStorage.getVar("geoInfo")>
      <cfif isSimpleValue(geoInfo)>
        <cfset logger.debug("Update GeoInfo")>
        <cftry>
          <cfset remoteAdd = GetHttpRequestData().headers['X-Forwarded-For']>
          <cfcatch type="any">
            <cfset remoteAdd = cgi.REMOTE_ADDR>
          </cfcatch>
        </cftry>
        <cfif ListLen(remoteAdd,",") gt 1>
          <cfset remoteAdd = ListFirst(remoteAdd)>
        </cfif>
        <cfset UserStorage.setVar("geoInfo",geoService.getAddressFromIp(remoteAdd))>        
      </cfif>        
    </cfif>
    <cfscript>
    rc.siteManager = false;
    rc.viewPath = "web/";
    rc.paging = getMyPlugin("Paging");
    rc.page = event.getValue("page",1);
    rc.bvMenu = event.getValue("showBVMenu","");
    rc.layoutMode = event.getValue("layoutMode",CookieStorage.getVar("layoutMode","public"));
    CookieStorage.setVar("layoutMode",rc.layoutMode,365);
    rc.productID = event.getValue('productID',0);
    rc.page = arguments.event.getValue("page",1);
    rc.categoryID = event.getValue('categoryID',0);
    rc.slug = event.getValue("slug","");
    rc.basket = request.mxtra.basket;
    rc.order = request.mxtra.order;
    rc.basketID = CookieStorage.getVar("basketID","");
    rc.tagService = request.tagService;
    rc.initialDialog = false;
    rc.quote = request.quote;
    rc.Query = event.getValue('query',"");
    rc.sess.eGroup = request.eGroup;
    </cfscript>
    <!--- timeouts --->

	</cffunction>

	<cffunction name="onRequestEnd" returntype="void" output="true">
		<cfargument name="event">
			<cfset var rc = arguments.event.getCollection()>
      <cfheader statuscode="200">
	</cffunction>

	<cffunction name="onSessionEnd" returntype="void" output="false">
		<cfargument name="event">

		<cfset var sessionScope = arguments.event.getValue("sessionReference")>
		<cfset var applicationScope = arguments.event.getValue("applicationReference")>

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
    <cfset rc.newTicketID = createUUID()>
    <cftry>
    <cfquery name="bugLog" datasource="bugs">
      insert into bug
      (ticket,request,type,title,description,status,priority,reproduce,url,username,email,system,site,created,formVars,urlVars,browser,version,hostname,referrer)
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.newTicketID#">,
        <cfqueryparam cfsqltype="cf_sql_clob" value="#flash#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="server">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#exceptionStruct.Message#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#exceptionStruct.detail#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="open">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#exceptionStruct.StackTrace#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="http://#cgi.HTTP_HOST##htmlEditFormat(CGI.PATH_INFO)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramValue('request.BMnet.name','')#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramValue('request.BMnet.username','')#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="BMnet">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramValue('request.bvsiteID','ebiz')#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(form)#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(url)#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_USER_AGENT#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#paramValue('rc.version','1.3')#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_HOST#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#CGI.HTTP_REFERER#">
    )
    </cfquery>
    <cfset rc.bugDetail = bugService.getBug(ticket=rc.newTicketID)>
    <cfcatch type="any">
      <cfdump var="#exceptionStruct#">
    </cfcatch>
    </cftry>
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