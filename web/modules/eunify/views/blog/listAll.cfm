<cfoutput query="rc.blogList">
  <div class="bloglist">
    <h2><a href="#bl('blog.view','id=#id#')#">#title#</a></h2>
    <div class="meta">
      <span class="blogdate">
        #dateFormatOrdinal(created,"DDDD D MMMM YYYY")# @ #timeFormat(created,"full")#
      </span>
      <span class="blogauthor">
        Created by #first_name# #surname#
      </span>
      <span class="blogcomments">
        #comments# comment<cfif comments neq 1>s</cfif>
      </span>
    </div>
    <br class="clear" />
      <div class="blogsummary">
        #paragraphformat2(body)#
      </div>
  </div>
</cfoutput>