<cfcomponent accessors="true" output="true" hint="The bvine module service layer" cache="true">

	<!--- Dependencies --->
  <cfproperty name="userService" inject="model:UserService"  scope="instance" />
  <cfproperty name="shoppingService" inject="model:aws.shopping" />
  <cfproperty name="ProductService" inject="model:ProductService" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" scope="instance" />
  <cfproperty name="logger" inject="logbox:root">


  <!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

  <cffunction name="list" returntype="Array">
    <cfargument name="siteID">
    <cfargument name="type">
    <cfset var ticket = request.user_ticket>
    <cfset var appRoot = instance.ApplicationStorage.getVar("appRoot")>
    <cfhttp timeout="90000" port="8080" url="http://46.51.188.170/alfresco/service/bv/promotion/list?siteID=#siteID#&type=#arguments.type#&alf_ticket=#ticket#" result="productList"></cfhttp>
    <cfreturn DeSerializeJSON(productList.fileContent)>
  </cffunction>

  <cffunction name="detail" returntype="Struct">
    <cfargument name="nodeRef">
    <cfset var ticket = request.user_ticket>
    <cfset var appRoot = instance.ApplicationStorage.getVar("appRoot")>
    <cfhttp timeout="90000" port="8080" url="http://46.51.188.170/alfresco/service/bv/promotion?nodeRef=#arguments.nodeRef#&alf_ticket=#ticket#" result="productList"></cfhttp>
    <cfreturn DeSerializeJSON(productList.fileContent)>
  </cffunction>

  <cffunction name="delete" returntype="void">
    <cfargument name="siteID">
    <cfargument name="nodeRef">
    <cfset var ticket = request.user_ticket>
    <cfset var appRoot = instance.ApplicationStorage.getVar("appRoot")>
    <cfhttp method="delete" timeout="90000" port="8080" url="http://46.51.188.170/alfresco/service/bv/promotion?nodeRef=#arguments.nodeRef#&siteID=#siteID#&alf_ticket=#ticket#" result="productList"></cfhttp>
  </cffunction>

</cfcomponent>