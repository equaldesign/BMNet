<cfset getMyPlugin(plugin="jQuery").getDepends("UISelect","secure/products/edit","secure/products/products,secure/products/#rc.buildingVine.productLayout#")>

<cfoutput>
 
  <cfif ArrayLen(rc.products.results) gte 1>
  <div class="row-fluid">
  	<div class="span4 pageCount">
      Showing #rc.products.startRow# to #rc.products.endRow# of #rc.products.products#
    </div>
		<div class="span8">
      #rc.paging.renderit(replace(rc.products.products,",",""),"/products/index/siteID/#rc.siteID#?nodeRef=#rc.nodeRef#&page=@page@","ajax")#
    </div>
  </div>
  </cfif>
<cfif ArrayLen(rc.products.categories) gte 1>
<cfif rc.nodeRef eq 0>
<div class="page-header">
  <h1>Product Categories</h1>
</div>	
<cfelse>
<div class="page-header"> 
  <h1>Sub Categories</h1>
</div>	
</cfif>
<div class="row-fluid">
	<div class="span12">  
	<cfloop array="#rc.products.categories#" index="item">	
		<div class="well">
	    <div class="row-fluid">
				<div class="span2 productImage">		    	
					<img class="catImage" src="https://www.buildingvine.com/api/productImage?categoryNodeRef=#item.NodeRef#&size=70" />
		      <cfif rc.siteManager>
		       <a href="##" class="refreshProductImage"></a>
		      </cfif>		      
		    </div>
				<div class="span10">
					<h2>
		          <a href="/products?nodeRef=#item.nodeRef#&siteID=#item.site#">            
		            #item.name#
		          </a>
		        </h2>
				</div> 
			</div>
		</div>	
  </cfloop>  
  </div>
</div>
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
<div class="row-fluid">
	<div class="span12">
		<cfloop array="#rc.products.results#" index="product">
		  <div class="well jstree-draggable">
		    <div rel="#product.nodeRef#" class="row-fluid">
		      <div class="span2 productImage">		   	    
			      <cfif ArrayLen(product.productImage) gte 1>
		          <img src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=70" />
		        <cfelse>
		          <img src="https://www.buildingvine.com/api/productImage?siteID=#rc.siteID#&eancode=#product.eancode#&size=70&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#" />
		        </cfif>
		        <cfif rc.siteManager>
		          <a href="##" class="refreshProductImage"></a>
		        </cfif>		        
		      </div>
		      <div class="span10">
		        <h2><a href="/products/productDetail?nodeRef=#product.nodeRef#&siteID=#rc.siteID#&page=#rc.page#" class="ajax">#product.title#</a></h2>
		        <cfif product.eanCode neq "">
		          <h5><span class="EAN">EAN:</span> #product.eancode#</h5>
		        <cfelse>
		          <!---<h5><span class="code">Code:</span> #showAttribute(product.attributes,"manufacturerproductcode,supplierproductcode,productcode")#</h5>--->
		        </cfif>
		        <cfif StructKeyExists(product.attributes,"RRP") AND product.attributes.RRP neq ""><h4><span class="rrp">RRP:</span> &pound;#product.attributes.rrp#</h4></cfif>
		      </div> 
		    </div>
		  </div>  
		  <cfset x++>
		</cfloop>    
  </div>
</div>
<cfif ArrayLen(rc.products.results) gte 1>
  <div class="row-fluid">
    <div class="span4 pageCount">
      Showing #rc.products.startRow# to #rc.products.endRow# of #rc.products.products#
    </div>
    <div class="span8">
      #rc.paging.renderit(replace(rc.products.products,",",""),"/products/index/siteID/#rc.siteID#?nodeRef=#rc.nodeRef#&page=@page@","ajax")#
    </div>
  </div>
  </cfif>
</cfoutput>
</div>