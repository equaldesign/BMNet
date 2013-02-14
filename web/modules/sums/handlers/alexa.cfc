<cfcomponent name="alexaHandler" cache="true">
  <cfproperty name="alexa" inject="id:aws.Alexa">
  <cffunction name="index" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("admin/alexa/index")>
  </cffunction>
  <cffunction name="info" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.details = {}>
    <cfset rc.host = cgi.HTTP_HOST>
    <cfset rc.details.rank = alexa.UrlInfo(rc.host,"Rank")>
    <cfset rc.details.speed = alexa.UrlInfo(rc.host,"Speed")>
    <cfset rc.details.RelatedLinks = alexa.UrlInfo(rc.host,"RelatedLinks")>
    <cfset rc.details.Keywords = alexa.UrlInfo(rc.host,"Keywords")>
    <cfset rc.details.LinksInCount = alexa.UrlInfo(rc.host,"LinksInCount")>
    <cfset rc.details.UsageStats = alexa.UrlInfo(rc.host,"UsageStats")>
    <cfset rc.details.RankByCity = alexa.UrlInfo(rc.host,"RankByCity")>
    <cfset event.setView("admin/alexa/info")>
  </cffunction>
</cfcomponent>