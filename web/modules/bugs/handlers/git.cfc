<cfcomponent output="false" cache="true" cacheTimeout="30" >

  <cfproperty name="bugs" inject="model:BugService" scope="instance" />
  <cfproperty name="dsn" inject="coldbox:datasource:bugs" scope="instance" />
  <cfproperty name="floRelationShipService" inject="id:flo.RelationShipService">
  <cfproperty name="floTaskService" inject="id:flo.TaskService">
  <cfproperty name="pingdom" inject="model:pingdomService">
  <cffunction name="push" returntype="void">
    <cfset var rc = event.getCollection()>
    <cfset rc.gitPayLoad = event.getValue("payload")>
    <cffile action="write" file="/tmp/git.tmp" output="#rc.gitPayLoad#">
    <cfdump var="#DeSerializeJSON(rc.gitPayLoad)#">
    
  </cffunction>
</cfcomponent>