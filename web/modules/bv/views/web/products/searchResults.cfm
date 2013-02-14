<cfset getMyPlugin(plugin="jQuery").getDepends("UISelect","secure/products/edit","secure/products/products,secure/products/#rc.buildingVine.productLayout#")>
<cfset getMyPlugin(plugin="jQuery").getDepends("form","products/detail","secure/products/products,secure/search")>

<cfoutput>
<cfif rc.siteID neq "">
  <div id="breadcrumb">
    <div id="blinks"><a href="/products/index/siteID/#rc.siteID#" class="ajax">Products</a> &raquo; Search Results
    </div>

</div>
</cfif>
<cfif rc.siteID neq "">
  <cfset cl = "ajax">
<cfelse>
  <cfset cl = "">
</cfif>
<div id="results">
<h2>Search Results for <span class="searchterm">#rc.query#</span></h2>
<cfif isDefined("rc.products.items")>
<cfif arrayLen(rc.products.items) eq 0>
  <p>Sorry, no products matching your term were found.</p>
<cfelse>
  <cfif rc.products.resultcount eq 100>
    <div id="folderInfo" class="Aristo ui-widget">
		  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-error ui-corner-all">
		    <p>
		     Over 100 products matched your search. Try a more specific search to get more accurate results</p>
		  </div>
		</div>
  </cfif>
#getMyPlugin(plugin="Paging").renderit(rc.products.resultcount,"/bv/products/search?siteID=#rc.siteID#&query=#rc.query#&page=@page@")#
<cfif rc.products.resultCount gt rc.boundaries.maxRow>Showing #rc.boundaries.startRow# to #rc.boundaries.maxRow# of #rc.products.resultCount#</cfif>
</cfif>
<cfset rc.products.results = rc.products.items>
<cfoutput>#renderView("web/products/list")#</cfoutput>
<cfif arrayLen(rc.products.items) neq 0>
#getMyPlugin(plugin="Paging").renderit(rc.products.resultcount,"/bv/products/search?siteID=#rc.siteID#&query=#rc.query#&page=@page@")#
<cfif rc.products.resultCount gt rc.boundaries.maxRow>Showing #rc.boundaries.startRow# to #rc.boundaries.maxRow# of #rc.products.resultCount#</cfif>
</cfif>
<cfelse>
<cfdump var="#rc.products#">
</cfif>
</cfoutput>

</div>