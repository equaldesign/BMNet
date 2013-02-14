<cfcomponent outut="false" hint="The bvine module service layer" cache="true">
  <cffunction name="getMappings" returntype="query" output="false">
	  <cfargument name="siteID" required="true" default="">
    <cfargument name="objectList" required="true" default="[]" type="array">
	  <cfquery name="Mappings" datasource="bvine">
      select id, object, fieldName, site, max(mapsTo) as mapsTo from fieldDefinitions where site IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="master,#siteID#" list="true">)
      AND object IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#ArrayToList(objectList)#" list="true">)
      group by fieldName order by fieldName asc;
    </cfquery>
    <cfreturn Mappings>
  </cffunction>
</cfcomponent>