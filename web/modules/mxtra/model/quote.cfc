<cfcomponent name="quote" hint="Creates a template code" cache="true" cachetimeout="90">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="ProductService" inject="id:eunify.ProductService" />
  <cfproperty name="CompanyService" inject="id:eunify.CompanyService" />
  <cfproperty name="UserStorage" inject="coldbox:myplugin:UserStorage" />
  <cfproperty name="EcommerceService" inject="id:eunify.EcommerceService" />

  <cffunction name="empty" output="false">
    <cfset var quote = this.getVar("quote")>
    <cfset quote.items = ArrayNew(1)>
    <cfset setVar("quote",quote)>
  </cffunction>
  <cffunction name="startQuote" output="false">
  	<cfargument name="reference">
    <cfargument name="deliverydate">
    <cfargument name="contact">
    <cfargument name="deliveryAddress">
    <cfargument name="postCode">
    <cfargument name="phone">
    <cfargument name="delivered">
    <cfset var siteID = request.siteID>
	  <cfset var quote = getQuote()>
    <cfset customer = CompanyService.getCompany(account_number=request.bmnet.account_number,siteID=request.siteID)>
    <cfquery name="createQuote" datasource="BMNet">
      insert into shopOrder
        (deliveryContact,deliveryAddress,deliveryPostCode,deliveryPhone,deliveryDate,reference,delivered,quote,account_number,billingContact,billingEmail,siteID)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#contact#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#deliveryAddress#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#postCode#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#phone#">,
          <cfqueryparam cfsqltype="cf_sql_date" value="#deliverydate#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#reference#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivered#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#customer.account_number#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#customer.name#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#customer.company_email#">,
		      <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        )
    </cfquery>
    <cfquery name="qID" datasource="BMNet">
      select LAST_INSERT_ID() as id from shopOrder;
    </cfquery>
    <cfset quote.id = qID.id>
	  <cfset setVar("quote",quote)>
    <cfreturn qID.id>
  </cffunction>
  <cffunction name="add" returntype="void">
    <cfargument name="productID" required="true">
    <cfargument name="quantity" required="true">
    <cfset var quote = getVar("quote")>
    <cfset var currentQuantity = 0>
    <!--- see if the product is already in the quote --->
    <!--- loop over existing items in the quote --->
    <cfset var existingItem = false>
    <cfset var product = ProductService.getProduct(arguments.productID,request.siteID)>
    <cfset var productCost = 0>
    <cfset var deliveryCost = 0>
    <cfloop array="#quote.items#" index="item">
      <cfif item.productID eq productID>
        <cfset item.quantity+=arguments.quantity>
        <cfset existingItem = true>
      </cfif>
    </cfloop>
    <cfif NOT existingItem>
      <cfset productCost = ProductService.getProductPrice(productID,request.siteID)>
        <cfset deliveryCost = 0>
      <cfset arrayAppend(quote.items,{
        productID = arguments.productID,
        item=arguments.quantity,
        quantity=1,
        itemCost = productCost
      })>
      <cfset setVar("quote",quote)>
    </cfif>
  </cffunction>


  <cffunction name="setItems" returntype="void">
	  <!--- first delete any existing items --->
	  <cfquery name="r" datasource="BMNet">
	  	delete from shopOrderLine where shopOrderId = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.quote.id#">
	  </cfquery>
	  <cfloop array="#request.quote.items#" index="item">
	  	<cfquery name="d" datasource="BMNet">
		  	insert into shopOrderLine (shopOrderId,itemNo,quantity,quotedPriceEach,quotedPriceTotal)
			  VALUES
			  (<cfqueryparam cfsqltype="cf_sql_integer" value="#request.quote.id#">,
			  <cfqueryparam cfsqltype="cf_sql_varchar" value="#item.productID#">,
			  <cfqueryparam cfsqltype="cf_sql_integer" value="#item.quantity#">,
			  <cfqueryparam cfsqltype="cf_sql_float" value="#item.itemCost#">,
			  <cfqueryparam cfsqltype="cf_sql_float" value="#item.itemCost#">
			  )
		  </cfquery>
	  </cfloop>
  </cffunction>

  <cffunction name="getQuote" returntype="any" output="true">
  	<cfargument name="quoteID" required="true" default="0">
	  <cfset var quote = this.getVar("quote")>
	  <cfif arguments.quoteID eq 0 OR arguments.quoteID eq request.quote.ID>
      <cfreturn quote>
	  <cfelse>
	  	<cfset orderDetail = EcommerceService.getOrder(arguments.quoteID)>
		  <cfset quote.items = ArrayNew(1)>
		  <cfloop query="orderDetail">
		  	<cfset productCost = ProductService.getProductPrice(product_code,request.siteID)>
        <cfset deliveryCost = 0>
	      <cfset arrayAppend(quote.items,{
	        productID = product_code,
	        item=quantity,
	        quantity=1,
	        itemCost = productCost
	      })>
		  </cfloop>
		  <cfreturn quote>
	  </cfif>
  </cffunction>

  <cffunction name="continue" returntype="any" output="true">
    <cfargument name="quoteID" required="true" default="0">
    <cfset var quote = this.getVar("quote")>
    <cfset orderDetail = EcommerceService.getOrder(arguments.quoteID)>
    <cfset quote.id = orderDetail.id>
    <cfset quote.items = ArrayNew(1)>
	  <cfset this.setVar("quote",quote)>
    <cfloop query="orderDetail">
      <cfset productCost = ProductService.getProductPrice(product_code,request.siteID)>
      <cfset deliveryCost = 0>
      <cfset add(product_code,quantity)>
    </cfloop>
  </cffunction>

  <cffunction name="getOrder" returntype="any" output="false">
    <cfreturn this.getVar("order")>
  </cffunction>

  <cffunction name="getSize" returntype="numeric" output="false">
    <cfset var quoteItems = 0>
    <cfset var quote = getVar("quote")>
    <cfloop array="#quote.items#" index="i">
      <cfset quoteItems+=i.quantity>
    </cfloop>
    <cfreturn quoteItems>
  </cffunction>

  <cffunction name="getTotalPrice" returntype="numeric" output="false">
    <cfset var quoteCost = 0>
    <cfset var quote = this.getVar("quote")>
    <cfloop array="#quote.items#" index="i">
      <cfset quoteCost+=((i.itemCost)*i.quantity)>
    </cfloop>
    <cfreturn quoteCost>
  </cffunction>

  <cffunction name="setVar" access="public" returntype="void" hint="Set a new permanent variable." output="false">
    <!--- ************************************************************* --->
    <cfargument name="name"  type="string" required="true" hint="The name of the variable.">
    <cfargument name="value" type="any"    required="true" hint="The value to set in the variable.">
    <cfset UserStorage.setVar(arguments.name,arguments.value)>
  </cffunction>

  <cffunction name="getVar" access="public" returntype="any" hint="Get a new permanent variable. If the variable does not exist. The method returns blank." output="false">
    <!--- ************************************************************* --->
    <cfargument  name="name"    type="string"  required="true"    hint="The variable name to retrieve.">
    <cfargument  name="default"   type="any"     required="false"   hint="The default value to set. If not used, a blank is returned." default="">
    <cfreturn UserStorage.getVar(arguments.name)>
  </cffunction>
</cfcomponent>