<cfcomponent>
  <cfproperty name="feed" inject="id:bv.FeedService">
  <cfproperty name="SiteService" inject="id:bv.SiteService">
  <cffunction name="index" access="public" returntype="void" output="false">
    <cfargument name="event" type="any">
    <cfset var rc = event.getCollection()>
    <cfset rc.siteFilter = event.getValue("siteFilter","")>	  
	  <cfset rc.typeFilter = event.getValue("typeFilter","")>    
    <cfset rc.boundaries = rc.paging.getBoundaries(15)>
	  <cfset rc.SiteService = SiteService>
    <cfset rc.feed = feed.getFeed(rc.siteFilter,rc.typeFilter)>
    <cfset event.setView("web/feed/index")>
  </cffunction>
  <cffunction name="email" access="public" returntype="void" output="false">
    <cfargument name="event" type="any">
    <cfset var rc = event.getCollection()>    
    <cfset rc.feed = feed.getActivityFeedDB()>
    <cfset event.setView("web/feed/email/index")>
  </cffunction>
</cfcomponent>