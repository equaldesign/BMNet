<cfset getMyPlugin(plugin="jQuery").getDepends("UISelect","secure/products/edit","secure/products/products,secure/products/list")>
<cfset rc.categoryArray = createObject("java", "java.util.Collections").reverse(rc.products.parentStruct)>
<cfoutput>
#renderView("web/products/header")#
<cfif ArrayLen(rc.products.categories) gte 1>
<table class="table table-bordered table-striped">
 <thead>
   <th width="30"></th>
   <th>Name</th>
 </thead>
 <tbody>
  <cfloop array="#rc.products.categories#" index="item">
  	<tr>
  		<td><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#item.nodeRef#")#"><img class="popImg" title="#item.name#" data-content='<img src="https://www.buildingvine.com/api/productImage?categoryNodeRef=#item.NodeRef#&size=300">' src="https://www.buildingvine.com/api/productImage?categoryNodeRef=#item.NodeRef#&size=30" /></a></td>
			<td><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#item.nodeRef#")#">#item.name#</a></td>
  	</tr>
  </cfloop>
  </tbody>
</table>
</cfif>
<cfset x = 1>
<cfif rc.nodeRef eq 0>
  <cfif ArrayLen(rc.products.results) gte 1>
    <div class="page-header">
      <h1>Featured Products</h1>
    </div>
  </cfif>
<cfelse>
  <cfif ArrayLen(rc.products.results) gte 1>
    <div class="page-header">
      <h1>Products in this category</h1>
    </div>
  </cfif>
</cfif>
<cfif ArrayLen(rc.products.results) gte 1>
<table class="table table-bordered table-striped">
 <thead>
   <th width="30"></th>
   <th>Name</th>
	 <th>EAN</th>
	 <th>RRP</th>
 </thead>
 <tbody>
    <cfloop array="#rc.products.results#" index="product">
      <tr>
      	<td>
      		<a href="#bl("products.productDetail","siteID=#request.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#product.nodeRef#&page=#rc.page#")#" class="ajax">
      		<cfif ArrayLen(product.productImage) gte 1>
            <img class="popImg" title="#product.title#" data-content='<img src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=300">' src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=30" />
          <cfelse>
            <img class="popImg" title="#product.title#" data-content='<img src="https://www.buildingvine.com/api/productImage?siteID=#rc.siteID#&eancode=#product.eancode#&size=30&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#">' src="https://www.buildingvine.com/api/productImage?siteID=#rc.siteID#&eancode=#product.eancode#&size=30&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#" />
          </cfif>
					</a>
      	</td>
				<td><a href="#bl("products.productDetail","siteID=#request.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#product.nodeRef#&page=#rc.page#")#" class="ajax">#product.title#</a> <cfif NOT paramValue("product.attributes.productactive",true)><span class="label label-important">DISCONTINUED</span></cfif></td>
				<td>#product.eancode#</td>
				<td><cfif StructKeyExists(product.attributes,"RRP") AND product.attributes.RRP neq "">&pound;#product.attributes.rrp#</cfif></td>
      </tr>
    </cfloop>
  </tbody>
</table>
</cfif>
#renderView("web/products/footer")#
</cfoutput>
