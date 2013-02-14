<cfcomponent   accessors="true" hint="Twitter API Client" output="false">
  <cfproperty name="twitter">  
  <cfproperty name="twitterFactory">  
  <cfproperty name="AccessTokenAPI">
  <cfproperty name="RequestTokenAPI">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />  

  <cffunction name="init">
    <cfargument name="JavaLoader" inject="coldbox:plugin:JavaLoader">
    <cfset JavaLoader.appendPaths("/fs/sites/ebiz/resources/java")>    
    <cfset this.settwitterFactory(JavaLoader.create("twitter4j.TwitterFactory"))>    
    <cfset this.setTwitter(gettwitterFactory().getInstance())>    
    <cfset this.setAccessTokenAPI(JavaLoader.create("twitter4j.auth.AccessToken"))>
    <cfset this.setRequestTokenAPI(JavaLoader.create("twitter4j.auth.RequestToken"))>    
    <cfset this.getTwitter().setOAuthConsumer("2lK8oHA9kSTvOpdIbbzqA","K098FdRhT7acYRA5zIznkdiglwh8I91T6rwhnlbrw")>
    <cfreturn this>
  </cffunction>
  
  <cffunction name="authorise" returntype="string">
    <cfset requestToken = this.getTwitter().getOAuthRequestToken("http://#cgi.http_host#/marketing/twitter/authorise")>
    <cfset UserStorage.setVar("requestToken", requestToken.getToken())>
    <cfset UserStorage.setVar("authtokensecret", RequestToken.getTokenSecret())>    
    <cfreturn requestToken.getAuthorizationURL()>
  </cffunction>
  
  <cffunction name="storeAccess" returntype="void">  
    <cfargument name="verifier">

    <cfset requestToken = UserStorage.getVar("requestToken")>    
    <cfset authtokensecret = UserStorage.getVar("authtokensecret")>   
    
    <cfset ThisAccessToken = getTwitter().getOAuthAccessToken(getRequestTokenAPI().init(requestToken,arguments.verifier))>
    <cfset StoredAccessToken  = ThisAccessToken.getToken()>
    <cfset StoredAccessSecret = ThisAccessToken.getTokenSecret()>
    <cfset OAuthToken = getAccessTokenAPI().init(StoredAccessToken, StoredAccessSecret)>
    <cfquery name="a" datasource="#dsn.getName()#">
      update 
        site 
      set 
        twitterconsumer_key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#StoredAccessToken#">,
        twitterconsumer_secret = <cfqueryparam cfsqltype="cf_sql_varchar" value="#StoredAccessSecret#">
      where
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>    
    <cfquery name="s" datasource="#dsn.getName()#">
      select * from site where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfset UserStorage.setVar("site",s)>
    <cfset getTwitter().setOAuthAccessToken(ThisAccessToken)>    

  </cffunction>

  <cffunction name="getTweets">
    <cfreturn getTwitter().getUserTimeline()>
  </cffunction>
  <cffunction name="findTweet" returntype="boolean">
     <cfargument name="tweetURL" required="true">
     <cfquery name="tweetExists" datasource="bvine">
       select id from tweets where tweetURL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tweetURL#">
     </cfquery>
     <cfif tweetExists.recordCount eq 0>
       <cfreturn false>
     <cfelse>
       <cfreturn true>
     </cfif>
  </cffunction>
  
  <cffunction name="saveTweet" returntype="void">
     <cfargument name="tweetURL" required="true">
     <cfquery name="tweetExists" datasource="bvine">
       insert into tweets (tweetURL) VALUES (<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.tweetURL#">)
     </cfquery>     
  </cffunction>
</cfcomponent>

