<cfset getMyPlugin(plugin="jQuery").getDepends("","","blog")>
<cfoutput>
<cfif arraylen(rc.blogPages) eq 0>
  <h1>No blog posts</h1>
  <p>This site does not currently have any blog posts yet</p>
<cfelse>
  <cfloop from="1" to="5" index="i">
    <cfset blogPost = rc.blogPages[i]>
    <cfif blogPost.isDraft eq "NO" OR blogPost.author.username eq rc.buildingVine.username>
    <h3 class="blogtitle">#blogPost.title#</h3>
    <div class="blogInfo">
      <span class="blogDate">#blogPost.modifiedOn#</span>
    </div>
    <p>#blogPost.content#</p>
    </cfif>
  </cfloop>
</cfif>

</cfoutput>