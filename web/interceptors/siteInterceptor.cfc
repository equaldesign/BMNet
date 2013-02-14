<cfcomponent name="siteInterceptor" extends="coldbox.system.interceptor">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cffunction name="OnRequestStart" returntype="void">
    <cfargument name="event">
    <cfargument name="interceptData">
    <cfset var site = "">
    <cfset var siteID = "">
    <cfscript>
      var httpData = getHTTPRequestData();
      var rc = arguments.event.getCollection();
      rc.isAjax = structKeyExists(httpData.headers, 'X-Requested-With')
        && httpData.headers['X-Requested-With'] == 'XMLHttpRequest';
    </cfscript>

  </cffunction>


</cfcomponent>