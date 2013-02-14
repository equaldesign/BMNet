<cfcomponent name="taskService" cache="true">
	<!--- a totally modular and seperate task, workflow and sales pipeline system --->
  <cfproperty name="dsn" inject="coldbox:datasource:flo" />
  <cfproperty name="relationship" inject="id:flo.RelationshipService">
  <cfproperty name="bugsystem" inject="coldbox:setting:bugsystem">
  <cfproperty name="BMNetFeedService" inject="id:eunify.FeedService">
  <cfproperty name="eGroupFeedService" inject="id:eGroup.feed">
  <cfproperty name="Renderer" inject="coldbox:plugin:Renderer">
  <cfproperty name="Utilities" inject="coldbox:plugin:Utilities">
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">


  <cffunction name="getStages" returntype="query">
    <cfargument name="itemType" default="active" required="true">

    <cfquery name="stages" datasource="#dsn.getName()#">
      SELECT
        stage.*
      FROM
        stage,
        itemType
      WHERE
        itemType.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.itemType#">
        AND
        stage.itemTypeID = itemType.id
        AND
        stage.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn stages>
  </cffunction>

  <cffunction name="getItemTypes" returntype="query">
    <cfquery name="t" datasource="#dsn.getName()#">
      SELECT
        *
      FROM
        itemType
      WHERE
        siteID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="0,#request.siteID#" list="true">)
        group by name order by siteID desc;
    </cfquery>
    <cfreturn t>
  </cffunction>

  <cffunction name="getItemTypeIDByName" returntype="numeric">
    <cfargument name="name">
    <cfquery name="t" datasource="#dsn.getName()#">
      SELECT
        id
      FROM
        itemType
      WHERE
        name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">
        AND
        siteID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="0,#request.siteID#" list="true">)
        order by siteID desc;
    </cfquery>
    <cfreturn t.id>
  </cffunction>

  <cffunction name="getStageTotal" returntype="query">
    <cfargument name="stageID">
    <cfquery name="sTotal" datasource="#dsn.getName()#">
      SELECT
        SUM(amount) as amount,
        count(*) as items
     FROM
        item
     WHERE
        stageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stageID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn sTotal>
  </cffunction>

  <cffunction name="setStage" returntype="void">
    <cfargument name="itemID" required="true">
    <cfargument name="stageID" required="true">
    <cfquery name="stages" datasource="#dsn.getName()#">
      UPDATE
        item
      SET
        stageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stageID#">
      WHERE
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
    </cfquery>
  </cffunction>

  <cffunction name="getTask" returntype="Struct">
    <cfargument name="id" required="true">
    <cfquery name="task" datasource="#dsn.getName()#">
      SELECT
        item.id,
        item.name,
        item.description,
        item.amount,
        item.status,
        (SELECT
          count(*)
          from
            itemParticipant
          WHERE
            itemParticipant.itemID = item.id) as participantCount,
        itemType.name as itemName,
        itemType.workflowDefinition,
        stage.name as stageName
      FROM

        flow.item,
        stage,
        itemType
      WHERE
        item.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        stage.id = item.stageID
        AND
        itemType.id = item.itemTypeID

    </cfquery>
    <cfset var returnObject = {}>
    <cfset returnObject.task = task>
    <cfset returnObject.relatedObject = []>
    <cfset returnObject.activities = getActivities(arguments.id)>
    <cfset returnObject.dependencies = getDependancies(arguments.id)>
    <cfset itemRelationships = getRelationships(arguments.id)>

    <cfloop query="itemRelationships">
      <cfset related = {}>
      <cfset related.type = relatedType>
      <cfset related.system = relatedSystem>
      <cfset related.object = relationship.getRelatedObject(relatedSystem,relatedType,relatedID)>
      <cfset arrayAppend(returnObject.relatedObject,related)>
    </cfloop>
    <cfreturn returnObject>
  </cffunction>

  <cffunction name="getDependancies" returntype="query">
    <cfargument name="itemID" required="true">
    <cfquery name="d" datasource="#dsn.getName()#">
      select * from itemParticipant where itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
    </cfquery>
    <cfset var returnQuery = QueryNew("contactID,first_name,surname,companyName,emailaddress,active,system")>
    <cfloop query="d">
      <cfset contact = relationship.getRelatedObject("BMNet","contact",contactID)>
      <cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"contactID",contactID)>
      <cfset QuerySetCell(returnQuery,"first_name",contact.first_name)>
      <cfset QuerySetCell(returnQuery,"surname",contact.surname)>
      <cfset QuerySetCell(returnQuery,"companyName",contact.name)>
      <cfset QuerySetCell(returnQuery,"emailaddress",contact.email)>
      <cfset QuerySetCell(returnQuery,"active",active)>
      <cfset QuerySetCell(returnQuery,"system",system)>
    </cfloop>
    <cfreturn returnQuery>
  </cffunction>

  <cffunction name="createCallBack" returntype="void">
    <cfargument name="name">
    <cfargument name="description">
    <cfargument name="due">
    <cfargument name="reminder">
    <cfargument name="contact">
    <cfargument name="participant">
    <!--- first get the callback item type for this site ---->
    <cfset itemTypeID = getItemTypeIDByName("callback")>
    <!--- now create an item --->
    <cfquery name="d" datasource="#dsn.getName()#">
      insert into item
        (
          name,
          description,
          amount,
          itemTypeID,
          status,
          stageID,
          siteID
        )
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.description#">,
          <cfqueryparam cfsqltype="cf_sql_float" value="0">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#itemTypeID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="active">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        )
    </cfquery>
    <cfquery name="n" datasource="#dsn.getName()#">
      select LAST_INSERT_ID() as id from item
    </cfquery>
    <cfset var newID = n.id>

    <!--- add the participant --->
    <cfquery name="i" datasource="#dsn.getName()#">
      INSERT INTO itemParticipant
      (
       itemID,
       contactID,
       system
      )
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.participant.id#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.participant.system#">
      )
    </cfquery>

    <!--- insert the dependency --->
    <cfquery name="i" datasource="#dsn.getName()#">
      INSERT INTO itemRelationship
      (
       itemID,
       relatedType,
       relatedID,
       relatedSystem
      )
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contact.id#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contact.system#">
      )
    </cfquery>

    <!--- now create the activity --->
    <cfquery name="i" datasource="#dsn.getName()#">
      INSERT INTO itemActivity
      (
       itemID,
       name,
       description,
       dueDate,
       reminderDate
      )
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.due)#">,
        <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.reminder)#">
      )
    </cfquery>
  </cffunction>

  <cffunction name="getMyActivities" returntype="query">
    <cfargument name="modle" default="BMNet" required="true">
    <cfargument name="showComplete" default="false" required="true">
    <cfquery name="a" datasource="#dsn.getName()#">
      SELECT
        item.id,
        item.name,
        item.description,
        item.amount,
        stage.name as stageName,
        itemActivity.id as activityID,
        itemActivity.name as activityName,
        itemActivity.description as activityDescription,
        itemActivity.dueDate,
        itemActivity.reminderDate,
        itemActivity.priority,
        itemActivity.email as remindViaEmail,
        itemActivity.complete,
        itemType.name,
        itemType.workflowDefinition
      FROM        
        itemActivity
        LEFT JOIN item on itemActivity.itemID = item.id
        LEFT JOIN stage on stage.id = item.stageID,
        itemType
      WHERE
        itemActivity.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request['#request.flowSystem#'].contactID#">
        AND
        item.id = itemActivity.itemID
        AND
        itemType.id = item.itemTypeID
        <cfif showComplete>
         AND
         itemActivity.complete = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
        </cfif>
        order by priority asc, duedate asc
    </cfquery>
    <cfreturn a>
  </cffunction>

  <cffunction name="assignActivityTo" returntype="void">
    <cfargument name="activityID" required="true">
    <cfargument name="contactID" required="true">
    <cfquery name="u" datasource="#dsn.getName()#">
      update itemActivity set contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
      WHERe
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activityID#">
    </cfquery>
    <cfset activity = getActivity(arguments.activityID)>
    <cfset task = getTask(activity.itemID)>
    <cfif arguments.contactID neq request['#request.flowSystem#'].contactID>
      <!--- send the user a calendar item with the info in --->
      <cfquery name="thisUser" dbtype="query">
        select * from task.dependencies where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
      </cfquery>
      <cfscript>
        calendarOb = {
          organizerName = "BuildersMerchant.net",
          organizerEmail = "support@buildersmerchant.net",
          subject = activity.name,
          location = "",
          description = activity.description,
          startTime = activity.reminderDate,
          endTime = activity.dueDate
        };

        local.Email = MailService.newMail();
        configStruct = {};
        confirmStruct.from="#request['#bugsystem#'].name# <support@buildersmerchant.net>";
        local.Email.setFrom(confirmStruct.from);
        confirmStruct.to="#thisUser.first_name# #thisUser.surname# <#thisUser.emailaddress#>";
        local.Email.setTo(confirmStruct.to);
        confirmStruct.subject="Flo: Task Assigned";
        fileWrite("/tmp/#activity.name#.ics",iCalUS(calendarOb));
        local.Email.setSubject(confirmStruct.subject);
        viewArgs = {
          task = task,
          calendarOb = calendarOb,
          thisUser = thisUser,
          activity = activity
        };
        mailBody = Renderer.renderLayout(layout="email/Layout.email.html",view="email/task",args=viewArgs);
        local.Email.setType("html");
        local.Email.setBody(mailBody);
        local.Email.addAttachments("/tmp/#activity.name#.ics");
        local.mailResult = MailService.send(local.Email);
      </cfscript>
    </cfif>
    <cfset floItem = task>
    <cfset fService = evaluate("#request.flowSystem#FeedService")>
    <cfset soID = request["#request.flowSystem#"].contactID>
    <cfset fService.createFeedItem(
      so="contact",
      sOID=sOID,
      rO="flo.task",
      rOID=arguments.activityID,
      action="floTaskAssign",
      tO="contact",
      tOID=arguments.contactID
    )>
    <cfloop array="#floitem.relatedObject#" index="r">
      <cfset fService.createFeedItem(
        so="contact",
        sOID=sOID,
        rO="flo.task",
        rOID=arguments.activityID,
        action="floTaskAssign",
        tO=r.type,
        tOID=r.object.id
      )>
    </cfloop>
  </cffunction>

  <cffunction name="completeActiviy" returntype="void">
    <cfargument name="activityID">
    <cfargument name="complete" required="true" default="true">
    <cfquery name="u" datasource="#dsn.getName()#">
      update itemActivity set complete = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.complete#">
      WHERe
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activityID#">
    </cfquery>
  </cffunction>

  <cffunction name="getActivities" returntype="query">
    <cfargument name="itemID" required="true">
    <cfquery name="a" datasource="#dsn.getName()#">
      SELECT
        *
      FROM
        itemActivity
      WHERE
      itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
    </cfquery>
    <cfset var returnQuery = QueryNew("id,itemID,contactID,first_name,surname,companyName,emailaddress,name,description,dueDate,reminderDate,email,complete")>
    <cfloop query="a">
      <cfset contact = relationship.getRelatedObject("BMNet","contact",contactID)>
      <cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"contactID",contactID)>
      <cfset QuerySetCell(returnQuery,"first_name",contact.first_name)>
      <cfset QuerySetCell(returnQuery,"surname",contact.surname)>
      <cfset QuerySetCell(returnQuery,"companyName",contact.name)>
      <cfset QuerySetCell(returnQuery,"emailaddress",contact.email)>
      <cfset QuerySetCell(returnQuery,"name",name)>
      <cfset QuerySetCell(returnQuery,"description",description)>
      <cfset QuerySetCell(returnQuery,"dueDate",dueDate)>
      <cfset QuerySetCell(returnQuery,"reminderDate",reminderDate)>
      <cfset QuerySetCell(returnQuery,"email",email)>
      <cfset QuerySetCell(returnQuery,"id",id)>
      <cfset QuerySetCell(returnQuery,"itemID",itemID)>
      <cfset QuerySetCell(returnQuery,"complete",complete)>
    </cfloop>
    <cfreturn returnQuery>
  </cffunction>

  <cffunction name="getActivity" returntype="query">
    <cfargument name="itemID" required="true">
    <cfquery name="a" datasource="#dsn.getName()#">
      SELECT
        *
      FROM
        itemActivity
      WHERE
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
    </cfquery>
    <cfreturn a>
  </cffunction>

  <cffunction name="getRelationships" returntype="query">
    <cfargument name="itemID" required="true">
    <cfquery name="a" datasource="#dsn.getName()#">
      SELECT
        *
      FROM
        itemRelationship
      WHERE
      itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">
    </cfquery>
    <cfreturn a>
  </cffunction>

  <cffunction name="getTasks" returntype="query">
    <cfargument name="status" default="active" required="true">
    <cfargument name="type" default="" required="true">
    <cfargument name="modle" default="BMNet" required="true">
    <cfargument name="db" default="BMNet" required="true">
    <cfargument name="myTasks" default="false" required="true">
    <cfargument name="stage" default="" required="true">
    <cfquery name="tasks" datasource="#dsn.getName()#">
      SELECT
        item.id,
        item.name,
        item.description,
        item.amount,
        (SELECT
	        count(*)
	        from
	          itemParticipant
	        WHERE
	          itemParticipant.itemID = item.id) as participantCount,
        itemType.name as itemName,
        stage.name as stageName
      FROM

        flow.item,
        stage,
        itemType
      WHERE
        stage.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        AND
        stage.itemTypeID = itemType.id
        <cfif arguments.stage neq "">
        AND
        stage.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage#">
        AND
        item.stageID = stage.id
        </cfif>
        <cfif arguments.type neq "">
        AND
        itemType.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
        AND
        item.itemTypeID =itemType.id
        <cfelse>
        AND
        itemType.id = item.itemTypeID
        </cfif>
        <cfif arguments.status neq "">
        AND
        item.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
        </cfif>

    </cfquery>
    <cfreturn tasks>
  </cffunction>

  <cffunction name="getAllTasks" returntype="query">
    <cfargument name="status" default="active" required="true">
    <cfargument name="type" default="" required="true">
    <cfargument name="stage" default="" required="true">
    <cfquery name="tasks" datasource="#dsn.getName()#">
      SELECT
        item.id,
        item.name,
        item.description,
        item.amount,
        itemType.name as itemName,
        itemType.workflowDefinition,
        stage.name as stageName
      FROM
        flow.item
          LEFT JOIN stage on stage.id = item.stageID,

        itemType
      WHERE
        item.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        <cfif stage neq "">
        AND
        stage.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage#">
        AND
        item.stageID = stage.id
        </cfif>
        <cfif arguments.type neq "">
        AND
        itemType.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
        AND
        item.itemTypeID =itemType.id
        <cfelse>
        AND
        itemType.id = item.itemTypeID
        </cfif>
      <cfif arguments.status neq "">
        AND
        item.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
      </cfif>

    </cfquery>
    <cfreturn tasks>
  </cffunction>

  <cffunction name="getMyTasks" returntype="query">
    <cfargument name="status" default="active" required="true">
    <cfargument name="type" default="" required="true">
    <cfargument name="stage" default="" required="true">
    <cfset var flowSystem = request.flowSystem>

    <cfset var systemObject = request["#flowSystem#"]>
    <cfquery name="tasks" datasource="#dsn.getName()#">
      SELECT
        item.id,
        item.name,
        item.description,
        item.amount,
        itemType.name as itemName,
        itemType.workflowDefinition,
        stage.name as stageName
      FROM
        flow.itemParticipant,
        flow.item
          LEFT JOIN stage on stage.id = item.stageID,

        itemType
      WHERE
        itemParticipant.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#systemObject.contactID#">
        AND
        item.id = itemParticipant.itemID
        <cfif stage neq "">
        AND
        stage.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.stage#">
        AND
        item.stageID = stage.id
        </cfif>
        <cfif arguments.type neq "">
        AND
        itemType.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
        AND
        item.itemTypeID =itemType.id
        <cfelse>
        AND
        itemType.id = item.itemTypeID
        </cfif>
      <cfif arguments.status neq "">
        AND
        item.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
      </cfif>

    </cfquery>
    <cfreturn tasks>
  </cffunction>

  <cffunction name="saveItem" returntype="numeric">
    <cfargument name="s">
    <cfset var newItem = true>
    <cfif s.amount eq "">
      <cfset s.amount = 0>
    </cfif>
    <cfif s.id neq 0>
      <cfset newItem = false>
      <cfquery name="d" datasource="#dsn.getName()#">
        update item
        set
          name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.s.name#">,
          description = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.s.description#">,
          amount = <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.s.amount#">,
          itemTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.s.itemType#">,
          status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.s.status#">,
          stageID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.s.stage#">
        where
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#s.id#">
      </cfquery>
    <cfelse>
      <cfquery name="d" datasource="#dsn.getName()#">
        insert into item
          (
            name,
            description,
            amount,
            itemTypeID,
            status,
            stageID,
            siteID
          )
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.s.name#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.s.description#">,
            <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.s.amount#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.s.itemType#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.s.status#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.s.stage#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          )
      </cfquery>
      <cfquery name="n" datasource="#dsn.getName()#">
        select LAST_INSERT_ID() as id from item
      </cfquery>
      <cfset s.id = n.id>
    </cfif>
    <!--- now insert participants --->
    <cfquery name="d" datasource="#dsn.getName()#">
      delete from itemParticipant
      where
      itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#s.id#">
    </cfquery>
    <cfloop array="#arguments.s.participant#" index="p">
      <cfquery name="i" datasource="#dsn.getName()#">
        INSERT INTO itemParticipant
        (
         itemID,
         contactID,
         system
        )
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#s.id#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#p['#p.type#']#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.system#">
        )
      </cfquery>
    </cfloop>
    <!--- now insert activities --->
    <!--- delete activities that have been deleted --->
    <cfset var activityIDs = []>
    <cfloop array="#arguments.s.activity#" index="a">
      <cfif isDefined("a.id")>
        <cfset arrayAppend(activityIDs,a.id)>
      </cfif>
    </cfloop>
    <cfif arrayLen(activityIDs) gte 1>
      <cfquery name="d" datasource="#dsn.getName()#">
        delete from itemActivity where id NOT IN(<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#ArrayToList(activityIDs)#">)
        AND
        itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#s.id#">
      </cfquery>
    </cfif>

    <cfloop array="#arguments.s.activity#" index="a">
      <cfif NOT isDefined("a.id")>
        <cfquery name="i" datasource="#dsn.getName()#">
          INSERT INTO itemActivity
          (
           itemID,
           name,
           description,
           dueDate,
           reminderDate
          )
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#s.id#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#a.name#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#a.description#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(a.due)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(a.reminder)#">
          )
        </cfquery>
      </cfif>
    </cfloop>
    <!--- now insert relationships --->
    <cfquery name="d" datasource="#dsn.getName()#">
      delete from itemRelationship
      where
      itemID = <cfqueryparam cfsqltype="cf_sql_integer" value="#s.id#">
    </cfquery>
    <cfloop array="#arguments.s.relationship#" index="r">
      <cfquery name="i" datasource="#dsn.getName()#">
        INSERT INTO itemRelationship
        (
         itemID,
         relatedType,
         relatedID,
         relatedSystem
        )
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#s.id#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#r.type#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#r['#r.type#']#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#r.system#">
        )
      </cfquery>
    </cfloop>
    <!--- add to feed --->
    <cfset fService = evaluate("#request.flowSystem#FeedService")>
    <cfset soID = request["#request.flowSystem#"].contactID>
    <cfif newItem>
      <!--- new flo item --->
      <cfloop array="#arguments.s.participant#" index="p">
        <cfset fService.createFeedItem(
          so="contact",
          sOID=sOID,
          rO="flo.item",
          rOID=s.id,
          action="newFloItem",
          tO=p.type,
          tOID=p['#p.type#']
        )>
      </cfloop>
      <cfloop array="#arguments.s.relationship#" index="r">
        <cfset fService.createFeedItem(
          so="contact",
          sOID=sOID,
          rO="flo.item",
          rOID=s.id,
          action="newFloItem",
          tO=r.type,
          tOID=r['#r.type#']
        )>
      </cfloop>
    <cfelse>
      <!--- updated flo item --->
      <cfloop array="#arguments.s.participant#" index="p">
        <cfset fService.createFeedItem(
          so="contact",
          sOID=sOID,
          rO="flo.item",
          rOID=s.id,
          action="editFloItem",
          tO=p.type,
          tOID=p['#p.type#']
        )>
      </cfloop>
      <cfloop array="#arguments.s.relationship#" index="r">
        <cfset fService.createFeedItem(
          so="contact",
          sOID=sOID,
          rO="flo.item",
          rOID=s.id,
          action="editFloItem",
          tO=r.type,
          tOID=r['#r.type#']
        )>
      </cfloop>
    </cfif>
    <cfreturn s.id>
  </cffunction>

  <cffunction name="addActivity" returntype="void">
    <cfargument name="name">
    <cfargument name="description">
    <cfargument name="dueDate">
    <cfargument name="reminderDate">
    <cfargument name="itemID">
    <cfquery name="a" datasource="#dsn.getName()#">
      INSERT INTO itemActivity
          (
           itemID,
           name,
           description,
           dueDate,
           reminderDate
          )
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.itemID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.description#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.dueDate)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.reminderDate)#">
          )
    </cfquery>
    <cfquery name="activityID" datasource="#dsn.getName()#">
      select last_insert_id() as newID from itemActivity;
    </cfquery>
    <cfset floItem = getTask(arguments.itemID)>
    <cfset fService = evaluate("#request.flowSystem#FeedService")>
    <cfset soID = request["#request.flowSystem#"].contactID>
    <cfloop query="floitem.dependencies">
        <cfset fService.createFeedItem(
          so="contact",
          sOID=sOID,
          rO="flo.task",
          rOID=activityID.newID,
          action="floTask",
          tO="contact",
          tOID=contactID
        )>
      </cfloop>
      <cfloop array="#floitem.relatedObject#" index="r">
        <cfset fService.createFeedItem(
          so="contact",
          sOID=sOID,
          rO="flo.task",
          rOID=activityID.newID,
          action="floTask",
          tO=r.type,
          tOID=r.object.id
        )>
      </cfloop>
  </cffunction>

  <cffunction name="pushBack" returntype="void">
    <cfargument name="activityID" required="true" type="numeric">
    <cfargument name="newDate" required="true">
    <cfif isDate(arguments.newDate)>
      <cfquery name="p" datasource="#dsn.getName()#" result="a">
        update itemActivity set reminderDate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#arguments.newDate#">
        WHERE
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activityID#">
      </cfquery>
    <cfelse>
    <!--- does the activity inherit done status? --->
      <cfset var activity = getActivity(arguments.activityID)>
      <cfset var item = getTask(activity.itemID)>
      <cfset workFlow = DeSerializejson(item.task.workFlowDefinition)>

      <cfif workflow.activities.completeParentonComplete>
        <!--- set the parent task to complete too --->
        <cfquery name="d" datasource="#dsn.getName()#">
          update item set status = <cfqueryparam cfsqltype="cf_sql_varchar" value="complete">
          where
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#item.task.id#">
        </cfquery>
      </cfif>
      <cfquery name="finish" datasource="#dsn.getName()#" result="a">
        update itemActivity set complete = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activityID#">
      </cfquery>
    </cfif>
  </cffunction>

  <cffunction name="changePriority" returntype="void">
    <cfargument name="activityID" required="true" type="numeric">
    <cfargument name="priority" required="true">
    <!--- does the activity inherit done status? --->
      <cfset var activity = getActivity(arguments.activityID)>
      <cfset var item = getTask(activity.itemID)>
      <cfset workFlow = DeSerializejson(item.task.workFlowDefinition)>
      <cfquery name="finish" datasource="#dsn.getName()#" result="a">
        update itemActivity set priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.priority#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.activityID#">
      </cfquery>

      <!--- <cfif workflow.activities.emailNotification>
        <!--- set the parent task to complete too --->
        <cfquery name="d" datasource="#dsn.getName()#">
          update item set status = <cfqueryparam cfsqltype="cf_sql_varchar" value="complete">
          where
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#item.task.id#">
        </cfquery>
      </cfif> --->
  </cffunction>
