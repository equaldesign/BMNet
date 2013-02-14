<cfif ListLast(event.getCurrentEvent(),".") eq "specials" or ListLast(event.getCurrentEvent(),".") eq "clearance">
	<cfhtmlhead text='<link rel="canonical" href="http://#cgi.http_host#/mxtra/shop/#ListLast(event.getCurrentEvent(),".")#/page/#rc.page#" />'>
	<cfset rc.pageslug = "product/#ListLast(event.getCurrentEvent(),".")#">
<cfelse>
	<cfset rc.pageslug = "category/#rc.categoryDetails.pageslug#">
  <cfhtmlhead text='<link rel="canonical" href="http://#cgi.http_host#/mxtra/shop/#rc.categoryDetails.pageslug#/page/#rc.page#" />'>
</cfif>
<cfset getMyPlugin(plugin="jQuery").getDepends("form","basket","")>
  <!--- try for SUMS generated content --->
  <cfset rc.sumsURL = "sums/page/#lcase(rc.categoryID)#.json?alf_ticket=#rc.buildingVine.user_ticket#&siteID=#rc.siteID#">
  <cfset rc.requestData = getModel("sums.PageService").proxy(
    proxyurl=rc.sumsURL,
    formCollection={},
    method="get",
    JSONRequest=false,
    siteID = rc.siteID,
    jsonData = "",
    alf_ticket=request.buildingVine.admin_ticket
  )>
  <cfset hasSUMSPage = false>
  <cfif isDefined("rc.requestData.page.attributes")>
  	<cfset hasSUMSPage = true>
  </cfif>
  <cfif hasSUMSPage AND rc.page eq 1>
  	<cfoutput>#HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.content)#</cfoutput>
  </cfif>
  <cfoutput>
    <input type="hidden" id="parentCategoryID" name="parentCategoryID" value="#rc.parentID#">
    <input type="hidden" id="urlString" value="#URLEncodedFormat('/mxtra/shop/category/#rc.pageslug#?categoryID=#rc.categoryID#&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&itemsPerPage=#rc.itemsPerPage#&page=#rc.Page#')#" />
  </cfoutput>

  <cfif rc.categoryID neq 0>
  <cfoutput>#getModel("eunify.ProductService").breadcrumb(categoryID=rc.categoryID,urlString="&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&itemsPerPage=#rc.itemsPerPage#&viewMode=#rc.viewMode#")#</cfoutput>
  </cfif>

  <div id="productList">
  <cfif rc.products.recordCount gt 0>
	  <cfoutput>
	  <div class="row">
			<div class="pull-right" id="pagecontrols">
		  #rc.paging.renderit(rc.productCount,"/mxtra/shop/#rc.pageslug#?viewMode=#rc.viewMode#&itemsPerPage=#rc.itemsPerPage#&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&categoryID=#rc.categoryID#&page=@page@",rc.itemsPerPage)#
		  #renderView("shop/product/layoutpicker")#
		  </div>
		</div>
	  </cfoutput>
  </cfif>
  <div class="clearer"></div>
  <cfoutput>
  <div id="filter">
    <cfif NOT hasSUMSPage OR rc.Page neq 1><h1>#lcase(rc.categoryName)#</h1></cfif>

		<cfif isDefined("rc.categories") AND rc.categories.recordCount neq 0>
		  <ul class="thumbnails">
		    <cfloop query="rc.categories">
		      <li class="span2">
		        <a class="thumbnail" href="/mxtra/shop/category/#pageslug#?viewMode=#rc.viewMode#&itemsPerPage=#rc.itemsPerPage#&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&categoryID=#id#">
		        	<cfif BVNodeRef neq "">
						    <cfset u = "nodeRef=#BVNodeRef#&size=150">
							<cfelse>
								<cfset u = "merchantCode=#id#&size=150">
					    </cfif>
		          <img class="h100" src="https://www.buildingvine.com/api/productImage?#u#">
		          <strong class="prodcatname">#ucase(name)#</strong>
		        </a>
		      </li>
		    </cfloop>
		  </ul>
		</cfif>
  </div>
  </cfoutput>
  <cfoutput>#renderView("shop/product/styles/#rc.viewMode#")#</cfoutput>
  <cfif rc.products.recordCount gt 0>
    <cfoutput>
      #rc.paging.renderit(rc.productCount,"/mxtra/shop/#rc.pageslug#?viewMode=#rc.viewMode#&categoryID=#rc.categoryID#&page=@page@",rc.itemsPerPage)#
    </cfoutput>
  </cfif>
  <div class="clearer"></div>
  </div>
