<cfcomponent name="eGroupCache" extends="coldbox.system.interceptor">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="SiteService" inject="id:eunify.SiteService">
  <cfproperty name="bvUserService" inject="id:bv.UserService">
  <cfproperty name="bvSiteService" inject="id:bv.SiteService">
  <cfproperty name="basket" inject="id:mxtra.basket">
  <cfproperty name="quote" inject="id:mxtra.quote" />
  <cfproperty name="tagService" inject="id:eunify.TagService" />
  <cfproperty name="WikiText" inject="coldbox:plugin:WikiText">
  <cfproperty name="groupService" inject="id:eunify.GroupsService" />
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cffunction name="OnRequestCapture" returntype="void">
    <cfargument name="event">
    <cfargument name="interceptData">

    <cfscript>
    var rc = arguments.event.getCollection();
    var prc = arguments.event.getCollection( private=true );
    var BMNet = UserStorage.getVar("BMNet");
    var buildingVine = UserStorage.getVar("buildingVine");

    var fullPurge = arguments.event.getValue("fullPurge",false);
    var httpData = getHTTPRequestData();
    var siteID = 0;
    if (isUserLoggedIn()) {
      rc.cid = session.cfid;
    }
    request.user_ticket = buildingVine.user_ticket;
    rc.isAjax = structKeyExists(httpData.headers, 'X-Requested-With')
    && httpData.headers['X-Requested-With'] == 'XMLHttpRequest';
    
    if (NOT isStruct(BMNet)) {
      runEvent("main.onSessionStart"); 
    }
    rc.rtURL = arguments.event.getCurrentRoutedURL();
    request.WikiText = WikiText;
    request.groupService = groupService;
    request.tagService = tagService;
    if (isUserLoggedIn()) {
      // UserStorage.setVar("buildingVine",buildingVine);
    }
    request.CookieStorage = CookieStorage;
    request.quote = quote.getQuote();
    request.buildingVine = buildingVine;
    
    request.contactID = paramValue("request.BMNet.contactID",0);
    request.companyID = paramValue("request.BMNet.companyID",0);
    request.geoInfo = UserStorage.getVar("geoInfo");
    rc.bvsiteID = event.getValue("siteID","buildingVine");
    if (NOT isDefined("request.siteID")) {     
      
      site = SiteService.gethost();
      if (site.recordCount neq 0) {
        request.siteID = site.ID;
        request.bvsiteID = site.bvsiteID;
        
        rc.siteID = site.bvsiteid;
        if (rc.bvsiteID eq "buildingVine") {
          rc.bvsiteID = request.bvsiteid;
        }
        request.site = site;
        if (site.primaryHost neq "" AND site.primaryHost neq cgi.http_host) {
          // locate to primary
          //doSafeRedirect(site.primaryHost,rc.rtURL,cgi.query_string);

        }
      } else {
        request.siteID = siteID;
        request.bvsiteID = "buildingVine";
        rc.siteID = "buildingVine";
      }
 
    }
    
    request.bvsiteID = rc.bvsiteID;
    if (request.bvsiteID neq request.buildingVine.siteID) {
      request.buildingVine.siteID = request.bvsiteID;
      request.buildingVine.site = bvSiteService.getSite(request.bvsiteID);
      if (isUserLoggedIn()) {
        UserStorage.setVar("buildingVine",request.buildingVine);
      }
    }
    if (CookieStorage.getVar("basketID","") eq "") {
      request.mxtra = ApplicationStorage.getVar("mxtra");
    } else {
      request.mxtra = UserStorage.getVar("mxtra");
      request.basket = basket.getBasket();

    }
    request.mxtra.filter = ApplicationStorage.getVar("mxtra").filter;

    if (event.getValue("fwCache","") neq "") {
       prc.clearCache = true;
       event.removeValue("fwCache");
    }
    if (fullPurge) {
       rc.fwCache=true;
    }
    if (BMNet.cacheDisabled or isUserInRole("admin")) {
      rc.fwCache=true;
    }
    if (isDefined("BMNet.editMode")) {
        if ((isBoolean(BMNet.editMode) AND BMNet.editMode)) {
          rc.fwCache=true;
        }
    }
    if (isUserInRole("staff")) {
       rc.fwCache=true;
    }
     /* BV Stuff */

    /* MXTRA Defaults */

    // FLOW Stuff
    if (event.getValue("flowSystem",UserStorage.getVar("flowSystem","BMNet")) neq UserStorage.getVar("flowSystem","BMNet")) {
       // UserStorage.setVar("flowSystem",event.getValue("flowSystem"));
    }
    request.flowSystem = UserStorage.getVar("flowSystem","BMNet");
    rc.system = request.flowSystem;

    // BMNet stuff
    request.BMNet = BMNet;

    // eGroup Stuff
    var eGroup = UserStorage.getVar("eGroup");
    request.eGroup = eGroup;

    rc.brands = event.getValue("brands",request.mxtra.filter.brands);
    rc.collectable = event.getValue("collectable",request.mxtra.filter.collectable);
    rc.delivery_charge = event.getValue("delivery_charge",request.mxtra.filter.delivery_charge);
    rc.delivery_locations = event.getValue("delivery_locations",request.mxtra.filter.delivery_locations);
    rc.priceFrom = event.getValue("priceFrom",request.mxtra.filter.priceFrom);
    rc.priceTo = event.getValue("priceTo",request.mxtra.filter.priceTo);
    rc.orderBy = event.getValue('orderBy',request.mxtra.filter.orderBy);
    rc.itemsPerPage = event.getValue('itemsPerPage',request.mxtra.filter.itemsPerPage);
    rc.orderDir = event.getValue('orderDir',request.mxtra.filter.orderDir);
    rc.viewMode = event.getValue('viewMode',request.mxtra.filter.viewMode);
    /*
    if (
      rc.brands neq request.mxtra.filter.brands
      OR
      rc.collectable neq request.mxtra.filter.collectable 
      OR
      rc.delivery_charge neq request.mxtra.filter.delivery_charge
      OR
      rc.delivery_locations neq request.mxtra.filter.delivery_locations
      OR
      rc.priceFrom neq request.mxtra.filter.priceFrom
      OR
      rc.priceTo neq request.mxtra.filter.priceTo
      OR
      rc.orderBy neq request.mxtra.filter.orderBy
      OR
      rc.orderDir neq request.mxtra.filter.orderDir
      OR
      rc.itemsPerPage neq request.mxtra.filter.itemsPerPage
      OR
      rc.viewMode neq request.mxtra.filter.viewMode
    ) {
       request.mxtra.filter.brands = rc.brands;
       request.mxtra.filter.collectable = rc.collectable;
       request.mxtra.filter.delivery_charge = rc.delivery_charge;
       request.mxtra.filter.delivery_locations = rc.delivery_locations;
       request.mxtra.filter.priceFrom = rc.priceFrom;
       request.mxtra.filter.priceTo = rc.priceTo;
       request.mxtra.filter.orderBy = rc.orderBy;
       request.mxtra.filter.orderDir = rc.orderDir;
       request.mxtra.filter.itemsPerPage = rc.itemsPerPage;
       request.mxtra.filter.viewMode = rc.viewMode;
    }
    */

    // lastly get user siteList if it doesn't already exist 
    logger.debug("main Interceptor");
    if (isSimpleValue(paramValue("request.buildingVine.userSiteList","")) AND request.buildingVine.active) {      
      if (isUserLoggedIn()) {
        request.buildingVine.userSiteList = bvUserService.listSites();
        // UserStorage.setVar("buildingVine",request.buildingVine);
      }
    }

    var bvApp = ApplicationStorage.getVar("buildingVine");

    // temp

    if (dateDiff("n", now(),bvApp.ticketTimeOut) lte 0) {
      logger.debug("Ticket: Stale Application Ticket Timeout");
      if (NOT bvUserService.isValidTicket(bvApp.user_ticket)) {
        bvApp.user_ticket = bvUserService.getTicket("website@buildingvine.com","f4ck5t41n");
      }
      bvApp.ticketTimeOut = dateAdd("n", 15, now());          
    } else {
      logger.debug('Ticket Application OK: #dateDiff("n",now(),bvApp.ticketTimeOut)# mins till expiry');
    }
    if (dateDiff("n", now(),bvApp.ticketTimeOutAdmin) lte 0) {
      logger.debug("Ticket: Stale Application Admin Ticket Timeout");
      if (NOT bvUserService.isValidTicket(bvApp.admin_ticket)) {
        bvApp.admin_ticket = bvUserService.getTicket("admin","bugg3rm33");
      }      
      bvApp.ticketTimeOutAdmin = dateAdd("n", 15, now());  
    } else {
      logger.debug('Ticket Application Admin OK: #dateDiff("n",now(),bvApp.ticketTimeOutAdmin)# mins till expiry');
    }
    if (dateDiff("n", now(),bvApp.ticketTimeOutGuest) lte 0) {
      logger.debug("Ticket: Stale Application Guest Ticket Timeout");
      if (NOT bvUserService.isValidTicket(bvApp.guest_ticket)) {
        bvApp.guest_ticket = bvUserService.getTicket("guest","");
      } 
      bvApp.ticketTimeOutGuest = dateAdd("n", 15, now());
    } else {
      logger.debug('Ticket Application User OK: #dateDiff("n",now(),bvApp.ticketTimeOutGuest)# mins till expiry');
    }
    if (dateDiff("n",now(), request.buildingVine.ticketTimeOut) lte 0) {
      logger.debug("Ticket: Stale Session Ticket Timeout");
      if (NOT bvUserService.isValidTicket(request.buildingVine.user_ticket)) {
        request.buildingVine.user_ticket = bvUserService.getTicket(request.buildingVine.username,request.buildingVine.password);
      }   
      request.buildingVine.ticketTimeOut = dateAdd("n", 15, now());          
    } else {
      logger.debug('Ticket Session OK: #dateDiff("n",now(),request.buildingVine.ticketTimeOut)# mins till expiry');
    }
    if (dateDiff("n",now(),request.buildingVine.ticketTimeOutAdmin) lte 0) {
      logger.debug("Ticket: Stale Session Admin Ticket Timeout");
      if (NOT bvUserService.isValidTicket(request.buildingVine.admin_ticket)) {
        request.buildingVine.admin_ticket = bvApp.admin_ticket;
      }
      request.buildingVine.ticketTimeOutAdmin = dateAdd("n", 15, now());  
    } else {
      logger.debug('Ticket Session Admin OK: #dateDiff("n",now(),request.buildingVine.ticketTimeOutAdmin)# mins till expiry');
    }
    if (dateDiff("n",now(),request.buildingVine.ticketTimeOutGuest) lte 0) {
      logger.debug("Ticket: Stale Session Guest Ticket Timeout");
      if (NOT bvUserService.isValidTicket(request.buildingVine.admin_ticket)) {
        request.buildingVine.guest_ticket = bvApp.guest_ticket;
      }
      request.buildingVine.ticketTimeOutGuest = dateAdd("n", 15, now());
    } else {
      logger.debug('Ticket Session Guest OK: #dateDiff("n",now(),request.buildingVine.ticketTimeOutGuest)# mins till expiry');
    }
    if (isUserLoggedIn()) {
      // UserStorage.setVar("buildingVine",request.buildingVine); 
    }
    ApplicationStorage.setVar("buildingVine",bvApp);
	</cfscript>



    <cfif rc.isAjax>
      <cfset arguments.event.setLayout('Layout.ajax')>
    <cfelseif event.getValue("useAjax",false)>
      <cfset arguments.event.setLayout('Layout.ajax.jQuery')>
    <cfelse>
      <cfif isUserInRole("staff")>
        <cfset arguments.event.setLayout('public/Layout.Main')>
        <cfif UserStorage.getVar("LayoutPath","public") eq "intranet">
          <cfset arguments.event.setLayout('intranet/Layout.Main')>
        </cfif>
      <cfelse>
        <cfset arguments.event.setLayout('public/Layout.Main')>
      </cfif>

    </cfif>

  </cffunction>

  <cffunction name="login" returntype="void">
    <cfargument name="username">
    <cfargument name="password">
    <cfargument name="roles">
    <cflogin>
      <cfloginuser name="#arguments.username#" password="#arguments.password#" roles="#arguments.roles#">
    </cflogin>
  </cffunction>
  <cffunction name="postProcess" returntype="void" output="true">
    <cfargument name="event">



  </cffunction>
  <cffunction name="doSafeRedirect" returntype="void">
    <cfargument name="hostName">
    <cfargument name="rtURL">
    <cfargument name="qs">
    <cflocation addtoken="false" url="http://#hostName#/#rtURL#?#qs#" statuscode="302"> 
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