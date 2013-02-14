<cfcomponent>
  <cfproperty name="responseService" inject="id:marketing.ResponseService" >


  <cffunction name="responsesBy">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.campaignID = event.getValue("campaignID",0)>
    <cfset rc.contactID = event.getValue("contactID",0)>
    <cfset rc.companyID = event.getValue("companyID",0)>
    <cfset rc.responses = responseService.getResponsesBy(rc.campaignID,rc.contactID,rc.companyID)>
    <cfset event.setView("")>
  </cffunction>

  <cffunction cache="true" name="overview" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.json = responseService.overview(rc.id);
      event.renderData(data=rc.json,type="JSON");
    </cfscript>
  </cffunction>
  <cffunction cache="true" name="pie" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.json = responseService.pieoverview(rc.id);
      event.renderData(data=rc.json,type="JSON");
    </cfscript>
  </cffunction>
  <cffunction name="table" returntype="void">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.type = event.getValue("type",0);
      rc.campaignID = event.getValue("campaignID",0);
      rc.sortColumn = event.getValue("iSortCol_0",0);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.recordCount = responseService.cCount(rc.searchQuery,rc.campaignID,rc.type);
      rc.chartData = responseService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery,rc.campaignID,rc.type);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.recordCount;
      rc.json["iTotalDisplayRecords"] = rc.recordCount;
      rc.json["aaData"] = rc.chartData.aaData;

    </cfscript>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>
  <cffunction name="map" returntype="void">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.type = event.getValue("type",0);
      rc.campaignID = event.getValue("campaignID",0);
      rc.json = responseService.listMap(rc.campaignID,rc.type);
    </cfscript>
    <cfset event.renderData("json",rc.json,"application/json")>
  </cffunction>
</cfcomponent>