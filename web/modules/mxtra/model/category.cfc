<cfcomponent name="category" hint="Deals with MerchantXtra Categories" cache="true">
  <cfproperty name="SessionStorage" inject="coldbox:plugin:SessionStorage" />
  <cfproperty name="product" inject="id:mxtra.products" />

  <cffunction name="getSubs" returntype="Query">
    <cfargument name="pID">
    <cfargument name="siteID">
    <cfset var  mxtra = SessionStorage.getVar("mxtra")>
    <cfquery name="children" datasource="BMNet">
      SELECT
        ProductCategory.id,
        ProductCategory.name,
        (
        select count(Products.product_code) as productCount
        FROM
        Products
        WHERE
        Products.categoryID = ProductCategory.id
        AND
        Products.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        <cfif isUserInRole("trade")>
          Products.webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        <cfelse>
          Products.publicWebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        </cfif>
        ) as productCount
      FROM
        ProductCategory
      WHERE
          ProductCategory.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        <cfif isUserInRole("trade")>
          ProductCategory.webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
          AND
        <cfelse>
          ProductCategory.publicWebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
          AND
        </cfif>
          ProductCategory.parentID = <cfqueryparam value="#pID#" cfsqltype="cf_sql_varchar">

    </cfquery>
    <cfreturn children>
  </cffunction>

  <cffunction name="getCategories" returntype="query">
    <cfargument name="categoryID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfset var  mxtra = SessionStorage.getVar("mxtra")>
    <cfquery name="getCats" datasource="BMNet">
      SELECT
        *
      FROM
        ProductCategory
      WHERE
        parentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
    </cfquery>
    <cfreturn getCats>
  </cffunction>

  <cffunction name="getParentCategory" returntype="query">
    <cfargument name="categoryID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">
   <cfset var mxtra = SessionStorage.getVar("mxtra")>
    <cfquery name="getCats" datasource="BMNet">
      SELECT
        *
      FROM
        ProductCategory
      WHERE
        id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
    </cfquery>
    <cfreturn getCats>
  </cffunction>
  <cffunction name="getCategoryName" returntype="string">
    <cfargument name="categoryID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">

    <cfquery name="getCats" datasource="BMNet">
      SELECT
        *
      FROM
        ProductCategory
      WHERE
        id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
    </cfquery>
    <cfreturn getCats.name>
  </cffunction>

  <cffunction name="catTree" returntype="string" access="public" output="false">
    <cfargument name="categoryID" required="yes" type="string">
    <cfargument name="tree" required="true" default="">
    <cfset var mxtra = SessionStorage.getVar("mxtra")>
    <cfif tree eq "">
        <cfset tree = getCategoryName(categoryID)>
    </cfif>
    <cfset parentPage = getCategories(arguments.categoryID)>
    <cfif parentPage.parentid eq "">
      <!--- we've reached the root --->
      <cfreturn Trim(tree)>
    <cfelse>
      <cfif name neq "">
        <cfset tree = "#name#/#tree#">
      <cfelse>
        <cfset tree = "#tree#">
      </cfif>
      <cfreturn catTree(parentPage.parentid,tree)>
    </cfif>
  </cffunction>

  <cffunction name="breadcrumb" returntype="string" access="public" output="true">
    <cfargument name="categoryID" required="yes" type="string">
    <cfargument name="productID" required="no" type="string">
    <cfargument name="tree" required="true" default="">
    <cfset var siteID = SessionStorage.getVar("mxtra")>
    <cfif tree eq "">
      <cfif isDefined('arguments.productID')>
        <cfset tree = "<li>#product.getProduct(productID,request.siteID).Full_description#</li></ul>">
        <cfset pagename = getParentCategory(categoryID,request.siteID)>
        <cfset tree = "<li><a href='/mxtra/shop/category?categoryID=#categoryID#'>#pagename.name#</a></li><span class='divider'>/</span>" & tree>
      <cfelse>
        <cfset tree = "<li>#getCategoryName(categoryID,request.siteID)#</li></ul>">
      </cfif>
    </cfif>
    <cfset parentPage = getCategories(arguments.categoryID,request.siteID)>
    <cfif parentPage.parentid eq "" OR parentPage.parentid eq 0 OR parentPage.recordCount eq 0>
      <!--- we've reached the root --->
      <cfreturn "<ul class='breadcrumb'>#arguments.tree#">
    <cfelse>
      <cfset pagename = getParentCategory(categoryID,request.siteID)>
      <cfset tree = "<li><a href='/mxtra/shop/category?categoryID=#parentPage.parentid#'>#pagename.name#</a></li><span class='divider'>/</span>" & tree>
      <cfreturn breadcrumb(categoryID=parentPage.parentid, tree=tree)>
    </cfif>
  </cffunction>
</cfcomponent>