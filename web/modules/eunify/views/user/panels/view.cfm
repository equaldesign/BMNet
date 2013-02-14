
<h2>Site Activity</h2>
<cfoutput>
<p>User since: #DateFormat(rc.user.created,"DD/MM/YYYY")#</p>
<p>Last updated: #DateFormat(rc.user.modified,"DD/MM/YYYY")#</p>
<p>Total page views: #rc.totalHits# </p>
<p>Page views this month: #rc.thisMonth# </p>
<P>Last 5 sessions:</P>
</cfoutput>
<cfif isUserInRole("superusers")>
<cfoutput>
<a href="#bl('user.fullHistory','id=#rc.user.id#')#">full history</a>
</cfoutput>
</cfif>