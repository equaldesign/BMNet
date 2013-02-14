<cfcomponent name="pollHandler" cache="true" cacheTimeout="30" output="false">
	<!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
	<!--- Default Action --->
	<cfproperty name="poll" inject="id:poll.PollService" />
	<cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="groups" inject="id:eunify.GroupsService" />
  <cfproperty name="dms" inject="id:eunify.DocumentService" />
  <cfproperty name="platform" inject="coldbox:setting:platform" />
  <cfproperty name="remoteDB" inject="coldbox:setting:remoteDatasource" />

  <cffunction name="list" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.filter = event.getValue("filter","open");
      rc.polls = poll.getPollList(rc.filter);
    </cfscript>
    <cfset arguments.event.setView('panel/list')>

  </cffunction>

  <cffunction name="index" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
    </cfscript>

    <cfset arguments.event.setView('index')>

  </cffunction>

  <cffunction name="clone" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = event.getValue("id",0);
      rc.newID = poll.clone(rc.id);
      setNextEvent(uri="/poll/detail/id/#rc.newID#");
    </cfscript>
  </cffunction>


  <cffunction name="detail" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.poll = poll.getPoll(rc.id);
      rc.invitees = poll.getInvitees(rc.id);
      rc.company = company.getCompany(rc.sess.eGroup.companyID);
      //rc.category = dms.getRelatedCategory("poll",rc.id);
      rc.invited = false;
      rc.completed = false;

    </cfscript>
      <!--- user has been invited --->
    <cfquery name="rc.s" dbtype="query">
      select completed from rc.invitees where contactID = <cfqueryparam value="#rc.sess.eGroup.contactID#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfif rc.s.recordCount gte 1>
      <cfset rc.invited = true>
      <cfset rc.completed = rc.s.completed>
    </cfif>
    <cfset arguments.event.setView('panel/detail')>

  </cffunction>

  <cffunction name="results" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.poll = poll.getPoll(rc.id);
      rc.invitees = poll.getInvitees(rc.id);
      rc.resultList = poll.getResultList(rc.id);
      rc.answerList = poll.answerList(rc.id);
      rc.stepperList = poll.stepperList(rc.id);
      rc.allAnswers = poll.getAllAnswers(rc.id);
      rc.sumList = poll.sumList(rc.id);
    </cfscript>

    <cfset arguments.event.setView('panel/results')>
  </cffunction>

  <cffunction name="pdf" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
         </cfscript>

    <cfset arguments.event.setView('panel/choosereport')>
  </cffunction>
  <cffunction name="showQuestionResponses">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.qID = event.getValue("qID")>
    <cfset rc.id = event.getValue("id")>
    <cfset rc.poll = poll.getPoll(rc.id)>
    <cfset rc.answers = poll.getQuestionResponses(rc.qID)>
    <cfset arguments.event.setView('panel/results/question')>
  </cffunction>



  <cffunction name="regsitrant" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.pollID = arguments.event.getValue("pollID",0);
      rc.registrantID = arguments.event.getValue("registrantID",0);
      rc.results = poll.getUserResult(rc.pollID,rc.registrantID);
    </cfscript>
    <cfset arguments.event.setView('panel/registrant')>

  </cffunction>

  <cffunction name="submit" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.invited = poll.userIsInvited(rc.sess.eGroup.contactID,rc.id);
      rc.completed = poll.userCompleted(rc.sess.eGroup.contactID,rc.id);
      rc.pollData = poll.getPoll(rc.id);
      rc.poll = poll;
    </cfscript>
    <cfset arguments.event.setView('panel/register')>
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
			rc.list = qa.getInvited(rc.id,rc.sortdir,rc.sortcol);
		</cfscript>
		<cfset rc.start = ((rc.page-1)*rc.pageSize)+1>
		<cfset rc.end = (rc.start-1) + rc.pageSize>
		<cfset rc.i = 1>
		<cfset rc.arrUsers = ArrayNew(1)>
		<cfloop query="rc.list" startrow="#rc.start#" endrow="#rc.end#">
			<cfset rc.arrUsers[rc.i] =
				{
					"contactID"		= "#contactID#",
					"cell"	=	["#first_name#","#surname#","#known_as#"]
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


	<cffunction name="edit" returntype="void" output="false">
		<cfargument name="event">

		<cfscript>
			var rc = arguments.event.getCollection();
			rc.layout = arguments.event.getValue("layout","Main");
			rc.id = arguments.event.getValue("id",0);
			rc.poll = poll.getPoll(rc.id);
			rc.permissions = dms.getDMSSecurity("poll",rc.id);
		</cfscript>
			<!--- user has been invited --->
		<cfset arguments.event.setView('panel/edit')>

	</cffunction>

  <cffunction name="doEdit" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.organiserID = arguments.event.getValue("organiserID",rc.sess.eGroup.contactID);
      rc.existingAgreement = event.getValue("existingAgreement","false");
      rc.poll = populateModel("poll.PollService");
      rc.poll.save();

      setNextEvent(uri="/poll/poll/index/id/#rc.poll.getid()#");
    </cfscript>

  </cffunction>

  <cffunction name="editForm" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.poll = poll;
      rc.formData = poll.getPoll(rc.id);
    </cfscript>
    <!--- user has been invited --->
    <cfset arguments.event.setView('panel/editForm')>

  </cffunction>


  <cffunction name="delete" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      poll.deletePoll(rc.id);
      setNextEvent(uri="/poll");
    </cfscript>
  </cffunction>

	<cffunction name="editList" returntype="void" output="false">
		<cfargument name="event">

		<cfscript>
			var rc = arguments.event.getCollection();
			rc.id = arguments.event.getValue("id",0);
			rc.contacts = groups.getContactsRemote();
			rc.contactGroups = groups.fullGroupList(rc.sess.eGroup.companyID);
			rc.inviteList = poll.getInvitees(rc.id);
		</cfscript>
			<!--- user has been invited --->
		<cfset arguments.event.setView('panel/editList')>

	</cffunction>
  <cffunction name="doListEdit">
  <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
    </cfscript>
    <cfset arguments.event.setLayout("Layout.Main")>
    <cfset arguments.event.setView("debug")>
  </cffunction>


  <cffunction name="doSubmit" returntype="void" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.pollID = event.getValue("pollID",0);
      rc.contactID = event.getValue("contactID",0);
      rc.formStruct = {};
    </cfscript>
    <cfloop collection="#rc#" item="formElement">
      <cfif left(formElement,6) eq "FIELD_">
        <cfset rc.formStruct["#formElement#"] = rc["#formElement#"]>
      </cfif>
    </cfloop>
    <cfset poll.register(rc.pollID,rc.contactID,rc.formStruct)>
      <!--- user has been invited --->
    <cfset arguments.event.setView('thankyou')>

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
      qa.sendInvites(rc.id,rc.subject,rc.notify,rc.template,rc.inviteList);
      setNextEvent(uri="/qa/detail/id/#rc.id#");
    </cfscript>

  </cffunction>

  <cffunction name="removeUsers" returntype="remote" output="false">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.userList = arguments.event.getValue("userList","");
      poll.removeInvitees(rc.id,rc.userList);
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
      rc.currentList = poll.getInvitees(rc.id);
      if (rc.userList eq "") {
        users = groups.getChildrenContactsList(rc.groupList);
        inviteList = contact.getContactList(ValueList(users.id));
      } else {
        inviteList = contact.getContactList(rc.userList);
      }
      currentList = contact.getContactList(ValueList(rc.currentList.contactID));
      newInvites = poll.addInvitees(rc.id,inviteList,currentList);
      event.renderData("JSON",newInvites);
    </cfscript>

  </cffunction>

  <cffunction name="print" returntype="void">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.poll = poll.getPoll(rc.id);
      rc.invitees = poll.getInvitees(rc.id);
      rc.resultList = poll.getResultList(rc.id);
      rc.answerList = poll.answerList(rc.id);
      rc.allAnswers = poll.getAllAnswers(rc.id);
      rc.sumList = poll.sumList(rc.id);
      rc.stepperList = poll.stepperList(rc.id);
      rc.chartType = event.getValue("cType","results");
    </cfscript>

    <cfset arguments.event.setView(view='poll/panel/pdf/#rc.chartType#',noLayout=true)>
  </cffunction>

	<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>
</cfcomponent>