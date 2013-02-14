
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="invoice" inject="id:eunify.InvoiceService">
  <cfproperty name="sales" inject="id:eunify.SalesService">
  <cfproperty name="RecommendationService" inject="id:eunify.RecommendationService">
  <cfproperty name="bvProductService" inject="model:bvProductService">
  <cfproperty name="ProductService" inject="id:eunify.ProductService">
  <cfproperty name="CompanyService" inject="id:eunify.CompanyService">
  <cfproperty name="EcommerceService" inject="id:eunify.EcommerceService">
  <cfproperty name="eGroupPSA" inject="id:eGroup.psa">
  <!--- preHandler --->

  <!--- index --->
  <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("ecommerce/list");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="list" returntype="void" output="false">
    <cfargument name="Event">
    <cfset var rc = event.getCollection()>
    <cfset rc.filter = event.getValue("filter","")>
    <cfset rc.filterID = event.getValue("filterID","")>
    <cfset event.setView("ecommerce/list")>
  </cffunction>

  <cffunction cache="true" name="detail" returntype="void" output="false">
    <cfargument name="Event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id","")>
	  <cfset rc.order = EcommerceService.getOrder(rc.id)>
    <cfset event.setView("ecommerce/detail")>
  </cffunction>
  <cffunction name="changeStatus" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.status = event.getValue("status","")>
    <cfset EcommerceService.changeStatus(rc.id,rc.status)>
    <cfset event.setLayout("Layout.ajax")>
    <cfset event.setView("blank")>
  </cffunction>
  <cffunction name="query" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.sortColumn = event.getValue("iSortCol_0",0);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.filter = event.getValue("filter","account_number");
      rc.filterid = event.getValue("filterid","");
      rc.customerCount = EcommerceService.cCount(rc.filter,rc.filterid);
      rc.CustomerData = EcommerceService.list(rc.filter,rc.filterid,rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.customerCount;
      rc.json["iTotalDisplayRecords"] = rc.customerCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.CustomerData">
      <cfset thisRow = ["#id#","#billingContact#","#billingAddress#","#billingPostCode#","#totalPrice#","#status#","#date#","#delivered#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>
</cfcomponent>