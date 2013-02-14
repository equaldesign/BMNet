<div class="row">
	<div class="span7">
		<div id="homeSearch" class="l glow roundCorners">
		  <form id="publicSearch" method="get" action="/search">
		    <label class="over publicSearchHomepage" for="publicSearchBox">Try searching for a product...</label>
		    <input class="span6" type="text" name="query" id="publicSearchBox" />
		    <input type="submit" name="submit" value="search" id="publicSearchButton" />
		  </form>
		</div>
		<div class="clear"></div>
		<div id="recentSites">
		  <h2>Some of our new additions</h2>
		  <div id="siteList">
		    <cfquery name="newSites" datasource="bvine">select * from site where active = 'true' order by created desc limit 0,15;</cfquery>
		    <div id="newsites">
		    <cfoutput query="newSites">
		      <cfset uImage = paramImage("companies/#shortName#/small.jpg","companies/generic.jpg")>
		      <a href="/sites/#shortName#"><img title="#xmlFormat(title)#" class="ttip profileImageSmall glow" width="46" height="46" alt="#xmlFormat(title)#" src="/includes/images/#uImage#" /></a>
		      <cfif currentRow MOD(15) eq 0><br class="clear" /></cfif>
		    </cfoutput>
		    </div>
	    </div>
    </div>
	</div>
  <div class="span5" id="signupRight">
    <cfoutput>#renderView("viewlets/public/signup",true,90)#</cfoutput>
  </div>  
</div>