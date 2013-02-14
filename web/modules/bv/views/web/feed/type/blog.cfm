<cfoutput>
  <cfset nodePath = Replace(link,":/","")>
  <div class="feedlogo">
      <img src="/includes/images/feed/#source#.jpg" />
  </div>
  <h2><a href="#bl('buildingVine.profile.index','id=#authoruri#')#">#authorName#</a> created the blog post <a href="#bl('buildingVine.blog.post','postID=#link#')#">#title#</a></h2>
  <div class="meta">
    <span class="feedDate">
      #dateFormatOrdinal(pdate,"DDDD D MMM YYYY")#
    </span>
  </div>
  <br class="clear" />
  <div class="feedsummary">
    #description#
  </div>
</cfoutput>