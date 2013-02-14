<cfset site = rc.SiteService.getSite(rc.feedItem.siteNetwork)>
<cfoutput>  
 <div class="row feeditem">
   <div class="span1">
     <cfset cImage = paramImage("companies/#rc.feedItem.siteNetwork#/small.jpg","/companies/generic_large.jpg")>
     <img class="thumbnail" src="/includes/images/#cImage#" />
   </div>
   <div>
     <h3><a href="#bl("blog.item","pageLink=blog/post/node/#rc.feedItem.detail.page#&siteID=#rc.feeditem.siteNetwork#")#">#rc.feedItem.detail.title#</a></h3>
     <p>
      <cftry>#rc.feedItem.detail.content#<cfcatch  type="any"></cfcatch></cftry>
      <span class="timestamp">#Duration(DateConvertISO8601(rc.feedItem.postDate,0),now())#</span>
     </p>    
   </div>
 </div>
</cfoutput>
