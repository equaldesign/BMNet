<cfcomponent name="promotions" accessors="true"  output="true" cache="true" cacheTimeout="0" autowire="true">


<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
<cfproperty name="dms" inject="id:eunify.DocumentService" />
<cfproperty name="company" inject="id:eunify.CompanyService" />
<cfproperty name="PromotionService" inject="id:bv.PromotionService" />

<cfproperty name="platform" inject="coldbox:setting:platform" />
<cfscript>
instance = structnew();
</cfscript>

  <cffunction cache="true" name="getCompanyPromotions" returntype="struct" access="public">
    <cfargument name="companyID" required="true" default="dmsCategory.id, dmsDocument.id">
    <cfset var eGroup = request.eGroup>
    <cfset var buildingVine = request.buildingVine>
    <cfset var promos = {}>
    <cfset promos.eGroup = dms.getRelatedCategory("company",arguments.companyID,"promotions",true)>

    <cfif buildingVine.user_ticket neq "">
      <cftry>
      <cfif company.getCompany(arguments.companyID,request.siteID).buildingVine>

        <cfset promos.buildingVine = PromotionService.list(company.getCompany(arguments.companyID).bvsiteid,"current")>

      </cfif>
        <cfcatch type="any"></cfcatch>
        </cftry>
    </cfif>
    <cfreturn promos>
  </cffunction>

  <cffunction cache="true" name="createCompanyPromotionFolder" returntype="numeric" access="public">
    <cfargument name="companyID" required="true" default="dmsCategory.id, dmsDocument.id">
	  <cfset var companyFolder = dms.getCategory(categoryName="Company Documents")>
	  <cfset var thisCompany = dms.getCategoryWithin(companyFolder.id,company.getCompany(arguments.companyID).name)>
	  <cfreturn dms.createDMSCategory("Promotions","","company",arguments.companyID,thisCompany.id)>
  </cffunction>

  <cffunction cache="true" name="getPromotionList" returntype="struct" access="public">
    <cfargument name="orderby" required="true" default="dmsCategory.id, dmsDocument.id">
    <cfset var eGroup = request.eGroup>
    <cfset var buildingVine = UserStorage.getVar("buildingVine")>
    <cfset var promos = {}>
    <cfquery name="getCategoryQ" datasource="#dsn.getName(true)#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
      select
        company.name as companyName,
        company.id as companyID,
        company.known_as,
        dmsCategory.name as categoryName,
        dmsCategory.id as categoryID,
        dmsCategory.description as categoryDescription,
        dmsCategory.validFrom as categoryValidFrom,
        dmsCategory.validTo as categoryValidTo,
        dmsSecurity.priviledge,
        parentCategory.relatedID as relID,
        dmsSecurity.securityAgainst,
        dmsDocument.* from
        dmsCategory,
        dmsCategory as companyCategory,
        company,
        dmsCategory as parentCategory
        LEFT JOIN dmsSecurity on (parentCategory.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="category">),
        dmsDocument LEFT JOIN dmsSecurity as docSecurity on (dmsDocument.id = docSecurity.relatedID AND docSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="document">)
      WHERE
        (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
        AND
        (docSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR docSecurity.priviledge is NULL)
        AND
        parentCategory.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="promotions">
        AND
        dmsCategory.parentID = parentCategory.id
        AND
        (dmsCategory.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
         OR
          (dmsCategory.timeSensitive = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
            AND
            (
              dmsCategory.validFrom <= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
              AND
              dmsCategory.validTo >= <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            )
          )
        )
        AND
        companyCategory.id = parentCategory.parentID
        AND
        company.id = companyCategory.relatedID
        AND
        dmsDocument.categoryID = dmsCategory.id
		<!--- TODO: do we need to group here? --->
        order by #orderby#
    </cfquery>
    <cfset promos.eGroup = getCategoryQ>
    <cfif buildingVine.user_ticket neq "">
        <cfset promos.buildingVine = PromotionService.list("","current")>
    </cfif>
    <cfreturn promos>
  </cffunction>
</cfcomponent>