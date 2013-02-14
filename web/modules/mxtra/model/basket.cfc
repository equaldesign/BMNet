<cfcomponent name="basket" hint="Creates a template code" cache="true" cachetimeout="90">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="ProductService" inject="id:eunify.ProductService" />
  <cfproperty name="logger" inject="logbox:root" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />

  <cffunction name="isDelivered" returntype="boolean">
    <cfset basket = getBasket()>
    <cfquery name="d" datasource="#dsn.getName()#">
      select id from basketItems where basketID = <cfqueryparam cfsqltype="cf_sql_integer" value="#basket.id#">
      AND
      delivered = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
    </cfquery>
    <cfif d.recordCount neq 0>
      <cfreturn true>
    <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="basketExists">
    <cfargument name="basketID">
    <cfquery name="e" datasource="#dsn.getName()#">
      select id from basket where cookie_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.basketID#">
    </cfquery>
    <cfif e.recordCount eq 0>
      <cfquery name="a" datasource="#dsn.getName()#">
        insert into basket (cookie_id,siteID,companyID)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.basketID#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.companyID#">
        )
      </cfquery>
      <cfquery name="a" datasource="#dsn.getName()#">
        select last_insert_id() as nID from basket where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
      <cfreturn a.nID>
    <cfelse>
      <cfreturn e.id>
    </cfif>
  </cffunction>

  <cffunction name="empty" output="false">
    <cfset var basketID = CookieStorage.getVar("basketID",CookieStorage.setVar(name="basketID",value=createUUID(),expires=expires=DateAdd("h", 12, now())))>
    <cfset basket = getBasket(basketID)>
    <cfquery name="e" datasource="#dsn.getName()#">
      delete from basketItems where basketID = <cfqueryparam cfsqltype="cf_sql_integer" value="#basket.id#">
    </cfquery>
  </cffunction>

  <cffunction name="add" returntype="void">
    <cfargument name="product_code" required="true">
    <cfargument name="quantity" required="true">
    <cfargument name="delivered" type="boolean" required="true" default="false">
    <cfargument name="collectionBranch" required="true" default="0">
    <cfargument name="siteID" required="true">
    <cfset var mxtra = request.mxtra>
    <cfset var currentQuantity = 0>
    <cfset var existingItem = false>
    <cfset var product = ProductService.getProduct(arguments.product_code,arguments.siteID)>
    <cfset var productCost = 0>
    <cfset var deliveryCost = 0>
    <cfif arguments.collectionBranch eq 0>
      <cfset arguments.delivered = true>
    </cfif>
    <cfif CookieStorage.getVar("basketID","") eq "">
      <cfset request.mxtra.basket.ID = createUUID()>
      <cfset CookieStorage.setVar(name="basketID",value=request.mxtra.basket.ID,expires=expires=DateAdd("h", 24, now()))>
      <cfset UserStorage.setVar("mxtra",request.mxtra)>
    <cfelseif CookieStorage.getVar("basketID","") neq request.mxtra.basket.ID>
      <cfset request.mxtra.basket.ID = CookieStorage.getVar("basketID","")>
      <cfset UserStorage.setVar("mxtra",request.mxtra)>
    </cfif>

    <cfset basket = getBasket()>
    <cfif basket.recordCount eq 0>
      <cfset var basketID = basketExists(request.mxtra.basket.ID)>
    <cfelse>
      <cfset var basketID = basket.id>
    </cfif>
    <cfif NOT hasItemInBasket(basket.id,product_code)>
      <cfset productCost = ProductService.getProductPrice(product_code,arguments.siteID)>
      <cfif arguments.delivered>
        <cfset deliveryCost = ProductService.getDeliveryCost(product_code,arguments.siteID)>
      <cfelse>
        <cfset deliveryCost = 0>
      </cfif>
      <cfquery name="n" datasource="#dsn.getName()#">
        insert into basketItems
          (basketID,product_code,quantity,item_cost,delivered,branchID,delivery_cost)
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#basketID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#productCost#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivered#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.collectionBranch#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#deliveryCost#">
          )
      </cfquery>
    <cfelse>
      <cfset updateQuantity(basket.id,product_code,arguments.quantity,true)>
    </cfif>
  </cffunction>

  <cffunction name="hasItemInBasket" returntype="boolean">
    <cfargument name="basketID">
    <cfargument name="product_code">
    <cfquery name="items" datasource="#dsn.getName()#">
      select id from basketItems where basketID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.basketID#">
      AND
      product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">
    </cfquery>
    <cfif items.recordCount eq 0>
      <cfreturn false>
    <cfelse>
      <cfreturn true>
    </cfif>
  </cffunction>

  <cffunction name="updateQuantity">
    <cfargument name="basketID" required="true">
    <cfargument name="product_code" required="true">
    <cfargument name="quantity" required="true">
    <cfargument name="increment" default="false" required="true">
    <cfif quantity eq 0>
        <cfquery name="a" datasource="#dsn.getName()#">
          delete from basketItems where basketID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.basketID#">
          AND
          product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">
        </cfquery>
    <cfelse>
      <cfquery name="u" datasource="#dsn.getName()#">
        update basketItems set quantity =
        <cfif arguments.increment>
          quantity + #arguments.quantity#
        <cfelse>
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quantity#">
        </cfif>
        WHERE
        basketItems.basketID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.basketID#">
        AND
        product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">
      </cfquery>

    </cfif>
  </cffunction>

  <cffunction name="getBasket" returntype="any" output="false">
    <cfquery name="b" datasource="#dsn.getName()#">
      select
        basket.id,
        basket.sale,
        basket.companyID,
        basketItems.product_code,
        basketItems.quantity,
        basketItems.item_cost,
        basketItems.line_cost,
        basketItems.delivered,
        basketItems.branchID,
        basketItems.delivery_cost
      FROM
        basket,
        basketItems
      WHERE
        basket.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        AND
        basket.cookie_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.mxtra.basket.ID#">
        AND
        basketItems.basketID = basket.id
    </cfquery>
    <cfreturn b>
  </cffunction>





  <cffunction name="getSize" returntype="numeric" output="false">
    <cfset b = getBasket()>
    <cfquery name="a" dbtype="query">
      select SUM(quantity) as q from b
    </cfquery>
    <cfif a.q eq "">
      <cfreturn 0>
    </cfif>
    <cfreturn a.q>
  </cffunction>

  <cffunction name="getTotalPrice" returntype="numeric" output="false">
    <cftry>
    <cfquery name="d" datasource="#dsn.getName()#">
      select
        SUM(((basketItems.item_cost*1.2)+basketItems.delivery_cost)*basketItems.quantity) as cost
      from
        basket,
        basketItems
        where
        basket.cookie_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.mxtra.basket.ID#">
        AND
        basketItems.basketID = basket.id
    </cfquery>
    <cfif d.recordCount eq 0 OR d.cost eq "">
      <cfreturn 0>
    <cfelse>
      <cfreturn d.cost>
    </cfif>
    <cfcatch type="any">
      <cfreturn 0>
    </cfcatch>
    </cftry>
  </cffunction>

</cfcomponent>