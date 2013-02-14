<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/blog/list")>
<cfoutput>
  <div id="pagingheader">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt rc.blog.itemCount>#rc.blog.total#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.blog.total# items
  <div id="pageCount">
  #rc.paging.renderit(rc.blog.total,"/blog/index/page/@page@?siteID=#rc.siteID#","ajax")#
  </div>
  </div>

  <cfloop array="#rc.blog.items#" index="blog">
    <div class="blogItem">
      <div class="blogHeader">
        <span class="dateBadge"><span class="month">#DateFormat(cdt2(blog.releasedOn),"MMM")#</span><span class="day">#DateFormat(cdt2(blog.releasedOn),"DD")#</span></span>
        <h3><a class="ajax" href="#bl("blog.item","nodeRef=#blog.url#&siteID=#request.bvsiteID#")#">#blog.title#</a></h3>
        <span class="meta"><span class="author">Created by <a href="/contact/index/#urlencrypt(blog.author.username)#">#blog.author.firstName# #blog.author.lastName#</a></span><span class="commentCount">#blog.commentCount# comment<cfif blog.commentCount neq 1>s</cfif></span>
      </div>
      <cfset wordArray = ListToArray(stripHTML(blog.content)," ")> 
      <cfif arrayLen(wordArray) gt 50>
        <cfset wordTo = 50>
      <cfelse>
        <cfset wordTo = arrayLen(wordArray)>
      </cfif>
      <div class="snippet">
        <cfif arrayLen(wordArray) eq 0>
          <!--- something went wrong stripping the HTML --->
          #blog.content#
        <cfelse>
          <cfloop from="1" to="#wordTo#" index="w">#wordArray[w]#  </cfloop>
        </cfif>

      </div>
    </div>
  </cfloop>
  <div id="pagingheader">
  Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt rc.blog.total>#rc.blog.total#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.blog.total# items
  <div id="pageCount">
  #rc.paging.renderit(rc.blog.total,"/blog/index/page/@page@?siteID=#rc.siteID#","ajax")#
  </div>
  </div>
  </cfoutput>