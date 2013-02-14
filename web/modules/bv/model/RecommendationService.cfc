<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">  
  <cfproperty name="dsn" inject="coldbox:datasource:easyRec" />
  <cffunction name="getViews" returntype="numeric">
    <cfargument name="nodeRef" required="true">
    <cfargument name="itemType" required="true" default="PRODUCT">
    <cfargument name="since" required="true" default="2013-01-01">
    <cfquery name="c" datasource="#dsn.getName()#" cachedwithin="#createTimeSpan(1, 0, 0, 0)#">
      select 
        count(action.id) as views 
      from 
        action, 
        idmapping
      where 
        idmapping.stringId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nodeRef#">
      AND      
        action.itemId = idmapping.intId
      AND
        action.actionTime > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.since#">
    </cfquery>
    <cfreturn c.views>
  </cffunction>
</cfcomponent>