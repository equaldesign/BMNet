<cfset getMyPlugin(plugin="jQuery").getDepends("UISelect","secure/products/edit","secure/products/products,secure/products/#request.buildingVine.productLayout#")>
<cfoutput>
 
<cfif ArrayLen(rc.products.categories) gte 1>
<div class="row-fluid">
  <div class="span12">
  <cfloop array="#rc.products.categories#" index="item">
    <div class="media">
      <a class="pull-left" href="#bl("products.index","siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#item.nodeRef#")#">
        <img width="46" class="media-object img-polaroid" src="https://www.buildingvine.com/api/productImage?categoryNodeRef=#item.NodeRef#&size=46&crop=true&aspect1:1" />
      </a>
      <div class="media-body">
        <h4 class="media-heading">
          <a href="#bl("products.index","siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#item.nodeRef#")#">
            #item.name#
          </a>
        </h4>
      </div>
    </div>
  </cfloop>
  </div>
</div>
</cfif>
<cfset x = 1>
<cfif rc.nodeRef neq 0>

  <cfif ArrayLen(rc.products.results) gte 1>
    <div class="page-header">
      <h1>Products in this category</h1>
    </div>
  </cfif>

<cfif ArrayLen(rc.products.results) gte 1>
<div class="row-fluid">
  <div class="span12">
    <cfloop array="#rc.products.results#" index="product">
      <div class="jstree-draggable">
       <div rel="#product.nodeRef#" class="media">
          <a class="pull-left" href="#bl("products.productDetail","siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#product.nodeRef#")#">
            <cfif ArrayLen(product.productImage) gte 1>
              <img width="46" class="img-polaroid media-object" src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=46&crop=true&aspect=1:1" />
            <cfelse>
              <img width="46" class="img-polaroid media-object" src="https://www.buildingvine.com/api/productImage?siteID=#rc.siteID#&eancode=#product.eancode#&size=46&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#&crop=true&aspect=1:1" />
            </cfif>
            <cfif isUserInRole("admin_#request.bvSiteID#")>
              <a href="##" class="refreshProductImage"></a>
            </cfif>
          </a>
          <div class="media-body">
            <h4 class="media-heading">
              <a href="#bl("products.productDetail","siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#product.nodeRef#")#">
                #product.title#
              </a>
            </h4>
            <cfif NOT product.productactive>
            <span class="label label-important">DISCONTINUED</span>
            </cfif>
          </div>
        </div>
      </div>
      <cfset x++>
    </cfloop>
  </div>
</div>
</cfif>
#renderView("web/products/footer")#
</cfif>

</cfoutput>