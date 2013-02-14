<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">


  <!--- injected properties --->
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />

  <!--- methods --->


  <cffunction name="getsite" returntype="query">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="s" datasource="#dsn.getName()#">
      select site.*
      from
      site
        WHERE
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
    </cfquery>
    <cfreturn s>
  </cffunction>

  <cffunction name="getHost" returntype="query">
    <cfquery name="s" datasource="#dsn.getName()#">
      select *
      from
      site
        WHERE
        host RLIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="(^|,)#cgi.http_host#($|,)">
    </cfquery>
    <cfreturn s>
  </cffunction> 

  <cffunction name="getcompanyByEgroup" returntype="query">
    <cfargument name="id" required="true" default="">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="s" datasource="#dsn.getName()#">
      select company.*, companyType.name as typeName
      from
      company,
      companyType
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
        AND
        eGroup_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        companyType.type_id = company.type_id
    </cfquery>
    <cfreturn s>
  </cffunction>
</cfcomponent>