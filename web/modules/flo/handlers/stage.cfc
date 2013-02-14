<cfcomponent>
  <cfproperty name="tasks" inject="id:flo.TaskService">
  <cfproperty name="relationship" inject="id:flo.RelationshipService">
  <cffunction name="index" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.relationship = relationship>
    <cfset rc.myTasks = event.getValue("myTasks","false")>
    <cfset rc.listType = event.getValue("type","sale")>
    <cfset rc.system = event.getValue("system","BMNet")>
    <cfset rc.myTasks = event.getValue("MyTasks","false")>
    <cfset rc.tasks = tasks>
    <cfset rc.stages = tasks.getStages(rc.listType)>
    <cfset event.setView("sales/index")>
  </cffunction>
  <cffunction name="getStageTotal" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.stageTotal = tasks.getStageTotal(rc.stageID)>
    <cfset event.renderData("JSON",rc.stageTotal)>
  </cffunction>
</cfcomponent>