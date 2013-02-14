<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
  <cfproperty name="ProductService" inject="id:eunify.ProductService">
  <cffunction name="getrecommendationsforuser" returntype="query">
    <cfargument name="account_number" required="true">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfset var returnQuery = QueryNew("product_code,full_description,retail_price,trade_price,Manufacturers_Product_Code,EANCode")>
    <cftry>
    <cfhttp port="8080" url="http://46.51.188.170/easyrec-web/api/1.0/json/recommendationsforuser?&apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=bmnet_#request.siteID#&userid=#arguments.account_number#&requesteditemtype=ITEM&actiontype=BUY" result="recommendations"></cfhttp>
    <cfset recommendations = DeSerializeJSON(recommendations.fileContent)>
    <cfloop array="#recommendations.recommendeditems.item#" index="i">
      <cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"product_code","#i.id#")>
      <cfset product = ProductService.getProduct(i.id)>
      <cfset QuerySetCell(returnQuery,"full_description","#product.full_description#")>
      <cfset QuerySetCell(returnQuery,"retail_price","#product.retail_price#")>
      <cfset QuerySetCell(returnQuery,"trade_price","#product.trade#")>
      <cfset QuerySetCell(returnQuery,"Manufacturers_Product_Code","#product.Manufacturers_Product_Code#")>
      <cfset QuerySetCell(returnQuery,"EANCode","#product.EANCode#")>
    </cfloop>
    <cfcatch type="any"></cfcatch>
    </cftry>
    <cfreturn returnQuery>
  </cffunction>

  <cffunction name="sendBuyAction" returntype="void">
    <cfargument name="invoice_number">
    <cfargument name="product_code">
    <cfargument name="full_description">
    <cfargument name="itemurl">
    <cfargument name="account_number">

    <cfhttp url="http://46.51.188.170/easyrec-web/api/1.0/buy?apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=bmnet_#request.siteID#&itemid=#arguments.product_code#&sessionid=#arguments.invoice_number#&userid=#arguments.account_number#">
  </cffunction>

   <cffunction name="getproductRecommendations" returntype="query">
    <cfargument name="productID" required="true">
    <cfargument name="siteID" required="true">
    <cfset var returnQuery = QueryNew("product_code,full_description,retail_price,trade_price,Manufacturers_Product_Code,EANCode")>
	      <cfhttp throwonerror="true" port="8080" timeout="3" url="http://46.51.188.170/easyrec-web/api/1.0/json/otherusersalsobought?&apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=bmnet_#request.siteID#&itemid=#arguments.productID#" result="recommendations"></cfhttp>
    <cfset recommendations = DeSerializeJSON(recommendations.fileContent)>
    <cfif isDefined("recommendations.recommendeditems.item") and isArray(recommendations.recommendeditems.item)>
    <cfloop array="#recommendations.recommendeditems.item#" index="i">
      <cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"product_code","#i.id#")>
      <cfset product = ProductService.getProduct(i.id,request.siteID)>
      <cfset QuerySetCell(returnQuery,"full_description","#product.full_description#")>
      <cfset QuerySetCell(returnQuery,"retail_price","#product.retail_price#")>
      <cfset QuerySetCell(returnQuery,"trade_price","#product.trade#")>
      <cfset QuerySetCell(returnQuery,"Manufacturers_Product_Code","#product.Manufacturers_Product_Code#")>
      <cfset QuerySetCell(returnQuery,"EANCode","#product.EANCode#")>
    </cfloop>
    </cfif>
    <cfreturn returnQuery>
  </cffunction>
</cfcomponent>