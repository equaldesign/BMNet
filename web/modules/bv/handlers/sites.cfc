
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <cfproperty name="siteService" inject="id:bv.SiteService">

  <!--- preHandler --->

  <!--- index --->
  <cffunction name="index" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.filter = event.getValue("f","");
      rc.siteList = siteService.siteList(rc.filter);
      event.setView("secure/sites/list");
    </cfscript>
  </cffunction>
  <cffunction name="switch" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.sess.siteID = lcase(rc.siteID);
      rc.sess.defaultSite = siteService.siteDB(rc.sess.siteID);
      setNextEvent(uri="/bv/products");
    </cfscript>
  </cffunction>
 <cffunction name="importPrices" returntype="void" output="false">
	<cfargument name="event" required="true">
	<cfset var rc = event.getCollection()>
  <cfset rc.siteList = userService.listSites(rc.sess.profileEmail)>
  <cfset rc.siteMembers = siteService.getMembership(rc.siteID)>
  <cfset event.setView("secure/tools/priceImport")>

</cffunction>
</cfcomponent>