<cfcomponent name="voting">
  <cfproperty name="VoteService" inject="id:bv.VoteService">
  <cffunction name="index" returnType="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.siteList = VoteService.listSites()>
    <cfset rc.showMenu = false>
    <cfset event.setView("web/vote/list")>
  </cffunction>
</cfcomponent>