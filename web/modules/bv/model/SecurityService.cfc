<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">

  <cfproperty name="logger" inject="logbox:root" />
	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage"  scope="instance" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage"  scope="instance" />
  <cfproperty name="bvAddress" inject="coldbox:setting:bvAddress">
  <cfproperty name="userService" inject="model:UserService"  scope="instance" />
	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

  <cffunction name="getPermissions" access="public" returntype="struct" output="false">
    <cfargument name="node">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/slingshot/doclib/permissions/#replace(node,':/','')#?alf_ticket=#ticket#" result="nodeSecurity"></cfhttp>
    <cfreturn DeSerializeJSON(nodeSecurity.fileCOntent)>
  </cffunction>

  <cffunction name="setPermission" access="public" returntype="struct" output="false">
    <cfargument name="node">
    <cfargument name="user">
    <cfset var ticket = request.user_ticket>
    <cfset js = {}>
    <cfset js["authority"] = user>
    <cfset js["isInherited"] = true>
    <cfset js["permissions"] = ["SiteConsumer"]>

    <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/slingshot/doclib/permissions/#node#?alf_ticket=#ticket#" result="nodeSecurity">
      <cfhttpparam type="header" name="content-type" value="application/json">
      <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
    </cfhttp>
    <cfreturn DeSerializeJSON(nodeSecurity.fileCOntent)>
  </cffunction>
</cfcomponent>