<cfcomponent   accessors="true" hint="Twitter API Client" output="false">
<cfproperty name="twitter" type="any">
<cfproperty name="jLoader" inject="coldbox:plugin:JavaLoader" />
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfscript>
  // Component initialization //
  instance = structNew();
  public any function doInit() {
   jLoader.appendPaths(getDirectoryFromPath(getMetaData(this).path) & "lib");
   this.setTwitter(jLoader.create("twitter4j.Twitter"));      
	 this.getTwitter().setOAuthConsumer("2lK8oHA9kSTvOpdIbbzqA","K098FdRhT7acYRA5zIznkdiglwh8I91T6rwhnlbrw");
	 return this;
  }
  public string function authorise() {
     // they haven't authorised
		 requestToken = this.getTwitter().getOAuthRequestToken("http://#cgi.http_host#/social/twitter/login");
		 UserStorage.setVar("authrequest", RequestToken.getToken());
     UserStorage.setVar("authtokensecret", RequestToken.getTokenSecret());
		 return requestToken.getAuthorizationURL();
	}
	public any function getTweets() {
	 return getTwitter().getUserTimeline();
	}
  </cfscript>
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

