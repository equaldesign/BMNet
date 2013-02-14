<cfoutput>
<ul class="nav nav-list" id="dashboardShortcuts">
  <li class="nav-header">Site Details</li>
  <li><a class="" href="/site/overview?siteID=#request.siteID#">Overview</a></li>  
	<li><a class="" href="/site/followers?siteID=#request.siteID#">Followers <span class="badge badge-success">#ArrayLen(rc.members)#</span> </a></li>
	<li class="divider"></li>	
</ul> 

</cfoutput>
