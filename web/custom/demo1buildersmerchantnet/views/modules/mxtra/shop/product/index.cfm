
<cfif ListLast(event.getCurrentEvent(),".") eq "specials" or ListLast(event.getCurrentEvent(),".") eq "clearance">

  <cfset rc.pageslug = "product/#ListLast(event.getCurrentEvent(),".")#">
<cfelse>
  <cfset rc.pageslug = "category/#rc.categoryDetails.pageslug#">

</cfif>
<cfif StructKeyExists(rc.landingData,"landing")>
  <cfset rc.landingImages = DeSerializeJSON(runEvent(event="mxtra:shop.category.landing",eventArguments={widget=true}))>
  <!-- landing exists -->

  <cfoutput>#renderView("shop/category/landing")#</cfoutput>

<cfelse>
  <!-- no landing -->
</cfif>

<cfset getMyPlugin(plugin="jQuery").getDepends("form","basket","")>
  <!--- try for SUMS generated content --->
  <cfoutput>
    <input type="hidden" id="parentCategoryID" name="parentCategoryID" value="#rc.parentID#">
    <input type="hidden" id="urlString" value="#URLEncodedFormat('/mxtra/shop/category/#rc.pageslug#?categoryID=#rc.categoryID#&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&itemsPerPage=#rc.itemsPerPage#&page=#rc.Page#')#" />
  </cfoutput>

  <cfif rc.categoryID neq 0>
  <cfoutput>#getModel("ProductService").breadcrumb(categoryID=rc.categoryID,urlString="#bsl()#")#</cfoutput>
  </cfif>

  <div id="productList">
  <cfif rc.products.recordCount gt 0>
    <cfoutput>
    <div id="listControls" class="row">
      <div class="pull-right" id="pagecontrols">
      #renderView("shop/product/layoutpicker")#
      #rc.paging.renderit(rc.productCount,"#bsl('/mxtra/shop/#rc.pageslug#?&categoryID=#rc.categoryID#&page=@page@')#",rc.itemsPerPage)#
      </div>
    </div>
    </cfoutput>
  </cfif>
  <div class="clearer"></div>
  <cfoutput>
  <div id="filter">
    <cfif NOT StructKeyExists(rc.metaData,"tabData") AND rc.Page neq 1><h1>#lcase(rc.categoryName)#</h1></cfif>

    <cfif isDefined("rc.categories") AND rc.categories.recordCount neq 0>
      <ul class="thumbnails">
        <cfloop query="rc.categories">
          <li class="thumbnail span2">
            <a href="#bsl('/mxtra/shop/category/#pageslug#?categoryID=#id#')#">
              <cfif BVNodeRef neq "">
                <cfset u = "nodeRef=#BVNodeRef#&size=300">
              <cfelse>
                <cfset u = "merchantCode=#id#&size=300">
              </cfif>
              <img src="https://www.buildingvine.com/api/productImage?#u#&crop=true&imageplaceholder=http://#cgi.http_host#/includes/images/sites/1/holdingimage.jpg">
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
      #rc.paging.renderit(rc.productCount,"#bsl('/mxtra/shop/#rc.pageslug#?categoryID=#rc.categoryID#&page=@page@')#",rc.itemsPerPage)#
    </cfoutput>
  </cfif>
  <div class="clearer"></div>
  </div>
