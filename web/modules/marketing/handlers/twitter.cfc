<cfcomponent name="twitterHandler" cache="true">
  <cfproperty name="twitterService" inject="id:marketing.social.TwitterService">
  <cfproperty name="SiteService" inject="id:eunify.SiteService">
  

  <cffunction name="preHandler" returnType="void" cache="true">
    <cfargument name="event" required="true">    
    <cfset var rc = event.getCollection()>     
    <cfset rc.oauth_token = event.getValue("oauth_token","")>
    <cfif request.site.twitterconsumer_key eq "" AND rc.oauth_token eq "">
      <cfset setNextEvent(uri=#twitterService.authorise()#)>        
      <cfthrow message="WTF!">
      <cfabort>         
    <cfelse>
      <cftry>
        <cfset x = twitterService.gettwitter().getOAuthAccessToken()>
        <cfcatch type="any">
          <cfset twitterService.gettwitter().setOAuthAccessToken(twitterService.getAccessTokenAPI().init(request.site.twitterconsumer_key,request.site.twitterconsumer_secret))>
        </cfcatch>
      </cftry>
    </cfif>
  </cffunction> 


  <cffunction name="authorise" returntype="void" cache="true"> 
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.oauth_token = event.getValue("oauth_token")>
    <cfset rc.oauth_verifier = event.getValue("oauth_verifier")>    
    <cfset twitterService.storeAccess(rc.oauth_token,rc.oauth_verifier)>
    <cfset setNextEvent(uri="/marketing/twitter")>
  </cffunction>
 
  <cffunction name="index" returntype="void" cache="true">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>        
    <cfset rc.twitterService = twitterService>
    <cfset rc.user = rc.twitterService.getTwitter().verifyCredentials()>    
    <cfset rc.timeline = rc.twitterService.getTwitter().getHomeTimeLine()>    
    <cfset event.setView("twitter/index")>    
  </cffunction>

  <cffunction name="profile" returntype="void" cache="true">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>    
    <cfset rc.twitterService = twitterService>
    <cfset rc.id = event.getValue("id",rc.twitterService.getTwitter().verifyCredentials().getScreenName())>        
    <cfset rc.user = rc.twitterService.getTwitter().showUser(rc.id)>
    <cfset rc.timeline = rc.twitterService.getTwitter().getUserTimeLine(rc.id)>    
    <cfset event.setView("twitter/profile")>    
  </cffunction>

</cfcomponent>