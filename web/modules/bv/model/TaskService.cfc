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

	<cffunction name="getWorkflowInstance" output="false" access="public" returntype="struct" hint="Constructor">
    <cfargument name="taskID">
    <cfargument name="transitionID">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/workflow-instances/#taskID#?includeTasks=true&alf_ticket=#ticket#" method="get" result="t"></cfhttp>
    <cfset retOb = {}>
    <cfset retOb.task = DeSerializeJSON(t.fileContent)>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/node?nr=#retOb.task.data.package#&alf_ticket=#ticket#" result="n"></cfhttp>
    <cfset retOb.taskRelated = []>
    <cfset taskChildren = DeSerializeJSON(n.fileContent)>
    <cfloop array="#taskChildren#" index="chd">
      <cfswitch expression="#chd.nodeType#">
        <cfcase value="cm:content">
          <cfset arrayAppend(retOb.taskRelated,documentService.documentDetail(chd.nodeRef))>
        </cfcase>
      </cfswitch>
    </cfloop>
    <cfreturn retOb>
  </cffunction>

  <cffunction name="getObjectTasks" output="false" access="public" returntype="struct" hint="Constructor">
    <cfargument name="nodeRef">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/node/workspace/SpacesStore/#nodeRef#/workflow-instances?alf_ticket=#ticket#" method="get" result="t"></cfhttp>
    <cfreturn DeSerializeJSON(t.fileContent)>
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