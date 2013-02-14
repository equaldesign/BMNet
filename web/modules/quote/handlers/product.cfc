
<cfcomponent output="false" autowire="true" cache="true">

	<!--- dependencies --->
	<cfproperty name="productService" inject="id:eunify.ProductService">
	<!--- preHandler --->

	<!--- index --->
	<cffunction cache="true" name="productDetail" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.product_code = event.getValue("product_code","");
			rc.product = productService.getProduct(rc.product_code);
			event.setView("products/detail");
		</cfscript>
	</cffunction>
</cfcomponent>