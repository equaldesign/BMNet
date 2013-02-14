<cfcomponent outut="false" hint="The bvine module service layer" cache="true">

	<!--- Dependencies --->

	<cfproperty name="userService" inject="model:UserService"  scope="instance" />

	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>


	<!--- getParentListing --->


	<cffunction name="getComments" access="public" returntype="any" output="false">
    <cfargument name="commentURL" required="true" type="string">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api#commentURL#?alf_ticket=#ticket#" result="nodeComments"></cfhttp>
    <cfset comments = DeSerializeJSON(nodeComments.fileContent)>
    <cfreturn comments>
  </cffunction>

  <cffunction name="addComment" access="public" returntype="any" output="false">
    <cfargument name="commentURL" required="true" type="string">
    <cfargument name="title">
    <cfargument name="content">
    <cfset var ticket = request.user_ticket>
    <cfset js = StructNew()>
    <cfset js["title"] = title>
    <cfset js["content"] = content>

    <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/api#commentURL#?alf_ticket=#ticket#" result="nodeComments">
      <cfhttpparam type="header" name="content-type" value="application/json">
      <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
    </cfhttp>
    <cfset comments = DeSerializeJSON(nodeComments.fileContent)>
    <cfreturn comments>
  </cffunction>

  <cffunction name="deleteComment" access="public" returntype="void" output="false">
    <cfargument name="commentURL" required="true" type="string">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" method="delete" url="http://46.51.188.170/alfresco/service/#commentURL#?alf_ticket=#ticket#" result="nodeComments">

    </cfhttp>
  </cffunction>
</cfcomponent>
