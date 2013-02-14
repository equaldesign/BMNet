
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="invoice" inject="id:eunify.InvoiceService">
  <cfproperty name="companyService" inject="id:eunify.CompanyService">
  <cfproperty name="RecommendationService" inject="id:eunify.RecommendationService">
  <cfproperty name="SalesService" inject="id:eunify.SalesService">
  <cfproperty name="ImportService" inject="id:eunify.ImportService">


  <!--- preHandler --->

  <!--- index --->
  <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.filterColumn = event.getValue("filterColumn","");
      rc.filterValue = event.getValue("filterValue","");
      event.setView("sales/site/overview");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="ledger" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.filter = event.getValue("filter","");
      rc.filterID = event.getValue("filterID","");
      event.setView("sales/ledger");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="thisMonth" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("sales/site/thismonth");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="warningsMap" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("sales/site/warningsMap");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="warnings" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.chartType = event.getValue("dataType","customerdissapearance");
      rc.data = SalesService.chartData(rc.chartType,ListToArray(rc.filterColumn),ListToArray(rc.filterValue),request.siteID);
      event.setView(view="sales/site/warnings");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="thisMonthMap" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("sales/site/thismonthMap");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="salesChartDataBy" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.filterBy = event.getValue("filterBy","salesman");
      rc.filterValue = event.getValue("filterValue","");
      rc.salesData = SalesService.salesChartDataBy(rc.sess.BMNet.siteID,rc.filterBy,rc.filtervalue);
      event.renderData(data=rc.salesData,type="JSON");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="getSalesFilter" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.filter = event.getValue("filter","salesman");
      rc.salesPeople = SalesService.getSalesFilter(rc.sess.BMNet.siteID,rc.filter);
      event.renderData(data=rc.salesPeople,type="JSON");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="salesFilter" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.filter = event.getValue("filter","salesman");
       event.setView("sales/filter");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="hchartData" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.chartType = event.getValue("dataType","yearonyearcomparison");
      rc.filterColumn = event.getValue("filterColumn","");
      rc.filterValue = event.getValue("filterValue","");
      rc.json = SalesService.salesChartData(request.siteID,rc.filterColumn,rc.filterValue);
      event.renderData(data=rc.json,type="JSON");
    </cfscript>
  </cffunction>
   <cffunction cache="true" name="chartData" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.chartType = event.getValue("dataType","yearonyearcomparison");
      rc.json = SalesService.chartData(rc.chartType,ListToArray(rc.filterColumn),ListToArray(rc.filterValue));
      event.renderData(data=rc.json,type="JSON");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="tableData" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.chartType = event.getValue("dataType","yearonyearcomparison");
      rc.data = SalesService.chartData(rc.chartType,ListToArray(rc.filterColumn),ListToArray(rc.filterValue));
      event.setView(view="sales/chart/table/#rc.chartType#",noLayout=true);
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="salesman" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("sales/person/overview");
    </cfscript>
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
  <cffunction cache="true" name="overview" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.account_number = event.getValue("id",0);
      rc.customer = companyService.getCustomer(rc.account_number);
      event.setView("customers/overview");
    </cfscript>
  </cffunction>
  <cffunction name="list" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.filter = event.getValue("filter","")>
    <cfset rc.filterID = event.getValue("filterID","")>
    <cfset event.setView("sales/list")>
  </cffunction>
  <cffunction cache="true" name="upsell" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.account_number = event.getValue("id","")>
    <cfset rc.recommendations = RecommendationService.getrecommendationsforuser(rc.account_number)>
    <cfset rc.account = companyService.getcompany(rc.account_number)>
    <cfset event.setView("sales/upsell")>
  </cffunction>
  <cffunction name="invoiceDetail" returntype="void">
    <cfset var rc = event.getCollection()>
    <cfset rc.filter = event.getValue("filter","")>
    <cfset rc.filterID = event.getValue("filterID","")>
    <cfset event.setView("sales/list")>
  </cffunction>
  <cffunction name="query" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.sortColumn = event.getValue("iSortCol_0",6);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.filter = event.getValue("filter","");
      rc.filterid = event.getValue("filterid","");
      rc.customerCount = invoice.cCount(rc.filter,rc.filterid);
      rc.CustomerData = invoice.list(rc.filter,rc.filterid,rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.customerCount;
      rc.json["iTotalDisplayRecords"] = rc.customerCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.CustomerData">
      <cfset thisRow = ["#id#","#branch_id#","#account_number#","#account_name#","#order_number#","#invoice_number#","#DateFormat(invoice_date,'DD/MM/YYYY')#","#invoice_total#","#salesman#","#PODFile#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>

  <cffunction name="import" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.importType = event.getValue("type","invoice")>
    <cfset event.setView("sales/import/#rc.importType#/import")>
  </cffunction>

  <cffunction name="uploadSpreadsheet" returntype="void">
    <cfargument name="event" required="true">
    <cfset rc.file = event.getValue("file","")>
    <cfset rc.importType = event.getValue("type","invoice")>
    <cfif rc.file neq "">
      <cffile action="upload" filefield="file" destination="/fs/sites/ebiz/www.buildingvine.com/cache/upload/#createUUID()#.xls" result="uploadedFile">
      <cfset rc.file = "/fs/sites/ebiz/www.buildingvine.com/cache/upload/#uploadedFile.ServerFile#">
      <cfspreadsheet action="read" src="#rc.file#" sheet="1" headerrow="1" query="sheet"></cfspreadsheet>
      <cfset rc.sheet = sheet>
      <cfset rc.iService = ImportService>
      <cfset event.setView("sales/import/#rc.importType#/mapfields")>
    </cfif>
  </cffunction>

  <cffunction name="doImport" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>

    <cfthread rc="#rc#" ImportService="#ImportService#" action="run" name="ledger#createUUID()#" priority="LOW">
      <cfset attributes.ImportService.doLedgerImport(attributes.rc,request.siteID)>
     </cfthread>
    <cfset event.setView('products/import/done')>
  </cffunction>
</cfcomponent>