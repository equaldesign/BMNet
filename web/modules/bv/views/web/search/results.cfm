<cfset getMyPlugin(plugin="jQuery").getDepends("UISelect","","secure/products/products")>
<cfoutput>
<div id="furtherSearch" class="l glow roundCorners">
  <form method="get" action="/search">
    <label class="over furtherSearchBox" for="furtherSearchBox" style="display: block; ">Search again...</label>
    <input type="text" name="query" id="furtherSearchBox">
    <input type="submit" name="submit" value="search" id="furtherSearchButton">
  </form>
</div>
<br class="clear" />
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
  <div id="pagingheader">
  <cfif rc.products.resultCount gt rc.boundaries.maxRow>Showing #rc.boundaries.startRow# to #rc.boundaries.maxRow# of #rc.products.resultCount#</cfif>
  <div id="pageCount">
  #rc.paging.renderit(rc.products.resultCount,"/search?query=#rc.query#&page=@page@","ajax")#
  </div>
  </div>
</cfif>

<cfloop array="#rc.products.items#" index="product">
<div class="productList">
<div class="product">
   <div class="productImage">
    <img src="https://www.buildingvine.com/api/productImage?eancode=#product.eancode#&size=small&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#" />
   </div>
   <div class="left productInfo">
    <h2><a href="/bv/products/productDetail?nodeRef=#product.nodeRef#&siteID=#product.site#&page=#rc.page#" class="ajax">#product.title#</a></h2>
    
    <cfif StructKeyExists(product.attributes,"RRP")><h4>RRP: &pound;#product.attributes.rrp#</h4></cfif>

    <cfset cImage = paramImage("companies/#lcase(product.site)#/small.jpg","/companies/generic_large.jpg")>
    <img src="/includes/images/#cImage#" width="25" height="25" class="glow">
  </div>
 <br clear="all" class="clear" />
</div>
</div>
</cfloop>

<cfif arrayLen(rc.products.items) neq 0>
  <div id="pagingheader">
  <cfif rc.products.resultCount gt rc.boundaries.maxRow>Showing #rc.boundaries.startRow# to #rc.boundaries.maxRow# of #rc.products.resultCount#</cfif>
  <div id="pageCount">
  #rc.paging.renderit(rc.products.resultCount,"/search?query=#rc.query#&page=@page@","ajax")#
  </div>
  </div>
</cfif>
<cfelse>
<cfdump var="#rc.products#">
</cfif>
</cfoutput>

</div>