
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="companyService" inject="id:eunify.CompanyService">
  <cfproperty name="SiteService" inject="id:bv.SiteService">
  <cfproperty name="PSAService" inject="id:eunify.PSAService">
  <cfproperty name="eGroupPSAService" inject="id:eGroup.psa">
  <cfproperty name="eGroupCompany" inject="id:eGroup.company">
  <cfproperty name="responseService" inject="id:marketing.ResponseService" >
  <cfproperty name="EmailService" inject="id:eunify.EmailService">
  <cfproperty name="TaskRelationships" inject="id:flo.RelationshipService">
  <cfproperty name="documentService" inject="id:bv.DocumentService">
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />


  <!--- preHandler --->

  <!--- index --->
  <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("company/list");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="detail" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.account_number = event.getValue("id",0);
      rc.company = companyService.getcompany(rc.account_number,request.siteid);
      if (rc.company.type_id eq 2) {
        rc.psas = PSAService.getArrangementBySupplier(supplierid=rc.account_number,toDate=now());
        if (rc.company.eGroup_id neq 0) {
         rc.eGroup.PSAs =  eGroupPSAService.getArrangementBySupplier(supplierid=rc.company.eGroup_id,toDate=now());
        }
      }
      event.setView("company/#rc.company.typename#/detail");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="overview" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.account_number = event.getValue("id",0);
      rc.company = companyService.getcompany(rc.account_number,request.siteid);
      rc.emails = rc.emailData = EmailService.list(0,7,0,"desc","",0,rc.company.id);
      rc.documentFolder = documentService.checkFolder(path="documentLibrary/companys/#trim(rc.company.name)#&c=true",siteID=request.buildingVine.siteID);
      rc.recentDocuments = documentService.getRecent(rc.documentFolder.nodeRef);
      rc.emailCampaignResponses = responseService.responsesBy(companyID=rc.company.id);
      rc.tasks = TaskRelationships.getRelatedTasks(relatedType="customer,supplier",relatedID=rc.company.id,activityComplete=false)
      event.setView("company/panels/overview");
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
      rc.companyCount = companyService.cCount(rc.searchQuery,rc.type_id,request.siteid);
      rc.companyData = companyService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery,rc.type_id,request.siteid);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.companyCount;
      rc.json["iTotalDisplayRecords"] = rc.companyCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.companyData">
      <cfset thisRow = ["#id#","#account_number#","<a href='/eunify/company/detail/id/#id#'>#name#</a>","#company_address_1#","#company_postcode#","#trade#","#creditLimit#","#balance#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>

  <cffunction name="contacts" returntype="void" output="false" hint="My main event" cache="true">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue('id',0);
      rc.contacts = companyService.getCompanyContacts(rc.id);
    </cfscript>
    <cfset arguments.event.setView('company/panels/contact')>
  </cffunction>

  <cffunction cache="false" name="edit" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.id = event.getValue("id",0);
      rc.company = companyService.getCompany(rc.id,request.siteID);
      rc.contacts = companyService.getCompanyContacts(rc.id);
      rc.bvSites = SiteService.fullList();
      if (request.eGroup.datasource neq "") {
        rc.eGroupCompanies = eGroupCompany.getCompany();
      }
      event.setView("company/edit");
    </cfscript>
  </cffunction>

  <cffunction  name="doEdit" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.id = event.getValue("id",0);
        rc.hidden = arguments.event.getValue("hidden","n");
        rc.status = arguments.event.getValue("status","inactive");
        rc.sendLogin = arguments.event.getValue("sendLogin","false");
        rc.inBuildingVine = arguments.event.getValue("inBuildingVine",false);
      beanFactory.populateFromQuery(companyService,companyService.getCompany(rc.id,request.siteID));

      populateModel(companyService);
      companyService.save();
      if (isUserInRole("staff")) {
        setNextEvent(uri="/eunify/company/detail/id/#companyService.getid()#");
      } else {
      	setNextEvent(uri="/quote/newuser/thankyou");
      }
    </cfscript>
  </cffunction>

</cfcomponent>