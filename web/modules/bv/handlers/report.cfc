<cfcomponent name="report">
  <cfproperty name="ReportService" inject="id:bv.ReportService" />
  <cffunction name="index" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset ReportService.monthly()>
  </cffunction>
</cfcomponent>