<cfcomponent name="calendarService" accessors="true" output="true" cache="true" cacheTimeout="0" autowire="true">
  <cfproperty name="id" />
  <cfproperty name="name" />
  <cfproperty name="description" />
  <cfproperty name="createdDate" />
  <cfproperty name="createdBy" />
  <cfproperty name="startDate" />
  <cfproperty name="endDate" />
  <cfproperty name="appointmentType" />
  <cfproperty name="companyID" />
  <cfproperty name="security" />
  <cfproperty name="address" />
  <cfproperty name="postCode" />
  <cfproperty name="eventMeta" />
  <cfproperty name="requireRegistration" />
  <cfproperty name="specialJScript" />
  <cfproperty name="permissions" />
  <cfproperty name="inviteeList" />
  <cfproperty name="organiserID" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="utils" inject="coldbox:plugin:Utilities" />
  <cfproperty name="platform" inject="coldbox:setting:platform" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="CampaignService" inject="id:marketing.CampaignService" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfscript>
    instance = structnew();
    function QueryDeDupe(theQuery,keyColumn) {
      var checkList='';
      var newResult=QueryNew(Lcase(theQuery.ColumnList));
      var keyvalue='';
      var q = 1;

      // loop through each row of the source query
      for (;q LTE theQuery.RecordCount;q=q+1) {

          keyvalue = theQuery[keycolumn][q];
          // see if the primary key value has already been used
          if (NOT ListFind(checkList,keyvalue)) {

              /* this is not a duplicate, so add it to the list and copy
             the row to the destination query */
            checkList=ListAppend(checklist,keyvalue);
            QueryAddRow(NewResult);

            // copy all columns from source to destination for this row
            for (x=1;x LTE ListLen(theQuery.ColumnList);x=x+1) {
                QuerySetCell(NewResult,ListGetAt(theQuery.ColumnList,x),theQuery[ListGetAt(theQuery.ColumnList,x)][q]);
            }
        }
      }
      return NewResult;
    }

    function populate_fields(str, values) {
      l = Len(str);
      i = 1;
      output = '';

      while (i LT l){
        f = REFindNoCase("\[([a-z])+\]",str,i,"TRUE");
        if (f.pos[1] IS 0){
            output = output & Mid(str,i,l-i+1);
            i = l;
        } else {
            output = output & Mid(str,i,f.pos[1]-i);
            name = Mid(str,f.pos[1]+1,f.len[1] - 2);
            output = output & values[name];
            i = f.pos[1] + f.len[1];
        }
      }
      return output;
    }
  </cfscript>

  <cffunction name="register" returntype="void">
    <cfargument name="eventID" required="true">
    <cfargument name="contactID" required="true">
    <cfargument name="formStruct" required="true">
    <!--- first, set the the user as attending the appointment --->

    <!--- were they "invited"? --->
    <cfif NOT userIsInvited(arguments.contactID,arguments.eventID)>
      <!--- we need to insert them into the invitation list --->
      <cfquery name="x" datasource="#dsn.getName()#">
        INSERT INTO
          calender_attendee
        (
          appointmentID,
          type,
          aID,
          status,
          emailSent
        )
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="attending">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="true">

        )
      </cfquery>
    </cfif>
    <cfset attendStatus(arguments.eventID,true,arguments.contactID)>

    <!--- now register them --->
    <cfloop collection="#arguments.formStruct#" item="fS">
      <cfset fieldID = ListLast(fs,"_")>
      <cfset fieldValue = arguments.formStruct["#fs#"]>
      <cfif fieldValue neq "">
        <cfset fieldDB = getRegField(fieldID)>
        <cfif fieldDB.encrypt>
          <cfset fieldValue = encrypt(fieldValue,"eggwah","CFMX_COMPAT")>
        </cfif>
        <!--- insert the registration information --->
        <cfquery name="x" datasource="#dsn.getName()#">
          insert into eventRegValues
          (
            metaID,
            appointmentID,
            value,
            contactID
          )
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#fieldID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#fieldValue#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
          )

        </cfquery>
      </cfif>
    </cfloop>

    <!--- now send registrant thankyou email
    <cfset template = getTemplate(5).contents>
    <cfset sendInvites(arguments.eventID,"Thank you for registering","",template,arguments.contactID)>
    <!--- now send organiser email --->
    <cftry>
    <cfmail bcc="tom.miller@ebiz.co.uk" from="no-reply@cemco.co.uk" to="dawn.baker@aespink.com" subject="Registration" server="127.0.0.1">
      Someone registered for the conference!
    </cfmail>
    <cfcatch type="any"></cfcatch>
    </cftry>
    <cfset template = getTemplate(6).contents>
    <cfset sendInvites(arguments.eventID,"Someone Registered!","",template,getAppointment(eventID).getOrganiserID())>
     --->
  </cffunction>

  <cffunction name="getTemplate" returntype="query">
    <cfargument name="templateID">
    <cfquery name="t" datasource="#dsn.getName(true)#">
      select * from calendar_template where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.templateID#">
    </cfquery>
    <cfreturn t>
  </cffunction>

  <cffunction name="getRegField" returntype="query">
    <cfargument name="fieldID">
    <cfquery name="r" datasource="#dsn.getName(true)#">
      select * from eventRegField where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fieldID#">
    </cfquery>
    <cfreturn r>
  </cffunction>

  <cffunction name="getAppointmentsToday" access="public" returntype="query">
    <cfargument name="thisday" type="date" required="yes">
    <cfset var eGroup = request.eGroup>
    <cfset var returnQ = QueryNew("id,startDate,name,endDate,attendees,attending,invited")>
    <cfset var appointments = "">
    <cfquery name="appointments" datasource="#dsn.getName(true)#">
      select
        calendar.id,
        calendar.name,
        calendar.startDate,
        calendar.endDate,
        count(calender_attendee.id) as attendees
      FROM
        calendar
        calendar left join calender_attendee on calender_attendee.appointmentID  = calendar.id
        LEFT JOIN dmsSecurity on (calendar.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR (dmsSecurity.priviledge = '' OR dmsSecurity.priviledge = 'view')))
          AND
        calendar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
        AND
        date(calendar.startDate) <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.thisDay#">
        AND
        date(calendar.endDate) >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.thisDay#">
          group by id
    </cfquery>
    <cfloop query="appointments">
      <Cfif id neq "">
        <cfset QueryAddRow(returnQ)>
        <cfset QuerySetCell(returnQ,"id",id)>
        <cfset QuerySetCell(returnQ,"startDate",startDate)>
        <cfset QuerySetCell(returnQ,"name",name)>
        <cfset QuerySetCell(returnQ,"endDate",endDate)>
        <cfset QuerySetCell(returnQ,"attendees",attendees)>
        <cfset QuerySetCell(returnQ,"attending",attendingStatus(id,eGroup.contactID))>
        <cfset QuerySetCell(returnQ,"invited",userIsInvited(id,eGroup.contactID))>
      </cfif>
    </cfloop>
  <cfreturn returnQ>
