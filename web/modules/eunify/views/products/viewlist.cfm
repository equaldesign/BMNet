<cfset getMyPlugin(plugin="jQuery",module="bv").getDepends("UISelect","secure/products/edit","")>

<cfoutput>

  <cfif rc.products.recordCount gte 1>
  <div id="pagingheader">
    Showing #rc.startRow+1# to <cfif rc.productCount lt rc.boundaries.maxrow>#rc.productCount#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.productCount#
    <div id="pageCount">
      #rc.sess.paging.renderit(rc.productCount,"/products/view/parentID/#rc.parentID#?page=@page@","ajax")#
    </div>
  </div>
  </cfif>
</cfoutput>
<ul id="productCategories">
<cfoutput query="rc.products">
<div class="productList jstree-draggable">
<div rel="#product_code#" class="product">
   <div class="productImage">
    <img src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&size=small&manufacturerproductcode=#Manufacturers_Product_Code#&supplierproductcode=#product_code#&productName=#full_description#" />
   </div>
   <div class="left productInfo">
    <h2><a href="/products/detail?id=#product_code#" class="ajax">#full_description#</a></h2>
    <cfif eanCode neq "">
      <h5><span class="EAN">EAN:</span>#eancode#</h5>
    <cfelse>
      <h5><span class="code">Code:</span>#product_code#</h5>
    </cfif>
    <h5 class="webtrade #webEnabled#">Web Trade</h5>
    <h5 class="webtrade #publicwebEnabled#">Web Public</h5>
   </div>
 <br clear="all" class="clear" />
</div>
</div>
</cfoutput>
  <cfoutput>
  <div id="pagingheader">
    Showing #rc.startRow+1# to <cfif rc.productCount lt rc.boundaries.maxrow>#rc.productCount#<cfelse>#rc.boundaries.maxrow#</cfif> of #rc.productCount#
    <div id="pageCount">
      #rc.sess.paging.renderit(rc.productCount,"/products/view/parentID/#rc.parentID#?page=@page@","ajax")#
    </div>
  </div>
  </cfoutput>
