<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />



  <cffunction name="list" returntype="query" output="false">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfset var columnArray = ["account_number","name","address_1","address_2","post_code","telephone_1"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfquery name="l" datasource="#dsn.getName()#">
      select
        account_number,
        name,
        address_1,
        address_2,
        post_code,
        telephone_1
      from
        Supplier
        <cfif arguments.searchQuery neq "">
        WHERE
        (
        name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        address_1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        account_number like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        post_code like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
        </cfif>
        order by #sortColName# #arguments.sortDir#
        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="cCount" returntype="Numeric">
    <cfargument name="searchQuery" required="true" default="">
    <cfquery name="s" datasource="#dsn.getName()#">
      select count(account_number) as records
      from
      Supplier
      <cfif arguments.searchQuery neq "">
        WHERE
        (
        name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        address_1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        account_number like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        post_code like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
      </cfif>
    </cfquery>
    <cfreturn s.records>
  </cffunction>

  <cffunction name="getSupplier" returntype="query">
    <cfargument name="id" required="true" default="">
    <cfquery name="s" datasource="#dsn.getName()#">
      select *
      from
      Supplier
        WHERE
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn s>
  </cffunction>


</cfcomponent>