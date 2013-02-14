<cfcomponent name="eGroupCache" extends="coldbox.system.interceptor">


  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">
  <cfproperty name="userService" inject="model:UserService">
  <cfproperty name="siteService" inject="model:SiteService">
  <cfscript>

  void function OnRequestCapture( required any event, required struct interceptData)
  {
    var instance = StructNew();
    var rc = arguments.event.getCollection();
    var prc = arguments.event.getCollection( private=true );
    var httpData = getHTTPRequestData();
    var changeSiteID = false;
    var clusterUser = CookieStorage.getVar("clusterUser","");
    rc.canChangeSite = true;
    rc.host = Replace(CGI.HTTP_HOST,":8080","","ALL");
    rc.paging = getMyPlugin(plugin="Paging");
    if (event.getValue("alf_ticket","") neq "") {
       UserStorage.setVar("alf_ticket",event.getValue("alf_ticket"));
    }

    // some default rc vars:
    rc.maxrows = event.getValue("maxrows",10);
    rc.layout = event.getValue("layout","grid");
    rc.page = event.getValue("page",1);


	  rc.buildingVine = UserStorage.getVar("buildingVine");
    request.user_ticket = UserService.getUserTicket();
    request.admin_ticket = UserService.getUserTicket(true);
    if (len(arguments.event.getCurrentRoutedURL()) gt 1) {
        rc.routeURL = MID(arguments.event.getCurrentRoutedURL(),1,Len(arguments.event.getCurrentRoutedURL())-1);
    } else {
        rc.routeURL = arguments.event.getCurrentRoutedURL();
	  }
    if (listGetAt(rc.host,2,".") neq "buildingvine") {
       rc.canChangeSite = false;
       rc.siteID = ListGetAt(rc.host,2,".");
    } else {
      if (event.getValue("siteID","") neq "") {
	      changeSiteID = true;
	      rc.siteID = event.getValue("siteID");
	    } else {
	      rc.siteID = ListGetAt(rc.host,2,".");
	    }
    }

	  request.siteID = rc.siteID;
	  /*if (CookieStorage.getVar("firstrun",true) && Left(CGI.HTTP_USER_AGENT,4) neq "Java") {
      logger.debug(Left(CGI.HTTP_USER_AGENT,4));
      CookieStorage.setVar("firstRun",true,1,false,"/","buildingvine.com");
      if (reFindNoCase("android.+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino",CGI.HTTP_USER_AGENT) GT 0 OR reFindNoCase("1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|e\-|e\/|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(di|rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|xda(\-|2|g)|yas\-|your|zeto|zte\-",Left(CGI.HTTP_USER_AGENT,4)) GT 0) {
      	if (ListFirst(rc.host,".") neq "m.") {
          // they have a mobile, but aren't on the mobile site
          if (rc.siteID neq "buildingVine") {
            setNextEvent(uri="http://m.#rc.siteID#.buildingvine.com/#rc.routeURL#");
          } else {
            setNextEvent(uri="http://m.buildingvine.com/#rc.routeURL#");
          }
        }
      } else {
        if (ListFirst(rc.host,".") eq "m.") {
          // they're on the mobile site, but not using a mobile device
          if (rc.siteID neq "buildingVine") {
            setNextEvent(uri="http://x.#rc.siteID#.buildingvine.com/#rc.routeURL#");
          } else {
            setNextEvent(uri="http://www.buildingvine.com/#rc.routeURL#");
          }
        }
      }
    }*/

    rc.layoutPath = "secure";
    rc.viewPath = "web/";

    rc.isAjax = structKeyExists(httpData.headers, 'X-Requested-With')
    && httpData.headers['X-Requested-With'] == 'XMLHttpRequest';
    rc.iData = interceptData;
    rc.showMenu = true;
    rc.siteManager = false;
    // rc.expires = GetHttpTimeString(dateAdd('d',7,now()));


    if (getAuthUser() neq "") {
         rc.layoutPath = "secure";
         rc.viewPath = "web/";
    }
    if (event.getCurrentModule() neq "") {
        //
    } else if (ListFirst(cgi.HTTP_HOST,".") eq "m") {
      event.setLayout("m.buildingvine.com/#rc.layoutPath#/Layout.Main");
      rc.viewPath = "mobile/secure/";
      rc.cExpiry = 30;
      rc.mobile = true;
    } else if (ListFirst(cgi.HTTP_HOST,".") eq "x") {
      if (rc.isAjax) {
        event.setLayout("Layout.ajax");
      } else {
        event.setLayout("x.buildingvine.com/Layout.Main");
      }
      rc.viewPath = "web/";
      rc.cExpiry = 1;
      rc.mobile = false;
    } else if (ListFirst(cgi.HTTP_HOST,".") eq "connect") {
      if (rc.isAjax) {
        event.setLayout("Layout.ajax");
      } else {
        event.setLayout("connect.buildingvine.com/Layout.Main");
      }
      rc.viewPath = "web/";
      rc.cExpiry = 1;
    } else if (ListGetAt(rc.host,2,".") neq "buildingvine") {
    	rc.buildingVine.siteID = ListGetAt(rc.host,2,".");
      if (rc.isAjax) {
        event.setLayout("Layout.ajax");
      } else {
        if (fileExists("/fs/sites/ebiz/www.buildingvine.com/web/layouts/#rc.host#/Layout.Main.cfm")) {
          event.setLayout("#rc.host#/Layout.Main");
        } else {
        	event.setLayout("www.buildingvine.com/secure/Layout.Main");
        }
      }
    } else {
      if (rc.isAjax) {
        event.setLayout("Layout.ajax");
      } else {
        event.setLayout("www.buildingvine.com/secure/Layout.Main");
      }
      rc.cExpiry = 1;
    }

    if (clusterUser neq "") {
      if (getAuthUser() eq "") {
      	logger.debug("Not authorised");
        // they've been timed out
        if (isValid("email",clusterUser)) {
          rc.buildingVine = UserService.logUserIn(rc.buildingVine.username,rc.buildingVine.password);
        } else {
        // reget the user struct
          rc.buildingVine = UserStorage.getVar("buildingVine");
        }
      }
    	if (changeSiteID) {
    		if (isUserLoggedIn()) {
    		 rc.buildingVine.siteID = rc.siteID;
    	   UserStorage.setVar("buildingVine",rc.buildingVine);
    	  }

    	}
      rc.siteID = rc.buildingVine.siteID;
      request.siteID = rc.siteID;
      logger.debug(arrayLen(rc.buildingVine.sitesManaged));
      logger.debug(rc.siteID);
      if (arrayLen(rc.buildingVine.sitesManaged) gt 0 AND arrayFind(rc.buildingVine.sitesManaged,rc.siteID)) {
        rc.siteManager = true;
        rc.cacheKey = createUUID();
      }
      CookieStorage.setVar("clusterUser",rc.buildingVine.username,DateAdd("n",20,now()));
    } else {
    	rc.cluserUser = false;
    }
    if (getAuthUser() neq "" AND (clusterUser eq "" OR NOT isDefined("rc.buildingVine.userProfile.firstName"))) {
    	  rc.buildingVine = UserService.logUserIn(ListFirst(getAuthUser(),"|"),ListLast(getAuthUser(),"|"));
    	  UserStorage.setVar("buildingVine",rc.buildingVine);
    	  GetPageContext().getResponse().setHeader("expires","#GetHttpTimeString(now())#");
        GetPageContext().getResponse().setHeader("cache-control","no-cache");
        CookieStorage.setVar("clusterUser",rc.buildingVine.username,DateAdd("n",20,now()));
    }
    try {
    rc.buildingVine.siteID = request.siteID;
    rc.buildingVine.siteDB = siteService.siteDB(request.siteID);
    rc.buildingVine.site = siteService.getSite(request.siteID);
    request.buildingVine = rc.buildingVine;
    } catch (any e) {
      doNotCache();
    }
  }
  void function preEvent(required any event) {
  	var rc = event.getCollection();
  	if (event.getCurrentHandler() neq "api") {
	    rc.leftMenu = "menu";
	    rc.page = event.getValue("page",1);
	  }
  }
  </cfscript>
  <cffunction name="doNotCache" returntype="void">
    <cfheader name="expires" value="#now()#">
    <cfheader name="pragma" value="no-cache">
    <cfheader name="cache-control" value="no-cache, no-store, must-revalidate">
  </cffunction>
</cfcomponent>