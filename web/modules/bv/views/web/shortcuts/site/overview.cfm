<cfoutput>
<ul class="nav nav-list" id="mainLinks">
  <li class="nav-header">Site Details</li>
  <li><a class="siteDetail" href="/bv/site/overview?siteID=#request.bvsiteID#"><i class="icon-building"></i> Overview</a></li>   
  <li><cfif isUserLoggedIn()><a class="followers" href="/bv/site/followers?siteID=#request.bvsiteID#"></cfif><i class="icon-users"></i> Followers <span class="pull-right badge badge-success">#ArrayLen(rc.members)#</span> <cfif isUserLoggedIn()></a></cfif></li>   
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
  <cfif isUserInRole("admin_#request.bvsiteID#")>  
  <li class="nav-header">Manage Site Users</li>
  <li><a class="shortcut manageusers" href="/bv/site/manage?siteID=#request.bvsiteID#"><i class="icon-user--pencil"></i> Edit Users/Groups</a></li>
  <li><a class="shortcut inviteusers" href="/bv/site/invite?siteID=#request.bvsiteID#"><i class="icon-user--plus"></i> Invite new Users</a></li>
  <li><a class="shortcut existingusers" href="/bv/site/invite?inviteType=existingUser&siteID=#request.bvsiteID#"><i class="icon-user--plus"></i> Invite existing Users</a></li>
  <li><a class="shortcut userlist" href="/bv/site/fullUserList?siteID=#request.bvsiteID#"><i class="icon-users"></i> Full User List</a></li>
  <li class="nav-header">Manage Site Details</li>
  <li><a class="shortcut sitecolour" href="/bv/site/settings?siteID=#request.bvsiteID#"><i class="icon-pencil"></i> Edit Details</a></li>
  <li><a class="shortcut sitelogo" href="/bv/site/logo?siteID=#request.bvsiteID#"><i class="icon-picture"></i> Change Logo</a></li>  
  <cfset siteType = paramValue("request.buildingVine.site.customProperties.companyType.value","Merchant")> 
  <!---
  <li class="nav-header">Order Fulfillment</li>
  <cfif siteType eq "Manufacturer" OR siteType eq "Distributor">      
    <li><a class="shortcut fullfilment" href="/delivery/siteoptions">Fullfilment options</a></li>
  <cfelseif siteType eq "Merchant">
    <li><a class="shortcut fullfilment" href="/delivery/overage">Fulfillment options</a></li> 
  </cfif>
  --->
  <li class="nav-header">Integration</li>
  <li><a class="shortcut siteBuyingGroups" href="/bv/site/buyinggroups?siteID=#request.bvsiteID#"><i class="icon-truck"></i> Buying Group Integration</a></li>
  </cfif>
</ul> 

</cfoutput>