</cffunction>

  <cffunction name="getTemplates" returnType="Query">
    <cfset var templates = "">
    <cfquery name="templates" datasource="#dsn.getName(true)#">
        select * from calendar_template;
      </cfquery>
    <cfreturn templates>
  </cffunction>

  <cffunction name="getEmptyAppointments" returntype="query">
    <cfset var eGroup = request.eGroup>
     <cfset var blankapps = "">
    <cfquery name="blankapps" datasource="#dsn.getName(true)#">
      select
       calendar.id,
       name,
       startDate,
       endDate,
       (Select count(*) from calender_attendee where appointmentID = calendar.id) as num
      from
       calendar
       LEFT JOIN dmsSecurity on (calendar.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">)
      WHERE
        (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR dmsSecurity.priviledge = ''))
        AND
      calendar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
        AND
      DATE(startDate) >= now()
      HAVING num = 0
      order by startDate asc;
    </cfquery>
    <cfreturn blankapps>
  </cffunction>
  <cffunction name="getMonthsAppointments" returntype="struct">
    <cfargument name="month" required="true" default="#now()#" type="date">
    <cfset var eGroup = request.eGroup>
    <cfset var returnQuery = QueryNew("id,name,startDate,endDate,invited,attending,address")>
    <cfset var retS = StructNew()>
    <cfset var dayArray = ArrayNew(1)>
    <cfset var d = "">
    <cfset var apps = "">
    <cfquery name="apps" datasource="#dsn.getName(true)#">
        select
         calendar.id,
         name,
         startDate,
         endDate,
         address
        from
         calendar
         LEFT JOIN dmsSecurity on (calendar.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR dmsSecurity.priviledge = ''))
          AND
        calendar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
          AND
        startDate BETWEEN <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(year(month),month(month),1)#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(year(month),month(month),daysinmonth(month))#">
        order by startDate asc;
      </cfquery>
    <cfloop query="apps">
      <cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"id",id)>
      <cfset QuerySetCell(returnQuery,"name",name)>
      <cfset QuerySetCell(returnQuery,"startDate",startDate)>
      <cfset QuerySetCell(returnQuery,"endDate",endDate)>
      <cfset QuerySetCell(returnQuery,"address",address)>
      <cfset QuerySetCell(returnQuery,"invited",userIsInvited(eGroup.contactID,id))>
      <cfset QuerySetCell(returnQuery,"attending",attendingStatus(id,eGroup.contactID))>
    </cfloop>
    <cfset retS.Q = returnQuery>
    <cfloop from="1" to="#daysinMonth(month)#" index="d">
      <cfset dayArray[d] = StructNew()>
      <cfset dayArray[d]["appointment"] = false>
      <cfset dayArray[d]["name"] = "">
      <cfset dayArray[d]["startDate"] = "">
      <cfset dayArray[d]["endDate"] = "">
      <cfset dayArray[d]["invited"] = false>
      <cfset dayArray[d]["attending"] = false>
    </cfloop>
    <cfloop query="returnQuery">
      <cfloop from="1" to="#DateDiff("d",startDate,endDate)+1#" index="x">
        <cfset thisDay = day(startDate)+(x-1)>
        <cfset dayArray[thisDay]["appointment"] = true>
        <cfset dayArray[thisDay]["name"] = name>
        <cfset dayArray[thisDay]["startDate"] = startDate>
        <cfset dayArray[thisDay]["endDate"] = endDate>
        <cfset dayArray[thisDay]["invited"] = invited>
        <cfset dayArray[thisDay]["attending"] = attending>
      </cfloop>
    </cfloop>
    <cfset retS.A = dayArray>
    <cfreturn retS>
  </cffunction>

  <cffunction name="getUpcomingAppointments" returntype="query">
    <cfset var eGroup = request.eGroup>
    <cfset var returnQuery = QueryNew("id,name,startDate,endDate,invited,attending,address,inviteCount")>
    <cfset var retS = StructNew()>
    <cfset var dayArray = ArrayNew(1)>
    <cfset var d = "">
    <cfset var apps = "">
    <cfquery name="apps" datasource="#dsn.getName(true)#">
        select
         calendar.id,
         name,
         startDate,
         endDate,
         address
        from
         calendar
         LEFT JOIN dmsSecurity on (calendar.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">)
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR dmsSecurity.priviledge = ''))
          AND
        calendar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
          AND
        startDate > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
        order by startDate asc;
      </cfquery>
    <cfloop query="apps">
      <cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"id",id)>
      <cfset QuerySetCell(returnQuery,"name",name)>
      <cfset QuerySetCell(returnQuery,"startDate",startDate)>
      <cfset QuerySetCell(returnQuery,"endDate",endDate)>
      <cfset QuerySetCell(returnQuery,"address",address)>
      <cfset QuerySetCell(returnQuery,"invited",userIsInvited(eGroup.contactID,id))>
      <cfset QuerySetCell(returnQuery,"attending",attendingStatus(id,eGroup.contactID))>
      <cfset QuerySetCell(returnQuery,"invitecount",getInvites(id).recordCount)>
    </cfloop>

    <cfreturn returnQuery>
  </cffunction>

  <cffunction name="userIsInvited" returntype="boolean">
    <cfargument name="contactID">
    <cfargument name="appointmentID">
    <cfset var invited = "">
    <cfquery name="invited" datasource="#dsn.getName(true)#">
        select * from calender_attendee where appointmentID = '#arguments.appointmentID#' AND type = 'contact' AND aid = '#arguments.contactID#';
      </cfquery>
    <cfif invited.recordCount gte 1>
      <cfreturn true>
      <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="getUserAppointments" returntype="query">
    <cfargument name="contactID" required="true" type="numeric">
    <cfargument name="status" required="true" type="string" default="unconfirmed">
    <cfargument name="endDate" required="false" type="date">
    <cfquery name="apps" datasource="#dsn.getName(true)#">
      select
        calendar.*
     from
      calender_attendee,
      calendar
     WHERE
      aID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
      AND
      calendar.id = calender_attendee.appointmentID
      AND
      calendar.startDate > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
      <cfif isDefined("arguments.endDate")>
      AND
      calendar.startDate < <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.endDate#">
      </cfif>
      AND
      <cfif NOT isDefined("arguments.endDate")>
        calender_attendee.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="unconfirmed">
      <cfelse>
        calender_attendee.status != <cfqueryparam cfsqltype="cf_sql_varchar" value="declined">
      </cfif>
    </cfquery>
    <cfreturn apps>
  </cffunction>

  <cffunction name="attendingStatus" access="public" returntype="string">
    <cfargument name="appointmentID" required="yes">
    <cfargument name="contactID" required="yes">
    <cfset var status = "">
    <cfquery name="status" datasource="#dsn.getName(true)#">
        select status from calender_attendee where appointmentID = '#arguments.appointmentID#' and aid = '#arguments.contactID#';
      </cfquery>
    <cfif status.status eq "attending">
      <cfreturn "yes">
      <cfelseif status.status eq "declined">
      <cfreturn "no">
      <cfelse>
      <cfreturn "unconfirmed">
    </cfif>
  </cffunction>

  <cffunction name="addMeta" returntype="void">
    <cfargument name="eventID">
    <cfargument name="fieldName">
    <cfargument name="fieldValue">
    <cfargument name="fieldGroup">
    <cfargument name="fieldType">
    <cfargument name="groupName">
    <cfargument name="required">
    <cfquery name="addMetaDB" datasource="#dsn.getName()#">
      insert into eventMeta (eventID,fieldName,fieldValue,fieldGroup,fieldType,groupName,_required)
      VALUES
        (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldName#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldValue#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldGroup#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldType#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.groupName#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.required#">
        )
    </cfquery>
  </cffunction>

  <cffunction name="getRegistrant" returntype="query">
    <cfargument name="eventID">
    <cfargument name="registrantID">
    <cfquery name="regDetails" datasource="#dsn.getName(true)#">
        select
          eventRegGroup.id as ergID,
          eventRegValues.value as fieldValue,
          eventRegField.encrypt as encrypted,
          eventRegField.id as fieldID,
          eventRegField.label as fieldLabel,
          eventRegField._type as fieldType,
          eventRegFieldOption.label as optionLabel
        from
          calendar,
          calender_attendee
          LEFT JOIN eventRegValues on (eventRegValues.contactID = calender_attendee.aID AND eventRegValues.appointmentID = calender_attendee.appointmentID)
          LEFT JOIN eventRegField on eventRegField.id = eventRegValues.metaID
          LEFT JOIN eventRegGroup on eventRegGroup.id = eventRegField.ergID
          LEFT JOIN eventRegFieldOption on eventRegFieldOption.id = eventRegValues.value
        WHERE
          calender_attendee.aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.registrantID#">
          AND
          calender_attendee.appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventID#">
          AND
          calendar.id = calender_attendee.appointmentID
          order by ergID, fieldID
        </cfquery>
        <cfreturn regDetails>
  </cffunction>

  <cffunction name="getFriendlyInvitees" returntype="query">
    <cfargument name="aID" required="yes">
    <cfset var invitees = "">
    <cfquery name="invitees" datasource="#dsn.getName(true)#">
      select
        concat(c.first_name," ",c.surname) as name,
        c.id as id,
        company.known_as
      from
      calender_attendee,
        contact as c,
      company
      where
        calender_attendee.appointmentID = #aID#
      and
        c.id = calender_attendee.aID
      and
        company.id = c.company_id
     </cfquery>
    <cfreturn invitees>
  </cffunction>

  <cffunction name="getAppointment" access="public" returntype="query" >
    <cfargument name="id" type="numeric" required="yes">
    <cfset var eGroup = request.eGroup>
    <cfset var appDetail = "">
    <cfset var appointments = "">
    <cfquery name="appDetail" datasource="#dsn.getName(true)#">
        select
          calendar.*
        FROM
          calendar
          LEFT JOIN dmsSecurity on (calendar.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'calendar')
         WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR dmsSecurity.priviledge = ''))
          AND
          calendar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
          AND calendar.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      </cfquery>
    <cfreturn appDetail>
  </cffunction>

  <cffunction name="getEventGroups" returntype="query">
    <cfargument name="eventID" required="true">
    <cfquery name="groups" datasource="#dsn.getName(true)#">
      select * from eventRegGroup where eventID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.eventID#">
      order by _order asc
    </cfquery>
    <cfreturn groups>
  </cffunction>

  <cffunction name="getEventFields" returntype="query">
    <cfargument name="groupID">
    <cfquery name="fields" datasource="#dsn.getName(true)#">
      select * from eventRegField where ergID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupID#">
      order by _order asc
    </cfquery>
    <cfreturn fields>
  </cffunction>

  <cffunction name="getEventFieldOptions" returntype="query">
    <cfargument name="fieldID">
    <cfquery name="options" datasource="#dsn.getName(true)#">
      select * from eventRegFieldOption where erfID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fieldID#">
      order by _order asc
    </cfquery>
    <cfreturn options>
  </cffunction>


  <cffunction name="getInvites" access="public" returntype="query">
    <cfargument name="id" type="numeric" required="yes">
    <cfset var appointments = "">
    <cfquery name="appointments" datasource="#dsn.getName(true)#">
        select
          appointmentID,type,aID,status,emailSent
        from
          calender_attendee
          where
          appointmentID = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.id#">
        </cfquery>
    <cfreturn appointments>
  </cffunction>

  <cffunction name="getInvitees" access="public" returntype="query">
    <cfargument name="id" type="numeric" required="yes">
    <cfset var appointments = "">
    <cfset var eGroup = request.eGroup>
    <cfquery name="appointments" datasource="#dsn.getName(true)#">
