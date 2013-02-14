<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/twitter/feed")>
<h2>Tweets</h2>
<cfoutput>
<div class="t">
<cfloop array="#rc.tweets#" index="tweet">
  <div class="trow">
    <div class="tcell tweetImage">
      <img src="#tweet.getUser().getProfileImageURL()#">
    </div>
    <div class="tcell tweet">
      <h4><a href="/marketing/twitter/user?id=#tweet.getUser().getName()#" class="ajax">#tweet.getUser().getName()#</a></h4>
      <cftry>#activateLinks(tweet.getText())#<cfcatch type="any">#tweet.getText()#</cfcatch></cftry>
      <div class="tweetDate">#Duration(tweet.getCreatedAt(),now())#</div>
    </div>
  </div>
</cfloop>
</div>
</cfoutput>

<cfscript>

</cfscript>