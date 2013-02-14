<cffunction name="processText" returntype="String">
  <cfargument name="text">
  <cfargument name="mentions">
  <cfargument name="links">
  <cfargument name="hashTags">
  <cfset var tweet = arguments.text>
  <cfloop array="#mentions#" index="mention">
    <cfset userName = mention.getScreenName()>
    <cfset tweet = replace(tweet,'@#username#','<a href="/marketing/twitter/profile?userName=#userName#">@#username#</a>','ALL')>
  </cfloop>
  <cfloop array="#links#" index="link">
    <cfset uri = link.getURL()>
    <cfset tweet = replace(tweet,'#uri#','<a href="#link.getExpandedURL()#" target="_blank">#uri#</a>','ALL')>
  </cfloop>
  <cfloop array="#hashTags#" index="hashTag">
    <cfset ht = hashTag.getText()>
    <cfset tweet = replace(tweet,'###ht#','<a href="/marketing/twitter/hashtag?tag=#ht#">###ht#</a>','ALL')>
  </cfloop>
  <cfreturn tweet>
</cffunction>
