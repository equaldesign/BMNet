<cfset site = rc.SiteService.getSite(rc.feedItem.siteNetwork)>
<cfoutput>  
 <div class="row feeditem">
   <div class="span1">
     <img width="45" height="45" class="thumbnail" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(rc.feedItem.postUserId)))#?size=45&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" />
   </div>
   <div>
     <a href="#bl("profile.index","id=#UrlEncrypt(rc.feedItem.postUserId)#")#">#rc.feedItem.detail.firstName# #rc.feedItem.detail.lastName#</a> 
     deleted the news item #rc.feedItem.detail.title# <span class="timestamp">#Duration(DateConvertISO8601(rc.feedItem.postDate,0),now())#</span>
     <div><cfset cImage = paramImage("companies/#lcase(rc.feedItem.siteNetwork)#/small.jpg","/companies/generic_large.jpg")><img src="/includes/images/#cImage#" width="25" height="25" class="feedimage"></div>
   </div>
 </div>
</cfoutput>
