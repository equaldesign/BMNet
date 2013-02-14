
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="invoice" inject="id:eunify.InvoiceService">
  <cfproperty name="ProductService" inject="id:eunify.ProductService">
  <cfproperty name="CustomerService" inject="id:eunify.CustomerService">
  <cfproperty name="BVProductService" inject="model:bvProductService">

  <!--- preHandler --->

  <!--- index --->
  <cffunction name="import" returntype="void" output="false">
    <cfargument name="Event">
    <cfsetting requesttimeout="9000">
    <cfscript>
      var rc = event.getCollection();
    </cfscript>
      <cfquery name="invoices" datasource="BMNet">
        select
          *,
          sum(goods_total) as goods_total,
          sum(line_total) as line_total,
          sum(line_total) as line_total,
          sum(quantity) as quantity
        from
          Invoice_Header
        where siteID = 1
        group by invoice_num
      </cfquery>
      <cfloop query="invoices">
        <cfset deliveryLatitude = 0>
        <cfset deliveryLongitude = 0>
        <cfset distance = 0>
        <cfif order_category eq "D">
            <!--- we now have the lat/long of the delivery address --->
            <cfquery name="branchCo" datasource="BMNet">
              SELECT maplat, maplong from branch where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#">
            </cfquery>
            <!--- now we need to work out the distance ...--->
            <cfhttp url="http://maps.googleapis.com/maps/api/directions/json?origin=#branchCo.latitude#,#branchCo.longitude#&destination=#delivery_postcode#&region=gb&sensor=false&unit=imperial" result="directions">
            <cfset jsonDirections = Deserializejson(directions.fileContent)>
            <cfif jsonDirections.status eq "OK">
              <cfset deliveryLatitude = jsonDirections.routes[1].legs[1].end_location.lat>
              <cfset deliveryLongitude = jsonDirections.routes[1].legs[1].end_location.lng>
              <cfset distance = jsonDirections.routes[1].legs[1].distance.text>
            </cfif>
        </cfif>
        <cfquery name="createHeader" datasource="BMNet">
          insert into Invoice
          (
            invoice_number,
            branch_id,
            account_number,
            account_name,
            order_number,
            invoice_date,
            order_category,
            description,
            quantity,
            invoice_total,
            line_total,
            vat_total,
            delivery_name,
            delivery_address_1,
            delivery_address_2,
            delivery_address_3,
            delivery_address_4,
            delivery_address_5,
            delivery_postcode,
            customer_order_number,
            salesman,
            PODFile,
            siteID,
            delivery_distance,
            delivery_latitude,
            delivery_longitude)
          VALUES (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#invoice_num#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#branch_id#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#account_number#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#account_name#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#order_number#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#inv_date#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#order_category#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#quantity#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#product_code#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#full_description#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#line_total#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#goods_total#">,
            <cfqueryparam cfsqltype="cf_sql_decimal" value="#line_vat#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_name#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_address_1#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_address_2#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_address_3#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_address_4#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_address_5#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#delivery_postcode#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#customer_order_no#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#salesman#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#PODFile#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#distance#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#deliveryLatitude#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#deliveryLongitude#">
         )
        </cfquery>
      </cfloop>

    <cfset event.noRender()>
  </cffunction>

  <cffunction name="syncProducts" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.products = ProductService.getUnSyncedProducts();
    </cfscript>
    <cfthread action="run" name="doSync" products="#rc.products#" ProductService="#ProductService#" BVProductService="#BVProductService#">
      <cfloop query="attributes.products">
        <cfif trim(EANCode) neq "">
          <cfset BVProducts = attributes.BVProductService.productSearch(EANCode)>
        <cfelseif trim(Manufacturers_Product_Code) neq "">
          <cfset BVProducts = attributes.BVProductService.productSearch(Manufacturers_Product_Code)>
        <cfelse>
          <cfset BVProducts = attributes.BVProductService.productSearch(full_description)>
        </cfif>
        <cfif isDefined("BVProducts.items") AND ArrayLen(BVProducts.items) gte 1 >
          <cfset NodeRef = BVProducts.items[1].nodeRef>
          <cfset ProductService.updateBVNodeRef(product_code,NodeRef)>
        </cfif>
      </cfloop>
    </cfthread>
  </cffunction>

  <cffunction name="detail" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.account_number = event.getValue("id",0);
      rc.customer = companyService.getCustomer(rc.account_number);
      event.setView("customers/detail");
    </cfscript>
  </cffunction>

  <cffunction name="overview" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.account_number = event.getValue("id",0);
      rc.customer = companyService.getCustomer(rc.account_number);
      event.setView("customers/overview");
    </cfscript>
  </cffunction>

  <cffunction name="list" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.sortColumn = event.getValue("iSortCol_0",0);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.customerCount = companyService.cCount(rc.searchQuery);
      rc.CustomerData = companyService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.customerCount;
      rc.json["iTotalDisplayRecords"] = rc.customerCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.CustomerData">
      <cfset thisRow = ["#account_number#","#name#","#company_address_1#","#company_postcode#","#trade#","#creditLimit#","#balance#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>

  <cffunction name="debug" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
    </cfscript>
    <cfset event.setView(view="blank",noLayout=true)>
  </cffunction>

  <cffunction name="updateCoRdinates" returntype="void">
    <cfargument name="event">
    <cfsetting requesttimeout="9000">
    <cfquery name="customers" datasource="BMNet">
      select *
      from
      Supplier
      where latitude = 0
    </cfquery>
    <cfloop query="customers">
      <cfset lat = "">
      <cfset lng = "">
      <cfset sString = " ">
      <cfif trim(address_2) neq "">
        <cfset sString= listAppend(sString,"#address_1#")>")>
      </cfif>
      <cfif trim(address_2) neq "">
        <cfset sString= listAppend(sString,"#address_2#")>")>
      </cfif>
      <cfif trim(address_3) neq "">
        <cfset sString= listAppend(sString,"#address_3#")>")>
      </cfif>
      <cfif trim(address_4) neq "">
        <cfset sString= listAppend(sString,"#address_4#")>")>
      </cfif>
      <cfif trim(address_5) neq "">
        <cfset sString= listAppend(sString,"#address_5#")>")>
      </cfif>
      <cfif post_code neq "">
        <cfset sString= listAppend(sString,"#post_code#")>")>
      </cfif>
      <cfhttp url="http://maps.google.com/maps/geo?q=#sString#&output=csv" result="pcRequestResult"></cfhttp>
      <cfset coOrds = ListToArray(pcRequestResult.fileContent)>
      <cfif (coOrds[1] eq "200") AND coOrds[4] GT -10>
        <cfquery name="updateLats" datasource="BMNet">
          update
            Supplier
         set
          latitude = <cfqueryparam cfsqltype="cf_sql_varchar" value="#coOrds[3]#">,
          longitude = <cfqueryparam cfsqltype="cf_sql_varchar" value="#coOrds[4]#">
        where
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>
      <cfelse>
    <cfhttp url="http://maps.google.com/maps/geo?q=#sString#&output=csv" result="pcRequestResult"></cfhttp>
      <cfset coOrds2 = ListToArray(pcRequestResult.fileContent)>
    <cfif (coOrds2[1] eq "200")>
      <cfquery name="updateLats" datasource="BMNet">
        update
          Supplier
       set
        latitude = <cfqueryparam cfsqltype="cf_sql_varchar" value="#coOrds2[3]#">,
        longitude = <cfqueryparam cfsqltype="cf_sql_varchar" value="#coOrds2[4]#">
      where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      </cfquery>
    </cfif>
      </cfif>
      <cfthread action="sleep" duration="#(1 * 250)#"></cfthread>
    </cfloop>
    <cfset event.noRender()>
  </cffunction>
</cfcomponent>