select
          calendar.*,
          contact.id as contactID,
          contact.first_name,
          contact.email,
          contact.surname,
          company.known_as,
          contact.company_id,
          company.id as companyID,
          calender_attendee.status
        from
          calendar
          left join calender_attendee on calender_attendee.appointmentID  = calendar.id
          LEFT JOIN dmsSecurity on (calendar.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">),
          contact,
          company
        WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR dmsSecurity.priviledge = ''))
          AND
          calendar.companyID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
          AND
          calendar.id = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.id#">
          AND
          calender_attendee.appointmentID = calendar.id
          AND
          contact.id = calender_attendee.aID
          AND
          company.id = contact.company_id
          order by known_as
        </cfquery>
    <cfreturn appointments>
  </cffunction>

  <cffunction name="getInvitedCount" access="public" returntype="numeric">
    <cfargument name="id">
    <cfquery name="appointments" datasource="#dsn.getName(true)#">
      select count(*) as result from calender_attendee WHERE
      calender_attendee.appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn appointments.result>
  </cffunction>

  <cffunction name="removeRecipient" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="id">
    <cfquery name="f" datasource="#dsn.getName()#">
      delete from calender_attendee where appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
      AND
      aID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
  </cffunction>

  <cffunction name="addQueryRecipient" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="queryID">

      <cfset childContacts = CampaignService.getQuery(arguments.queryID)>
      <cfloop query="childContacts">
       <cfquery name="c" datasource="#dsn.getName()#">
          select id from calender_attendee where appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
          AND
          aID = <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
        </cfquery>
        <cfif c.recordCount eq 0>
          <cfquery name="aq" datasource="#dsn.getName()#">
            insert into calender_attendee (appointmentID,aID)
            VALUES
            (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
            )
          </cfquery>
        </cfif>
      </cfloop>
  </cffunction>

  <cffunction name="addRecipient" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="objectType">
    <cfargument name="id">
    <cfif objectType eq "group">
      <cfset childContacts = GroupService.getChildrenContacts(arguments.id,true)>
      <cfloop query="childContacts">
       <cfquery name="c" datasource="#dsn.getName()#">
          select id from calender_attendee where appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
          AND
          aID = <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
        </cfquery>
        <cfif c.recordCount eq 0>
          <cfquery name="aq" datasource="#dsn.getName()#">
            insert into calender_attendee (appointmentID,aID)
            VALUES
            (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
            )
          </cfquery>
        </cfif>
      </cfloop>
    <cfelse>
      <cfquery name="c" datasource="#dsn.getName()#">
        select id from calender_attendee where appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND
        aID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
      </cfquery>
      <cfif c.recordCount eq 0>
        <cfquery name="aq" datasource="#dsn.getName()#">
          insert into calender_attendee (appointmentID,aID)
          VALUES
          (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
          )
        </cfquery>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="getInvited" access="public" returntype="query">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfargument name="id" type="numeric" required="yes">
    <cfargument name="onlySent" type="string" required="no" default="">
    <cfset var appointments = "">
    <cfset var columnArray = ["name","known_as"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfquery name="appointments" datasource="#dsn.getName(true)#">
        select
          contact.id as contactID,
           concat(contact.first_name," ",contact.surname) as name,
          company.known_as,
          contact.company_id,
          company.id as companyID,
          calender_attendee.status
        from
          calendar,
          contact,
          company,
          calender_attendee
          where
          calendar.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          AND
          calendar.id = <cfqueryparam cfsqltype="cf_sql_integer"  value="#arguments.id#">
          AND
          calender_attendee.appointmentID = calendar.id
          AND
          contact.id = calender_attendee.aID
          AND
          company.id = contact.company_id
          <cfif onlySent neq "">
          AND
          calender_attendee.emailSent = <cfqueryparam cfsqltype="cf_sql_varchar" value="#onlySent#">
          </cfif>
          order by #sortColName# #arguments.sortDir#
        limit #arguments.startRow#,#arguments.maxRow#
        </cfquery>
    <cfreturn appointments>
  </cffunction>

  <cffunction name="save" returntype="void">
    <cfargument name="datasource" default="">
    <cfset var eGroup = request.eGroup>
    <cfset var u = "">
    <cfset var n = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfif this.getid() eq 0 OR this.getid() eq "">
      <cfquery name="u" datasource="#arguments.datasource#">
          insert into calendar (name,description,startDate,endDate,appointmentType,companyID,security,address,createdBy,postCode,requireRegistration,organiserID)
          VALUES
            (<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getname()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdescription()#" />,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this.getstartDate()#" />,
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#this.getendDate()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getappointmentType()#" />,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcompanyID()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getsecurity()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar"  value="#eGroup.contactID#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpostCode()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getrequireRegistration()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getorganiserID()#" />)
        </cfquery>
      <cfquery name="n" datasource="#arguments.datasource#">
          select LAST_INSERT_ID() as id from branch;
        </cfquery>
      <cfset this.setid(n.id)>
      <cfelse>
      <cfquery name="u" datasource="#arguments.datasource#">
          update calendar
            set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getname()#" />,
            description = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getdescription()#" />,
            startDate = <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#this.getstartDate()#" />,
            endDate = <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#this.getendDate()#" />,
            appointmentType = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getappointmentType()#" />,
            companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcompanyID()#" />,
            security = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getsecurity()#" />,
            address = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getaddress()#" />,
            postCode = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getpostCode()#" />,
            requireRegistration = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getrequireRegistration()#" />,
            organiserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getorganiserID()#" />
          where
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
        </cfquery>
    </cfif>
    <!--- permissions --->

    <cfquery name="delPerm" datasource="#dsn.getName()#">
      delete from dmsSecurity where securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">
      AND
      relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
    </cfquery>
    <cfloop list="#getpermissions()#" index="p">
      <cfif p neq 0>
      <cfquery name="addPerm" datasource="#dsn.getName()#">
        insert into dmsSecurity (groupID,securityAgainst,relatedID)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
        )
      </cfquery>
      </cfif>
    </cfloop>

    <cftry>
      <cfset feed.createFeedItem('contact',eGroup.contactID,'calendar',getid(),'editMeeting','company',eGroup.companyID,0,"edited appointment",datasource)>
      <cfcatch type="any">
        <cflog application="true" text="#cfcatch.Message#">
      </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="sendInvites" access="public" output="true" returntype="boolean">
    <cfargument name="id" type="numeric" required="true">
    <cfargument name="subject" type="String" required="true">
    <cfargument name="notify" type="String" required="true">
    <cfargument name="template" type="String" required="true">
    <cfargument name="inviteList" type="string" required="true">
    <cfset var appointmentID = id>
    <cfset var eGroup = request.eGroup>
    <cfset var appointment = getAppointment(appointmentID)>
    <cfset var attendees = getInvitees(appointmentID,inviteList)>
    <cfset var data = "">
    <cfset var contents = "">
    <cfset var i = "">
    <cfset var a = "">
    <cfset var insertAttendee = "">
    <cfscript>
       data = StructNew();
       data.appointmentName = "#appointment.name#";
       data.appointmentStartDate = DateFormat(appointment.startDate,"DD/MM/YYYY");
       data.appointmentStartTime = TimeFormat(appointment.startDate,"HH:MM");
       data.AppointmentEndDate = DateFormat(appointment.endDate,"DD/MM/YYYY");
       data.appointmentEndTime = TimeFormat(appointment.endDate,"HH:MM");
    </cfscript>
    <cfif arguments.notify eq "newonly">
      <cfquery name="unvitedOnly" dbtype="query">
        select attendees.*, attendees.aid as contactID from attendees where emailSent = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
      </cfquery>
      <cfset thisList = unvitedOnly>
    <cfelse>
      <cfset thisList = attendees>
    </cfif>
    <cfloop query="thisList">
      <cfscript>
        contactQ = contact.getContactQuery(contactID);
        data.appointmentConfirmationLink = "http://#cgi.HTTP_HOST#/calendar/confirm/id/#appointmentID#/cID/#contactID#/canattend/yes";
        data.appointmentNoAttendLink = "http://#cgi.HTTP_HOST#/calendar/confirm/id/#appointmentID#/cID/#contactID#/canattend/no";
        populated = populate_fields(template,data);
        contents = populated;
       </cfscript>
       <cfsavecontent variable="ics"><cfoutput>BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:#DateFormat(appointment.StartDate,"YYYYMMDD")#T#TimeFormat(appointment.StartDate,"HHMMSS")#Z
DTEND:#DateFormat(appointment.endDate,"YYYYMMDD")#T#TimeFormat(appointment.endDate,"HHMMSS")#Z
LOCATION:#Replace(replace(appointment.Address,chr(13),"","ALL"),CHR(10),"","ALL")#
DESCRIPTION:#appointment.description#
SUMMARY:#data.appointmentName#
PRIORITY:3
END:VEVENT
END:VCALENDAR</cfoutput></cfsavecontent>
        <cfset randomFile = "#createUUID()#.ics">
        <cffile action="write" file="ram://#randomFile#" output="#ics#">
       <cfmail to="#contactQ.first_name# #contactQ.surname# <#contactQ.email#>" from="#eGroup.name# <#eGroup.username#>" server="127.0.0.1" subject="#subject#">
         <cfmailparam file="ram://#randomFile#" disposition="attachment" type="text/calendar">
         #contents#
       </cfmail>
       <cfquery name="u" datasource="#dsn.getName()#">
        update calender_attendee set emailSent = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        where
        appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#appointmentID#">
        AND
        aID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
      </cfquery>
    </cfloop>
    <cfreturn true>
  </cffunction>

  <cffunction name="removeInvitees" access="remote" returntype="boolean">
    <cfargument name="id" type="numeric" required="true">
    <cfargument name="inviteList" type="string" required="true">
    <cfquery name="remove" datasource="#dsn.getName()#">
      delete from calender_attendee where appointmentID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
      AND
      aID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#inviteList#">)
    </cfquery>
    <cfreturn true>
  </cffunction>
  <cffunction name="addInvitees" returntype="any">
    <cfargument name="eventID">
    <cfargument name="contactQ">
    <cfargument name="currentQ">
    <cfset var thisQ = contactQ>
    <cfset var newUsers = QueryNew("id,name,known_as")>

    <cfloop query="thisQ">
      <cfquery name="exists" datasource="#dsn.getName()#">
        select aid from calender_attendee
        where aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        AND
        appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eventID#">
      </cfquery>
      <cfif exists.recordCount eq 0>
        <!--- add them! --->
        <cfquery name="addPerson" datasource="#dsn.getName()#">
          insert into calender_attendee
          (appointmentID,type,aID,status,emailSent)
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#eventID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="unconfirmed">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
            )
        </cfquery>
        <cfset QueryAddRow(newUsers)>
        <cfset QuerySetCell(newUsers,"id",id)>
        <cfset QuerySetCell(newUsers,"name","#first_name# #surname#")>
        <cfset QuerySetCell(newUsers,"known_as","#known_as#")>
      </cfif>
    </cfloop>
    <cfreturn newUsers>
  </cffunction>

  <cffunction name="attendStatus" access="public" returntype="boolean">
    <cfargument name="id" required="true" type="numeric">
    <cfargument name="status" required="true" type="boolean">
    <cfargument name="ciD" required="true" type="numeric">
    <cfargument name="datasource" required="true" default="">
    <cfset var eGroup = request.eGroup>
    <cfset var u = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="u" datasource="#arguments.datasource#">
      update calender_attendee set status =
      <cfif status>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="attending">
      <cfelse>
        <cfqueryparam cfsqltype="cf_sql_varchar" value="declined">
      </cfif>
      where appointmentID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      AND
      aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#cid#">
    </cfquery>
    <cfif status>
      <cftry>
        <cfset feed.createFeedItem('contact',ciD,'calendar',id,'attendMeeting','company',eGroup.companyID,0,"",datasource)>
        <cfcatch type="any">
          <cflog application="true" text="#cfcatch.Message#">
        </cfcatch>
      </cftry>
      <cfelse>
      <cftry>
        <cfset feed.createFeedItem('contact',ciD,'calendar',id,'declineMeeting','company',eGroup.companyID,0,"",datasource)>
        <cfcatch type="any">
          <cflog application="true" text="#cfcatch.Message#">
        </cfcatch>
      </cftry>
    </cfif>
    <cfreturn true>
  </cffunction>

  <cffunction name="queryCompare" returntype="struct" output="false">
    <cfargument name="query1" type="query" required="true" />
    <cfargument name="query2" type="query" required="true" />
    <cfset var rStruct = StructNew()>
    <cfset var q1 = arguments.query1>
    <cfset var q2 = arguments.query2>
    <cfset var q3 = QueryNew( q1.columnlist )>
    <cfset var q4 = QueryNew( q2.columnlist )>
    <cfset var message = "">
    <cfset var rowch = false>
    <cfset var colArray = listtoarray(q1.columnlist)>
    <cfset var thisCol = "">
    <cfset var count = 1>
    <cfset var i = "">
    <cfset var j = "">
    <cfset var k = "">
    <cfloop from="1" to="#listlen(q1.columnlist)#" index="thisCol">
      <cfif listfindnocase(q2.columnlist,listgetat(q1.columnlist,thisCol)) eq 0>
        <cfset message = "Columns in query1 (#q1.columnlist#) and query2 (#q2.columnlist#) doesn't match">
      </cfif>
    </cfloop>
    <cfif not len(trim(message))>
      <cfloop from="1" to="#listlen(q2.columnlist)#" index="thisCol">
        <cfif listfindnocase(q1.columnlist,listgetat(q2.columnlist,thisCol)) eq 0>
          <cfset message = "Columns in query1 (#q1.columnlist#) and query2 (#q2.columnlist#) doesn't match">
        </cfif>
      </cfloop>
    </cfif>
    <cfif not len(trim(message))>
      <cfloop from="1" to="#q1.recordcount#" index="i">
        <cfset rowch = false>
        <cfloop from="1" to="#arraylen(colArray)#" index="j">
          <cfif comparenocase(q1[colArray[j]][i],q2[colArray[j]][i])>
            <cfset rowch = true>
          </cfif>
        </cfloop>
        <cfif rowch>
          <cfset queryaddrow(q3)>
          <cfloop from="1" to="#arraylen(colArray)#" index="k">
            <cfset querysetcell( q3, colArray[k], q1[colArray[k]][count] )>
          </cfloop>
        </cfif>
        <cfset count = count + 1>
      </cfloop>
      <cfset count = 1>
      <cfloop from="1" to="#q2.recordcount#" index="i">
        <cfset rowch = false>
        <cfloop from="1" to="#arraylen(colArray)#" index="j">
          <cfif comparenocase(q1[colArray[j]][i],q2[colArray[j]][i])>
            <cfset rowch = true>
          </cfif>
        </cfloop>
        <cfif rowch>
          <cfset queryaddrow(q4)>
          <cfloop from="1" to="#arraylen(colArray)#" index="k">
            <cfset querysetcell( q4, colArray[k], q2[colArray[k]][count] )>
          </cfloop>
        </cfif>
        <cfset count = count + 1>
      </cfloop>
      <cfif q4.recordcount OR q3.recordcount>
        <cfset message = "Records do not match">
      </cfif>
    </cfif>
    <cfif len(trim(message))>
      <cfset structinsert(rStruct,"message",message)>
      <cfset structinsert(rStruct,"in_query1_butnotin_query2",q3)>
      <cfset structinsert(rStruct,"in_query2_butnotin_query1",q4)>
      <cfelse>
      <cfset structinsert(rStruct,"message","Query 1 and Query 2 are identical")>
    </cfif>
    <cfreturn rStruct />
  </cffunction>

  <cffunction name="deleteAppointment" returntype="any">
    <cfargument name="id">
    <cfset var d = "">
    <cfquery name="d" datasource="#dsn.getName()#">
      delete from calendar where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>
  </cffunction>


  <cffunction name="AppointmentList" access="public" returntype="query">
    <cfargument name="startDate" type="date" required="yes">
    <cfargument name="endDate" type="date" required="yes">
    <cfset var appointments = "">
    <cfquery name="appointments" datasource="#dsn.getName()#">
      select
        calendar.id,
        calendar.name,
        calendar.description,
        calendar.address,
        calendar.postcode,
        calendar.startDate,
        calendar.endDate,
        (select count(calender_attendee.id) from calender_attendee where appointmentID = calendar.id) as attendees,
        (select status from calender_attendee where appointmentID = calendar.id and aid = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.contactID#">) as attending
      FROM
        calendar
        LEFT JOIN security on (calendar.id = security.relatedID AND security.securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="calendar">)
        WHERE
          (security.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.bmnet.rolesids#">) OR security.priviledge is NULL)
          AND
        calendar.siteID = <cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#request.siteID#">
        AND
        calendar.startDate BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.startDate#"> AND <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.endDate#">
    </cfquery>

  <cfreturn appointments>
</cffunction>



</cfcomponent>

