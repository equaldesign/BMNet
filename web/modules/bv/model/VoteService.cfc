<cfcomponent>
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cffunction name="listSites" returnType="query">
    <cfquery name="siteList" datasource="bvine">
      SELECT
        shortName,
        title,
        (
          select count(id) from siteVote where shortName = site.shortName AND request_productData = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        ) as productVotes,
        (
          select count(id) from siteVote where shortName = site.shortName AND request_priceFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        ) as priceVotes,
        (
          select count(id) from siteVote where shortName = site.shortName AND request_webContent = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        ) as webVotes,
        (
          select count(id) from siteVote where shortName = site.shortName AND request_documentation = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        ) as docVotes,
        (
          select count(id) from siteVote where shortName = site.shortName AND request_healthAndSafety = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        ) as healthVotes,
        (
          select count(id) from siteVote where shortName = site.shortName AND request_promotions = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        ) as promoVotes,
        (
          select count(id) from siteVote where shortName = site.shortName
        ) as votes
      from
        site
      WHERE
      status = <cfqueryparam cfsqltype="cf_sql_varchar" value="vote">
      order by shortName asc
    </cfquery>
    <cfreturn siteList>
  </cffunction>
</cfcomponent>