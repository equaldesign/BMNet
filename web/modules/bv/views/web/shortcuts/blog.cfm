<cfoutput>
<ul class="nav nav-list" id="mainLinks">
  <li class="nav-header">Press Releases &amp; News</li>  
  <li><a class="shortcut blog ajax" href="/bv/blog?siteID=#request.bvsiteID#"><i class="icon-blog"></i>View news items</a></li>
	<cfif isUserInRole("admin_#request.bvsiteID#")>
    <li class="nav-header">Manage News</li>  
    <li><a class="shortcut createblog" href="/bv/blog/edit?siteID=#request.bvsiteID#"><i class="icon-blog--plus"></i>Create new press release</a></li>  
	</cfif>
</ul>
<!---
<cfset tags = getModel("bv.TagService").getTagScopes("#request.bvsiteID#","blog")>
<ul class="tags">
<cfloop array="#tags.tags#" index="tag">
  
    <li><a class="tag" href="/">#tag.name# (#tag.count#)</a></li>

</cfloop>
</ul>
--->
</cfoutput>