<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">



	<!--- Dependencies --->
  <cfproperty name="bvAddress" inject="coldbox:setting:bvAddress">
	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="userService" inject="model:UserService" />
  <cfproperty name="documentService" inject="model:DocumentService" />

	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="getAllEvents" output="false" access="public" returntype="struct" hint="Constructor">
    <cfargument name="siteID">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/calendar/events/#lcase(siteID)#/user?alf_ticket=#ticket#" method="get" result="c"></cfhttp>
    <cfreturn DeSerializeJSON(c.fileContent)>
  </cffunction>

  <cffunction name="getTask" output="false" access="public" returntype="struct" hint="Constructor">
    <cfargument name="taskID">
    <cfargument name="transitionID">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/task-instances/#taskID#?includeTasks=true&alf_ticket=#ticket#" method="get" result="t"></cfhttp>
    <cfset retOb = {}>
    <cfset retOb.task = DeSerializeJSON(t.fileContent)>
    <cfreturn getWorkflowInstance(retOb.task.data.workflowInstance.id)>
  </cffunction>

  <cffunction name="getUserTasks" returntype="struct">
      <cfargument name="filter" required="true" default="all">
      <cfset var ticket = UserStorage.getVar("alf_ticket")>
      <cfset var email = UserStorage.getVar("username")>
      <cfset var retStruct = []>
      <cfhttp port="8080" result="userTasks" method="get" url="http://46.51.188.170/alfresco/service/slingshot/dashlets/my-tasks?filter=#filter#&alf_ticket=#ticket#"></cfhttp>
      <cfset userTasks = DeSerializeJSON(userTasks.fileContent)>
      <cfreturn userTasks>
  </cffunction>

</cfcomponent>