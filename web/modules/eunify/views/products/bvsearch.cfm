<cfoutput>
<cfloop array="#rc.bvProduct.items#" index="product">
<div class="productList jstree-draggable">
	<div class="product">
	   <div class="productImage">
	   	<cfif ArrayLen(product.productImage) gte 1>
		    <img src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=small" />		  
		  </cfif>	    
	   </div>
	   <div class="left productInfo">
	    <h2>#product.attributes.title#</a></h2>
	    <cfif product.eanCode neq "">
	      <h5><span class="EAN">EAN:</span>#product.eancode#</h5>
	    <cfelse>
	      <h5><span class="code">Code:</span>#product.manufacturerproductcode#</h5>
	    </cfif>
	    <a href="/eunify/products/bvset?productID=#rc.product.id#&bvnodeRef=#product.nodeRef#" class="btn btn-success">Choose this Building Vine Product</a>	    
	   </div> 
	 <br clear="all" class="clear" />
	</div>
</div>
</cfloop>
</cfoutput>