<cfset getMyPlugin(plugin="jQuery").getDepends("scroll","feed/filter")>
<cfset categories = getModel("modules.eunify.model.FeedService").getCategories()>
<cfset filter = rc.sess.BMNet.newsfilter>
<h2>Filter feed</h2>
<form action="/feed/doFilter?fullPurge=true" method="post" id="feedFilter">
<!--- <dl class="feed-categories">
  <cfoutput>
	<dt><input type="checkbox" value="true" name="favourites" #IIf(rc.sess.eGroup.showFavouritesOnly eq true,"'checked=checked'","''")# /></dt>
  <dd class="favourites">Favourite companies only</dd>
	</cfoutput>
</dl> --->
<h4>Select the categories you'd like to display in the feed:</h4>
<dl class="feed-categories">
  <cfoutput query="categories">
	<dt><input class="filterCheck" type="checkbox" value="#id#" name="filterCat" #IIf(listFind(filter,id) neq 0 OR filter eq 0,"'checked=checked'","''")# /></dt>
  <dd class="articlestyle_#name#">Show #Title#</dd>
	</cfoutput>
</dl>
<dl class="feed-categories">
  <dt><input type="checkbox" value="y" class="selectAll" /></dt>
  <dd>Select/Deselect All</dd>
</dl>
<input type="submit" value="filter &raquo;">
</form>