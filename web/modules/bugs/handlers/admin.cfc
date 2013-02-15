<cfcomponent name="admin" cache="false" cachetimeout="50">

  <cfproperty name="automaton" inject="model:automaton" scope="instance" />
  <cffunction name="index">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.adminObj = createObject("component","cfide.appdeployment.AppDeployer")>
    <cfdump var="#rc.adminObj#">
    <cfabort>
  </cffunction>
</cfcomponent>