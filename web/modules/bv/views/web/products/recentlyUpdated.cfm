<cfoutput>
<div class="page-header">
	<h2>Recently updated Products</h2>
</div>
	<cfloop array="#rc.products.results#" index="product">
<div class="row">
  <div class="span9">		
		 <div class="well jstree-draggable">
		  <div rel="#product.firstResult.nodeRef#" class="row">
		    <div class="span1 productImage">    
		      <cfif arrayLen(product.firstResult.productImage) gte 1>          
		        <img alt="#product.firstResult.title#" src="https://www.buildingvine.com/api/productImage?nodeRef=#product.firstResult.productImage[1].nodeRef#&size=70" class="glow smallImage">
		      <cfelse>
		        <img src="https://www.buildingvine.com/api/productImage?siteID=#product.site#&eancode=#product.firstResult.eancode#&size=70&supplierproductcode=#paramValue('product.firstResult.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.firstResult.attributes.manufacturerproductcode','')#&productName=#product.firstResult.title#" title="#product.firstResult.title#" class="glow smallImage">
		      </cfif>		
		    </div>
		    <div class="span7">
            <h2><a href="/products/recent?filterSite=#product.site#&nodeRef=#product.firstResult.nodeRef#&siteID=#product.site#&page=#rc.page#" class="ajax">#product.firstResult.title#</a></h2>
          <cfif product.firstResult.eanCode neq "">
            <h5><span class="EAN">EAN:</span> #product.firstResult.eancode#</h5>      
          </cfif>
          <img src="/includes/images/companies/#product.site#/small.jpg" />    
          <h4 style="color:##990000">Plus #product.products# other products also updated recently</h4>
        </div>

		  </div>
		</div>
	</div>
</div>
</cfloop>
</cfoutput>

