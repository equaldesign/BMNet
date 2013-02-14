<cfset getMyPlugin(plugin="jQuery").getDepends("form","secure/products/detail","secure/products/products,secure/products/#rc.buildingVine.productLayout#")>

<cfoutput>
<div id="furtherSearch">
  <form method="get" action="/search/az">
    <div class="l searchDiv">
      <label class="over furtherSearchBox" for="furtherSearchBox" style="display: block; ">Search again...</label>
      <input type="text" name="query" id="furtherSearchBox">
      <button type="submit">
        <p><span class="search"></span> Search</p>
      </button>
    </div>
    <br class="clear" />
  </form>
</div>
<br class="clear" />
<div id="results">
<h2>Search Results for <span class="searchterm">#rc.query#</span></h2>
<cfif rc.products.ItemSearchResponse.Items.TotalResults.xmltext eq 0>
<h4>No items were found that matched your search</h4>
<Cfelse>
<div id="pagingheader">
  <cfif rc.resultCount gt rc.boundaries.maxRow>Showing #rc.boundaries.startRow# to #rc.boundaries.maxRow# of #rc.resultCount#</cfif>
  <div id="pageCount">
  #rc.buildingVine.paging.renderit(rc.resultCount,"/search/az?query=#rc.query#&page=@page@","ajax")#
  </div>
  </div>
<cfloop array="#rc.products.ItemSearchResponse.Items.item#" index="product">

<div class="productList">
<div class="product">
   <div class="productImage">
    <img src="#product.smallImage.URL.xmlText#" />
   </div>
   <div class="left productInfo">
    <h2><a href="/products/az/id/#product.ASIN.xmlText#" class="ajax">#product.ItemAttributes.Title.xmlText#</a></h2>
    <cfif isDefined("product.OfferSummary.LowestNewPrice.FormattedPrice")>
    <h4>#product.OfferSummary.LowestNewPrice.FormattedPrice.xmlText#</h4>
    </cfif>
  </div>
 <br clear="all" class="clear" />
</div>
</div>
</cfloop>
</cfif>

</cfoutput>

</div>