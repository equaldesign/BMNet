<cfcomponent name="documentsHandler" cache="true" cacheTimeout="30" output="false">
	<!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
	<!--- Default Action --->
	<cfproperty name="dms" inject="id:eunify.DocumentService" />
  <cfproperty name="psa" inject="id:eunify.PSAService" />
  <cfproperty name="calendar" inject="id:eunify.CalendarService" />
  <cfproperty name="dsn" inject="coldbox:datasource:eGroup" />
  <cfproperty name="company" inject="id:eunify.SupplierService" />


			<cffunction name="relatedCategories" returntype="void" output="false" hint="My main event" cache="true">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.relatedID = arguments.event.getValue('relatedID',0);
				  rc.relatedType = arguments.event.getValue('type','deal');
				  rc.layout = arguments.event.getValue("layout","ajax");
				  rc.v = arguments.event.getValue("v","list");
				  rc.category = dms.getRelatedCategory(rc.relatedType,rc.relatedID);
				  if (rc.category.recordCount eq 0) {
				    // throw

				    if (rc.relatedType == "deal") {
              rc.dmspsa = psa.getPSA(rc.relatedID);
              rc.companyCat = dms.getRelatedCategory("company",rc.dmspsa.getcompany_id());
              rc.dmsCompany = company.getCompany(rc.dmspsa.getcompany_id());
              if (rc.companyCat.recordCount == 0) {
                // need to create company too!
                rc.rootCompanyCat = dms.getCategory(categoryName="Company Documents");
                rc.newcompanyCat = dms.createDMSCategory(
                  categoryTitle = "#rc.dmsCompany.getname()#",
                  categoryDescription = "",
                  categoryRelationshipType = "company",
                  categoryRelationShipID = rc.dmsCompany.getid(),
                  parentCategoryID = rc.rootCompanyCat.id
                );
                rc.newCorpIDCat = dms.createDMSCategory(
                  categoryTitle = "Corporate ID",
                  categoryDescription = "",
                  categoryRelationshipType = "company",
                  categoryRelationShipID = rc.dmsCompany.getid(),
                  parentCategoryID = rc.newcompanyCat
                );
                rc.agreeementsCat = dms.createDMSCategory(
                  categoryTitle = "Agreements",
                  categoryDescription = "",
                  categoryRelationshipType = "company",
                  categoryRelationShipID = rc.dmsCompany.getid(),
                  parentCategoryID = rc.newcompanyCat
                );

                rc.companyCat  = dms.getCategory(rc.agreeementsCat);
              } else {
                rc.agg = dms.getCategoryWithin(rc.companyCat.id,"Agreements");
                if (rc.agg.recordCount == 0) {
                  // no agreements cat
                  rc.companyCatID = dms.createDMSCategory(
                    categoryTitle = "Agreements",
                    categoryDescription = "",
                    categoryRelationshipType = "company",
                    categoryRelationShipID = rc.dmsCompany.getid(),
                    parentCategoryID = rc.companyCat.id
                  );
                  rc.companyCat = dms.getCategory(rc.companyCatID);
                } else {
                  rc.companyCat = rc.agg;
                }
              }
              rc.newcategory = dms.createDMSCategory(
                categoryTitle = "#rc.dmspsa.getid()#-#year(rc.dmspsa.getperiod_from())# #rc.dmsCompany.getname()#",
                categoryDescription = "",
                categoryRelationshipType = "deal",
                categoryRelationShipID = rc.dmspsa.getid(),
                parentCategoryID = rc.companyCat.id
              );
              dms.createDMSCategory(
                categoryTitle = "Prices",
                categoryDescription = "",
                categoryRelationshipType = "deal",
                categoryRelationShipID = rc.dmspsa.getid(),
                parentCategoryID = rc.newcategory
              );
              rc.docsCat = dms.createDMSCategory(
                categoryTitle = "Documents",
                categoryDescription = "",
                categoryRelationshipType = "deal",
                categoryRelationShipID = rc.dmspsa.getid(),
                parentCategoryID = rc.newcategory
              );
              dms.createDMSSecurity("view",getModel("groups").getGroupByName("rebates"),"category",rc.docsCat);
              dms.createDMSCategory(
                categoryTitle = "Correspondence",
                categoryDescription = "",
                categoryRelationshipType = "deal",
                categoryRelationShipID = rc.dmspsa.getid(),
                parentCategoryID = rc.newcategory
              );
              rc.category = dms.getCategory(rc.newcategory);
				    } else if (rc.relatedType == "appointment") {
				    	rc.appointment = calendar.getAppointment(rc.relatedID);
				    	rc.rootCompanyCat = dms.getCategory(categoryName="Meeting Documents");
              rc.appointmentCat = dms.createDMSCategory(
                  categoryTitle = "#rc.appointment.getname()#",
                  categoryDescription = "",
                  categoryRelationshipType = "appointment",
                  categoryRelationShipID = rc.relatedID,
                  parentCategoryID = rc.rootCompanyCat.id
                );
              rc.category = dms.getCategory(rc.appointmentCat);
				    } else if (rc.relatedType == "company") {
              rc.company = company.getSupplier(rc.relatedID);
              rc.rootCompanyCat = dms.getCategory(categoryName="Company Documents");
              rc.supplierCat = dms.createDMSCategory(
                  categoryTitle = "#rc.company.name#",
                  categoryDescription = "",
                  categoryRelationshipType = "company",
                  categoryRelationShipID = rc.relatedID,
                  parentCategoryID = rc.rootCompanyCat.id
                );
              rc.category = dms.getCategory(rc.supplierCat);
            }
				  }
 				  rc.folders = dms.getCategories(rc.category.id);
				  rc.documents = dms.getDocuments(rc.category.id);
				  rc.tree = dms.dmsTree(rc.category.id);
				</cfscript>
				<cfset arguments.event.setLayout('Layout.#rc.layout#')>
				<cfset arguments.event.setView('dms/#rc.v#')>
			</cffunction>

  <cffunction name="detail" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset rc.document = dms.getDocument(rc.id)>
    <cfif rc.document.fileType eq "pdf">
      <cftry>
      <cfpdf action="getinfo" source="#rc.app.appRoot#dms/documents/#rc.id#.pdf" name="rc.pdfInfo" />
      <cfcatch type="any">

      </cfcatch>
      </cftry>
    </cfif>
    <cfset rc.catID = rc.document.categoryID>
    <cfset rc.tree = dms.dmsTree(rc.catID)>
    <cfset arguments.event.setView('dms/documentDetail')>
  </cffunction>
  <cffunction name="info" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset rc.type = arguments.event.getValue("type","document")>
    <cfif rc.type eq "document">
      <cfset rc.document = dms.getDocument(rc.id)>
      <cfset rc.permissions = dms.getDMSSecurity("document",rc.id)>
      <cfset arguments.event.setView('dms/fileInfo')>
    <cfelse>
      <cfset rc.category = dms.getCategory(rc.id)>
      <cfset rc.permissions = dms.getDMSSecurity("category",rc.id)>
      <cfset arguments.event.setView('dms/folderInfo')>
    </cfif>
  </cffunction>

  <cffunction name="doEdit" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset rc.type = arguments.event.getValue("type","document")>
    <cfset rc.name = arguments.event.getValue("name","")>
    <cfset rc.description = arguments.event.getValue("description","")>
    <cfset rc.timeSensitive = arguments.event.getValue("timesensitive",false)>
    <cfset rc.showThumbnail = arguments.event.getValue("thumbnail",false)>
    <cfset rc.validFrom = arguments.event.getValue("validFrom","")>
    <cfset rc.validTo = arguments.event.getValue("validTo","")>
    <cfset rc.groupID = arguments.event.getValue("permissions",0)>
    <cfset rc.relatedType = arguments.event.getValue("relatedType",0)>
    <cfset rc.relatedID = arguments.event.getValue("relatedID",0)>
    <cfset rc.parentID = arguments.event.getValue("parentID",0)>
    <cfif rc.type eq "document">
      <cfset rc.document = dms.updateDMSDocument(rc.id,rc.name,rc.description,rc.timeSensitive,rc.validFrom,rc.validTo,rc.groupID,rc.relatedType,rc.relatedID,rc.showThumbnail,rc.parentID)>
    <cfelse>
      <cfset rc.category = dms.updateDMSCategory(rc.id,rc.name,rc.description,rc.timeSensitive,rc.validFrom,rc.validTo,rc.groupID,rc.relatedType,rc.relatedID,rc.parentID)>
    </cfif>
    <cfset arguments.event.setView("blank")>
  </cffunction>
			<cffunction name="categoryList" returntype="void" output="false" hint="My main event" cache="true">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.id = arguments.event.getValue('id',0);
          rc.category = dms.getCategory(rc.id);
          rc.folders = dms.getCategories(rc.id);
          rc.documents = dms.getDocuments(rc.id);
          rc.tree = dms.dmsTree(rc.id);
				</cfscript>
        <cfset arguments.event.setView('dms/list')>
			</cffunction>

			<cffunction name="documentList" returntype="void" output="false" hint="My main event" cache="true">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.id = arguments.event.getValue('id',0);
					rc.layout = arguments.event.getValue("layout","ajax");
					rc.results = dms.getDocuments(rc.id);
				</cfscript>
				<cfset arguments.event.setView('dms/documentList')>
			</cffunction>

      <cffunction name="documentNameList" returntype="void" output="false" hint="My main event" cache="true">
        <cfargument name="event">

        <cfsetting requesttimeout="900">
        <cfscript>
          var rc = arguments.event.getCollection();
          rc.name = arguments.event.getValue('name',"Prices");
          rc.period = arguments.event.getValue("period","");
          rc.timeSensitive = arguments.event.getValue("timeSensitive",false);
          rc.category = dms.getRelatedCategoryDocuments("",0,rc.name,rc.timeSensitive,rc.period);
        </cfscript>
        <cfset arguments.event.setView('dms/pricelist')>
      </cffunction>

      <cffunction name="createFolder" returntype="void" output="false">
        <cfargument name="event">

        <cfset var rc = arguments.event.getCollection()>
        <cfset rc.parentID = arguments.event.getValue("id","")>
        <cfset rc.folderName = arguments.event.getValue("name","")>
        <cfset rc.newID = dms.createDMSCategory(
                  categoryTitle = rc.folderName,
                  parentCategoryID = rc.parentID
               )>
        <cfset setNextEvent(uri="/documents/categoryList/id/#rc.newID#")>
      </cffunction>

      <cffunction name="delete" returntype="void" output="false">
        <cfargument name="event">

        <cfset var rc = arguments.event.getCollection()>
        <cfset rc.id = arguments.event.getValue("id","")>
        <cfset rc.document = dms.getDocument(rc.id)>
        <cfset dms.deleteDocument(rc.id)>
        <cfset setNextEvent(uri="/documents/categoryList/id/#rc.document.categoryID#")>
      </cffunction>

      <cffunction name="deleteFolder" returntype="void" output="false">
        <cfargument name="event">

        <cfset var rc = arguments.event.getCollection()>
        <cfset rc.id = arguments.event.getValue("id","")>
        <cfset rc.category = dms.getCategory(rc.id)>
        <cfset dms.deleteCategory(rc.id)>
        <cfset setNextEvent(uri="/documents/categoryList/id/#rc.category.parentID#")>
      </cffunction>

			<cffunction name="download" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.id = arguments.event.getValue('id',0);
					rc.layout = arguments.event.getValue("layout","ajax");
				  rc.document = dms.getDocument(rc.id);
				</cfscript>
				<cfif rc.document.recordCount eq 0>
					<cfset rc.layout = arguments.event.getValue("layout","Layout.Main")>
					<cfset arguments.event.setView('dms/notallowed')>
				<cfelse>
					<cfset rc.fileName = "#rc.app.dmsRoot#dms/documents/#rc.id#.#rc.document.filetype#">
					<cfset arguments.event.setView('dms/download')>
				</cfif>
			</cffunction>

      <cffunction name="dd" returntype="void" output="false" hint="My main event">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          rc.id = arguments.event.getValue('id',0);
        </cfscript>
          <cfset rc.fileName = "#rc.app.appRoot#dms/documents/#rc.id#">
          <cfset arguments.event.setView('dms/dd')>
      </cffunction>

      <cffunction name="inline" returntype="void" output="false" hint="My main event" cache="true">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          rc.id = arguments.event.getValue('id',0);
          rc.document = dms.getDocument(rc.id,true);
        </cfscript>
        <cfset arguments.event.setLayout("Layout.ajax")>
        <cfset rc.fileName = "#rc.app.appRoot#dms/documents/#rc.id#.#rc.document.filetype#">
        <cfset arguments.event.setView('dms/inline')>
      </cffunction>

      <cffunction name="flexPaper" returntype="void" output="false" hint="My main event" cache="true">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          rc.id = arguments.event.getValue('id',0);
          rc.document = dms.getDocument(rc.id,true);
          dms.flexPaper(rc.id,rc.document.fileType);
        </cfscript>
        <cfthread action="sleep" duration="#(2 * 1000)#" />
        <cfset rc.fileName = "#rc.app.appRoot#dms/documents/#rc.id#_pdf.swf">
        <cfset arguments.event.setView('dms/inline',true)>
      </cffunction>

			<cffunction name="upload" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
		      var rc = arguments.event.getCollection();
		      rc.nodeRef = arguments.event.getValue("nodeRef","");
		      rc.fileData = arguments.event.getValue("fileData","");
		      rc.categoryID = arguments.event.getValue("categoryID",0);
		      rc.documentID = arguments.event.getValue("documentID","undefined");
		      rc.filename = arguments.event.getValue("filename","speng");
		    </cfscript>
        <cflog application="true" text="#rc.documentID#">
		    <cffile action="copy" source="#rc.fileData#" destination="#rc.app.appRoot#dms/documents/#rc.filename#">
        <cfset rc.fileSize = dms.fileSize("#rc.app.appRoot#dms/documents/#rc.filename#")>
        <cfset rc.fileType = getextension("#rc.app.appRoot#dms/documents/#rc.filename#")>
		    <cfif rc.documentID eq "undefined">
          <cfset rc.documentID = dms.createDMSDocument(
            categoryID = rc.categoryID,
            documentName = listFirst(rc.filename,"."),
            fileSize = rc.fileSize,
            fileType = rc.fileType
          )>
          <cffile action="move" source="#rc.app.appRoot#dms/documents/#rc.filename#" destination="#rc.app.appRoot#dms/documents/#rc.documentID#.#rc.fileType#">
        <cfelse>
          <cffile action="move" source="#rc.app.appRoot#dms/documents/#rc.filename#" destination="#rc.app.appRoot#dms/documents/#rc.documentID#.#listLast(rc.fileName,'.')#">
          <cflog application="true" text="update #rc.documentID#">
          <cfset dms.updateWithDocumentInfo(
            documentID = rc.documentID,
            name = listFirst(rc.filename,"."),
            fileType = listLast(rc.fileName,".")
          )>
        </cfif>
        <cfset dms.createThumbnails(rc.documentID,rc.fileType)>
        <cfset arguments.event.setLayout("Layout.ajax")>
        <cfset arguments.event.setView("blank")>

			</cffunction>

      <cffunction name="arrangeDocuments" returntype="void">
        <cfargument name="event">

        <cfset var rc = arguments.event.getCollection()>
        <cfset var companies = company.getCompanies()>
        <cfloop query="companies">
          <cfset rc.dmsCat = dms.getRelatedCategory(relatedType="company",relatedID="#id#")>
          <cfif rc.dmsCat.recordCount eq 0>
            <cfset rc.x = dms.createDMSCategory(categoryTitle="#name#",categoryRelationshipType="company",categoryRelationShipID=id,parentCategoryID=3199)>
            <cfset rc.dmsCat = dms.getRelatedCategory(relatedType="company",relatedID="#id#")>
          </cfif>
          <cfset rc.newCat = dms.createDMSCategory(categoryTitle="Agreements",categoryRelationshipType="company",categoryRelationShipID=id,parentCategoryID=rc.dmsCat.id)>
          <cfset rc.dmsCat = dms.getCategory(rc.newCat)>
          <cfset rc.deals = psa.getArrangementBySupplier(id)>
          <cfloop query="rc.deals">
             <cfset rc.dealCat = dms.getRelatedCategory(relatedType="deal",relatedID="#id#")>
             <cfif rc.dealCat.recordCount eq 0>
              <cfset dms.createDMSCategory(categoryTitle="#name#",categoryRelationshipType="deal",categoryRelationShipID=id,parentCategoryID=rc.dmsCat.id)>
              <cfset rc.dealCat = dms.getRelatedCategory(relatedType="deal",relatedID="#id#")>
             </cfif>
             <cfif rc.dealCat.id eq "">
                <cfset rc.dealCat.id = 0>
              </cfif>
             <cfquery name="updatedms" datasource="#dsn.getName()#">
                update dmsCategory set name= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.deals.id#-#YEAR(rc.deals.period_from)# #company.getCompany(rc.deals.company_id).getknown_as()#">, parentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#dmsCat.id#"> where
                id = <cfqueryparam cfsqltype="cf_sql_integer" value="#rc.dealCat.id#">
              </cfquery>
          </cfloop>
        </cfloop>
      </cffunction>

  <cffunction name="tree" cache="true">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.tree = dms.getCategories(rc.id);
      if (rc.id neq 0) {
        rc.documents = dms.getDocuments(rc.id);
      }
    </cfscript>
    <cfset rc.logEvent = false>
    <cfset rc.listItems = ArrayNew(1)>
    <cfloop query="rc.tree">
      <cfset rc.x = StructNew()>
        <cfset rc.x["attr"]["id"] = "#id#">
        <cfset rc.x["data"]["title"] = "#name#">
        <cfset rc.x["data"]["attr"]["href"] = "#bl('documents.categoryList','id=#id#')#">
        <cfset rc.x["state"] = "closed">
        <cfset arrayAppend(rc.listItems,rc.x)>
    </cfloop>
    <cfif rc.id neq 0>
    <cfloop query="rc.documents">
      <cfset rc.d = StructNew()>
      <cfset rc.d["data"]["title"] = name>
      <cfset rc.d["data"]["attr"]["id"] = "#id#">
      <cfset rc.d["data"]["attr"]["title"] = "#name#">
      <cfset rc.d["data"]["attr"]["class"] = "tooltip">
      <cfset rc.d["data"]["attr"]["href"] = "#bl('documents.detail','id=#id#')#">
      <cfset rc.d["data"]["icon"] = "#fileType#">
      <cfset arrayAppend(rc.listItems,rc.d)>
    </cfloop>
    </cfif>

    <cfset rc.json = SerializeJSON(rc.listItems)>
    <cfset arguments.event.setView("renderJSON")>
  </cffunction>

  <cffunction name="search" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.str = arguments.event.getValue("q","")>
    <cfset rc.results = dms.search(rc.str,getSetting("sitename"))>
    <cfset arguments.event.setView("debug")>
  </cffunction>
	<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>
  <cffunction name="oldhandler" returntype="void">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.doc = arguments.event.getValue("doc","xxxx")>
    <cfset rc.dmsDOc = dms.getDocumentByName(ListFirst(rc.doc,"."))>
    <cfif rc.dmsDoc.recordCOunt neq 0>
      <cfset setNextEvent(uri="/documents/detail/id/#rc.dmsDoc.id#")>
    </cfif>
    <cfset arguments.event.setView("/dms/oldhandler")>
  </cffunction>
</cfcomponent>

