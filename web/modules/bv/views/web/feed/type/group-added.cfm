<cfset site = rc.SiteService.getSite(rc.feedItem.siteNetwork)>
<cfoutput>  
 <div class="row feeditem">
   <div class="span1">
     <cfset cImage = paramImage("companies/#rc.feedItem.siteNetwork#/small.jpg","/companies/generic_large.jpg")>
     <img class="thumbnail" src="/includes/images/#cImage#" />
   </div>
   <div>     
     <p>#ListLast(rc.feedItem.detail.groupName,"_")# is now following #site.title#      
      <span class="timestamp">#Duration(DateConvertISO8601(rc.feedItem.postDate,0),now())#</span>
     </p>    
   </div>
 </div>
</cfoutput>
