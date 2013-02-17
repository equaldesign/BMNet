<cfcomponent name="taskService" cache="true">
  <!--- a totally modular and seperate task, workflow and sales pipeline system --->
  <cfproperty name="dsn" inject="coldbox:datasource:flo" />
  <cfproperty name="wirebox" inject="wirebox" />
  <cffunction name="getRelatedObject" returntype="any">
    <cfargument name="relatedSystem" default="BMNet" required="true">
    <cfargument name="relatedType" default="contact" required="true">
    <cfargument name="relatedID" default="0" required="true">
    <cfswitch expression="#arguments.relatedSystem#">
      <cfcase value="BMNet">
        <cfswitch expression="#arguments.relatedType#">
          <cfcase value="contact">
            <cfreturn wireBox.getInstance("eunify.ContactService").getContactAndCompany(arguments.relatedID)>
          </cfcase>
          <cfcase value="colleagues">
            <cfreturn wireBox.getInstance("eunify.ContactService").getColleagues(arguments.relatedID)>
          </cfcase>
          <cfcase value="customer,supplier">
            <cfreturn wireBox.getInstance("eunify.CompanyService").getCompany(arguments.relatedID)>
          </cfcase>
        </cfswitch>

      </cfcase>
      <cfcase value="eGroup">
        <cfswitch expression="#arguments.relatedType#">
          <cfcase value="contact">
            <cfreturn wireBox.getInstance("eGroup.contact").getContact(arguments.relatedID)>
          </cfcase>
          <cfcase value="company">
            <cfreturn wireBox.getInstance("eGroup.company").getCompany(arguments.relatedID)>
          </cfcase>
          <cfcase value="arrangement">
            <cfreturn wireBox.getInstance("eGroup.psa").panelData("overview",arguments.relatedID)>
          </cfcase>
        </cfswitch>
      </cfcase>
      <cfdefaultcase>
        <!--- just try a badboy database query --->
        <cfquery name="x" datasource="#arguments.relatedSystem#">
          select * from #arguments.relatedType#
          where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">
        </cfquery>
        <cfreturn x>
      </cfdefaultcase>
    </cfswitch>
  </cffunction>

  <cffunction name="getRelatedTasks" returntype="query">
    <cfargument name="relatedType" required="true" type="string">
    <cfargument name="relatedID" required="true" type="numeric">
    <cfargument name="participants" required="true" type="numeric" default="0">
    <cfargument name="status" required="true" type="string" default="">
    <cfargument name="stage" required="true" type="string" default="">
    <cfargument name="activityComplete" required="true" type="string" default="">
    <cfargument name="flowSystem" required="true" type="string" default="#request.flowSystem#">
    <cfquery name="tasks" datasource="#dsn.getName()#">
      select
        item.id,
        item.name,
        item.amount,
        stage.name as stageName,
        itemType.name as typeName,
        itemActivity.name as activityName,
        itemActivity.dueDate,
        itemActivity.priority,
        itemActivity.id as activityID,
        contact.first_name,
        contact.surname,
        contact.id as contactID
      FROM
        item LEFT JOIN itemActivity on itemActivity.itemID = item.id,
        itemParticipant
          LEFT JOIN #request.flowSystem#.contact as contact on contact.id = itemParticipant.contactID,
        itemRelationship,
        itemType,
        stage
        <cfif arguments.relatedType eq "customer,supplier">
        , #arguments.flowSystem#.company as sourceCompany,
          #arguments.flowSystem#.contact as sourceContact
        </cfif>
      WHERE
          itemRelationship.relatedSystem = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.flowSystem#">
        AND
           <cfif arguments.relatedType eq "customer,supplier">
            sourceCompany.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">
            AND
            sourceContact.company_id = sourceCompany.id
            AND
            (
              (
                itemRelationship.relatedID = sourceCompany.id
                AND
                itemRelationship.relatedType IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="customer,supplier" list="true">)
              )
              OR
              (
                itemRelationship.relatedID = sourceContact.id
                AND
                itemRelationship.relatedType IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="contact" list="true">)
              )
            )
           <cfelse>
            itemRelationship.relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">
           </cfif>
        AND
          item.id = itemRelationship.itemID
        <cfif arguments.participants neq 0>
        AND
          itemParticipant.contactID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.participants#" list="true">)
        </cfif>
        <cfif arguments.status neq "">
        AND
          item.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
        </cfif>
        <cfif arguments.stage neq "">
        AND
          stage.name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.stage#">
        AND
          item.stageID = stage.id
        </cfif>
        
        <cfif arguments.activityComplete neq "">
        AND
          itemActivity.complete = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activityComplete#">
        </cfif>
        AND
          itemParticipant.itemID = item.id
        AND
          itemType.id = item.itemTypeID
        AND
          item.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        AND
          stage.id = item.stageID
        order by item.id, activityID, contactID
    </cfquery>
    <cfreturn tasks>
  </cffunction>
</cfcomponent>