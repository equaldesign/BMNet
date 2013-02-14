<cfcomponent name="products" hint="Deals with MerchantXtra Products" cache="true">
  <cfproperty name="SessionStorage" inject="coldbox:plugin:SessionStorage" />
  <cfproperty name="basket" inject="id:mxtra.basket" scope="instance" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />

  <cffunction name="getProducts" returntype="query">
    <cfargument name="categoryID" type="string" required="yes">
    <cfargument name="sRow" type="numeric" required="yes">
    <cfargument name="maxRows" type="numeric" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfquery name="products" datasource="BMNet">
      SELECT
        P.*,
        P.Full_Description as name,
        P.Retail_Price as price
      FROM
        Products as P
      WHERE
        categoryID =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
      AND
        P.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
        <cfif isUSerInRole("trade")>
          webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        <cfelse>
          publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        </cfif>
        group by Product_Code
        order by #CookieStorage.getVar("mxtra_orderBy","price")# #CookieStorage.getVar("mxtra_orderDir","asc")#
				limit #sRow-1#,#maxRows#
    </cfquery>
    <cfreturn products>
  </cffunction>

  <cffunction name="getSpecials" returntype="query">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfquery name="products" datasource="BMNet">
      SELECT
        P.*,
        P.Full_Description as name
      FROM
        Products as P
      WHERE
        special = <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="true">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.siteID#">
    </cfquery>
    <cfreturn products>
  </cffunction>

  <cffunction name="getClearance" returntype="query">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfquery name="products" datasource="BMNet">
      SELECT
        P.*,
        P.Full_Description as name
      FROM
        Products as P
      WHERE
        clearance = <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="true">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#arguments.siteID#">
    </cfquery>
    <cfreturn products>
  </cffunction>

  <cffunction name="getRecommendations" returntype="query">
    <cfargument name="productID" required="true">
    <cfset var mxtra = SessionStorage.getVar("mxtra")>
    <cfset var returnQuery = QueryNew("product_code,full_description,retail_price,trade_price,Manufacturers_Product_Code,EANCode")>
    <cfreturn returnQuery>
    <cfhttp port="8080" url="http://ec2-50-17-63-66.compute-1.amazonaws.com/easyrec-web/api/1.0/json/otherusersalsobought?&apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=bmnet_#mxtra.siteID#&itemid=#arguments.productID#" result="recommendations"></cfhttp>
    <cfset recommendations = DeSerializeJSON(recommendations.fileContent)>
    <cfif isDefined("recommendations.recommendeditems.item")>
    <cfloop array="#recommendations.recommendeditems.item#" index="i">
      <cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"product_code","#i.id#")>
      <cfset product = getProduct(i.id)>
      <cfset QuerySetCell(returnQuery,"full_description","#product.full_description#")>
      <cfset QuerySetCell(returnQuery,"retail_price","#product.retail_price#")>
      <cfset QuerySetCell(returnQuery,"trade_price","#product.trade#")>
      <cfset QuerySetCell(returnQuery,"Manufacturers_Product_Code","#product.Manufacturers_Product_Code#")>
      <cfset QuerySetCell(returnQuery,"EANCode","#product.EANCode#")>
    </cfloop>
    </cfif>
    <cfreturn returnQuery>
  </cffunction>

  <cffunction name="getProductPrice" returntype="numeric">
    <cfargument name="productID" type="string" required="yes">
    <cfset var mxtra = SessionStorage.getVar("mxtra")>

    <cfquery name="basket" datasource="BMNET">
      SELECT
        *
      FROM
        Products
      WHERE
        product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#">
      AND
        p.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.siteID#">
    </cfquery>
    <cfif prod.recordCount eq 0>
      <cfreturn 0>
    <cfelse>
      <cfif mxtra.account.trade eq "Y">
        <cfif web_trade_price neq "">
          <cfreturn web_trade_price>
        <cfelse>
          <cfreturn Trade>
        </cfif>
      <cfelse>
        <cfif web_price neq "">
          <cfreturn web_price>
        <cfelse>
          <cfreturn Retail_Price>
        </cfif>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="getProductCount" returntype="numeric">
    <cfargument name="parentID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">

    <cfquery name="prod" datasource="BMNET">
      SELECT
        count(*) as children
      FROM
        Products
      WHERE
        categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
        <cfif isUserInRole("trade")>
          webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        <cfelse>
          publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        </cfif>
    </cfquery>
    <cfreturn prod.children>
  </cffunction>

  <cffunction name="getProduct" returntype="query">
    <cfargument name="productID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfquery name="products" datasource="BMNet">
      SELECT
        *
      FROM
        Products
      WHERE
        product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
    </cfquery>
    <cfreturn products>
  </cffunction>



  <cffunction name="getavailableBranchStock" returntype="query">
    <cfargument name="productID" required="yes" type="string">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfset var product = getProduct(arguments.productID,arguments.siteID)>
    <cfquery name="StockProducts" datasource="BMNet">
      SELECT
        branch.name,
        branch.id as branchID,
        stock.physical
      FROM
        stock,
        branch
      WHERE
        stock.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
        stock.Product_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
      AND
        branch.id = stock.branchID
      AND
        stock.physical > 0
      AND
        stock.physical > stock.reserved
      group by branch.id order by physical  desc;
    </cfquery>
    <cfreturn StockProducts>
  </cffunction>

  <cffunction name="getDeliveryCost" returntype="numeric">
    <cfargument name="weight" required="true" default="0">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfset var mxtra = SessionStorage.getVar("mxtra")>
    <cfset var ret = StructNew()>

    <cfreturn trim(numberformat(17.50,"9999.00"))>
  </cffunction>

</cfcomponent>