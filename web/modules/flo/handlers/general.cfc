<cfcomponent output="false"  cache="true">

  <cfproperty name="tasks" inject="id:flo.TaskService">
  <cfproperty name="relationship" inject="id:flo.RelationshipService">

	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
    <cfset rc.system = event.getValue("system","BMNet")>
		<cfset event.setView(view="index")>
	</cffunction>
  <cffunction name="myTasks" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.system = event.getValue("system","BMNet")>
    <cfset rc.db = event.getValue("system","BMNet")>
    <cfset rc.status = event.getValue("status","active")>
    <cfset rc.type = event.getValue("type","")>
    <cfset rc.stage = event.getValue("stage","")>
    <cfset rc.tasks = tasks.getMyTasks(type="#rc.type#",modle="#rc.system#",stage="#rc.stage#")>
    <cfset event.setView(view="sales/tasks",noLayout="true")>
  </cffunction>
	</cfcomponent>