<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNetRead" />
  <cfproperty name="FeedService" inject="id:eunify.FeedService" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />
  <cfproperty name="PageService" inject="model:bmnet.modules.sums.model.PageService" />
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">
  <cfproperty name="logger" inject="logbox:root" />


  <cfproperty name="id" />
  <cfproperty name="Product_Code" />
  <cfproperty name="Full_Description" />
  <cfproperty name="List_Price" />
  <cfproperty name="Unit_of_Sale" />
  <cfproperty name="Retail_Price" />
  <cfproperty name="Unit_of_Price" />
  <cfproperty name="Trade" />
  <cfproperty name="Discount_Code" />
  <cfproperty name="StatusCode" />
  <cfproperty name="Status" />
  <cfproperty name="categoryID" />
  <cfproperty name="Description2" />
  <cfproperty name="Replacemnt_Cost_Base" />
  <cfproperty name="Discount_1" />
  <cfproperty name="Discount_2" />
  <cfproperty name="Discount_3" />
  <cfproperty name="Cost_Price" />
  <cfproperty name="Unit_of_Buy" />
  <cfproperty name="Unit_of_Cost" />
  <cfproperty name="Supplier_Code" />
  <cfproperty name="Weight" />
  <cfproperty name="Purchase_Text" />
  <cfproperty name="Manufacturers_Product_Code" />
  <cfproperty name="Key_Word_Search" />
  <cfproperty name="Web_Name" />
  <cfproperty name="web_description" />
  <cfproperty name="EANCode" />
  <cfproperty name="BVNodeRef" />
  <cfproperty name="BVImageNodeRef" />
  <cfproperty name="publicwebEnabled" />
  <cfproperty name="webEnabled" />
  <cfproperty name="web_price" />
  <cfproperty name="web_trade_price" />
  <cfproperty name="subunit" />
  <cfproperty name="subsperunit" />
  <cfproperty name="feature" />
  <cfproperty name="delivery_charge" />
  <cfproperty name="minimum_delivery_quantity" />
  <cfproperty name="minimum_delivery_quantity_trade" />
  <cfproperty name="minimum_delivery_quantity_unit" />
  <cfproperty name="minimum_delivery_quantity_trade_unit" />
  <cfproperty name="carrier_web" />
  <cfproperty name="carrier_trade" />
  <cfproperty name="delivery_charge_trade" />
  <cfproperty name="delivery_charge_value" />
  <cfproperty name="delivery_charge_value_trade" />
  <cfproperty name="delivery_time" />
  <cfproperty name="delivery_time_trade" />
  <cfproperty name="delivery_locations" />
  <cfproperty name="delivery_locations_trade" />
  <cfproperty name="delivery_location_value" />
  <cfproperty name="delivery_location_value_trade" />
  <cfproperty name="collectable" />
  <cfproperty name="special" />
  <cfproperty name="clearance" />
  <cfproperty name="bvSiteID" />
  <cfproperty name="pageslug" />
  <cfproperty name="keywords" />
  <cfproperty name="metadescription" />
  <cfproperty name="youTube" />

  <cfscript>
  	  function getUKPostcodeFirstPart(postcode) {
    // validate input parameters
    postcode = UCASE(postcode);

    // UK mainland / Channel Islands (simplified version, since we do not require to validate it)
    if (ReMatch('/^[A-Z]([A-Z]?\d(\d|[A-Z])?|\d[A-Z]?)\s*?\d[A-Z][A-Z]$/i', postcode))
        return ReReplace('/^([A-Z]([A-Z]?\d(\d|[A-Z])?|\d[A-Z]?))\s*?(\d[A-Z][A-Z])$/i', '$1',postcode);
    // British Forces
    if (ReMatch('/^(BFPO)\s*?(\d{1,4})$/i', postcode))
        return ReReplace('/^(BFPO)\s*?(\d{1,4})$/i', '$1', postcode);
    // overseas territories
    if (ReFind('/^(ASCN|BBND|BIQQ|FIQQ|PCRN|SIQQ|STHL|TDCU|TKCA)\s*?(1ZZ)$/i', postcode))
        return ReReplace('/^([A-Z]{4})\s*?(1ZZ)$/i', '$1', postcode);

    // well ... even other form of postcode... return it as is
    return postcode;
  }
  </cfscript>

  <cffunction name="applyToAll" returntype="void">
  	<cfargument name="productID" required="true">
	  <cfargument name="collectable" required="true">
	  <cfargument name="publicWebEnabled" required="true">
		<cfargument name="webEnabled" required="true">
		<cfargument name="delivery_time" required="true">
		<cfargument name="delivery_locations" required="true">
		<cfargument name="delivery_location_value" required="true">
		<cfargument name="carrier_web" required="true">
		<cfargument name="delivery_charge" required="true">
		<cfargument name="delivery_charge_value" required="true">
		<cfargument name="delivery_time_trade" required="true">
		<cfargument name="delivery_locations_trade" required="true">
		<cfargument name="delivery_location_value_trade" required="true">
		<cfargument name="carrier_trade" required="true">
		<cfargument name="delivery_charge_trade" required="true">
		<cfargument name="delivery_charge_value_trade" required="true">
		<cfargument name="minimum_delivery_quantity" required="true">
	  <cfargument name="minimum_delivery_quantity_trade" required="true">
    <cfargument name="minimum_delivery_quantity_unit" required="true">
    <cfargument name="minimum_delivery_quantity_trade_unit" required="true">
    <cfargument name="subunit" required="true">
    <cfargument name="subsperunit" required="true">
		<cfset var product = getProduct(arguments.productID,request.siteID)>
		<cfset var products = this.list(0,10000,0,"asc","",product.categoryID)>
		<cfset logger.debug("Apply to #products.recordCount# products")>
		<cfloop query="products">
			<cfset logger.debug("Apply to product: #product_code#")>
			<cfquery name="editProd" datasource="#dsn.getName()#">
				update Products set
				collectable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.collectable#">,
				publicWebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicWebEnabled#">,
				webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.webEnabled#">,
				delivery_time = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_time#">,
				delivery_locations = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_locations#">,
				delivery_location_value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_location_value#">,
				carrier_web = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrier_web#">,
				delivery_charge = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_charge#">,
				delivery_charge_value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_charge_value#">,
				delivery_time_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_time_trade#">,
				delivery_locations_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_locations_trade#">,
				delivery_location_value_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_location_value_trade#">,
				carrier_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.carrier_trade#">,
				delivery_charge_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_charge_trade#">,
				delivery_charge_value_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivery_charge_value_trade#">,
				minimum_delivery_quantity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.minimum_delivery_quantity#">,
				minimum_delivery_quantity_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.minimum_delivery_quantity_trade#">,
        minimum_delivery_quantity_unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.minimum_delivery_quantity_unit#">,
        minimum_delivery_quantity_trade_unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.minimum_delivery_quantity_trade_unit#">,
        subunit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subunit#">,
        subsperunit = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.subsperunit#">
				WHERE
				product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code#">
				AND
				siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
			</cfquery>
		</cfloop>
  </cffunction>

  <cffunction name="getCategoryBySlug" returntype="string">
    <cfargument name="slug" type="string" required="yes">

    <cfquery name="getCats" datasource="#dsnRead.getName()#">
      SELECT
        id
      FROM
        ProductCategory
      WHERE
        pageslug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slug#">
		  AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn getCats.id>
  </cffunction>

  <cffunction name="getCategorySlug" returntype="string">
    <cfargument name="categoryID" type="string" required="yes">

    <cfquery name="getCats" datasource="#dsnRead.getName()#">
      SELECT
        pageslug
      FROM
        ProductCategory
      WHERE
        id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn getCats.pageslug>
  </cffunction>

  <cffunction name="getCategories" returntype="query">
    <cfargument name="categoryID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">

    <cfquery name="getCats" datasource="#dsnRead.getName()#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
      SELECT
        *
      FROM
        ProductCategory
      WHERE
        parentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
      <cfif NOT isUserInAnyRole("trade,staff")>
      AND
      publicWebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
      </cfif>
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      order by _order;
    </cfquery>
    <cfreturn getCats>
  </cffunction>

  <cffunction name="getParentCategory" returntype="query">
    <cfargument name="categoryID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfquery name="getCats" datasource="#dsnRead.getName()#">
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

    <cfquery name="getCats" datasource="#dsnRead.getName()#">
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

  <cffunction name="breadcrumb" returntype="string" access="public" output="true">
    <cfargument name="categoryID" required="yes" type="string">
    <cfargument name="productID" required="no" type="string">
    <cfargument name="tree" required="true" default="">
	  <cfargument name="urlString" required="true" default="">
    <cfif tree eq "">
      <cfif isDefined('arguments.productID')>
        <cfset tP = getProduct(productID,request.siteID)>
        <cfif tP.Web_name neq "">
          <cfset tree = "<li>#lcase(tP.Web_name)#</li></ul>">
        <cfelse>
          <cfset tree = "<li>#lcase(tP.Full_description)#</li></ul>">
        </cfif>
        <cfset pagename = getParentCategory(categoryID,request.siteID)>
        <cfset tree = "<li><a href='/mxtra/shop/category/#getCategorySlug(arguments.categoryID)#?#arguments.urlString#'>#lcase(pagename.name)#</a><span class='divider'>/</span></li>" & tree>
      <cfelse>
        <cfset tree = "<li>#lcase(getCategoryName(categoryID,request.siteID))#</li></ul>">
      </cfif>
    </cfif>
    <cfset cat = getCategory(categoryID,request.siteID)>
    <cfset parentPage = getCategory(cat.parentID,request.siteID)>
    <cfif parentPage.id eq "" OR parentPage.id eq 0 OR parentPage.recordCount eq 0>
      <!--- we've reached the root --->
      <cfreturn "<ul class='breadcrumb'><li><a href='/'>Homepage</a><span class='divider'>/</span></li>#arguments.tree#">
    <cfelse>
      <cfset tree = "<li><a href='/mxtra/shop/category/#getCategorySlug(parentPage.id)#?#arguments.urlString#'>#lcase(parentPage.name)#</a><span class='divider'>/</span></li>" & tree>
      <cfreturn breadcrumb(categoryID=parentPage.id, tree=tree)>
    </cfif>
  </cffunction>

  <cffunction name="setAttribute" returntype="void">
    <cfargument name="product_code">
    <cfargument name="attribute">
    <cfargument name="value">
    <cfquery name="y" datasource="#dsn.getName()#">
      UPDATE
        Products
      SET
        #attribute# = '#value#'
      WHERE
        Product_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
  </cffunction>

  <cffunction name="categoryTraverse" returntype="array" access="public" output="true">
    <cfargument name="parentID" required="yes" type="string">
	  <cfargument name="categoryArray" required="yes" type="array" default="#ArrayNew(1)#" >
    <cfset ArrayAppend(arguments.categoryArray,arguments.parentID)>
    <cfset var children = getCategories(arguments.parentID,request.siteID)>
    <cfloop query="children">
		  <cfset ArrayAppend(arguments.categoryArray,id)>
		  <cfset arguments.categoryArray = categoryTraverse(id,arguments.categoryArray)>
	  </cfloop>
	  <cfreturn arguments.categoryArray>
  </cffunction>

  <cffunction name="categoryTraverseBackwards" returntype="array" access="public" output="true">
    <cfargument name="parentID" required="yes" type="string">
    <cfargument name="categoryArray" required="yes" type="array" default="#ArrayNew(1)#">
    <cfset ArrayAppend(arguments.categoryArray,arguments.parentID)>
    <cfset cat = getCategory(arguments.parentID,request.siteID)>
    <cfset parentPage = getCategory(cat.parentID,request.siteID)>
    <cfif parentPage.id eq "" OR parentPage.id eq 0 OR parentPage.recordCount eq 0>
      <cfreturn categoryArray>
    <cfelse>
      <cfreturn categoryTraverseBackwards(parentPage.id,categoryArray)>
    </cfif>
  </cffunction>

  <cffunction name="getProduct" returntype="query">
    <cfargument name="product_code" required="true">
    <cfargument name="siteID" type="numeric" required="yes" default="#request.siteID#">
    <cfargument name="slug" type="string" required="yes" default="">
    <cfquery name="p" datasource="#dsn.getName()#">
      select
	       Products.*,
	       unitType.display as unitDisplay,
	       company.bvsiteID as buildingVineID
	    from
	       Products LEFT JOIN company on (Products.Supplier_Code = company.account_number AND company.siteID =<cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">)
		   LEFT JOIN unitType ON (unitType.type = Products.Unit_of_Price AND unitType.siteID = Products.siteID)
	    where
	      <cfif arguments.slug neq "">
		  	 pageslug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.slug#">
		  	<cfelse>
	       product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.product_code#">
		    </cfif>
      AND
        Products.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">

    </cfquery>
    <cfreturn p>
  </cffunction>

  <cffunction name="getProductRanges" returntype="struct">
    <cfargument name="categoryID" type="string" required="yes">
	  <cfset var returnObject = {}>
    <cfquery name="brands" datasource="#dsnRead.getName()#">
      SELECT

			  company.name as brand,
			  company.account_number as brandID,
			  company.bvsiteID
			FROM
			  Products as P
        LEFT JOIN  company on (LPAD(company.account_number,7,'0000') = P.Supplier_Code  AND
      company.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">)
			WHERE
			  categoryID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#" list="true">)
			AND
			  P.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
			AND
			  publicwebEnabled = 'true'
			AND
			<cfif request.siteID eq 3>
			company.type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
			<cfelse>
			company.type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="2">
			</cfif>

			group by Supplier_Code
    </cfquery>
    <cfquery name="products" datasource="#dsnRead.getName()#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
      SELECT
        Retail_Price*1.2 as minPrice,
        Retail_Price*1.2 as maxPrice,
        categoryID,
        delivery_charge,
        collectable,
        delivery_locations
      FROM
        Products as P
      WHERE
        categoryID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#" list="true">)
      AND
        P.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      AND
        publicwebEnabled = 'true'
    </cfquery>

    <cfset returnObject.brands = brands>
	  <cfquery name="min" dbtype="query">select min(minPrice) as minP from products</cfquery>
	  <cfquery name="max" dbtype="query">select max(maxPrice) as maxP from products</cfquery>
	  <cfset returnObject.min = min.minP>
	  <cfset returnObject.max = max.maxP>
    <cfquery name="locations" dbtype="query">select delivery_locations as locations from products group by delivery_locations</cfquery>
    <cfset returnObject.locations = locations>
    <cfquery name="collectable" dbtype="query">select collectable as collectable from products group by collectable</cfquery>
    <cfset returnObject.collectable = collectable>
    <cfquery name="delivery_charge" dbtype="query">select delivery_charge as delivery_charge from products group by delivery_charge</cfquery>
    <cfset returnObject.delivery_charge = delivery_charge>
    <cfreturn returnObject>
  </cffunction>

  <cffunction name="getProducts" returntype="query">
    <cfargument name="categoryID" type="string" required="yes" default="">
    <cfargument name="sRow" type="numeric" required="yes" default="1">
    <cfargument name="maxRows" type="numeric" required="yes" default="25">
    <cfargument name="siteID" type="numeric" required="yes" default="#request.siteID#">
    <cfargument name="featured" type="boolean" required="yes" default="false">
    <cfquery name="products" datasource="#dsnRead.getName()#" result="executedQ">
      SELECT
        P.*,
        P.Full_Description as name,
        P.Retail_Price as price,
        U.display as unitDisplay,
        (SELECT count(*) from Invoice_Header where product_code = P.Product_Code) as salesQuantity
      FROM
        Products as P,
        unitType as U
      WHERE
        P.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      AND
      U.type = P.Unit_of_Price
      AND
      U.siteID = P.siteID
      <cfif arguments.categoryID neq "">
      AND
        categoryID IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#" list="true">)
      </cfif>

      <cfif arguments.featured>
      AND
      P.feature = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
      </cfif>
		  <cfif request.mxtra.filter.priceFrom neq "">
		  AND
		  P.Retail_Price > <cfqueryparam cfsqltype="cf_sql_float" value="#request.mxtra.filter.priceFrom#">
		  </cfif>
      <!--- collectable --->
      <cfif request.mxtra.filter.collectable neq "">
      AND
      P.collectable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.mxtra.filter.collectable#">
      </cfif>
      <!--- delivery charge --->
      <cfif request.mxtra.filter.delivery_charge neq "">
      AND
      P.delivery_charge IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.mxtra.filter.delivery_charge#">)
      </cfif>

      <!--- delivery locations --->
      <cfif request.mxtra.filter.delivery_locations neq "">
      AND
      P.delivery_locations IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.mxtra.filter.delivery_locations#">)
      </cfif>

      <cfif request.mxtra.filter.priceTo neq "">
      AND
      P.Retail_Price < <cfqueryparam cfsqltype="cf_sql_float" value="#request.mxtra.filter.priceTo#">
      </cfif>
      <cfif request.mxtra.filter.brands neq "" AND request.mxtra.filter.brands neq "brands" >
      AND
      TRIM(LEADING '0' FROM P.Supplier_Code) IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.mxtra.filter.brands#" list="true">)
      </cfif>
      AND
        <cfif isUSerInRole("trade")>
          webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        <cfelse>
          publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        </cfif>
        group by Product_Code
        order by salesQuantity desc, #request.mxtra.filter.orderBy# #request.mxtra.filter.orderDir#
        limit #sRow-1#,#maxRows#
    </cfquery>
    <cfreturn products>
  </cffunction>

  <cffunction name="getProductCount" returntype="numeric">
    <cfargument name="parentID" type="string" required="yes">
    <cfargument name="siteID" type="numeric" required="yes">

    <cfquery name="prod" datasource="#dsnRead.getName()#">
      SELECT
        count(*) as children
      FROM
        Products
      WHERE
        categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      <cfif request.mxtra.filter.priceFrom neq "">
      AND
      Retail_Price > <cfqueryparam cfsqltype="cf_sql_float" value="#request.mxtra.filter.priceFrom#">
      </cfif>
      <!--- collectable --->
      <cfif request.mxtra.filter.collectable neq "">
      AND
      collectable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.mxtra.filter.collectable#">
      </cfif>
      <!--- delivery charge --->
      <cfif request.mxtra.filter.delivery_charge neq "">
      AND
      delivery_charge IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.mxtra.filter.delivery_charge#">)
      </cfif>

      <!--- delivery locations --->
      <cfif request.mxtra.filter.delivery_locations neq "">
      AND
      delivery_locations IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.mxtra.filter.delivery_locations#">)
      </cfif>

      <cfif request.mxtra.filter.priceTo neq "">
      AND
      Retail_Price < <cfqueryparam cfsqltype="cf_sql_float" value="#request.mxtra.filter.priceTo#">
      </cfif>
      <cfif request.mxtra.filter.brands neq "" AND request.mxtra.filter.brands neq "brands" >
      AND
      TRIM(LEADING '0' FROM Supplier_Code) IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#request.mxtra.filter.brands#" list="true">)
      </cfif>
      AND
        <cfif isUserInRole("trade")>
          webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        <cfelse>
          publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        </cfif>
    </cfquery>
    <cfreturn prod.children>
  </cffunction>

  <cffunction name="getDeliveryCostForProduct" rreturntype="numeric">
  	<cfargument name="productWeight" required="true">
	  <cfargument name="carrierID" required="true">
	  <cfargument name="deliveryPostCode" required="true">
	  <cfquery name="p" datasource="#dsnRead.getName()#">
	  	select
		    price
		  from
		    shipping
		  WHERE
		    carrierID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.carrierID#">
		  AND
		  weight <= <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.productWeight#">
		  AND
		  postCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deliveryPostCode#">
		  LIMIT 0,1
	  </cfquery>
	  <cfreturn p.price>
  </cffunction>



  <cffunction name="getDeliveryCost" returntype="numeric">
    <cfargument name="productID" required="true" default="0">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfset var product = getProduct(arguments.productID,arguments.siteID)>
    <cfif isUserInRole("trade")>
      <cfif product.delivery_charge_trade eq "none">
        <cfreturn 0>
      <cfelseif product.delivery_charge_trade eq "fixed">
        <cfreturn product.delivery_charge_value_trade>
      <cfelse>
	  	  <cfif request.fullbasket.deliverypostcode neq "">
				  <cfreturn getDeliveryCostForProduct(product.weight,product.carrier_trade,request.fullbasket.deliverypostcode)>
				<cfelse>
          <!--- delivery cost is based on weight and delivery area --->
          <cfreturn 0>
		    </cfif>
      </cfif>
    <cfelse>
      <cfif product.delivery_charge eq "none">
        <cfreturn 0>
      <cfelseif product.delivery_charge eq "fixed">
        <cfreturn product.delivery_charge_value>
      <cfelse>
        <cfif request.fullbasket.deliverypostcode neq "">
          <cfreturn getDeliveryCostForProduct(product.weight,product.carrier_web,request.fullbasket.deliverypostcode)>
        <cfelse>
          <!--- delivery cost is based on weight and delivery area --->
          <cfreturn 0>
        </cfif>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="getavailableBranchStock" returntype="query">
    <cfargument name="productID" required="yes" type="string">
    <cfargument name="siteID" type="numeric" required="yes">
    <cfquery name="StockProducts" datasource="#dsnRead.getName()#">
      SELECT
        branch.name,
        branch.branch_ref as branchID,
        branch.id as realBranchID,
        stock.physical
      FROM
        stock,
        branch
      WHERE
        stock.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      AND
        stock.Product_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
      AND
        branch.branch_ref = stock.branchID
      AND
        stock.physical > 0
      AND
        stock.physical > stock.reserved
      group by branch.id order by physical  desc;
    </cfquery>
    <cfreturn StockProducts>
  </cffunction>

  <cffunction name="getProductPrice" returntype="numeric">
    <cfargument name="productID" type="string" required="yes">
    <cfargument name="siteID" type="string" required="yes">
    <cfset var product = getProduct(arguments.productID,arguments.siteID)>
    <cfif product.recordCount eq 0>
      <cfreturn 0>
    <cfelse>
      <cfif isUserInRole("trade")>
        <cfif product.web_trade_price neq "">
          <cfreturn web_trade_price>
        <cfelse>
          <cfreturn product.Trade>
        </cfif>
      <cfelse>
        <cfif product.web_price neq "">
          <cfreturn product.web_price>
        <cfelse>
          <cfreturn product.Retail_Price>
        </cfif>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="getCategory" returntype="query">
    <cfargument name="categoryID" required="true">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="p" datasource="#dsnRead.getName()#">
      select * from ProductCategory where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn p>
  </cffunction>

  <cffunction name="moveCategory" returntype="void">
    <cfargument name="sourceID" required="true">
    <cfargument name="targetID" required="true">
    <cfargument name="position" required="true">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <!--- move all the others up --->
    <cfquery name="u" datasource="#dsn.getName()#">
      update ProductCategory
      set
      _order = _order - 1
      WHERE
      parentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sourceID#">
      AND
      _order > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <!--- move all the others up --->
    <cfquery name="u" datasource="#dsn.getName()#">
      update ProductCategory
      set
      _order = _order + 1
      WHERE
      parentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.targetID#">
      AND
      _order > <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.position#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfquery name="p" datasource="#dsn.getName()#">
      update ProductCategory
      set parentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.targetID#">,
      _order = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.position+1#">
      where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sourceID#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
  </cffunction>

  <cffunction name="moveProduct" returntype="void">
    <cfargument name="categoryID" required="true">
    <cfargument name="productID" required="true">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="p" datasource="#dsn.getName()#">
      update Products
      set categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">
      where product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.productID#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
  </cffunction>

  <cffunction name="list" returntype="query" output="false">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfargument name="categoryID" required="true" type="string" default="0">
    <cfset var columnArray = ["product_code","full_description","retail_price","trade_price","cost_price","margin","eancode","BVNodeRef","webenabled","publicwebEnabled"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="l" datasource="#dsnRead.getName()#">
      select
        product_code,
        full_description,
        web_name,
        web_description,
        <cfif arguments.searchQuery neq "">
        MATCH (Full_Description,Manufacturers_Product_Code,EANCode,Product_Code) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#searchQuery#">) as score,
		    </cfif>
        manufacturers_product_code,
        retail_price,
        retail_price as Price,
        subunit,
        subsperunit,
        trade as trade_price,
        trade,
        ((retail_price - Cost_Price) / retail_price)*100 as margin,
        Cost_Price as cost_price,
        BVNodeRef,
        BVSiteID,
        BVApproved,
        web_price,
        web_trade_price,
        EANCode,
        webEnabled,
        publicwebEnabled,
        delivery_charge,
        delivery_charge_trade,
        delivery_charge_value,
        delivery_charge_value_trade,
        delivery_time,
        delivery_time_trade,
        collectable,
        U.display as unitDisplay,
        (SELECT count(*) from Invoice_Header where product_code = Products.Product_Code) as salesQuantity
      from
        Products LEFT JOIN unitType as U on (U.type = Products.Unit_of_Price AND U.siteID = Products.siteID)
        WHERE
        Products.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">

        <cfif arguments.searchQuery neq "">
        AND
        MATCH (Full_Description,Manufacturers_Product_Code,EANCode,Product_Code) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#searchQuery#">)
        </cfif>
        <cfif NOT getAuthUser() neq "">
         AND
			   publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
		    </cfif>
        <cfif arguments.categoryID neq "0">
          AND
          categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
        </cfif>
        order by <cfif arguments.searchQuery neq "">score desc<cfelse>#sortColName# #arguments.sortDir#</cfif>
        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>
    <cfreturn l>
  </cffunction>
  <cffunction name="updateBVNodeRef" returntype="void">
    <cfargument name="product_code">
    <cfargument name="nodeRef">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="u" datasource="#dsn.getName()#">
      update Products set BVNodeRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nodeRef#">
      WHERE
      product_code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
  </cffunction>
  <cffunction name="getUnSyncedProducts" returntype="query" output="false">
     <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="l" datasource="#dsnREad.getName()#">
      select
        *
      from
        Products
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        AND
        BVNodeRef is null
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="getUnitTypes" returntype="query" output="false">
    <cfquery name="l" datasource="#dsnREad.getName()#">
      select
        *
      from
        unitType
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="cCount" returntype="Numeric">
    <cfargument name="searchQuery" required="true" default="">
    <cfargument name="categoryID" required="true" default="">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="s" datasource="#dsnRead.getName()#">
      select count(product_Code) as records
      from
      Products
      WHERE
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      <cfif arguments.searchQuery neq "">
        AND
        (
        product_code like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        full_description like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
      </cfif>
      <cfif arguments.categoryID neq "0">
      AND
      categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
      </cfif>
    </cfquery>
    <cfreturn s.records>
  </cffunction>

  <cffunction name="categoryFind" returntype="array" access="public" output="true">
    <cfargument name="foundCategories" required="true" type="array" default="#ArrayNew(1)#">
    <cfargument name="subcategories" required="yes" type="array">
    <cfargument name="keys" required="yes" type="array">
    <cfloop array="#arguments.subcategories#" index="cat">
		  <cfset allSubs = categoryTraverse(cat)>
		  <cfloop array="#allSubs#" index="deep">
		  	<cfif arrayFind(arguments.keys,deep)>
		      <cfset arrayAppend(arguments.foundCategories,cat)>
		    </cfif>
		  </cfloop>
	  </cfloop>
    <cfreturn arguments.foundCategories>
  </cffunction>

  <cffunction name="categoryList" returntype="query">
    <cfargument name="parentID" required="true">
    <cfargument name="showTrade" required="true" default="false">
    <cfquery name="list" datasource="#dsn.getName()#">
      select
        ProductCategory.*,
        (select count(*) from Products where categoryID = ProductCategory.id) as children,
        (select count(*) from ProductCategory as subCat where subCat.parentID = ProductCategory.id) as childrenCats
      from
        ProductCategory
      where
        parentID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#parentID#">
		  <cfif NOT isUserInAnyRole("trade,staff")>
      AND
      publicWebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
      </cfif>
      <cfif not isUserInRole("staff") OR showTrade>
      AND
      webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
      </cfif>
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        order by _order
    </cfquery>
    <cfif request.mxtra.filter.priceFrom eq "" AND request.mxtra.filter.priceTo eq "" AND request.mxtra.filter.brands eq "">
      <cfreturn list>
	  <cfelse>
	  	<!--- we only want to show categories when they have categories or products matching the criteria. Here goes nothing! --->
		  <!--- first, we need a list of all the sub categories --->
		  <cfset allSubCategories = categoryTraverse(arguments.parentID)>
		  <!--- now we need a list of all products that match the criteria within these categories --->
		  <cfset filteredProducts = getProducts(sRow=1,categoryID=ArrayToList(allSubCategories),maxRows=10000,siteID=request.siteID)>
		  <!--- now we have an altered list of sub categories that only match the criteria --->
		  <cfset filteredSubCategories = ListToArray(ValueList(filteredProducts.categoryID))>
		  <!--- these are the immediate sub categories. We may need to remove a category here and there if the filter knocks them out --->
		  <cfset immediateSubCategories = ListToArray(ValueList(list.id))>
		  <cfset filteredImmediates = categoryFind(subcategories=immediateSubCategories,keys=filteredSubCategories)>
		  <cfquery name="newList" dbtype="query">
		  	select * from list where id IN (<cfqueryparam value="#ArrayToList(filteredImmediates)#" cfsqltype="cf_sql_varchar" list="true">)
		  </cfquery>
		  <cfreturn newList>
	  </cfif>
  </cffunction>

  <cffunction name="setCategoryImage" returntype="void">
  	<cfargument name="categoryID">
	  <cfargument name="nodeRef">
	  <cfset var category = getCategory(arguments.categoryID)>
	  <cfquery name="setIm" datasource="BMNet">
	  	update ProductCategory set BVNodeRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nodeRef#">
		  where
		  id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
		  AND
		  siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
	  </cfquery>
	  <cfif category.parentID neq 0>
	  	<cfset parent = getCategory(category.parentID)>
		  <cfif parent.recordCount neq 0>
		  	<cfset setCategoryImage(parent.id,arguments.nodeRef)>
		  </cfif>
	  </cfif>
  </cffunction>
  <cffunction name="getBVProductImages" returntype="void">
    <cfquery name="products" datasource="#dsnRead.getName()#">
		  select * from Products where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
	  </cfquery>
	  <cfloop query="products">
	  	  <cfhttp redirect="false" username="admin" password="bugg3rm33" result="pImage" url="http://46.51.188.170/alfresco/service/buildingvine/api/productSearch.json?doRedirect=false&eanCode=#EANCode#&supplierProductCode=#Manufacturers_Product_Code#&merchantCode=#Product_Code#&mimetype=image/jpeg&productName=#Full_Description#"></cfhttp>
	  	  <cftry>
				  <cfset imageresult = DeSerializeJSON(pIMage.fileContent)>
				  <cfif ArrayLen(imageresult) gte 1>
				  	<cfquery name="u" datasource="BMNet">
					  	update Products set BVImageNodeRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#imageresult[1].id#">
						  where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
					  </cfquery>
					  <cfset setCategoryImage(categoryID,imageresult[1].id)>
				  </cfif>
				<cfcatch type="any"><cfset logger.debug(cfcatch.message)></cfcatch>
			</cftry>
	  </cfloop>
	</cffunction>

  <cffunction name="renameCategory" returntype="void">
    <cfargument name="categoryID" required="true" default="0">
    <cfargument name="categoryName" required="true" default="">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="renameCat" datasource="#dsn.getName()#">
      update ProductCategory set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">
      WHERE
      id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
  </cffunction>

  <cffunction name="createCategory" returntype="string">
    <cfargument name="categoryParent" required="true">
    <cfargument name="categoryName" required="true">
    <cfset UID = createUuid()>
    <cfquery name="createCat" datasource="#dsn.getName()#">
      insert into ProductCategory (id,name,parentID,siteID)
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#UID#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryParent#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      )
    </cfquery>
    <cfreturn UID>
  </cffunction>

  <cffunction name="saveCategory" returntype="void">
    <cfargument name="categoryID" required="true">
    <cfargument name="parentID" required="true" default="0">
    <cfargument name="categoryName" required="true">
    <cfargument name="webEnabled" required="true">
    <cfargument name="publicwebEnabled" required="true">
    <cfargument name="oldID" required="true">
	  <cfargument name="description" rrequired="true">
	  <cfargument name="BVNodeRef" rrequired="true">
	  <cfargument name="pageslug" required="true">
    <cfif arguments.oldID neq 0>
      <cfquery name="createCat" datasource="#dsn.getName()#">
        update ProductCategory
        set
          id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">,
          name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">,
          webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.webEnabled#">,
          publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicwebEnabled#">,
		      description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
			    BVNodeRef = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.BVNodeRef#">,
				  pageslug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pageslug#">
        WHERE
          id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.oldID#">
      </cfquery>
    <cfelse>
      <!--- they're creating a new category ---->
      <cfquery name="createCat" datasource="#dsn.getName()#">
        insert into ProductCategory (id,name,parentID,webEnabled,publicWebEnabled,siteID,description,pageslug)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryName#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.parentID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.webEnabled#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.publicwebEnabled#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">,
		      <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
			    <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pageslug#">
        )
      </cfquery>
    </cfif>
  </cffunction>

  <cffunction name="deleteCategory" returntype="void">
    <cfargument name="categoryID" required="true">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
      <cfquery name="delCat" datasource="#dsn.getName()#">
        delete from ProductCategory
        WHERE
        id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.categoryID#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
  </cffunction>

  <cffunction name="save" returntype="void">
    <cfif this.getid() neq "">
      <cfquery name="s" datasource="#dsn.getName()#">
        UPDATE
          Products
        SET
          Product_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getProduct_Code()#">,
          Full_Description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getFull_Description()#">,
          <cfif this.getList_Price() neq "">
            List_Price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getList_Price()#">,
          </cfif>
          Unit_of_Sale = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Sale()#">,
          <cfif this.getRetail_Price() neq "">
            Retail_Price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getRetail_Price()#">,
          </cfif>
          Unit_of_Price = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Price()#">,
            <cfif this.getTrade() neq "">
          Trade = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getTrade()#">,
          </cfif>
          Discount_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_Code()#">,
          StatusCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getStatusCode()#">,
          Status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getStatus()#">,
          categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcategoryID()#">,
          Description2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDescription2()#">,
          <cfif this.getReplacemnt_Cost_Base() neq "">
            Replacemnt_Cost_Base = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getReplacemnt_Cost_Base()#">,
          </cfif>
          Discount_1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_1()#">,
          Discount_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_2()#">,
          Discount_3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_3()#">,
          <cfif this.getCost_Price() neq "">
            Cost_Price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getCost_Price()#">,
          </cfif>
          Unit_of_Buy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Buy()#">,
          Unit_of_Cost = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Cost()#">,
          Supplier_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSupplier_Code()#">,
          Weight = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getWeight()#">,
          Purchase_Text = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPurchase_Text()#">,
          Manufacturers_Product_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getManufacturers_Product_Code()#">,
          Key_Word_Search = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getKey_Word_Search()#">,
          Web_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getWeb_Name()#">,
          web_description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getweb_description()#">,
          EANCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getEANCode()#">,
          BVNodeRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getBVNodeRef()#">,
          BVImageNodeRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getBVImageNodeRef()#">,
          <cfif this.getfeature() neq "">
            feature = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getfeature()#">,
          <cfelse>
            feature = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>
          <cfif this.getpublicwebEnabled() neq "">
            publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpublicwebEnabled()#">,
          <cfelse>
            publicwebEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>

          <cfif this.getwebEnabled() neq "">
            webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getwebEnabled()#">,
          <cfelse>
            webEnabled = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>
          <cfif this.getweb_price() neq "">
            web_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getweb_price()#">,
          </cfif>
          <cfif this.getweb_trade_price() neq "">
            web_trade_price = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getweb_trade_price()#">,
          </cfif>
          subunit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsubunit()#">,
          <cfif this.getsubsperunit() neq "">
            subsperunit = <cfqueryparam cfsqltype="cf_sql_float" value="#this.getsubsperunit()#">,
          </cfif>
          <cfif this.getdelivery_charge() neq "">
            delivery_charge = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_charge()#">,
          <cfelse>
            delivery_charge = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>
          <cfif this.getminimum_delivery_quantity() neq "">
            minimum_delivery_quantity = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getminimum_delivery_quantity()#">,
          </cfif>
          <cfif this.getminimum_delivery_quantity_trade() neq "">
            minimum_delivery_quantity_trade = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getminimum_delivery_quantity_trade()#">,
          </cfif>
          minimum_delivery_quantity_unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getminimum_delivery_quantity_unit()#">,
          minimum_delivery_quantity_trade_unit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getminimum_delivery_quantity_trade_unit()#">,
          <cfif this.getcarrier_web() neq "">
            carrier_web = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcarrier_web()#">,
          </cfif>
          <cfif this.getcarrier_trade() neq "">
            carrier_trade = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcarrier_trade()#">,
          </cfif>
          <cfif this.getdelivery_charge_trade() neq "">
            delivery_charge_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_charge_trade()#">,
          <cfelse>
            delivery_charge_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>
          <cfif this.getdelivery_charge_value() neq "">
            delivery_charge_value = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getdelivery_charge_value()#">,
          </cfif>
          <cfif this.getdelivery_charge_value_trade() neq "">
            delivery_charge_value_trade = <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getdelivery_charge_value_trade()#">,
          </cfif>
          delivery_time = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_time()#">,
          delivery_time_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_time_trade()#">,
          <cfif this.getdelivery_locations() neq "">
            delivery_locations = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_locations()#">,
          <cfelse>
            delivery_locations = <cfqueryparam cfsqltype="cf_sql_varchar" value="radius">,
          </cfif>
          <cfif this.getdelivery_locations_trade() neq "">
            delivery_locations_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_locations_trade()#">,
          <cfelse>
            delivery_locations_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="radius">,
          </cfif>
          delivery_location_value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_location_value()#">,
          delivery_location_value_trade = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_location_value_trade()#">,
          <cfif this.getcollectable() neq "">
            collectable = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcollectable()#">,
          <cfelse>
            collectable = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>
          <cfif this.getspecial() neq "">
            special = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getspecial()#">,
          <cfelse>
            special = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>
          <cfif this.getclearance() neq "">
            clearance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getclearance()#">,
          <cfelse>
            clearance = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
          </cfif>
          bvSiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getbvSiteID()#">,
          pageslug = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpageslug()#">,
          keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getkeywords()#">,
          metadescription = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getmetadescription()#">,
          youTube = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getyouTube()#">
        WHERE
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
      </cfquery>
    <cfelse>
      <!--- we have to create the product --->
      <cfquery name="s" datasource="#dsn.getName()#">
        INSERT INTO
          Products
          (
            Product_Code,
            Full_Description,
            <cfif this.getList_Price() neq "">
            List_Price,
            </cfif>
            Unit_of_Sale,
            <cfif this.getRetail_Price() neq "">
            Retail_Price,
            </cfif>
            Unit_of_Price,
            <cfif this.getTrade() neq "">
            Trade,
            </cfif>
            Discount_Code,
            StatusCode,
            Status,
            categoryID,
            Description2,
            <cfif this.getReplacemnt_Cost_Base() neq "">
            Replacemnt_Cost_Base,
            </cfif>
            Discount_1,
            Discount_2,
            Discount_3,
            <cfif this.getCost_Price() neq "">
            Cost_Price,
            </cfif>
            Unit_of_Buy,
            Unit_of_Cost,
            Supplier_Code,
            Weight,
            Purchase_Text,
            Manufacturers_Product_Code,
            Key_Word_Search,
            Web_Name,
            web_description,
            EANCode,
            BVNodeRef,
            BVImageNodeRef,
            <cfif this.getpublicwebEnabled() neq "">
            publicwebEnabled,
            </cfif>
            <cfif this.getwebEnabled() neq "">
            webEnabled,
            </cfif>
            <cfif this.getweb_price() neq "">
            web_price,
            </cfif>
            <cfif this.getweb_trade_price() neq "">
            web_trade_price,
            </cfif>
            subunit,
            <cfif this.getsubsperunit() neq "">
            subsperunit,
            </cfif>
            delivery_charge,
            <cfif this.getminimum_delivery_quantity() neq "">
            minimum_delivery_quantity,
            </cfif>
            <cfif this.getminimum_delivery_quantity_trade() neq "">
            minimum_delivery_quantity_trade,
            </cfif>
            minimum_delivery_quantity_unit,
            minimum_delivery_quantity_trade_unit,
            <cfif this.getcarrier_web() neq "">
            carrier_web,
            </cfif>
            <cfif this.getcarrier_trade() neq "">
            carrier_trade,
            </cfif>
            delivery_charge_trade,
            <cfif this.getdelivery_charge_value() neq "">
            delivery_charge_value,
            </cfif>
            <cfif this.getdelivery_charge_value_trade() neq "">
            delivery_charge_value_trade,
            </cfif>
            delivery_time,
            delivery_time_trade,
            delivery_locations,
            delivery_locations_trade,
            delivery_location_value,
            delivery_location_value_trade,
            <cfif this.getcollectable() neq "">
            collectable,
            </cfif>
            <cfif this.getspecial() neq "">
            special,
            </cfif>
            <cfif this.getclearance() neq "">
            clearance,
            </cfif>
            bvSiteID,
            pageslug,
            keywords,
            metadescription,
            youTube,
            siteID
          )
          VALUES
          (

          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getProduct_Code()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getFull_Description()#">,
          <cfif this.getList_Price() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getList_Price()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Sale()#">,
          <cfif this.getRetail_Price() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getRetail_Price()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Price()#">,
          <cfif this.getTrade() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getTrade()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_Code()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getStatusCode()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getStatus()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcategoryID()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDescription2()#">,
          <cfif this.getReplacemnt_Cost_Base() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getReplacemnt_Cost_Base()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_1()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_2()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getDiscount_3()#">,
          <cfif this.getCost_Price() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getCost_Price()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Buy()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getUnit_of_Cost()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getSupplier_Code()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getWeight()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPurchase_Text()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getManufacturers_Product_Code()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getKey_Word_Search()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getWeb_Name()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getweb_description()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getEANCode()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getBVNodeRef()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getBVImageNodeRef()#">,
          <cfif this.getpublicwebEnabled() neq "">
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpublicwebEnabled()#">,
          </cfif>
          <cfif this.getwebEnabled() neq "">
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getwebEnabled()#">,
          </cfif>
          <cfif this.getweb_price() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getweb_price()#">,
          </cfif>
          <cfif this.getweb_trade_price() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getweb_trade_price()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsubunit()#">,
          <cfif this.getsubsperunit() neq "">
          <cfqueryparam cfsqltype="cf_sql_float" value="#this.getsubsperunit()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_charge()#">,
          <cfif this.getminimum_delivery_quantity() neq "">
          <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getminimum_delivery_quantity()#">,
          </cfif>
          <cfif this.getminimum_delivery_quantity_trade() neq "">
          <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getminimum_delivery_quantity_trade()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getminimum_delivery_quantity_unit()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getminimum_delivery_quantity_trade_unit()#">,
          <cfif this.getcarrier_web() neq "">
          <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcarrier_web()#">,
          </cfif>
          <cfif this.getcarrier_trade() neq "">
          <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcarrier_trade()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_charge_trade()#">,
          <cfif this.getdelivery_charge_value() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getdelivery_charge_value()#">,
          </cfif>
          <cfif this.getdelivery_charge_value_trade() neq "">
          <cfqueryparam cfsqltype="cf_sql_decimal" value="#this.getdelivery_charge_value_trade()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_time()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_time_trade()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_locations()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_locations_trade()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_location_value()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdelivery_location_value_trade()#">,
          <cfif this.getcollectable() neq "">
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcollectable()#">,
          </cfif>
          <cfif this.getspecial() neq "">
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getspecial()#">,
          </cfif>
          <cfif this.getclearance() neq "">
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getclearance()#">,
          </cfif>
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getbvSiteID()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpageslug()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getkeywords()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getmetadescription()#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getyouTube()#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        )
      </cfquery>
    </cfif>
    <cfset product = getProduct(this.getProduct_Code(),request.siteID)>
    <cfdump var="#product#"><cfabort>
    <cfset FeedService.createFeedItem(
      so = "user",
      soID = request.BMNet.contactID,
      to = "Products",
      tOID = product.id,
      action = "updateProduct"
    )>
  </cffunction>

  <cffunction name="getSpecials" returntype="query">
    <cfargument name="categoryID" type="string" required="false">
    <cfargument name="sRow" type="numeric" required="yes" default="1">
    <cfargument name="maxRows" type="numeric" required="yes" default="1000000">
    <cfargument name="siteID" type="numeric" required="yes" default="1">
    <cfargument name="priceFrom" type="string" required="yes" default="">
    <cfargument name="priceTo" type="string" required="yes" default="">
    <cfargument name="brands" type="string" required="yes" default="">
    <cfquery name="products" datasource="#dsnRead.getName()#">
      SELECT
        P.*,
        P.Full_Description as name,
        P.Retail_Price as price,
        U.display as unitDisplay,
        (SELECT count(*) from Invoice_Header where product_code = P.Product_Code) as salesQuantity
      FROM
        Products as P,
        unitType as U
      WHERE
        special = <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="true">
      AND
        P.siteID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#request.siteID#">
		  AND
		    U.type = P.Unit_of_Price
      AND
      U.siteID = P.siteID
      group by Product_Code
        order by salesQuantity desc, #CookieStorage.getVar("mxtra_orderBy","price")# #CookieStorage.getVar("mxtra_orderDir","asc")#
        limit #sRow-1#,#maxRows#
    </cfquery>
    <cfreturn products>
  </cffunction>

  <cffunction name="getCarriers" rreturntype="query">
  	<cfquery name="carriers" datasource="#dsnRead.getName()#">
      SELECT
        *
      FROM
        shippingCompany
      WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#request.siteID#">
    </cfquery>
    <cfreturn carriers>
  </cffunction>

  <cffunction name="getClearanceItems" returntype="query">
    <cfargument name="siteID" required="true" default="1">
    <cfquery name="products" datasource="#dsnRead.getName()#">
      SELECT
        P.*,
        P.Full_Description as name,
        U.display as unitDisplay
      FROM
        Products as P,
        unitType as U
      WHERE
        clearance = <cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="true">
      AND
        P.siteID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#request.siteID#">
		  AND
		    U.type = P.Unit_of_Price
      AND
      U.siteID = P.siteID
    </cfquery>
    <cfreturn products>
  </cffunction>


  <cffunction name="getProductMeta" returntype="struct">
    <cfargument name="productID" required="true">
    <cfargument name="idType" required="true" default="product">
    <cfargument name="mType" required="true" default="tabData">
    <cfset var returnStruct = {}>
    <cfif arguments.idType eq "product">
      <cfset var product = getProduct(arguments.productID,request.siteID)>
      <cfset rc.categoryID = product.categoryID>
    <cfelse>
      <cfset rc.categoryID = arguments.productID>
    </cfif>
    <cfif arguments.mType eq "tabData">
      <cfset var categories = categoryTraverseBackwards(rc.categoryID)>
      <cfset createObject("java", "java.util.Collections").reverse(categories)>
      <cfloop array="#categories#" index="i">
        <cfset rc.sumsURL = "sums/page/search?alf_ticket=#request.buildingVine.admin_ticket#&siteID=#request.bvsiteID#&search_key=ReferenceID.metaType&search_value=#i#.#arguments.mType#">
        <cfset rc.requestData = PageService.proxy(
          proxyurl=rc.sumsURL,
          formCollection={},
          method="get",
          JSONRequest=false,
          siteID = request.bvsiteID,
          jsonData = "",
          alf_ticket=request.buildingVine.admin_ticket
        )>
         <cfif isArray(rc.requestData) AND arrayLen(rc.requestData) gte 1>
          <cfloop array="#rc.requestData#" index="p">
            <cfset metaType = p.page.attributes.customProperties.metaType>
            <cfif NOT StructKeyExists(returnStruct,metaType)>
              <cfset returnStruct["#metaType#"] = ArrayNew(1)>
            </cfif>
            <cfset arrayAppend(returnStruct["#metaType#"],p.page.attributes)>
          </cfloop>
         </cfif>
      </cfloop>
    <cfelse>
      <!--- we don't want to travese backwards --->
      <cfset rc.sumsURL = "sums/page/search?alf_ticket=#request.buildingVine.admin_ticket#&siteID=#request.bvsiteID#&search_key=ReferenceID.metaType&search_value=#arguments.productID#.#arguments.mType#">
      <cfset rc.requestData = PageService.proxy(
        proxyurl=rc.sumsURL,
        formCollection={},
        method="get",
        JSONRequest=false,
        siteID = request.bvsiteID,
        jsonData = "",
        alf_ticket=request.buildingVine.admin_ticket
              )>
      <cfif isArray(rc.requestData) AND arrayLen(rc.requestData) gte 1>
        <cfloop array="#rc.requestData#" index="p">
          <cfset metaType = p.page.attributes.customProperties.metaType>
          <cfif NOT StructKeyExists(returnStruct,metaType)>
            <cfset returnStruct["#metaType#"] = ArrayNew(1)>
          </cfif>
          <cfset arrayAppend(returnStruct["#metaType#"],p.page.attributes)>
        </cfloop>
      </cfif>
    </cfif>
    <cfif arguments.idType eq "product">
      <cfset rc.sumsURL = "sums/page/search?alf_ticket=#request.buildingVine.admin_ticket#&siteID=#request.bvsiteID#&search_key=ReferenceID&search_value=#arguments.productID#">
      <cfset rc.requestData = PageService.proxy(
        proxyurl=rc.sumsURL,
        formCollection={},
        method="get",
        JSONRequest=false,
        siteID = request.bvsiteID,
        jsonData = "",
        alf_ticket=request.buildingVine.admin_ticket
      )>
       <cfif isArray(rc.requestData) AND  arrayLen(rc.requestData) gte 1>
        <cfloop array="#rc.requestData#" index="p">
          <cfset metaType = p.page.attributes.customProperties.metaType>
          <cfif NOT StructKeyExists(returnStruct,metaType)>
            <cfset returnStruct["#metaType#"] = ArrayNew(1)>
          </cfif>
          <cfset arrayAppend(returnStruct["#metaType#"],p.page.attributes)>
        </cfloop>
       </cfif>
    </cfif>
    <cfreturn returnStruct>
  </cffunction>




</cfcomponent>