<cfcomponent name="figuresHandler" cache="true" cacheTimeout="30" output="false">

	<cfproperty name="groups" inject="id:eunify.GroupsService" />
	<cfproperty name="site" inject="model:SiteService" />
	<cfproperty name="user" inject="model:UserService" />
	<cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfproperty name="figures" inject="id:eunify.FiguresService" />
	<cfproperty name="psa" inject="id:eunify.PSAService" />
	<cfproperty name="favourites" inject="id:eunify.FavouritesService" />
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="dsnRead" inject="model:datasource" />

<cffunction name="index" returntype="void" output="false" hint="My main event" cache="true">
		<cfargument name="event">

		<cfscript>
		  var rc = arguments.event.getCollection();
		  rc.id = arguments.event.getValue('id',0);
		  rc.user = user.getUser(rc.id);
		  rc.company = site.getsite();

		  rc.canEditContact = isUserInRole("ebiz");
		</cfscript>

		<cfset arguments.event.setView('user/view')>
	</cffunction>

  <cffunction name="noiemessage" returntype="void">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.cookie.setVar("showIEMessage","false")>
    <cfset arguments.event.setView("blank",true)>
  </cffunction>

  <cffunction name="cachecontrol" returntype="void">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.enabled = event.getValue("enabled",false)>
    <cfset rc.cookie.setVar("cacheDisabled",rc.enabled,90)>
    <cfset rc.sess.eGroup.cacheDisabled = rc.enabled>
    <cfset arguments.event.setView("blank",true)>
  </cffunction>

  <cffunction name="passwordReminder" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.email = arguments.event.getValue("email","")>
    <cfset user.emailPassword(rc.email)>
    <cfset arguments.event.setView('login/reminderSent')>
  </cffunction>

  <cffunction name="getSessStruct" returntype="struct">
    <cfargument name="emailAddress" required="true">
    <cfargument name="timeout" required="true" default="20">
    <cfset var contact = "">
    <cfquery name="contact" datasource="#dsnRead.getName()#">
        select sessStruct from user where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailAddress#">
      </cfquery>
    <cfif isJSON(contact.sessStruct)>
    <cfreturn DeSerializeJSON(contact.sessStruct)>
    <cfelse>
    <cfreturn StructNew()>
    </cfif>
  </cffunction>

  <cffunction name="setSessStruct" returntype="void">
    <cfargument name="emailAddress" required="true">
    <cfargument name="struct" required="true">
    <cfset var contact = "">
    <cfquery name="contact" datasource="#dsnRead.getName()#">
        update user set sessStruct = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(arguments.struct)#"> where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailAddress#">
      </cfquery>
  </cffunction>

  <cffunction name="layoutMode" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.simple = arguments.event.getValue("simple","on");
      if (rc.simple eq "on") {
        rc.cookie.setVar("layoutStyle","Simple");
      } else {
        rc.cookie.setVar("layoutStyle","Main");
      }
      rc.sess.BMNet.sessionReference = createUUID();
      // now we need to clear this users cache

    </cfscript>

    <cfset arguments.event.setView('blank')>
  </cffunction>

			<cffunction name="edit" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.id = arguments.event.getValue('id',0);
				  rc.user = user.getUser(rc.id);
				  rc.groups = groups;
				  rc.layout = arguments.event.getValue("layout","Main");
					rc.sites = sites.List();
					rc.suppliers = company.getSuppliers();
					rc.both = company.getCompanies(3);
					if (rc.id eq 0) {
						rc.canEditContact = true;
					} else {
						rc.company = company.getCompany(rc.contact.getcompany_id());
						rc.canEditContact = canEditContact(rc.contact.getcompany_id(),rc.sess.eGroup.companyID);
					}


				</cfscript>
				<cfset arguments.event.setView('contact/edit')>
			</cffunction>
			<cffunction name="favourites" returntype="void" output="false" hint="My main event">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.id = arguments.event.getValue('id',0);
				  rc.favourites = favourites.get(rc.id);
				  rc.layout = arguments.event.getValue("layout","ajax");
				</cfscript>
				<cfset arguments.event.setLayout('Layout.#rc.layout#')>
				<cfset arguments.event.setView('contact/panels/favourites')>
			</cffunction>
		<cffunction name="view" returntype="void" output="false" hint="My main event" cache="true">
			<cfargument name="event">

			<cfscript>
			  var rc = arguments.event.getCollection();
			  rc.id = arguments.event.getValue('id',0);
			  rc.user = user.getUser(rc.id);
				rc.totalHits = 0;
				rc.thisMonth = 0;
				rc.lastFiveSessions = 0;

			</cfscript>


			<cfset arguments.event.setView('user/panels/view')>
		</cffunction>

    <cffunction name="pivotSource" returntype="void" output="false" cache="true">
      <cfargument name="event">

      <cfset var rc = arguments.event.getCollection()>
      <cfset rc.e = urlEncrypt(rc.sess.eGroup.username)>
      <cfset arguments.event.setView("contact/pivotSource")>
    </cffunction>

		<cffunction name="allContacts" returntype="void" output="false" hint="My main event" cache="true">
			<cfargument name="event">

			<cfscript>
			  var rc = arguments.event.getCollection();
			  rc.typeID = arguments.event.getValue('id',0);
			  rc.contacts = contact.getCompanyTypeContacts(rc.id);
			</cfscript>

			<cfset arguments.event.setView('contact/allContacts')>
		</cffunction>

		<cffunction name="allContactsGrid" returntype="void" output="false" hint="My main event" cache="true">
			<cfargument name="event">

			<cfscript>
			  var rc = arguments.event.getCollection();
			  rc.typeID = arguments.event.getValue('id',0);
				rc.page = arguments.event.getValue("page",1);
				rc.pageSize = arguments.event.getValue("rows",10);
				rc.sortcol = arguments.event.getValue("sidx","id");
				rc.sortdir = arguments.event.getValue("sortd","asc");
				rc.s = arguments.event.getValue("search","");
				rc.contacts = contact.getAllContacts(rc.sortdir,rc.sortcol,rc.s);
		</cfscript>
		<cfset rc.start = ((rc.page-1)*rc.pageSize)+1>
		<cfset rc.end = (rc.start-1) + rc.pageSize>
		<cfset rc.i = 1>
		<cfset rc.arrUsers = ArrayNew(1)>
		<cfloop query="rc.contacts" startrow="#rc.start#" endrow="#rc.end#">
			<cfset rc.arrUsers[rc.i] =
				{
					"contactID"		= "#contactID#",
					"cell"	=	["#first_name#","#surname#","#known_as#"]
				}>
			<cfset rc.i = rc.i + 1>
		</cfloop>

		<cfset rc.totalPages = Ceiling(rc.contacts.recordcount/rc.pageSize)>
		<cfset rc.jsO = StructNew()>
		<cfset rc.jsO["total"] = rc.totalPages>
		<cfset rc.jsO["page"] = rc.page>
		<cfset rc.jsO["records"] = rc.contacts.recordcount>
		<cfset rc.jsO["rows"] = rc.arrUsers>
		<cfset rc.json = serializeJSON(rc.jsO)>

		<cfset arguments.event.setLayout('Layout.ajax')>
		<cfset arguments.event.setView('renderJSON')>
		</cffunction>

  <cffunction name="fullHistory" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.contactID = arguments.event.getValue("id",0)>
    <cfset rc.date_from = arguments.event.getValue("date_from","")>
    <cfset rc.date_to = arguments.event.getValue("date_to","")>
    <cfset rc.logFilter = arguments.event.getValue("logFilter","")>
    <cfset rc.contact = contact.getContact(rc.contactID)>
    <cfset rc.company = company.getCompany(rc.contact.getcompany_id())>
    <cfset rc.boundaries = getMyPlugin("Paging").getBoundaries(15)>
    <cfset rc.history = contact.getHistory(rc.contactID,rc.boundaries.startRow,rc.boundaries.maxrow,rc.date_from,rc.date_to,rc.logFilter)>
    <cfset rc.count = rc.history.count.count>
    <cfset rc.historyQ = rc.history.history>
    <cfset arguments.event.setView("contact/fullHistory")>
  </cffunction>

	<cffunction name="childGrid" returntype="void" output="false" hint="My main event" cache="true">
			<cfargument name="event">

			<cfscript>
			  var rc = arguments.event.getCollection();
				rc.parentID = arguments.event.getValue("parentID",0);
				rc.contacts = groups.getAllChildContactsforGrid(rc.parentID);
		</cfscript>
		<cfset rc.arrUsers = ArrayNew(1)>
		<cfloop query="rc.contacts">
			<cfset rc.arrUsers[currentRow] = StructNew()>
			<cfscript>
				rc.arrUsers[currentRow]["id"] ="#id#";
				rc.arrUsers[currentRow]["first_name"] = "#first_name#";
				rc.arrUsers[currentRow]["surname"] = "#surname#";
				rc.arrUsers[currentRow]["known_as"] = "#known_as#";
			</cfscript>
		</cfloop>
		<cfset rc.jsO = StructNew()>
		<cfset rc.jsO["rows"] = rc.arrUsers>
		<cfset rc.json = serializeJSON(rc.jsO)>
		<cfset arguments.event.setLayout('Layout.ajax')>
		<cfset arguments.event.setView('renderJSON')>
		</cffunction>

	<cffunction name="allContactsGroupsGrid" returntype="void" output="false" hint="My main event" cache="true">
			<cfargument name="event">

			<cfscript>
			  var rc = arguments.event.getCollection();
				rc.page = arguments.event.getValue("page",1);
				rc.pageSize = arguments.event.getValue("rows",10);
				rc.sortcol = arguments.event.getValue("sidx","id");
				rc.sortdir = arguments.event.getValue("sortd","asc");
				rc.groups = groups.fullGroupListGrid(rc.sortdir,rc.sortcol);
		</cfscript>
		<cfset rc.start = ((rc.page-1)*rc.pageSize)+1>
		<cfset rc.end = (rc.start-1) + rc.pageSize>
		<cfset rc.i = 1>
		<cfset rc.arrUsers = ArrayNew(1)>
		<cfloop query="rc.groups" startrow="#rc.start#" endrow="#rc.end#">
			<cfset rc.arrUsers[rc.i] =
				{
					"id"		= "#id#",
					"cell"	=	["#name#"]
				}>
			<cfset rc.i = rc.i + 1>
		</cfloop>
		<cfset rc.totalPages = Ceiling(rc.groups.recordcount/rc.pageSize)>
		<cfset rc.jsO = StructNew()>
		<cfset rc.jsO["total"] = rc.totalPages>
		<cfset rc.jsO["page"] = rc.page>
		<cfset rc.jsO["records"] = rc.groups.recordcount>
		<cfset rc.jsO["rows"] = rc.arrUsers>
		<cfset rc.json = serializeJSON(rc.jsO)>

		<cfset arguments.event.setLayout('Layout.ajax')>
		<cfset arguments.event.setView('renderJSON')>
		</cffunction>

  <cffunction name="dashboard" returntype="void" output="false" hint="My main event" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psa = psa>
    <cfset rc.logger = logger>
    <cfset rc.monthrebatePayments = figures.payable(rc.sess.eGroup.companyID)>
    <cfset rc.yearrebatePayments = figures.payable(memberID=rc.sess.eGroup.companyID,period_from=createDate(year(now()),1,1))>
    <cfset arguments.event.setView('contact/dashboard')>
  </cffunction>
  <cffunction name="dashboarddata" returntype="void" output="false" hint="My main event" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.rebatePayments = figures.getMemberTurnover(periodFrom=DateAdd("yyyy",-2,now()),periodTo=now(),members=rc.sess.eGroup.companyID)>
    <cfset rc.groupPayments = figures.getMemberTurnover(periodFrom=DateAdd("yyyy",-2,now()),periodTo=now(),members=rc.sess.eGroup.companyID,allbut=true)>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('charts/memberTurnover')>
  </cffunction>

		<cffunction name="negotiating" returntype="void" output="false" hint="My main event" cache="true">
			<cfargument name="event">

			<cfscript>
			  var rc = arguments.event.getCollection();
			  rc.id = arguments.event.getValue('id',0);
			  rc.psas = psa.getArrangementByNegotiator(rc.id);
			  rc.layout = arguments.event.getValue("layout","ajax");
			</cfscript>

			<cfset arguments.event.setLayout('Layout.#rc.layout#')>
			<cfset arguments.event.setView('contact/panels/psas')>
		</cffunction>

		<cffunction name="feed" returntype="void" output="false" hint="My main event" cache="true">
				<cfargument name="event">

				<cfscript>
				  var rc = arguments.event.getCollection();
				  rc.id = arguments.event.getValue('id',0);
				  rc.feed = feed.getFeed(sql='((sourceObject = "contact" AND sourceID = "#rc.id#") OR (targetObject="contact" AND targetID = "#rc.id#"))');
				  rc.contact = contact.getContact(rc.id);
				  rc.layout = arguments.event.getValue("layout","ajax");
				</cfscript>

				<cfset arguments.event.setLayout('Layout.#rc.layout#')>
				<cfset arguments.event.setView('feed/general')>
			</cffunction>

			<cffunction name="doEdit" returntype="void" output="false" hint="My main event">
			<cfargument name="event">

			<!--- should probably use a bean for this - but time is of the essence! --->
			<cfscript>
			 var rc = arguments.event.getCollection();
			  rc.id = arguments.event.getValue('id',0);
				if (rc.id neq 0 and rc.id neq "") {
					rc.contact = contact.getContact(rc.id);
					rc.contact = populateModel(rc.contact);
				} else {
					rc.contact = populateModel(contact);
				}
				arguments.event.setLayout('Layout.Main');
				arguments.event.setView('debug');
			  rc.contact.save();
				if (platform neq "CF9") {
          thread action="run" name="data_#createIID#" rc=rc remoteDB=remoteDB {
            attributes.rc.contact.save(attributes.remoteDB);
          }
        }
			  setNextEvent("contact.index","id=#rc.contact.getid()#");
			</cfscript>

		</cffunction>
  <cffunction name="delete" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset rc.contact = contact.getContact(rc.id)>
    <cfset contact.deleteContact(rc.id)>
    <cfscript>
    if (platform neq "CF9") {
          thread action="run" name="data_#createIID#" instance=instance  rc=rc remoteDB=remoteDB {
            attributes.contact.deleteContact(attributes.rc.id,attributes.remoteDB);
          }
        }
    </cfscript>
    <cfset setNextEvent("company.index.id.#contact.getcompany_id()#")>
  </cffunction>


  <cffunction name="export" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.membercontacts = contact.exportData(1)>
    <cfset rc.suppliercontacts = contact.exportData(2)>
    <cfspreadsheet  query="rc.membercontacts" sheetname="Member Contacts" action="write" filename="/tmp/#getSetting('SiteName')#members.xls" />
    <cfspreadsheet  query="rc.suppliercontacts" sheetname="Supplier Contacts" action="update" filename="/tmp/#getSetting('SiteName')#members.xls" />
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("company/export")>
  </cffunction>
	<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>

  <cffunction name="currentUsers" returntype="void" output="false" cache="true" cacheTimeout="10">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.logEvent = false>
    <cfquery name="rc.currentUsers" datasource="#dsnRead.getName()#" result="rc.currUs">
      select
        contactID,
        contact.first_name,
        contact.surname,
        contact.email,
        company.name,
        company.known_as,
        company.id as companyID
      from
        visitorLog,
        contact,
        company
      where
        stamp > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n',-5,DateConvert('local2utc',now()))#">
        AND
        contact.id = visitorLog.contactID
        AND
        company.id = contact.company_id
        group by contactID
    </cfquery>

    <cfset arguments.event.setView("contact/currentUsers")>
  </cffunction>

  <cffunction name="recentlyViewed" returntype="void" output="true" cache="true" cacheTimeout="10">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.logEvent = false>
    <cfset rc.recentlyViewed = contact.recentlyViewed()>
    <cfset arguments.event.setView("contact/recentlyViewed")>
  </cffunction>
</cfcomponent>

