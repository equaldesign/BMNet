
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="SupplierService" inject="id:eunify.SupplierService">

  <!--- preHandler --->

  <!--- index --->
  <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("suppliers/list");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="detail" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.account_number = event.getValue("id",0);
      rc.supplier = SupplierService.getSupplier(rc.account_number);
      event.setView("suppliers/detail");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="overview" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.account_number = event.getValue("id",0);
      rc.supplier = SupplierService.getSupplier(rc.account_number);
      event.setView("suppliers/overview");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="list" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.sortColumn = event.getValue("iSortCol_0",0);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.supplierCount = SupplierService.cCount(rc.searchQuery);
      rc.SupplierData = SupplierService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.supplierCount;
      rc.json["iTotalDisplayRecords"] = rc.supplierCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.SupplierData">
      <cfset thisRow = ["#account_number#","#name#","#address_1#","#address_2#","#post_code#","#telephone_1#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>
</cfcomponent>