
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="invoice" inject="id:eunify.InvoiceService">
  <cfproperty name="sales" inject="id:eunify.SalesService">
  <cfproperty name="RecommendationService" inject="id:eunify.RecommendationService">
  <cfproperty name="bvProductService" inject="id:bv.ProductService">
  <cfproperty name="ProductService" inject="id:eunify.ProductService">
  <cfproperty name="ImportService" inject="id:eunify.ImportService">
  <cfproperty name="CustomerService" inject="id:eunify.CompanyService">
  <cfproperty name="Paging" inject="coldbox:myPlugin:Paging">
  <cfproperty name="eGroupCompany" inject="id:eGroup.company">
  <cfproperty name="eGroupPSA" inject="id:eGroup.psa">
  <cfproperty name="populator" inject="wirebox:populator">
  <!--- preHandler --->

  <!--- index --->
    <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.categoryID = event.getValue("categoryID",0);
      event.setView("products/list");
    </cfscript>
  </cffunction>

  <cffunction name="setAttribute" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset ProductService.setAttribute(rc.product_code,rc.attribute,rc.value)>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="searchIndex" rreturntype="void">
  	<cfargument name="event">
	  <cfset var rc = event.getCollection()>
	  <cfset rc.products = ProductService.list(maxrow=100000)>
	  <cfindex
      query="rc.products"
	    collection="bmnetproducts_#request.siteID#"
	    action="Update"
	    type="Custom"
	    key="product_code"
	    title="Full_Description"
		  custom1="product_code"
			custom2="unitDisplay"
			custom3="EANCode"
      custom4="Manufacturers_Product_Code"
	    body="product_code,Full_Description,EANCode,Manufacturers_Product_Code,unitDisplay">
  </cffunction>


  <cffunction name="applyToAll" returntype="void" output="false">
  	<cfargument name="event">
	  <cfset var rc = event.getCollection()>
	  <cfset ProductService.applyToAll(
	   event.getValue("productID",""),
	   event.getValue("collectable",""),
	   event.getValue("publicWebEnabled",""),
	   event.getValue("webEnabled",""),
	   event.getValue("delivery_time",""),
	   event.getValue("delivery_locations",""),
	   event.getValue("delivery_location_value",""),
	   event.getValue("carrier_web",""),
	   event.getValue("delivery_charge",""),
	   event.getValue("delivery_charge_value",""),
	   event.getValue("delivery_time_trade",""),
	   event.getValue("delivery_locations_trade",""),
	   event.getValue("delivery_location_value_trade",""),
	   event.getValue("carrier_trade",""),
	   event.getValue("delivery_charge_trade",""),
	   event.getValue("delivery_charge_value_trade",""),
	   event.getValue("minimum_delivery_quantity",""),
	   event.getValue("minimum_delivery_quantity_trade",""),
     event.getValue("minimum_delivery_quantity_unit",""),
     event.getValue("minimum_delivery_quantity_trade_unit",""),
     event.getValue("subunit",""),
     event.getValue("subsperunit",0)
	  )>
	  <cfset event.setView("blank")>
  </cffunction>

  <cffunction cache="true" name="overview" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.product_code = event.getValue("id",0);

      rc.unitTypes = ProductService.getUnitTypes();
      rc.product = ProductService.getProduct(rc.product_code,request.siteID);
      rc.sectionHeader = rc.product.full_description;
      rc.carriers = ProductService.getCarriers();
      try {
        if (rc.product.BVNodeRef neq "") {
          rc.bvProduct = bvProductService.productDetail(rc.product.BVNodeRef);
          rc.eGroup.company = eGroupCompany.getCompanyByBVSiteID(rc.bvProduct.detail.site);
          rc.eGroup.PSAs = eGroupPSA.getArrangementBySupplier(supplierID=rc.eGroup.company,toDate=now());
        }
      } catch (e Any) {

      }
      event.setView("products/overview");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="detail" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.product_code = event.getValue("id",0);

      rc.unitTypes = ProductService.getUnitTypes();
      rc.product = ProductService.getProduct(rc.product_code,request.siteID);
      rc.sectionHeader = rc.product.full_description;
      try {
        if (rc.product.BVNodeRef neq "") {
          rc.bvProduct = bvProductService.productDetail(rc.product.BVNodeRef);
          rc.eGroup.company = eGroupCompany.getCompanyByBVSiteID(rc.bvProduct.detail.site);
          rc.eGroup.PSAs = eGroupPSA.getArrangementBySupplier(supplierID=rc.eGroup.company,toDate=now());
        }
      } catch (e Any) {

      }
      event.setView("products/index");
    </cfscript>
  </cffunction>

  <cffunction name="add">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
  </cffunction>

  <cffunction cache="true" name="bvsearch" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.product_code = event.getValue("id",0);
      rc.product = ProductService.getProduct(rc.product_code,request.siteID);
      if (rc.product.eancode neq "") {
        rc.q = rc.product.eancode;
      } else if (rc.product.Manufacturers_Product_Code neq ""){
        rc.q = Manufacturers_Product_Code;
      } else {
        rc.q = ListFirst(rc.product.Key_Word_Search,";");
      }
      rc.bvProduct = bvProductService.productSearch(rc.q);
      event.setView("products/bvsearch");
    </cfscript>
  </cffunction>

  <cffunction cache="false" name="edit" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.type = event.getValue("type","detail");
      rc.product_code = event.getValue("id",0);
      rc.product = ProductService.getProduct(rc.product_code,request.siteID);
      rc.carriers = ProductService.getCarriers();
      event.setView("products/edit/index");
    </cfscript>
  </cffunction>


  <cffunction cache="false" name="list" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.categoryID = event.getValue("categoryID",0);
      rc.sortColumn = event.getValue("iSortCol_0",0);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.ProductCount = ProductService.cCount(rc.searchQuery,rc.categoryID);
      rc.ProductData = ProductService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery,rc.categoryID);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["aoColumns"] = [
            {"bVisible" = false, "aTargets" = [0]},
            {"bVisible" = false, "aTargets" = [1]},
            {"bVisible" = true, "bSortable" = false, "aTargets"= [2]},
            {"sTitle" = "Products Code"},
            {"sTitle" = "Description"},
            {"sTitle" = "Retail Price"},
            {"sTitle" = "Trade Price"},
            {"sTitle" = "BV"},
            {"sTitle" = "Web"},
            {"sTitle" = "Public"}
      ];
      rc.json["iTotalRecords"] = rc.ProductCount;
      rc.json["iTotalDisplayRecords"] = rc.ProductCount;

      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.ProductData">
      <cfset thisRow = [
        '#BVNodeRef#',
        '<i class="icon-arrow-move jstree-draggable" rel="#product_code#"></i>',
        "<a href='/eunify/products/detail?id=#product_code#'>#product_code#</a>",
        "<a href='/eunify/products/detail?id=#product_code#'>#full_description#</a>",
        "#retail_price#",
        "#trade_price#",
        "<a href='##' class='getBV' data-product_code='#product_code#' data-bvNode='#BVNodeRef#' data-ean='#EANCode#' data-mpc='#manufacturers_product_code#'>#IIf(BVNodeRef neq '',"'<i class=""icon-tick-circle-frame""></i>'","'<i class=""icon-cross-circle-frame""></i>'")#</a>",
        "<a href='##' class='approveBV' data-bvapproved='#BVApproved#'>#IIf(BVApproved,"'<i class=""icon-tick-circle-frame""></i>'","'<i class=""icon-cross-circle-frame""></i>'")#</a>",
        "<a href='##' data-trade-enabled='#webEnabled#' class='tradeEnable' data-product_code='#product_code#'>#IIf(webEnabled eq 'true',"'<i class=""icon-tick-circle-frame""></i>'","'<i class=""icon-cross-circle-frame""></i>'")#</a>",
        "<a href='##' data-public-web-enabled='#publicwebEnabled#' class='webEnable' data-product_code='#product_code#'>#IIf(publicwebEnabled eq 'true',"'<i class=""icon-tick-circle-frame""></i>'","'<i class=""icon-cross-circle-frame""></i>'")#</a>"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>

  <cffunction cache="true" name="view" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.boundaries = Paging.getBoundaries();
      rc.boundaries = Paging.getBoundaries();
      rc.startRow = rc.boundaries.startRow-1;
      rc.maxRows = rc.boundaries.maxrow;
      rc.sortColumn = event.getValue("orderby",0);
      rc.sortDirection = event.getValue("orderDir","asc");
      rc.parentID = event.getValue("parentID",0);
      rc.ProductCount = ProductService.cCount("",rc.parentID);
      rc.products = ProductService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,"",rc.parentID);

    </cfscript>
    <cfset event.setView("products/viewlist")>
  </cffunction>

  <cffunction cache="true" name="move" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.categoryID = event.getValue("categoryID",0);
      rc.productID = event.getValue("productID",0);
      rc.category = ProductService.moveProduct(rc.categoryID,rc.productID);
      event.setView("blank");
    </cfscript>
  </cffunction>
