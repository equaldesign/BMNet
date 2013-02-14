<cfcomponent name="formbuilder" accessors="true" output="true" cache="true" cacheTimeout="0" autowire="true">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />

  <cffunction name="editValue" returntype="void">
    <cfargument name="table" required="true" />
    <cfargument name="field" required="true" />
    <cfargument name="id" required="true" />
    <cfargument name="value" required="true" />
    <cfquery name="e" datasource="#dsn.getName()#">
      update #arguments.table#
      set #arguments.field# = '#arguments.value#'
      where
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
  </cffunction>

  <cffunction name="addOption" returntype="numeric">
    <cfargument name="table" required="true" />
    <cfargument name="rel" required="true" />
    <cfargument name="id" required="true" />
    <cfargument name="value" required="true" />
    <cfquery name="maxOrder" datasource="#dsn.getName(true)#">
      SELECT max(_order)+1 as maxOrder from #arguments.table# where #arguments.rel# = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfif maxOrder.maxOrder eq "">
      <cfset maxOrderNum = 1>
    <cfelse>
      <cfset maxOrderNum = maxOrder.maxOrder>
    </cfif>
    <cfquery name="e" datasource="#dsn.getName()#">
      INSERT into #arguments.table# (#arguments.rel#,label,_order)
      VALUES (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.value#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#maxOrderNum#">
      )
    </cfquery>
    <cfquery name="v" datasource="#dsn.getName()#">
      select LAST_INSERT_ID() as id from #arguments.table#
    </cfquery>
    <cfreturn v.id>
  </cffunction>

  <cffunction name="addField" returntype="numeric">
    <cfargument name="table" required="true" />
    <cfargument name="label" required="true" />
    <cfargument name="name" required="true" />
    <cfargument name="type" required="true" />
    <cfargument name="rel" required="true" />
    <cfargument name="requireIt" required="true" />
    <cfargument name="encryptIt" required="true" />
    <cfargument name="requirenumeric" required="true" />
    <cfargument name="id" required="true" />
    <cfargument name="increments" required="true" default="1" />
    <cfargument name="maxvalue" required="true" default="999999999" />
    <cfquery name="maxOrder" datasource="#dsn.getName()#">
      SELECT max(_order)+1 as maxOrder from #arguments.table# where #arguments.rel# = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfif maxOrder.maxOrder eq "">
      <cfset maxOrderNum = 1>
    <cfelse>
      <cfset maxOrderNum = maxOrder.maxOrder>
    </cfif>
    <cfquery name="e" datasource="#dsn.getName()#">
      INSERT into #arguments.table# (#arguments.rel#,label,name,_required,encrypt,_type,_order,requirenumeric,_increments,_max)
      VALUES (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.label#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requireIt#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.encryptIt#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#maxOrderNum#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.requirenumeric#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.increments#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.maxvalue#">
      )
    </cfquery>
    <cfquery name="v" datasource="#dsn.getName()#">
      select LAST_INSERT_ID() as id from #arguments.table#
    </cfquery>
    <cfreturn v.id>
  </cffunction>

  <cffunction name="addGroup" returntype="numeric">
    <cfargument name="table" required="true" />
    <cfargument name="name" required="true" />
    <cfargument name="id" required="true" />
    <cfargument name="description" required="true" />
    <cfargument name="rel" required="true" />
    <cfquery name="maxOrder" datasource="#dsn.getName()#">
      SELECT max(_order)+1 as maxOrder from #arguments.table# where #arguments.rel# = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfif maxOrder.maxOrder eq "">
      <cfset maxOrderNum = 1>
    <cfelse>
      <cfset maxOrderNum = maxOrder.maxOrder>
    </cfif>
    <cfquery name="e" datasource="#dsn.getName()#">
      INSERT into #arguments.table# (#arguments.rel#,name,description,_order)
      VALUES (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#maxOrderNum#">
      )
    </cfquery>
    <cfquery name="v" datasource="#dsn.getName()#">
      select LAST_INSERT_ID() as id from #arguments.table#
    </cfquery>
    <cfreturn v.id>
  </cffunction>

  <cffunction name="move" returntype="void">
    <cfargument name="data" required="true" type="struct" />
    <cfloop from="1" to="#ArrayLen(data.items)#" index="i">
      <cfquery name="e" datasource="#dsn.getName()#">
        update #data.table#
        set _order = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#data.items[i]#">
      </cfquery>
    </cfloop>
  </cffunction>
  <cffunction name="delete" returntype="void">
    <cfargument name="table" required="true" type="string" />
    <cfargument name="id" required="true" type="numeric" />

      <cfquery name="e" datasource="#dsn.getName()#">
        delete from #arguments.table#
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
      </cfquery>
  </cffunction>
</cfcomponent>