<cfcomponent name="favouritesService" output="true" cache="true" cacheTimeout="30" autowire="true">
  <!--- Dependencies --->
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfscript>
  		instance = structnew();
  	</cfscript>

  <cffunction name="add" returnType="void">
    <cfargument name="companyID" required="true">
    <cfargument name="datasource" default="">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var contactID = eGroup.contactID>
    <cfset var inser = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfif NOT isFavourite(companyID)>
      <cfquery name="inser" datasource="#arguments.datasource#">
  				insert into contactFavourite
  				(contactID,companyID)
  				VALUES
  				(
  					<cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">,
  					<cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
  				)
  			</cfquery>
    </cfif>
  </cffunction>

  <cffunction name="delete" returnType="void">
    <cfargument name="companyID" required="true">
    <cfargument name="datasource" default="">
    <cfset var inser = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var contactID = eGroup.contactID>
    <cfif isFavourite(companyID)>
      <cfquery name="inser" datasource="#arguments.datasource#">
  					delete from contactFavourite
  					where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
  					AND companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
  				</cfquery>
    </cfif>
  </cffunction>

  <cffunction name="get" returnType="query">
    <cfargument name="contactID" required="true" default="0">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var favs = "">
    <cfif arguments.contactID eq 0>
      <cfset arguments.contactID = eGroup.contactID>
    </cfif>
    <cfquery name="favs" datasource="#dsnRead.getName()#">
  				select company.*
  					from
  				contactFavourite,
  				company
  				where contactFavourite.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
  				AND
  				company.id = contactFavourite.companyID
  				order by known_as asc;
  			</cfquery>
    <cfreturn favs>
  </cffunction>

  <cffunction name="isFavourite" returnType="boolean">
  <cfargument name="companyID" required="true">
  <cfset var eGroup = UserStorage.getVar("eGroup")>
  <cfset var contactID = eGroup.contactID>
  <cfset var isFav = "">
  <cfquery name="isFav" datasource="#dsn.getName()#">
			select
				id
			from
				contactFavourite
			where
				contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
					AND
				companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
		</cfquery>
  <cfif isFav.recordCount eq 0>
    <cfreturn false>
    <cfelse>
    <cfreturn true>
  </cfif>
</cffunction>
</cfcomponent>