<cfcomponent name="calendarHandler" cache="true" cacheTimeout="30" output="false">
  <!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
  <!--- Default Action --->
  <cfproperty name="calendar" inject="id:eunify.CalendarService" />
  <cfproperty name="CampaignService" inject="id:marketing.CampaignService" />
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="groups" inject="id:eunify.GroupsService" />
  <cfproperty name="dms" inject="id:eunify.DocumentService" />
  <cfproperty name="platform" inject="coldbox:setting:platform" />
  <cfproperty name="remoteDB" inject="coldbox:setting:remoteDatasource" />

  <cffunction name="index" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
    </cfscript>
    <cfset arguments.event.setView('calendar/showCalendar')>
  </cffunction>
  <cffunction name="appointmentList" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.start = unix2timestamp(event.getValue("start",DateDiff("s", CreateDate(1970,1,1), Now())));
      rc.end = unix2timestamp(event.getValue("end",DateDiff("s", CreateDate(1970,1,1), Now())));
      rc.appointments = calendar.AppointmentList(rc.start,rc.end);
    </cfscript>
    <cfset var eventList = []>
    <cfloop query="rc.appointments">
      <cfset var eventS = {}>
      <cfset eventS["id"] = "#id#">
      <cfset eventS["title"] = "#name#">
      <cfset eventS["url"] = "/eunify/calendar/detail?id=#id#">
      <cfset eventS["target"] = "_self">
      <cfset eventS["description"] = "#description#">
      <cfset eventS["start"] = "#DateFormat(startDate,'YYYY-MM-DD')#T#TimeFormat(startDate,'HH:MM:SS')#.000Z">
      <cfset eventS["end"] = "#DateFormat(endDate,'YYYY-MM-DD')#T#TimeFormat(endDate,'HH:MM:SS')#.000Z">
      <cfset eventS["className"] = "#attending#">
      <cfset eventS["attendees"] = "#attendees#">
      <cfset eventS["address"] = "#address#">
      <cfset eventS["postcode"] = "#postcode#">
      <cfset ArrayAppend(eventList,eventS)>
    </cfloop>
    <cfset event.renderData(data=eventList,type="JSON")>

  </cffunction>

  <cffunction name="day" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.day = arguments.event.getValue("date",now());
      rc.appointments = calendar.getAppointmentsToday(rc.day);
      rc.yesterday = dateAdd('d',-1,rc.day);
      rc.tomorrow = dateAdd('d',1,rc.day);
      rc.dayStart  = CreateDateTime(year(rc.day),month(rc.day),day(rc.day),8,0,0);
      rc.dayEnd  = CreateDateTime(year(rc.day),month(rc.day),day(rc.day),20,0,0);
      rc.appWidth = 635;
      if (rc.appointments.recordCount gte 1) {
        rc.appWidth = int(635/rc.appointments.recordCount);
      }
    </cfscript>
    <cfset arguments.event.setView('calendar/day')>

  </cffunction>

  <cffunction name="detail" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.invited = false;
      rc.appointment = calendar.getAppointment(rc.id);
      rc.company = company.getCompany(request.bmnet.companyID);
      rc.category = dms.getRelatedCategory("appointment",rc.id);
      /*
      if (rc.category.recordCount eq 0) {
        rc.rootCompanyCat = dms.getCategory(categoryName="Appointments");
        rc.appointmentCat = dms.createDMSCategory(
            categoryTitle = "#rc.appointment.name# (#DateFormat(rc.appointment.StartDate,'MMMM DD YYYY')#)",
            categoryDescription = "",
            categoryRelationshipType = "appointment",
            categoryRelationShipID = rc.id,
            parentCategoryID = rc.rootCompanyCat.id
          );
        rc.category = dms.getCategory(rc.appointmentCat);
      }
      rc.docs = dms.getDocuments(rc.category.id);
      */
    </cfscript>
      <!--- user has been invited --->

      <cfset rc.invited = calendar.userIsInvited(request.bmnet.contactID,rc.id)>
      <cfset rc.status = calendar.attendingStatus(rc.id,request.bmnet.contactID)>
    <cfset arguments.event.setView('calendar/detail')>

  </cffunction>

  <cffunction name="regsitrant" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.eventID = arguments.event.getValue("eventID",0);
      rc.registrantID = arguments.event.getValue("registrantID",0);
      rc.attendeeInfo = calendar.getRegistrant(rc.eventID,rc.registrantID);
    </cfscript>
    <cfset arguments.event.setView('calendar/registrant')>

  </cffunction>

  <cffunction name="register" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.invited = false;
      rc.calendar = calendar;
      rc.appointment = calendar.getAppointment(rc.id);
    </cfscript>

    <cfset arguments.event.setView('calendar/register')>

  </cffunction>

  <cffunction name="attendeeList">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("campaignID",0)>
    <cfset rc.startRow = event.getValue("iDisplayStart",0)>
    <cfset rc.maxRows = event.getValue("iDisplayLength",10)>
    <cfset rc.categoryID = event.getValue("categoryID",0)>
    <cfset rc.sortColumn = event.getValue("iSortCol_0",0)>
    <cfset rc.sEcho = event.getValue("sEcho","")>
    <cfset rc.sortDirection = event.getValue("sSortDir_0","asc")>
    <cfset rc.searchQuery = event.getValue("sSearch","")>
    <cfset rc.recipientCount = calendar.getInvitedCount(rc.id)>
    <cfset rc.recipients = calendar.getInvited(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery,rc.id)>
    <cfscript>
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.recipients.recordcount;
      rc.json["iTotalDisplayRecords"] = rc.recipientCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.recipients">
      <cfset thisRow = [
        "#name#",
        "#known_as#",
        '<input type="hidden" name="recipient" value="#contactID#" /><button data-id="#contactID#" class="btn btn-small btn-sucess removeobject"><i class="icon-cross-circle-frame"></i>']>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json)>
  </cffunction>

  <cffunction name="aList" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.layout = arguments.event.getValue("layout","Main");
      rc.id = arguments.event.getValue("id",0);
      rc.page = arguments.event.getValue("page",1);
      rc.pageSize = arguments.event.getValue("rows",10);
      rc.sortcol = arguments.event.getValue("sidx","contactID");
      rc.sortdir = arguments.event.getValue("sortd","asc");
      rc.s = arguments.event.getValue("search","");
      rc.list = calendar.getInvited(rc.id,rc.sortdir,rc.sortcol);
    </cfscript>
    <cfset rc.start = ((rc.page-1)*rc.pageSize)+1>
    <cfset rc.end = (rc.start-1) + rc.pageSize>
    <cfset rc.i = 1>
    <cfset rc.arrUsers = ArrayNew(1)>
    <cfloop query="rc.list" startrow="#rc.start#" endrow="#rc.end#">
      <cfset rc.arrUsers[rc.i] =
        {
          "contactID"   = "#contactID#",
          "cell"  = ["#first_name#","#surname#","#known_as#"]
        }>
      <cfset rc.i = rc.i + 1>
    </cfloop>

    <cfset rc.totalPages = Ceiling(rc.list.recordcount/rc.pageSize)>
    <cfset rc.jsO = StructNew()>
    <cfset rc.jsO["total"] = rc.totalPages>
    <cfset rc.jsO["page"] = rc.page>
    <cfset rc.jsO["records"] = rc.list.recordcount>
    <cfset rc.jsO["rows"] = rc.arrUsers>
    <cfset rc.json = serializeJSON(rc.jsO)>

    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('renderJSON')>


  </cffunction>

  <cffunction name="confirm" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset rc.canattend = arguments.event.getValue("canattend","false")>
    <cfset rc.cID = arguments.event.getValue("cid",rc.sess.eGroup.contactID)>
    <cfset rc.return = calendar.attendStatus(rc.id,rc.canattend,rc.cID)>
    <cfscript>
    if (platform neq "CF9") {
        thread action="run" name="data_#createIID#" rc=rc instance=instance {
          attributes.calendar.attendStatus(rc.id,rc.canattend.rc.cID,remoteDB);
        }
      }
    </cfscript>
    <cfset arguments.event.setLayout("Layout.Main")>
    <cfset rc.nextURL = "/calendar/detail/id/#rc.id#">
    <cfif rc.canattend>
    <cfset rc.message = "Thank you. You Will be attending.">
    <cfelse>
    <cfset rc.message = "Thank you. You Will not be attending.">
    </cfif>
    <cfset arguments.event.setView("message")>
  </cffunction>

  <cffunction name="edit" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.layout = arguments.event.getValue("layout","Main");
      rc.id = arguments.event.getValue("id",0);
      rc.appointment = calendar.getAppointment(rc.id);
      if (rc.id eq 0) {
        rc.startDate = now();
        rc.endDate = now();
      } else {
        rc.startDate = rc.appointment.startDate;
        rc.endDate = rc.appointment.endDate;
      }
      rc.permissions = dms.getDMSSecurity("calendar",rc.id);
      rc.invitees = calendar.getInvitees(rc.id);
    </cfscript>
      <!--- user has been invited --->
    <cfset arguments.event.setView('calendar/edit')>

  </cffunction>

  <cffunction name="editRegistration" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.calendar = calendar;
      rc.appointment = calendar.getAppointment(rc.id);
    </cfscript>
    <!--- user has been invited --->
    <cfset arguments.event.setView('calendar/editRegistration')>

  </cffunction>

  <cffunction name="removeAttendee">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset calendar.removeRecipient(rc.campaignID,rc.id)>
    <cfset event.noRender()>
  </cffunction>
  <cffunction name="addAttendee">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.recipients = calendar.addRecipient(rc.campaignID,rc.type,rc.id)>
    <cfset event.noRender()>
  </cffunction>
  <cffunction name="addQuery">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.recipients = calendar.addQueryRecipient(rc.campaignID,rc.queryID)>
    <cfset event.noRender()>
  </cffunction>
  <cffunction name="addMeta" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.eventID = event.getValue("eventID",0)>
    <cfset rc.fieldName = event.getValue("fieldName",0)>
    <cfset rc.fieldValue = event.getValue("fieldValue",0)>
    <cfset rc.fieldType = event.getValue("fieldType",0)>
    <cfset rc.fieldGroup = event.getValue("fieldGroup",0)>
    <cfset rc.groupName = event.getValue("groupName",0)>
    <cfset rc.required = event.getValue("required",0)>
    <cfset calendar.addMeta(rc.eventID,rc.fieldName,rc.fieldValue,rc.fieldType,rc.fieldGroup,rc.groupName,rc.required)>
    <cfset event.setView("blank")>
  </cffunction>

  <cffunction name="delete" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.appointment = calendar.getAppointment(rc.id);
      calendar.deleteAppointment(rc.id);
      if (platform neq "CF9") {
        thread action="run" name="data_#createIID#" rc=rc instance=instance {
          attributes.calendar.deleteAppoint(attributes.rc.id,remoteDB);
        }
      }
      setNextEvent(uri="/calendar/day/date/#rc.appointment.getstartDate()#");
    </cfscript>
      <!--- user has been invited --->
    <cfset arguments.event.setLayout('Layout.Main')>
    <cfset arguments.event.setView('calendar/edit')>

  </cffunction>

  <cffunction name="editList" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.layout = arguments.event.getValue("layout","Main");
      rc.id = arguments.event.getValue("id",0);
      rc.templates = calendar.getTemplates();
      rc.contactGroups = groups.fullGroupList(rc.sess.eGroup.companyID);
      rc.prequeries = CampaignService.listQueries();
    </cfscript>
      <!--- user has been invited --->
    <cfset arguments.event.setView('calendar/editList')>

  </cffunction>
  <cffunction name="doListEdit">
  <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
    </cfscript>
    <cfset arguments.event.setLayout("Layout.Main")>
    <cfset arguments.event.setView("debug")>
  </cffunction>
  <cffunction name="doEdit" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.layout = arguments.event.getValue("layout","Main");
      rc.id = arguments.event.getValue("id",0);
      rc.invite =  arguments.event.getValue("inviteGuests",false);
      rc.startDate = LSDateFormat(arguments.event.getValue("startDate",now()));
      rc.companyID = arguments.event.getValue("companyID",0);
      rc.startHour = arguments.event.getValue("startHour",8);
      rc.startMinute = arguments.event.getValue("startMinute",0);
      rc.startDate = CreateDateTime(year(rc.startDate),month(rc.startDate),day(rc.startDate),rc.startHour,rc.startMinute,0);
      rc.endDate = LSDateFormat(arguments.event.getValue("endDate",now()));
      rc.endHour = arguments.event.getValue("endHour",8);
      rc.endMinute = arguments.event.getValue("endMinute",0);
      rc.organiserID = arguments.event.getValue("organiserID",rc.sess.eGroup.contactID);
      rc.endDate = CreateDateTime(year(rc.endDate),month(rc.endDate),day(rc.endDate),rc.endHour,rc.endMinute,0);
      if (rc.id neq 0 and rc.id neq "") {
          rc.calendar = populateModel(calendar);
          rc.calendar.setid(rc.id);
        } else {
          rc.calendar = populateModel(calendar);
          // create DMS Category...

        }
      rc.calendar.save();
      if (platform neq "CF9") {
        thread action="run" name="data_#createIID#" rc=rc {
          attributes.rc.calendar.save(remoteDB);
        }
      }
      if (rc.invite) {
        setNextEvent(uri="/index.cfm?event=calendar.editList&id=#rc.calendar.getid()#");
      } else {
        setNextEvent("calendar.detail.id.#rc.calendar.getid()#");

      }
    </cfscript>
      <!--- user has been invited --->
    <cfset arguments.event.setLayout('Layout.Main')>
    <cfset arguments.event.setView('calendar/edit')>

  </cffunction>

  <cffunction name="doRegister" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.appointmentID = event.getValue("appointmentID",0);
      rc.contactID = event.getValue("contactID",0);
      rc.formStruct = {};
    </cfscript>
    <cfloop collection="#rc#" item="formElement">
      <cfif left(formElement,6) eq "FIELD_">
        <cfset rc.formStruct["#formElement#"] = rc["#formElement#"]>
      </cfif>
    </cfloop>
    <cfset calendar.register(rc.appointmentID,rc.contactID,rc.formStruct)>
      <!--- user has been invited --->
    <cfset arguments.event.setView('calendar/thankyou')>

  </cffunction>

  <cffunction name="doInvites" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.subject = arguments.event.getValue("subject","");
      rc.notify = arguments.event.getValue("notify","");
      rc.template = arguments.event.getValue("template","");
      rc.inviteList = arguments.event.getValue("inviteeID","");
      calendar.sendInvites(rc.id,rc.subject,rc.notify,rc.template,rc.inviteList);
      setNextEvent(uri="/calendar/detail/id/#rc.id#");
    </cfscript>

  </cffunction>

  <cffunction name="removeUsers" returntype="remote" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.userList = arguments.event.getValue("userList","");
      calendar.removeInvitees(rc.id,rc.userList);
      event.renderData("JSON","");
    </cfscript>

  </cffunction>

  <cffunction name="addUsers" returntype="remote" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.userList = arguments.event.getValue("userList","");
      rc.groupList = arguments.event.getValue("groupList","");
      rc.currentList = calendar.getInvited(rc.id);
      if (rc.userList eq "") {
        users = groups.getChildrenContactsList(rc.groupList);
        inviteList = contact.getContactList(ValueList(users.id));
      } else {
        inviteList = contact.getContactList(rc.userList);
      }
      currentList = contact.getContactList(ValueList(rc.currentList.contactID));
      newInvites = calendar.addInvitees(rc.id,inviteList,currentList);
      event.renderData("JSON",newInvites);
    </cfscript>

  </cffunction>

  <!------------------------------------------- PRIVATE EVENTS ------------------------------------------>
</cfcomponent>
