<cfcomponent displayname="Branch Locator" hint="A branch locator template for eGroup Merchants" cache="true">
  <cffunction name="init">
    <cfreturn this>
  </cffunction>
  <cffunction name="getBranches" returntype="Query">
  	<cfargument name="companyID">
	  <cfargument name="datasource">
	  <cfquery name="branches" datasource="#arguments.datasource#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
	  	select * from branch where company_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companyID#">
	  </cfquery>
	  <cfreturn branches>
  </cffunction>
</cfcomponent>