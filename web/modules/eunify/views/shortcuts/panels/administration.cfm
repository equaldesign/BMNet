
<cfoutput>
  <cfif isUserInRole("admin")>
  <h2>Group Admin</h2>
  <ul>
    <li class="group_administrator"><a href="/eunify/groups/administrator" title="Administer Contact Groups">group &amp; category manager</a></li>
  </ul>
  </cfif>
  <cfif isUserInAnyRole("admin,author")>
  <h2>News</h2>
  <ul>
    <li class="blog_create"><a href="#bl('blog.edit')#" title="Create news">Create news story</a></li>
  </ul>
  </cfif>
</cfoutput>
