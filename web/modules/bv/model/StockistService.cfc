<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
  <cfproperty name="BranchService" inject="id:eunify.BranchService">
  
  <cffunction name="search" returntype="query" output="false">
    <cfargument name="siteID" required="true">
    <cfargument name="postcode" required="true">
    <cfset coOrdinates = BranchService.getGenericCoOrdinates(arguments.postcode)>
    <cfquery name="results" datasource="bvine">
      SELECT
        *,
        (3959 * acos( cos( radians('#coOrdinates[1]#') ) * cos( radians( branchLat ) ) * cos( radians( branchLong ) - radians('#coOrdinates[2]#') ) + sin( radians('#coOrdinates[1]#') ) * sin( radians( branchLat ) ) ) ) AS distance
      FROM
        stockistLocator
        where
        bvsiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
        HAVING
        distance < 20 ORDER BY distance LIMIT 0 , 20;
    </cfquery>
     
    <cfreturn results>
  </cffunction>

  
</cfcomponent> 