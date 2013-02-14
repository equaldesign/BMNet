<cfif rc.layoutStyle eq "Main">
<cfoutput>#renderView("contact/homepagecontrols")#</cfoutput>
</cfif>
<cfoutput>
#getMyPlugin(plugin="Paging").renderit(rc.blogCount,"/blog/index/page/@page@")#
Showing #rc.boundaries.startRow# to <cfif rc.boundaries.maxrow gt rc.blogCount>#rc.blogCount#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.blogCount#
</cfoutput>
<div id="homepage">
<cfoutput query="rc.blogList">
  <div class="homepage bloglist">
    <h2>
      <cfif relatedTo eq "arrangement"><cfset deal = getModel("psa").getArrangementAndSupplier(relatedID)>
      <img width="25" class="gravatar" src="#paramImage('company/#deal.company_id#_square.jpg','website/unknown.jpg')#" alt="#deal.known_as#" />
      </cfif>
      <a href="#bl('blog.view','id=#id#')#">#title#</a>
      <cfif relatedTo eq "arrangement">
        (<a href="#bl('psa.index','psaid=#deal.id#')#" class="smaller ajax tooltip" title="#deal.name#">#deal.known_as#</a>)
      </cfif>
       </h2>
    <div class="meta">
      <span class="blogdate">
        #dateFormatOrdinal(date,"DDDD D MMMM YYYY")#
      </span>
      <span class="blogauthor">
        Created by <a href="#bl('contact.index','id=#createdby#')#">#first_name# #surname#</a>
      </span>
      <span class="blogcomments">
        #comments# comment<cfif comments neq 1>s</cfif>
      </span>
    </div>
    <br class="clear" />
	    <div class="blogsummary">
	      #paragraphFormat2(body)#
	    </div>
  </div>
</cfoutput>
</div>