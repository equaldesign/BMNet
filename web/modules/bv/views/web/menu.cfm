<cfset getMyPlugin(plugin="jQuery").getDepends(",","","public/home/mainmenu")>
<cfoutput>
<div class="menu">
<ul>
  <li class="mm"><a title="News" class="#IIf(event.getCurrentHandler() eq 'blog',"'active'","''")# main" href="/blog?siteID=#rc.siteID#">News<span></span></a></li>
  <li class="mm"><a title="Products" id="ProdTree" rel="productTree" href="/products?siteID=#rc.siteID#" class="#IIf(event.getCurrentHandler() eq 'products',"'active'","''")# main">Products<span></span></a>
  </li>

  <!---
  <li class="mm"><a id="DocTree" title="Documents" rel="documentTree" href="##" class="#IIf(event.getCurrentHandler() eq 'documents',"'active'","''")# main show">Documents<span></span></a>
  <cfset getMyPlugin(plugin="jQuery").getDepends("","secure/documents/tree","")>
    <ul class="#Iif(event.getCurrentHandler() eq 'documents','""','"hidden"')# tree" id="documentTree"></ul>
  </li>
  --->
  <li class="mm"><a title="Stockists" class="#IIf(event.getCurrentHandler() eq 'stockist',"'active'","''")# main" href="/stockist/map?siteID=#rc.siteID#">Stockists<span></span></a></li>
</ul>
</div>
</cfoutput>
