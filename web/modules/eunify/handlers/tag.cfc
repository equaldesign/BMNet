<cfcomponent name="tagHandler" cache="true" cacheTimeout="30" output="false">
  <!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
  <!--- Default Action --->

  <cfproperty name="tag" inject="id:eunify.TagService" />


  <cffunction name="delete" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
	  <cfset var rc = event.getCollection()>
	  <cfset rc.id = event.getValue("id",0)>
	  <cfset tag.delete(rc.id)>
	  <cfset event.setView("blank")>
  </cffunction>

  <cffunction name="filter" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.tag = event.getValue("tag",0)>
	  <cfset rc.relationship = event.getValue("relationship","contact")>
    <cfset rc.clause = event.getValue("clause","IN")>
	  <cfset rc.results = tag.filter(rc.tag,rc.relationship,rc.clause)>
    <cfset event.setView("tags/filter/#rc.relationship#")>
  </cffunction>

    <!------------------------------------------- PRIVATE EVENTS ------------------------------------------>
</cfcomponent>

