<cfcomponent name="figuresHandler" cache="true" cacheTimeout="30" output="false">
	<!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
	<!--- Default Action --->
	<cfproperty name="groups" inject="id:eunify.GroupsService" />
	<cfproperty name="company" inject="id:eunify.CompanyService" />
	<cfproperty name="branch" inject="id:eunify.BranchService" />
	<cfproperty name="psa" inject="id:eunify.PSAService" />
	<cfproperty name="feed" inject="id:eunify.FeedService" />
	<cfproperty name="favourites" inject="id:eunify.FavouritesService" />

			<cffunction name="edit" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
					rc.id = arguments.event.getValue("id",0);
					rc.companyID = arguments.event.getValue("companyID",0);
					rc.branch = branch.getBranch(rc.id);
				</cfscript>
				<cfset arguments.event.setView('branch/edit')>
			</cffunction>

			<cffunction name="getAll" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();

				  rc.id = arguments.event.getValue('id',0);
					rc.company = company.getCompany(rc.id);
				  rc.branches = branch.getAll(rc.id);
				</cfscript>
				<cfset arguments.event.setView('branch/list')>
			</cffunction>

			<cffunction name="delete" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.id = arguments.event.getValue('id',0);
				  rc.branches = branch.getBranch(rc.id);
					rc.branches.delete();
					if (platform neq "CF9") {
					 thread name="data_#createUUID()#" action="run" rc=rc {
					   rc.branches.delete(remoteDB);
					 }
					}
				  rc.layout = arguments.event.getValue("layout","ajax");
				</cfscript>

				<cfset arguments.event.setLayout('Layout.#rc.layout#')>
				<cfset arguments.event.setView('blank')>
			</cffunction>

			<cffunction name="doEdit" returntype="void" output="false" hint="My main event">
			<cfargument name="event">

			<!--- should probably use a bean for this - but time is of the essence! --->
			<cfscript>
			  var rc = arguments.event.getCollection();
			  rc.id = arguments.event.getValue('id',0);
				if (rc.id neq 0 and rc.id neq "") {
					rc.branch = branch.getBranch(rc.id);
					rc.branch = populateModel(rc.branch);
				} else {
					rc.branch = populateModel(branch);
				}
				arguments.event.setLayout('Layout.Main');
				arguments.event.setView('debug');
				rc.branch.save();
			  setNextEvent(uri="/eunify/company/detail/id/#rc.branch.getcompany_id()#");
			</cfscript>

		</cffunction>

			<cffunction name="getCoOrdinates" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();

				  rc.branch = populateModel(branch);
					rc.branch.getCoOrdinates();
				  rc.layout = arguments.event.getValue("layout","ajax");
					rc.json = structNew();
					rc.json["longitude"] = rc.branch.getmaplong();
					rc.json["latitude"] = rc.branch.getmaplat();
					rc.json = SerializeJSON(rc.json);
				</cfscript>
        <cfset rc.logEvent = false>

				<cfset arguments.event.setView('renderJSON')>
			</cffunction>

      <cffunction name="listAll" returntype="void" output="true" hint="My main event">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          var x = "";
          var html = "";
          rc.branches = branch.getFullList();
          rc.layout = arguments.event.getValue("layout","ajax");
          rc.results = arrayNew(1);
        </cfscript>
        <cfloop query="rc.branches">
          <cfset rc.c = currentRow>
          <cfsavecontent variable="html">
            <cfoutput>
              #renderView("branch/mapView")#
            </cfoutput>
          </cfsavecontent>
          <cfset x = StructNew()>
          <cfset x["longitude"] = maplong>
          <cfset x["html"] = html>
          <cfset x["latitude"] = maplat>
          <cfset x["id"] = id>
          <cfset x["name"] = name>
          <cfset x["address1"] = address1>
          <cfset x["address2"] = address2>
          <cfset x["producttypes"] = "#product_types#markerimage">
          <cfset x["town"] = town>
          <cfset x["tel"] = tel>
          <cfset x["email"] = email>
          <cfset ArrayAppend(rc.results,x)>
        </cfloop>
        <cfscript>
          rc.json = rc.results;
          rc.json = SerializeJSON(rc.json);
        </cfscript>

        <cfset arguments.event.setLayout('Layout.#rc.layout#')>
        <cfset arguments.event.setView('renderJSON')>
      </cffunction>

      <cffunction name="getAllJSON" returntype="void" output="false" hint="My main event">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          var x = "";
          rc.id = arguments.event.getValue('companyID',0);
          rc.type = arguments.event.getValue("type","application/json");
          rc.company = company.getCompany(rc.id);
          rc.branches = branch.getAll(rc.id);
          rc.layout = arguments.event.getValue("layout","ajax");
          rc.results = arrayNew(1);
        </cfscript>
        <cfloop query="rc.branches">
          <cfset x = StructNew()>
          <cfset x["longitude"] = maplong>
          <cfset x["latitude"] = maplat>
          <cfset x["id"] = id>
          <cfset x["name"] = name>
          <cfset x["address1"] = address1>
          <cfset x["address2"] = address2>
          <cfset x["producttypes"] = "#product_types#markerimage">
          <cfset x["town"] = town>
          <cfset x["tel"] = tel>
          <cfset x["email"] = email>
          <cfset ArrayAppend(rc.results,x)>
        </cfloop>
        <cfscript>
          rc.json = rc.results;
          rc.json = SerializeJSON(rc.json);
        </cfscript>

        <cfset arguments.event.setLayout('Layout.#rc.layout#')>
        <cfset arguments.event.setView('renderJSON')>
      </cffunction>

    <cffunction name="getAllJSONLocator" returntype="void" output="false" hint="My main event">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          var x = "";
          var html = "";
          var resulthtml = "";
          rc.id = arguments.event.getValue('companyID',0);
          rc.type = arguments.event.getValue("type","application/json");
          rc.company = company.getCompany(rc.id);
          rc.branches = branch.getAll(rc.id);
          rc.layout = arguments.event.getValue("layout","ajax");
          rc.results = arrayNew(1);
        </cfscript>
        <cfloop query="rc.branches">
          <cfset rc.c = currentRow>
          <cfsavecontent variable="html">
            <cfoutput>
              #renderView("branch/mapView")#
            </cfoutput>
          </cfsavecontent>
          <cfsavecontent variable="resulthtml">
            <cfoutput>
              #renderView("branch/additionalResult")#
            </cfoutput>
          </cfsavecontent>
          <cfset x = StructNew()>
          <cfset x["longitude"] = maplong>
          <cfset x["html"] = html>
          <cfset x["resulthtml"] = resulthtml>
          <cfset x["latitude"] = maplat>
          <cfset x["id"] = id>
          <cfset x["name"] = name>
          <cfset x["address1"] = address1>
          <cfset x["address2"] = address2>
          <cfset x["producttypes"] = "#product_types#markerimage">
          <cfset x["town"] = town>
          <cfset x["tel"] = tel>
          <cfset x["email"] = email>
          <cfset ArrayAppend(rc.results,x)>
        </cfloop>
        <cfscript>
          rc.json = rc.results;
          rc.json = SerializeJSON(rc.json);
        </cfscript>

        <cfset arguments.event.setLayout('Layout.#rc.layout#')>
        <cfset arguments.event.setView('renderJSON')>
      </cffunction>

      <cffunction name="getAllJSONP" returntype="void" output="false" hint="My main event">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          var x = "";
          rc.id = arguments.event.getValue('companyID',0);
          rc.type = arguments.event.getValue("type","application/json");
          rc.company = company.getCompany(rc.id);
          rc.callback = arguments.event.getValue("callback","");
          rc.branches = branch.getAll(rc.id);
          rc.layout = arguments.event.getValue("layout","ajax");
          rc.results = arrayNew(1);
        </cfscript>
        <cfloop query="rc.branches">
          <cfset x = StructNew()>
          <cfset x["longitude"] = maplong>
          <cfset x["latitude"] = maplat>
          <cfset x["id"] = id>
          <cfset x["name"] = name>
          <cfset x["address1"] = address1>
          <cfset x["address2"] = address2>
          <cfset x["producttypes"] = "#product_types#markerimage">
          <cfset x["town"] = town>
          <cfset x["tel"] = tel>
          <cfset x["email"] = email>
          <cfset ArrayAppend(rc.results,x)>
        </cfloop>
        <cfscript>
          rc.json = rc.results;
          rc.json = SerializeJSON(rc.json);
        </cfscript>

        <cfset arguments.event.setLayout('Layout.#rc.layout#')>
        <cfset arguments.event.setView('renderJSONp')>
      </cffunction>
      <cffunction name="detailJSONP" returntype="void" output="false" hint="My main event">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          rc.id = arguments.event.getValue('branchID',0);
          rc.branch = branch.getBranch(rc.id);
          rc.callback = arguments.event.getValue("callback","");
          rc.type = arguments.event.getValue("type","application/json");
        </cfscript>
        <cfscript>
          rc.json = SerializeJSON(rc.branch);
        </cfscript>

        <cfset arguments.event.setLayout('Layout.ajax')>
        <cfset arguments.event.setView('renderJSONp')>
      </cffunction>


      <cffunction name="search" returntype="void" output="true" hint="My main event">
        <cfargument name="event">

        <cfscript>
          var rc = arguments.event.getCollection();
          var x = "";
          var html = "";
          var resulthtml = "";
          rc.lat = arguments.event.getValue("lat","");
          rc.long = arguments.event.getValue("lng","");
          rc.radius = arguments.event.getValue("radius","");
          rc.branches = branch.branchLocator(rc.lat,rc.long,rc.radius);
          rc.layout = arguments.event.getValue("layout","ajax");
          rc.results = arrayNew(1);
        </cfscript>
        <cfloop query="rc.branches">
          <cfset rc.c = currentRow>
          <cfsavecontent variable="html">
            <cfoutput>
              #renderView("branch/mapView")#
            </cfoutput>
          </cfsavecontent>
          <cfsavecontent variable="resulthtml">
            <cfoutput>
              #renderView("branch/mapResult")#
            </cfoutput>
          </cfsavecontent>
          <cfset x = StructNew()>
          <cfset x["longitude"] = maplong>
          <cfset x["html"] = html>
          <cfset x["resulthtml"] = resulthtml>
          <cfset x["latitude"] = maplat>
          <cfset x["id"] = id>
          <cfset x["name"] = name>
          <cfset x["address1"] = address1>
          <cfset x["address2"] = address2>
          <cfset x["town"] = town>
          <cfset x["tel"] = tel>
          <cfset x["producttypes"] = "#product_types#markerimage">
          <cfset x["email"] = email>
          <cfset x["distance"] = distance>
          <cfset ArrayAppend(rc.results,x)>
        </cfloop>
        <cfscript>
          rc.json = rc.results;
          rc.json = SerializeJSON(rc.json);
        </cfscript>

        <cfset arguments.event.setLayout('Layout.#rc.layout#')>
        <cfset arguments.event.setView('renderJSON')>
      </cffunction>

  <cffunction name="export" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.branches = branch.exportData()>
    <cfspreadsheet  query="rc.branches" sheetname="Branches" action="write" filename="/tmp/#getSetting('SiteName')#members.xls" />
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("company/export")>
  </cffunction>
	<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>
</cfcomponent>

