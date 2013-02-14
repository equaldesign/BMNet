<cfcomponent outut="false" hint="The bvine module service layer" cache="true">

	<!--- Dependencies --->

	<cfproperty name="userService" inject="model:UserService"  scope="instance" />

	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="search" access="public" returntype="any" output="false">
	    <cfargument name="query" required="true" type="string" default="">
      <cfargument name="siteID" required="true" type="string" default="">
	    <cfargument name="container" required="true" type="string" default="">
      <cfargument name="startRow" required="true" type="numeric" default="1">
      <cfargument name="maxrow" required="true" type="numeric" default="10">
	    <cfset var ticket = request.user_ticket>
	    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/search/documents.json?term=#query#&site=#siteID#&container=#container#&maxrows=#maxRow#&startRow=#startRow#&alf_ticket=#ticket#" result="searchResult">
	    <cfreturn DeserializeJSON(searchResult.fileContent)>
  	</cffunction>

  <cffunction name="company" access="public" returntype="Any" output="false">
    <cfargument name="query" required="true" type="string" >
    <cfargument name="siteID" required="true" type="string" default="" >
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <!--- RC Reference --->
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/search/company?q=#query#&siteID=#lcase(siteID)#&maxrows=#maxRow#&startRow=#startRow#&alf_ticket=#ticket#" result="companies"></cfhttp>
    <cftry>
    <cfreturn DeserializeJSON(companies.fileContent)>
    <cfcatch type="any">
    <cfreturn companies.fileContent>
    </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="contact" access="public" returntype="Any" output="false">
    <cfargument name="query" required="true" type="string" >
    <!--- RC Reference --->
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/people?filter=#query#&alf_ticket=#ticket#" result="companies"></cfhttp>
    <cftry>
    <cfreturn DeserializeJSON(companies.fileContent)>
    <cfcatch type="any">
    <cfreturn companies.fileContent>
    </cfcatch>
    </cftry>
  </cffunction>
</cfcomponent>

<!---

http://46.51.188.170/alfresco/service/bvine/search/documents.json?term=test

--->