<cfscript>
/**
 * Pass a formatted structure containing the event properties and get back a string in the iCalendar format (correctly offset for daylight savings time in U.S.) that can be saved to a file or returned to the browser with MIME type=&quot;text/calendar&quot;.
 * v2 updated by Dan Russel
 *
 * @param stEvent      Structure of data for the event. (Required)
 * @return Returns a string.
 * @author Troy Pullis (tpullis@yahoo.com)
 * @version 2, December 18, 2008
 */
function iCalUS(stEvent) {
    var vCal = "";
    var CRLF=chr(13)&chr(10);
    var date_now = Now();

    if (NOT IsDefined("stEvent.organizerName"))
        stEvent.organizerName = "Organizer Name";

    if (NOT IsDefined("stEvent.organizerEmail"))
        stEvent.organizerEmail = "Organizer_Name@CFLIB.ORG";

    if (NOT IsDefined("stEvent.subject"))
        stEvent.subject = "Event subject goes here";

    if (NOT IsDefined("stEvent.location"))
        stEvent.location = "Event location goes here";

    if (NOT IsDefined("stEvent.description"))
        stEvent.description = "Event description goes here\n---------------------------\nProvide the complete event details\n\nUse backslash+n sequences for newlines.";

    if (NOT IsDefined("stEvent.startTime"))  // This value must be in Eastern time!!!
        stEvent.startTime = ParseDateTime("3/21/2008 14:30");  // Example start time is 21-March-2008 2:30 PM Eastern

    if (NOT IsDefined("stEvent.endTime"))
        stEvent.endTime = ParseDateTime("3/21/2008 15:30");  // Example end time is 21-March-2008 3:30 PM Eastern

    if (NOT IsDefined("stEvent.priority"))
        stEvent.priority = "1";

    vCal = "BEGIN:VCALENDAR" & CRLF;
    vCal = vCal & "PRODID: -//CFLIB.ORG//iCalUS()//EN" & CRLF;
    vCal = vCal & "VERSION:2.0" & CRLF;
    vCal = vCal & "METHOD:REQUEST" & CRLF;
    vCal = vCal & "BEGIN:VTIMEZONE" & CRLF;
    vCal = vCal & "TZID:Eastern Time" & CRLF;
    vCal = vCal & "BEGIN:STANDARD" & CRLF;
    vCal = vCal & "DTSTART:20061101T020000" & CRLF;
    vCal = vCal & "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=1SU;BYMONTH=11" & CRLF;
    vCal = vCal & "TZOFFSETFROM:-0400" & CRLF;
    vCal = vCal & "TZOFFSETTO:-0500" & CRLF;
    vCal = vCal & "TZNAME:Standard Time" & CRLF;
    vCal = vCal & "END:STANDARD" & CRLF;
    vCal = vCal & "BEGIN:DAYLIGHT" & CRLF;
    vCal = vCal & "DTSTART:20060301T020000" & CRLF;
    vCal = vCal & "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=2SU;BYMONTH=3" & CRLF;
    vCal = vCal & "TZOFFSETFROM:-0500" & CRLF;
    vCal = vCal & "TZOFFSETTO:-0400" & CRLF;
    vCal = vCal & "TZNAME:Daylight Savings Time" & CRLF;
    vCal = vCal & "END:DAYLIGHT" & CRLF;
    vCal = vCal & "END:VTIMEZONE" & CRLF;
    vCal = vCal & "BEGIN:VEVENT" & CRLF;
    vCal = vCal & "UID:#date_now.getTime()#.CFLIB.ORG" & CRLF;  // creates a unique identifier
    vCal = vCal & "ORGANIZER;CN=#stEvent.organizerName#:MAILTO:#stEvent.organizerEmail#" & CRLF;
    vCal = vCal & "DTSTAMP:" &
            DateFormat(date_now,"yyyymmdd") & "T" &
            TimeFormat(date_now, "HHmmss") & CRLF;
    vCal = vCal & "DTSTART;TZID=Eastern Time:" &
            DateFormat(stEvent.startTime,"yyyymmdd") & "T" &
            TimeFormat(stEvent.startTime, "HHmmss") & CRLF;
    vCal = vCal & "DTEND;TZID=Eastern Time:" &
            DateFormat(stEvent.endTime,"yyyymmdd") & "T" &
            TimeFormat(stEvent.endTime, "HHmmss") & CRLF;
    vCal = vCal & "SUMMARY:#stEvent.subject#" & CRLF;
    vCal = vCal & "LOCATION:#stEvent.location#" & CRLF;
    vCal = vCal & "DESCRIPTION:#stEvent.description#" & CRLF;
    vCal = vCal & "PRIORITY:#stEvent.priority#" & CRLF;
    vCal = vCal & "TRANSP:OPAQUE" & CRLF;
    vCal = vCal & "CLASS:PUBLIC" & CRLF;
    vCal = vCal & "BEGIN:VALARM" & CRLF;
    vCal = vCal & "TRIGGER:-PT30M" & CRLF;  // alert user 30 minutes before meeting begins
    vCal = vCal & "ACTION:DISPLAY" & CRLF;
    vCal = vCal & "DESCRIPTION:Reminder" & CRLF;
    vCal = vCal & "END:VALARM" & CRLF;
    vCal = vCal & "END:VEVENT" & CRLF;
    vCal = vCal & "END:VCALENDAR";
    return Trim(vCal);
}
</cfscript>
</cfcomponent>