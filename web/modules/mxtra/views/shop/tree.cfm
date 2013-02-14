<cffunction name="breadcrumb" returntype="string" access="public" output="true">
  <cfargument name="categoryID" required="yes" type="string">
  <cfargument name="productID" required="no" type="string">
	<cfif NOT isDefined('variables.tree')>
  	<cfif isDefined('arguments.productID')>
	    <cfset variables.tree = "#session.mxtra_shop.product.getProductName(productID)#">
      <cfquery name="pagename" datasource="#session.mxtra_datasource#">
				select name from ProductCategory where id = '#categoryID#';
			</cfquery>
      <cfset variables.tree = "<a href='/mxtra/shop/category?categoryID=#categoryID#' class='breadcrumb'>#pagename.name#</a> &raquo;&nbsp;" & variables.tree>
    <cfelse>
			<cfset variables.tree = "#session.mxtra_shop.category.getCategoryName(categoryID)#">
    </cfif>
	</cfif>
	<cfquery name="parentPage" datasource="#session.mxtra_datasource#">
		select parentid from ProductCategory where id = '#arguments.categoryID#';
	</cfquery>
	<cfif parentPage.parentid eq "">
		<!--- we've reached the root --->
		<cfreturn tree>
	<cfelse>
		<cfquery name="pagename" datasource="#session.mxtra_datasource#">
			select name from ProductCategory where id = '#parentPage.parentid#';
		</cfquery>
			<cfset variables.tree = "<a href='/mxtra/shop/category?categoryID=#parentPage.parentid#' class='breadcrumb'>#pagename.name#</a> &raquo;&nbsp;" & variables.tree>
		<cfreturn breadcrumb(parentPage.parentid)>
	</cfif>
</cffunction>
You are here: 