<cfoutput>
<cfset recentProductChanges = getModel("bv.ProductService").recentlyUpdatedCount(siteID=request.bvsiteID)>  
<ul class="nav nav-list" id="mainLinks">
  <li class="nav-header">Site Details</li>
  <li><a class="siteDetail" href="/bv/site/overview?siteID=#request.bvsiteID#"><i class="icon-building"></i> Overview</a></li>  
  <li><a class="siteDetail" href="/bv/products?siteID=#request.bvsiteID#"><i class="icon-drill"></i> Products</a></li>
  <li><a class="siteDetail" href="/bv/documents?siteID=#request.bvsiteID#"><i class="icon-document-pdf"></i> Documents</a></li>
  <li><a class="siteDetail" href="/bv/promotions?siteID=#request.bvsiteID#"><i class="icon-store"></i> Promotions</a></li>
  <li><a class="siteDetail" href="/bv/blog?siteID=#request.bvsiteID#"><i class="icon-newspaper"></i> News</a></li>
  <li><cfif isUserLoggedIn()><a class="followers" href="/bv/site/followers?siteID=#request.bvsiteID#"><cfelse><span class="block"></cfif><i class="icon-users"></i> Followers <span class="pull-right badge badge-success">#ArrayLen(rc.members)#</span> <cfif isUserLoggedIn()></a><cfelse></span></cfif></li>   
  <li class="nav-header">What's new</li>
  <li><a class="siteDetail" href="/bv/products/recent?filterSite=#request.bvsiteID#&siteID=#request.bvsiteID#"><i class="icon-drill"></i> Products <span class="badge pull-right">#recentProductChanges.products#</a></li>  
  <cfif paramValue("request.buildingVine.site.customProperties.website.value","") neq "">  
  <li class="nav-header">External Links</li>    
    <li><a target="_blank" class="website" href="#request.buildingVine.site.customProperties.website.value#"><i class="icon-globe"></i> Website</a></li>
  </cfif>
  <cfif paramValue("request.buildingVine.site.customProperties.googlePlusPage.value","") neq "">
    <li><a target="_blank" class="googlePlus" href="#request.buildingVine.site.customProperties.googlePlusPage.value#"><i class="icon-google_plus_16"></i> Google +</a></li>
  </cfif> 
  <cfif paramValue("request.buildingVine.site.customProperties.facebookPage.value","") neq "">
    <li><a target="_blank" class="facebook" href="#request.buildingVine.site.customProperties.facebookPage.value#"><i class="icon-facebook_16"></i> Facebook</a></li>
  </cfif>
  <cfif paramValue("request.buildingVine.site.customProperties.twitterUsername.value","") neq "">
    <li><a target="_blank" class="twitter" href="#request.buildingVine.site.customProperties.twitterUsername.value#"><i class="icon-twitter_16"></i> Twitter</a></li>
  </cfif>
  <cfif paramValue("request.buildingVine.site.customProperties.linkedInPage.value","") neq ""> 
    <li><a target="_blank" class="linkedIn" href="#request.buildingVine.site.customProperties.linkedInPage.value#"><i class="icon-linkedin_16"></i> LinkedIn</a></li>
  </cfif>
  <cfif paramValue("request.buildingVine.site.customProperties.youtube.value","") neq "">
    <li><a target="_blank" class="youtube" href="#request.buildingVine.site.customProperties.youtube.value#"><i class="icon-youtube_16"></i> YouTube</a></li>
  </cfif>
  
</ul>
</cfoutput>