<cfoutput>
  <h2>#rc.blogPost.getTitle()#</h2>
  <p>#rc.blogPost.getbody()#</p>
  <cfif isUserInRole("edit")>
    <a href="#bl('blog.edit','id=#rc.id#')#">edit post</a>
  </cfif>
<h2>Comments</h2>
#renderView("comment/list")#
</cfoutput>

