
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="purchase" inject="id:eunify.PurchaseService">

  <!--- preHandler --->

  <!--- index --->
  <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("customers/list");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="detail" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.id = event.getValue("id",0);
      rc.invoice = invoice.getInvoice(rc.id);
      event.setView("invoice/detail");
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

  <cffunction cache="true" name="list" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.filter = event.getValue("filter","")>
    <cfset rc.filterID = event.getValue("filterID","")>
    <cfset event.setView("purchases/list")>
  </cffunction>

  <cffunction cache="true" name="invoiceDetail" returntype="void">
    <cfset var rc = event.getCollection()>
    <cfset rc.filter = event.getValue("filter","")>
    <cfset rc.filterID = event.getValue("filterID","")>
    <cfset event.setView("purchases/list")>
  </cffunction>

  <cffunction cache="true" name="query" returntype="Any" output="false">
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
      rc.customerCount = purchase.cCount(rc.filter,rc.filterid);
      rc.CustomerData = purchase.list(rc.filter,rc.filterid,rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.customerCount;
      rc.json["iTotalDisplayRecords"] = rc.customerCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.CustomerData">
      <cfset thisRow = ["#id#","#account_number#","#account_name#","#order_number#","#invoice_number#","#DateFormat(invoice_date,'DD/MM/YYYY')#","#goods_total#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>
</cfcomponent>