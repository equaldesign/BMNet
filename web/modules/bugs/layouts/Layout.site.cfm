<cfset getMyPlugin(plugin="jQuery",module="buildingVine").getDepends("","bvine")>
<cfoutput>
<div id="header" class="greyBox">
	<ul>
		<li class="first"><a rev="bvine" class="blog ajax" href="/bvine/blog/index/siteID/#rc.siteID#">Blog</a></li>
		<li><a rev="bvine" class="feed ajax" href="/bvine/feed/index/siteID/#rc.siteID#">Feed</a></li>
		<li><a rev="bvine" class="documents ajax" href="/bvine/documents/index/siteID/#rc.siteID#">Documents</a></li>
		<li><a rev="bvine" class="products ajax" href="/bvine/products/index/siteID/#rc.siteID#">Products</a></li>
		<li><a rev="bvine" class="wiki ajax" href="/bvine/wiki/index/siteID/#rc.siteID#">Wiki</a></li>
		<li><a rev="bvine" class="discussions ajax" href="/bvine/forum/index/siteID/#rc.siteID#">Discussions</a></li>
		<li class="last"><a rev="bvine" class="members ajax" href="/bvine/site/members/siteID/#rc.siteID#">Members</a></li>
	</ul>
	<br clear="all" />
</div>
<div id="bvMain">
#renderView()#
</div>
<input type="hidden" id="cfid" value="#cfid#" /><input type="hidden" id="cftoken" value="#cftoken#" /><input type="hidden" id="jsessionid" value="#jsessionid#" />
</cfoutput>
