<ul class="nav nav-list" id="dashboardShortcuts">
  <li class="nav-header">Sites</li>    
  <li><a class="shortcut sites" href="/sites?siteID=buildingVine">Site List</a></li> 
  <cfif isUserLoggedIn()>
  <cfif rc.siteManager><li><a name="Documents" class="dialog shortcut help" href="/pages/What_are_sites">Help!</a></li></cfif>
  <li class="divider"></li>  
  <li class="nav-header">What's new?</li>
  <li><a class="shortcut feed" href="/feed">News Feed</a></li>
  <li><a class="shortcut products" href="/feed?typeFilter=com.buildingVine.products.products-imported">Product Updates</a></li>
  <li><a class="shortcut documents" href="/feed?typeFilter=com.buildingVine.upload.document-upload">Document additions</a></li>
  <li><a class="shortcut promotions" href="feed?typeFilter=com.buildingVine.promotions.added">New promotions</a></li>
  <li><a class="shortcut prices" href="/feed?typeFilter=com.buildingVine.price.changes">Price Changes</a></li>
  <li><a class="shortcut blog" href="/feed?typeFilter=org.alfresco.blog.post-created">Press Releases</a></li>
  </cfif>
  <!---<cfoutput query="rc.sites">
  <li><a class="shortcut nopadd" href="/sites/switch/siteID/#shortName#">
    <cfset uImage = paramImage("companies/#lcase(shortName)#/small.jpg","/bv/companies/generic_large.jpg")>
    <img src="/includes/images/#uImage#" width="16" height="16" class="glow">
    #title#</a></li>
  </cfoutput>--->
</ul>
