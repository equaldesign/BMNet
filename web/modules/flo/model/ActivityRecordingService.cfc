<cfcomponent name="activityRecordingService" cache="true">
  <cfproperty name="dsn" inject="coldbox:datasource:flo" />
  <cffunction name="startTracking" returntype="numeric">
    <cfargument name="activityID">
    <cfquery name="s" datasource="#dsn.getName()#">
      insert into
      itemActivityWorklog (activityID,startTS)
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activityID#">,
        <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
      ) 
    </cfquery>
    <cfquery name="worklog" datasource="#dsn.getName()#">
      select LAST_INSERT_ID() as newID from itemActivityWorklog;
    </cfquery>
    <cfreturn worklog.newID>
  </cffunction>
  <cffunction name="stopTracking" returntype="void">
    <cfargument name="worklogID">
    <cfquery name="s" datasource="#dsn.getName()#">
      update
        itemActivityWorklog 
      set
        endTS = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
      where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.worklogID#">
      
    </cfquery>
  </cffunction>
  
  <cffunction name="getActiveWorklog" returntype="query">
    <cfargument name="activityID">
    <cfquery name="s" datasource="#dsn.getName()#">
      select id, startTS
      from
        itemActivityWorklog
      where
        activityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activityID#">
      AND
        endTS is null
    </cfquery>
    <cfreturn s>  
  </cffunction>
  
  <cffunction name="getRunningItems" returntype="query">    
    <cfquery name="tasks" datasource="#dsn.getName()#">
      SELECT
        item.id,
        item.name,
        item.description,
        itemActivity.name as activityName,
        TIME_TO_SEC(TIMEDIFF(now(), startTS))/3600 as running
      FROM
        item,
        itemActivity,
        itemActivityWorklog
      WHERE
        itemActivityWorklog.endTS is null
        AND
        
        item.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">        
        AND
        itemActivity.id = itemActivityWorklog.activityID
        AND
        item.id = itemActivity.itemID
    </cfquery>
    <cfreturn tasks>
  </cffunction>
  
</cfcomponent>