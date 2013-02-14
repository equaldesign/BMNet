<cfcomponent>
  <cfproperty name="importService" inject="model:importService">
  <cffunction name="index">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset importService.doImport(95,"tuckerfrench")>
  </cffunction>
</cfcomponent>