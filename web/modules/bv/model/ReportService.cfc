<cfcomponent name="reportingService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="blogService" inject="id:bv.BlogService">
  <cffunction name="monthly" returntype="void">
    <!--- firstly, fix the blogs --->
    <cfquery name="blogs" datasource="bvine">
      select 
        * 
      from 
        visitorLog
      where 
        siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value=""> 
      AND 
        itemType = <cfqueryparam cfsqltype="cf_sql_varchar" value="BLOG">
      GROUP BY nodeRef
    </cfquery>  
    <cfloop query="blogs">
      <cftry>
        
      
      <cfset blogPost = blogService.getPost("blog/post/node/#replace(nodeRef,":/","")#","")>      
      <cfset shortName = ListLast(listGetAt(blogPost.qnamePath,3,"/"),":")>
      <cfquery name="u" datasource="bvine">
        update 
          visitorLog
        set
          tstamp = tstamp,
          siteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">
        where 
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      </cfquery>      
      <cfcatch type="any"></cfcatch>
      </cftry>
    </cfloop>
    <cfquery name="records" datasource="bvine">
      select 
        *,
        count(*) as hits 
      from 
        visitorLog
      where 
        siteID != ''
        AND
        tstamp BETWEEN <cfqueryparam  cfsqltype="cf_sql_date" value="#dateAdd("d", -31, now())#">
        AND
        <cfqueryparam  cfsqltype="cf_sql_date" value="#now()#">
      GROUP BY nodeRef
      ORDER BY
        siteID, itemType      
    </cfquery>
    <cfdump var="#records#"><cfabort>
  </cffunction>
</cfcomponent>