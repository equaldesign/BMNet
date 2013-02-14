<cfset getMyPlugin(plugin="jQuery").getDepends("form","basket","sites/#request.siteID#/productlist,sites/#request.siteID#/shop,sites/#request.siteID#/screenShotPreview")>
  <!--- try for SUMS generated content --->
  <cfset pageslug = "">
  <div id="productList">
  <cfif rc.products.recordCount gt 0>
    <cfoutput>
    #rc.paging.renderit(rc.productCount,"#bsl('/mxtra/shop/category?q=#rc.q#&page=@page@')#",rc.itemsPerPage)#
    #renderView("shop/product/layoutpickersearch")#
    </cfoutput>
  </cfif>
  <div class="clearer"></div>
  <cfoutput>
  </cfoutput>
  <cfoutput>#renderView("shop/product/styles/#rc.viewMode#")#</cfoutput>
  <cfif rc.products.recordCount gt 0>
    <cfoutput>
      #rc.paging.renderit(rc.productCount,"#bsl('/mxtra/shop/category?q=#rc.q#&page=@page@')#",rc.itemsPerPage)#
    </cfoutput>
  </cfif>

  <div class="clearer"></div>
  </div>