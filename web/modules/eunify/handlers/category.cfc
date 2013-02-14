
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="invoice" inject="id:eunify.InvoiceService">
  <cfproperty name="sales" inject="id:eunify.SalesService">
  <cfproperty name="RecommendationService" inject="id:eunify.RecommendationService">
  <cfproperty name="bvProductService" inject="model:bv.ProductService">
  <cfproperty name="ProductService" inject="id:eunify.ProductService">
  <cfproperty name="CustomerService" inject="id:eunify.CompanyService">
  <cfproperty name="eGroupCompany" inject="id:eGroup.company">
  <cfproperty name="eGroupPSA" inject="id:eGroup.psa">
  <!--- preHandler --->


  <cffunction name="setOrder" returntype="void">
    <cfargument name="event">
    <cfquery name="cats" datasource="BMNet">
      select inc, parentID from ProductCategory where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfloop query="cats">
      <!--- get parents --->
      <cfquery name="ps" datasource="BMNet">
        select
        count(id) as maxCount
        from
          ProductCategory
        where
          parentID = <Cfqueryparam cfsqltype="cf_sql_varchar" value="#parentID#">
          AND
          inc < <cfqueryparam cfsqltype="cf_sql_varchar" value="#inc#">
          AND
           siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
      <cfquery name="ps" datasource="BMNet">
        update
          ProductCategory
        set
          _order = <cfqueryparam cfsqltype="cf_sql_integer" value="#ps.maxCount+1#">
        where
          inc = <cfqueryparam cfsqltype="cf_sql_integer" value="#inc#">
      </cfquery>
    </cfloop>
    <cfabort>
  </cffunction>

  <cffunction cache="false" name="edit" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.categoryID = event.getValue("categoryID","");
      rc.parentID = event.getValue("parentID",0);
      rc.category = ProductService.getCategory(rc.categoryID);
      event.setView("products/category/edit");
    </cfscript>
  </cffunction>

  <cffunction cache="false" name="doEdit" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.id = event.getValue("id","");
      rc.parentID = event.getValue("parentID",0);
      rc.oldID = event.getValue("oldID",0);
      rc.categoryName = event.getValue("name","");
      rc.description = event.getValue("description","");
      rc.webEnabled = event.getValue("webEnabled","false");
      rc.BVNodeRef = event.getValue("BVNodeRef","");
      rc.pageslug = event.getValue("pageslug","");
      rc.publicWebEnabled = event.getValue("publicWebEnabled","false");
      ProductService.saveCategory(rc.id,rc.parentID,rc.categoryName,rc.webEnabled,rc.publicWebEnabled,rc.oldID,rc.description,rc.BVNodeRef,rc.pageslug);
      event.setView("blank");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="move" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.sourceID = event.getValue("sourceID",0);
      rc.targetID = event.getValue("targetID",0);
      rc.position = event.getValue("position",0)
      rc.category = ProductService.moveCategory(rc.sourceID,rc.targetID,rc.position);
      event.setView("blank");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="delete" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.categoryID = event.getValue("categoryID",0);
      ProductService.deleteCategory(rc.categoryID);
      event.setView("blank");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="rename" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.categoryID = event.getValue("categoryID",0);
      rc.categoryName = event.getValue("categoryName",10);
      ProductService.renameCategory(rc.categoryID,rc.categoryName);
      event.setView("blank");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="view" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.boundaries = rc.sess.paging.getBoundaries();
      rc.boundaries = rc.sess.paging.getBoundaries();
      rc.startRow = rc.boundaries.startRow-1;
      rc.maxRows = rc.startRow+rc.startRow+rc.boundaries.maxrow;
      rc.sortColumn = event.getValue("orderby",0);
      rc.sortDirection = event.getValue("orderDir","asc");
      rc.parentID = event.getValue("parentID",0);
      rc.ProductCount = ProductService.cCount("",rc.parentID);
      rc.products = ProductService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,"",rc.parentID);

    </cfscript>
    <cfset event.setView("products/viewlist")>
  </cffunction>

  <cffunction name="BVCategorySync" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfthread name="BVSync_#request.siteID#" siteID="#request.siteID#" priority="LOW" ProductService="#ProductService#" bvProductService="#bvProductService#">
      <cfset attributes.ProductService.getBVProductImages()>
    </cfthread>
    <cfset event.setView("products/bvsyncRunning")>
  </cffunction>
</cfcomponent>