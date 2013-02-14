<cfcomponent name="eGroupCache" extends="coldbox.system.interceptor">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="contact" inject="model:contact">
  <cfproperty name="groupService" inject="model:groupService">
  <cfproperty name="tagService" inject="model:tag">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="pingdom" inject="model:pingdom.pingdom">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">
  <cffunction name="OnRequestCapture" returntype="void">
    <cfargument name="event">
    <cfargument name="interceptData">
    <cfscript>
    var rc = arguments.event.getCollection();
    var prc = arguments.event.getCollection( private=true );
    var secureLogin = CookieStorage.getVar("clusterUser","");
    var eGroup = UserStorage.getVar("eGroup");
    var fullPurge = arguments.event.getValue("fullPurge",false);
    var httpData = getHTTPRequestData();
    rc.isAjax = structKeyExists(httpData.headers, 'X-Requested-With')
    && httpData.headers['X-Requested-With'] == 'XMLHttpRequest';
    if (rc.isAjax) {
      arguments.event.setLayout('Layout.ajax');
    } else {
      arguments.event.setLayout('Layout.Main');
    }

    </cfscript>
  </cffunction>

  <cffunction name="login" returntype="void">
    <cfargument name="username">
    <cfargument name="password">
    <cfargument name="roles">
    <cflogin>
      <cfloginuser name="#arguments.username#" password="#arguments.password#" roles="#arguments.roles#">
    </cflogin>
  </cffunction>
</cfcomponent>