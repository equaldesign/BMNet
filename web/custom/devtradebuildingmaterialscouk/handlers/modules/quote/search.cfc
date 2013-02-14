<cfcomponent output="false"  cache="true">

  <cfproperty name="ProductService" inject="id:bv.ProductService" />

	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfset rc.term = event.getValue('term','')>
    <cfset rc.results = productService.productSearch(rc.term,"",1,100000)>
<!--- 		<cfloop list="#rc.term#" index="q" delimiters=" ">
			<cfset rc.query = ListAppend(rc.query,"+#q#")>
		</cfloop>
		<cfsearch collection="bmnetproducts_#request.siteID#" name="results" criteria="#rc.query#">
		<cfset rc.results = results> --->
		<cfset event.setView(view="products/searchresults",noLayout="true")>
	</cffunction>

	</cfcomponent>