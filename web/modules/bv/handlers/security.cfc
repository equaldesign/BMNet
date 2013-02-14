
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="securityService" inject="id:bv.SecurityService">
  <!--- preHandler --->
 
  <!--- index --->
  <cffunction name="index" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
        event.setView("secure/sales/overview");

    </cfscript>
  </cffunction>

  <cffunction name="getSecurity" returntype="void" output="false" cache="true">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.node = event.getValue("node","")>
    <cfset rc.security = securityService.getPermissions(rc.node)>
    <cfset rc.members = siteService.getMembership(rc.siteID)>
    <cfset event.setLayout("Layout.ajax")>
    <cfset event.setView("web/security/display")>
  </cffunction>

  <cffunction name="setPermission" returntype="void" output="false" cache="true">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.user = event.getValue("user","")>
    <cfset rc.security = securityService.setPermission(rc.nodeRef,rc.user)>
    <cfset event.setLayout("Layout.ajax")>
    <cfset event.setView("blank")>
  </cffunction>
</cfcomponent>