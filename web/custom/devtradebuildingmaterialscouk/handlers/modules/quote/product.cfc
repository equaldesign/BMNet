
<cfcomponent output="false" autowire="true" cache="true">

	<!--- dependencies --->
	<cfproperty name="productService" inject="model:bvProductService">
	<!--- preHandler --->

	<!--- index --->
	<cffunction cache="true" name="productDetail" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.nodeRef = event.getValue("nodeRef","");
			rc.product = productService.productDetail(rc.nodeRef,"");

			rc.parents = [];
			var index = ArrayLen(rc.product.detail.parents);
			while (index>0) {
				ArrayAppend(rc.parents,"###rc.product.detail.parents[index]#");
				index--;
			}
			rc.amazonExists = false;
			if (isDefined("rc.product.amazon.mainProduct.ItemSearchResponse.Items.item")) {
			  if (ArrayLen(rc.product.amazon.mainProduct.ItemSearchResponse.Items.item) gte 1) {
			  	 rc.amazonExists = true;
			  	 rc.amazon = rc.product.amazon.mainProduct.ItemSearchResponse.Items.item[1];
			  	 rc.amazonRelated = rc.product.amazon.relatedProducts;
			  }
			}
			event.setView("products/detail");
		</cfscript>
	</cffunction>
</cfcomponent>