<cffunction name="tree" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = event.getCollection();
      rc.id = event.getValue("id","");
      rc.categories = ProductService.categoryList(rc.id);
    </cfscript>
    <cfset listItems = ArrayNew(1)>
    <cfloop query="rc.categories">
      <cfset x = StructNew()>

        <cfset x["attr"]["id"] = "#id#">
        <cfset x["attr"]["rel"] = "default">
        <cfset x["data"]["attr"]["id"] = "#id#">
        <cfset x["data"]["attr"]["rel"] = "default">
        <cfset x["data"]["attr"]["class"] = "ajax">
        <cfif childrenCats eq 0>
          <cfset x["data"]["title"] = "#left(name,30)# (#children#)  #IIf(webEnabled,"'T'","''")# #IIf(publicwebEnabled,"'P'","''")#">
          <cfset x["data"]["attr"]["href"] = "/eunify/products/index/categoryID/#id#">
          <cfset x["data"]["attr"]["rev"] = "maincontent">
          <cfset x["data"]["icon"] = "product">
          <cfset x["data"]["attr"]["rel"] = "product">
          <cfset x["attr"]["rel"] = "product">
        <cfelse>
        <cfset x["data"]["title"] = "#left(name,30)# (#childrenCats#)  #IIf(webEnabled,"'T'","''")# #IIf(publicwebEnabled,"'P'","''")#">
          <cfset x["attr"]["class"] = "jstree-drop">
          <cfset x["data"]["attr"]["href"] = "">
          <cfset x["attr"]["rel"] = "default">
          <cfset x["data"]["attr"]["rel"] = "default">
          <cfset x["state"] = "closed">
        </cfif>
        <cfset arrayAppend(listItems,x)>
    </cfloop>
    <cfset rc.json = SerializeJSON(listItems)>
    <cfset event.setView("renderJSON")>
  </cffunction>

  <cffunction name="doEdit" returntype="void">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.product_code = event.getValue("product_code","")>
    <cfset rc.publicWebEnabled = event.getValue("publicWebEnabled","false")>
    <cfset rc.webEnabled = event.getValue("webEnabled","false")>
    <cfset rc.collectable = event.getValue("collectable","false")>
    <cfset rc.special = event.getValue("special","false")>
    <cfset rc.clearance = event.getValue("clearance","false")>
    <cfset rc.feature = event.getValue("feature","false")>
    <cfset rc.productBean = populator.populateFromQuery(ProductService,ProductService.getProduct(rc.product_code))>
    <cfset rc.populatedBean = populator.populateFromStruct(rc.productBean,rc)>
    <cfset rc.populatedBean.save()>
    <cfset event.setView("blank")>
  </cffunction>

  <cffunction name="import" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.importType = event.getValue("type","products")>
    <cfset event.setView("products/import/#rc.importType#/import")>
  </cffunction>

  <cffunction name="uploadSpreadsheet" returntype="void">
    <cfargument name="event" required="true">
    <cfset rc.file = event.getValue("file","")>
    <cfset rc.importType = event.getValue("type","products")>
    <cfif rc.file neq "">
      <cffile action="upload" filefield="file" destination="/fs/sites/ebiz/www.buildingvine.com/cache/upload/#createUUID()#.xls" result="uploadedFile">
      <cfset rc.file = "/fs/sites/ebiz/www.buildingvine.com/cache/upload/#uploadedFile.ServerFile#">
      <cfspreadsheet action="read" src="#rc.file#" sheet="1" headerrow="1" query="sheet"></cfspreadsheet>
      <cfset rc.sheet = sheet>
      <cfset rc.iService = ImportService>
      <cfset event.setView("products/import/#rc.importType#/mapfields")>
    </cfif>
  </cffunction>

  <cffunction name="doImport" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.importobject = event.getValue("importobject","product")>
    <cfset rc.importTable = event.getValue("importTable","Products")>
    <cfset rc.importKey = event.getValue("importKey","")>
    <cfthread rc="#rc#" ImportService="#ImportService#" action="run" name="product#createUUID()#" priority="LOW">
      <cfset attributes.ImportService.doImport(attributes.rc,request.siteID,rc.importobject,rc.importTable,rc.importKey)>
     </cfthread>
    <cfset event.setView('products/import/done')>
  </cffunction>

  <cffunction name="BVsync" returntype="void">
    <cfargument name="event">
	  <cfset var rc = event.getCollection()>
	  <cfthread name="BVSync_#request.siteID#" siteID="#request.siteID#" priority="LOW" ProductService="#ProductService#" bvProductService="#bvProductService#">
      <cfset productList = attributes.ProductService.list(startRow=1,maxrow=50000)>
      <cfloop query="productList">
        <cfset sString = "">
        <cfif EANCode neq "">
          <cfset sString = EANCode>
        <cfelseif Manufacturers_Product_Code neq "">
			    <cfset sString = Manufacturers_Product_Code>
        <cfelse>
          <cfset sString = Full_Description>
		    </cfif>
		    <cfset bvProduct = attributes.bvProductService.productSearch(sString)>
			  <cfif isDefined("bvProduct.items") AND ArrayLen(bvProduct.items) gte 1 AND ArrayLen(bvProduct.items) lt 5>
			  	 <cfquery name="d" datasource="BMNet">
				   	  update Products set BVNodeRef = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bvProduct.items[1].nodeRef#">
						  where
						  Product_Code = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productList.Product_Code#">
						  AND
						  siteID = <Cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.siteID#">
				   </cfquery>
			  </cfif>
		   </cfloop>
	  </cfthread>
	  <cfset event.setView("products/bvsyncRunning")>
  </cffunction>
</cfcomponent>