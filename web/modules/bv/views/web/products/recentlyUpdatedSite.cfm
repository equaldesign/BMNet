
<cfoutput>
<div class="page-header">
  <h2>Recently updated #rc.buildingVine.siteDB.title# Products</h2>
</div>
<cfset x = 1>
<cfloop array="#rc.products.results#" index="product">
<div class="row">
  <div class="span9">   
     <div class="well jstree-draggable">
      <div class="row">
        <div class="span1 productImage">    
			    <cfif arrayLen(product.productImage) gte 1>
			      <!--- we have a proper product image --->     
			      <img alt="#product.title#" src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=70" class="glow smallImage">
			    <cfelse>
			        <img src="https://www.buildingvine.com/api/productImage?siteID=#product.site#&eancode=#product.eancode#&size=70&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#" title="#product.title#" class="glow smallImage">
			    </cfif> 
			   </div>
			   <div class="span7">
			    <h2><a href="/products/productDetail?nodeRef=#product.nodeRef#&siteID=#product.site#" class="ajax">#product.title#</a></h2>
			    <cfif product.eanCode neq "">
			      <h5><span class="EAN">EAN:</span> #product.eancode#</h5>
			    <cfelse>
			      <!---<h5><span class="code">Code:</span> #showAttribute(product.attributes,"manufacturerproductcode,supplierproductcode,productcode")#</h5>--->
			    </cfif>
			    <img src="/includes/images/companies/#product.site#/small.jpg" />    
			    <cfif StructKeyExists(product.attributes,"RRP") AND product.attributes.RRP neq ""><h4><span class="rrp">RRP:</span> &pound;#product.attributes.rrp#</h4></cfif>
			  </div>

      </div>
    </div>
  </div>
</div>
<cfset x++>
</cfloop>

</cfoutput>
