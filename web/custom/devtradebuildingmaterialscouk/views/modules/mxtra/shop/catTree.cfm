<cfif NOT isDefined('rc.category')>
  <cfset rc.category = getModel("modules.eunify.model.ProductService")>
</cfif>
<cfset rc.baseCats = rc.category.categoryList(rc.categoryID,rc.priceFrom,rc.priceTo,rc.brands)>
<cfset rc.thisCategory = rc.category.getParentCategory(rc.categoryID,request.siteID)>
<cfif NOT isDefined("rc.filterOptions")>
  <cfset rc.filterOptions = rc.category.getProductRanges(ArrayToList(rc.category.categoryTraverse(rc.categoryID)))>
</cfif>
<div>
	<form class="form-search" action="/mxtra/shop/product/search">
	  <div class="input-append">
	    <input name="q" class="input-medium" placeholder="Search for a product..." />
	    <input type="submit" class="btn btn-success" value="Search">
	  </div>
	</form>
	
	<ul class="nav nav-list">
		<cfif rc.categoryID neq 0><cfoutput><li class="active"><a href="/mxtra/shop/category?viewMode=#rc.viewMode#&itemsPerPage=#rc.itemsPerPage#&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&categoryID=#rc.thisCategory.parentid#"><i class="icon-up"></i> Up a level</a></li></cfoutput></cfif>
		<cfif rc.baseCats.recordCount neq 0>
			
			<li class="nav-header"><cfif rc.categoryID neq 0>Further </cfif>Categories</li>
			<li class="divider"></li>
		  <cfoutput query="rc.baseCats">
		    <li><a href="/mxtra/shop/category/#pageSlug#?viewMode=#rc.viewMode#&itemsPerPage=#rc.itemsPerPage#&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&categoryID=#id#"><i class="icon-nav"></i> #capFirstTitle(name)#</a></li>
		  </cfoutput>
		  <li class="divider"></li>
		</cfif> 	
		<cfoutput>#getMyPlugin(plugin="jQuery").getDepends("","sites/3/shop","",false)#</cfoutput>
		<cfif rc.categoryID neq 0>
			<!--- filtering options --->
	    <li class="nav-header">Brands</li>
			<li data-toggle="buttons-checkbox">			
				<cfoutput query="rc.filterOptions.brands">			
						<a data-brandID="#brandID#" href="##" class="brandFilter #iif(ListFind(rc.brands,brandID),"'active'","''")# btn btn-mini">#brand#</a>
				</cfoutput>			
			</li>
			<!--- get all distinct brands in the category --->
	    <li class="divider"></li>
			<cfoutput>
			<cfif rc.priceFrom eq "">
				<cfset startPrice = rc.filterOptions.min>
			<cfelse>
				<cfset startPrice = rc.priceFrom>
			</cfif>
			<cfif rc.priceTo eq "">
        <cfset endPrice = rc.filterOptions.max>
      <cfelse>
        <cfset endPrice = rc.priceTo>
      </cfif>  
			<li class="nav-header">Price <small id="amount">&pound;#startPrice# - &pound;#endPrice# </small></li>
			<li>
				<div data-min="#rc.filterOptions.min#" data-max="#rc.filterOptions.max#" id="pricerange"></div>			
				<input type="hidden" id="price_from" value="#startPrice#" />
				<input type="hidden" id="price_to" value="#endPrice#" />
			</li>
			</cfoutput>
			<!--- group by price range --->
		</cfif>
	</ul>
	<br />
	
</div>
