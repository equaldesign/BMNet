<cfcomponent>
  
  <cffunction name="openTasks" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>    
    <cfset event.setView("activity/running")> 
  </cffunction>
</cfcomponent>