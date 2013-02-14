<cfcomponent cache="true" cacheTimeout="0" autowire="true">
	<cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
	<cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />

	<cffunction name="getTags" returntype="query">
		<cfargument name="relationShip" required="true">
		<cfargument name="id" required="true">
		<cfquery name="tags" datasource="#dsnRead.getName()#">
			select * from tag where relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relationShip#">
			AND
			relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
       AND
       siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
		</cfquery>
		<cfreturn tags>
	</cffunction>

  <cffunction name="hasTag" returntype="boolean">
    <cfargument name="relationShip" required="true">
    <cfargument name="id" required="true">
    <cfargument name="tag" required="true">
    <cfquery name="tags" datasource="#dsnRead.getName()#">
      select * from tag where relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relationShip#">
      AND
      tag = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#">
      AND
      relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
       AND
       siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfif tags.recordCount eq 0>
      <cfreturn false>
    <cfelse>
      <cfreturn true>
    </cfif>
    <cfreturn tags>
  </cffunction>

	<cffunction name="add" returntype="void">
		<cfargument name="tags" required="true">
		<cfargument name="relationship" required="true">
		<cfargument name="id" required="true">
		<cfloop list="#arguments.tags#" index="thistag">
			<cfif thistag neq "">
        <cfif NOT hasTag(relationship,id,thistag)>                  
  				<cfquery name="tags" datasource="#dsn.getName()#">
  		      insert into tag (tag,relatedType,relatedID,siteID)
  			  VALUES
  			   (<cfqueryparam cfsqltype="cf_sql_varchar" value="#thistag#">,
  			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relationship#">,
  				  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">)
  		    </cfquery>
        </cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="filter" returntype="query">
    <cfargument name="tag" required="true">
    <cfargument name="relationship" required="true">
    <cfargument name="clause" required="true" default="IN">
    <cfquery name="tags" datasource="#dsnRead.getName()#">
       select
	       #relationship#.*
		   from
		    tag
		      LEFT JOIN #relationship#
		        on
				      (tag.relatedID = #relationship#.id )
				  LEFT JOIN dmsSecurity
				    on (#relationship#.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = '#relationship#')
         WHERE
          tag.relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relationship#">
		     AND
			     tag.tag #arguments.clause# (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tag#" list="true">)
		     AND
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
        group by #relationship#.id
    </cfquery>
    <cfreturn tags>
  </cffunction>

	<cffunction name="delete" returntype="void">
    <cfargument name="id" required="true">
    <cfquery name="d" datasource="#dsn.getName()#">
      delete from tag where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
  </cffunction>

	<cffunction name="search" returntype="query">
    <cfargument name="q" required="true">
    <cfquery name="tags" datasource="#dsnRead.getName()#">
      select
	     tag from tag where tag LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.q#%">
       AND
       siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn tags>
  </cffunction>
</cfcomponent>