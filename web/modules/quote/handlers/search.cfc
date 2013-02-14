<cfcomponent output="false"  cache="true">

  <cfproperty name="ProductService" inject="id:eunify.ProductService" />

	<cffunction name="index" returntype="void" output="false">
		<cfargument name="event" required="true">
		<cfset var rc = event.getCollection()>
		<cfset rc.term = event.getValue('term','')>
    <cfset rc.results = productService.list(startRow=1,maxrow=10000,searchQuery=rc.term)>
		<cfset event.setView(view="products/searchresults",noLayout="true")>
	</cffunction>

	</cfcomponent>