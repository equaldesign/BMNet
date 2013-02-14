<cfset recentProductChanges = getModel("bv.ProductService").recentlyUpdatedCount(siteID=request.bvsiteID)>
<cfoutput>
<ul class="nav nav-list" id="mainLinks">
  <li class="nav-header">Products</li>	  
  <cfif isUserInRole("admin_#request.bvsiteID#")><li><a class="shortcut ajax uploadproducts" href="/bv/products/upload?siteID=#request.bvsiteID#"><i class="icon-drive-upload"></i>Upload product database</a></li></cfif>
  <cfif isUserInRole("admin_#request.bvsiteID#")><li><a class="shortcut ajax importprices" href="/bv/products/importprices?siteID=#request.bvsiteID#"><i class="icon-drive-upload"></i>Import a price list</a></li></cfif>
  <cfif isUserInRole("admin_#request.bvsiteID#")><li><a name="Products" class="dialog shortcut help" href="/bv/pages/Managing_Products"><i class="icon-question"></i>Help!</a></li></cfif>
  <li class="nav-header">Spreadsheets</li>
  <li><a class="shortcut ajax createproduct" href="/bv/products/download?siteID=#request.bvsiteID#"><i class="icon-drive-download"></i>Download Products</a></li>
  <li><a class="shortcut ajax createproduct" href="/bv/products/download?siteID=#request.bvsiteID#&dateFrom=#dateFormat(dateAdd("d", -31, now()),"YYYY-MM-DD")#"><i class="icon-drive-download"></i>Download Recently Changed Products <span class="badge pull-right">#recentProductChanges.products#</span></a></li>
  <li class="nav-header">Feed</li> 
  <li><a class="shortcut ajax createproduct" href="/bv/products/feed?siteID=#request.bvsiteID#&format=json"><i class="icon-drive-download"></i>Download Products</a></li>
</ul>
<!---
<cfset tags = getModel("bv.TagService").getTagScopes("#request.bvsiteID#","ProductFiles")>  
<ul class="tags">
<cfloop array="#tags.tags#" index="tag">
  
    <li><a class="tag" href="/">#tag.name# (#tag.count#)</a></li>

</cfloop>
</ul> 
---> 
</cfoutput>