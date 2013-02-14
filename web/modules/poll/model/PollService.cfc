<cfcomponent name="PollService" accessors="true" output="true" cache="true" cacheTimeout="0" autowire="true">
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="utils" inject="coldbox:plugin:Utilities" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />

  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="formbuilder" inject="id:poll.FormBuilder" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />

  <cfproperty name="id" />
  <cfproperty name="name" />
  <cfproperty name="description" />
  <cfproperty name="status" />
  <cfproperty name="organiserID" />
  <cfproperty name="CoOrdinatorID" />
  <cfproperty name="categoryID" />
  <cfproperty name="relatedTo">
  <cfproperty name="relatedID">
  <cfproperty name="existingAgreement" />
  <cfproperty name="permissions" />
  <cfproperty name="protection" />
  <cfproperty name="allowMultipleResponses" />
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
    <cfargument name="pollID" required="true">
    <cfargument name="contactID" required="true">
    <cfargument name="formStruct" required="true">
    <!--- first, set the the user as attending the appointment --->
    <cfset var contactUser = contact.getContact(arguments.contactID)>
    <cfset var poll = getPoll(arguments.pollID)>
    <!--- were they "invited"? --->

    <!--- has anyone else from this company filled it in? --->
    <cfif NOT poll.allowMultipleResponses>
      <!--- we have to delete any previous responses from other people --->
      <cfset responses = companyResponses(arguments.pollID,contactUser.company_id)>
      <cfif responses.recordCount neq 0>
        <cfquery name="deleteInvitations" datasource="#dsn.getName()#">
          delete from pollInvitation where contactID IN (
            select
              c1.id
            from
              contact,
              contact as c1
            where
              contact.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
                AND
              c1.company_id = contact.company_id)
            )
            AND
            pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
        </cfquery>
        <cfquery name="deleteExisting" datasource="#dsn.getName()#">
          delete from pollValues where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#responses.contactID#">
        </cfquery>
      </cfif>
    </cfif>

    <cfif NOT userIsInvited(arguments.contactID,arguments.pollID)>
      <!--- we need to insert them into the invitation list --->
      <!--- check if they're allowed to participate --->
      <cfquery name="x" datasource="#dsn.getName()#">
        INSERT INTO
          pollInvitation
        (
          pollID,
          contactID,
          completed,
          emailSent
        )
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="true">

        )
      </cfquery>
    </cfif>



    <cfquery name="deleteExisting" datasource="#dsn.getName()#">
      delete from pollValues where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
    </cfquery>


    <!--- now register them --->
    <cfloop collection="#arguments.formStruct#" item="fS">
      <cfset fieldID = ListLast(fs,"_")>
      <cfset fieldValue = arguments.formStruct["#fs#"]>
      <cfif fieldValue neq "">
        <cfset fieldDB = getPollField(fieldID)>
        <cfif fieldDB.encrypt>
          <cfset fieldValue = encrypt(fieldValue,"eggwah","CFMX_COMPAT")>
        </cfif>
        <!--- insert the registration information --->
        <cfquery name="x" datasource="#dsn.getName()#">
          insert into pollValues
          (
            metaID,
            pollID,
            value,
            contactID
          )
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#fieldID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#fieldValue#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
          )

        </cfquery>
      </cfif>
    </cfloop>

    <!--- mark the poll as complete --->
    <cfquery name="updateStatus" datasource="#dsn.getName()#">
      update pollInvitation set completed = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
      where
      contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
      AND
      pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
    </cfquery>
  </cffunction>

  <cffunction name="clone" returntype="numeric">
    <cfargument name="id" required="true">
    <cfset beanFactory.populateFromQuery(this,getPoll(arguments.id))>
    <cfset this.setCoOrdinatorID(request.eGroup.contactID)>
    <cfset this.setid(0)>
    <cfset this.save()>
    <cfset returnID = this.getid()>
    <cfset pollGroups = getPollGroups(arguments.id)>
    <cfloop query="pollGroups">
      <cfset newPollGroupID = formbuilder.addGroup("pollGroup",pollGroups.name,returnID,pollGroups.description,"pollID")>
      <cfset pollFields = getPollFields(pollGroups.id)>
      <cfloop query="pollFields">
        <cfset newPollFieldID = formbuilder.addField("pollField",pollFields.label,pollFields.name,pollFields._type,"pollGroupID",pollFields._required,pollFields.encrypt,pollFields.requirenumeric,newPollGroupID)>
        <cfset fieldOptions = getPollFieldOptions(pollFields.id)>
        <cfloop query="fieldOptions">
          <cfset formbuilder.addOption("pollFieldOption","pollFieldID",newPollFieldID,fieldOptions.label)>
        </cfloop>
      </cfloop>
    </cfloop>
    <cfset addInvitees(returnID,getInvitees(arguments.id))>
    <cfreturn returnID>
  </cffunction>

  <cffunction name="getPollField" returntype="query">
    <cfargument name="fieldID">
    <cfquery name="r" datasource="#dsn.getName(true)#">
      select * from pollField where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fieldID#">
    </cfquery>
    <cfreturn r>
  </cffunction>

  <cffunction name="userCanComplete" returntype="boolean">
    <cfargument name="contactID">
    <cfargument name="pollID">
    <cfset poll = getPoll(arguments.pollID)>
    <cfif poll.protection eq "invited">
      <cfif NOT userIsInvited(arguments.contactID,arguments.pollID)>
        <cfreturn false>
      </cfif>
    </cfif>
    <cfif NOT poll.allowMultipleResponses>
      <cfset thiCompany = company.getCompany(contact.getContact(arguments.contactID).company_id)>
      <cfif thiCompany.contact_id eq arguments.contactID>
        <cfreturn true>
      </cfif>
      <cfset responses = companyResponses(arguments.pollID,thiCompany.id)>
      <cfif responses.recordCount neq 0>
        <!--- is the reponse me? --->
        <cfif responses.contactID neq arguments.contactID>
          <cfreturn false>
        </cfif>
      </cfif>
    </cfif>
    <cfreturn true>
  </cffunction>
  <cffunction name="userIsInvited" returntype="boolean">
    <cfargument name="contactID">
    <cfargument name="pollID">
    <cfset var invited = "">
    <cfquery name="invited" datasource="#dsn.getName(true)#">
  	    select
  	      *
  	    from
  	      pollInvitation
  	    where
  	      pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
  	    AND
  	      contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">;
  	  </cfquery>
    <cfif invited.recordCount gte 1>
      <cfreturn true>
      <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="getResultList" returntype="query">
    <cfargument name="pollID">
    <cfset var resultList = "">
    <cfquery name="resultList" datasource="#dsn.getName(true)#">
      select
      pollGroup.name,
      pollField.label,
      pollField.id,
      pollFieldOption.id as optionID,
      pollFieldOption.label as optionLabel,
      (SELECT
        count(*) as results from pollValues
          where
            metaID = pollField.id
            AND
            value = pollFieldOption.id
        ) as optionCount
      FROM
      poll,
      pollGroup,
      pollField,
      pollFieldOption
    where
      poll.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
      AND
      pollGroup.pollID = poll.id
      AND pollField.polLGroupID = pollGroup.id
      AND
      pollField._type = 'radio'
      AND
      pollFieldOption.pollFieldID = pollField.id
      group by optionID
    </cfquery>
    <cfreturn resultList>
  </cffunction>

  <cffunction name="getAllAnswers" returntype="query">
    <cfargument name="pollID">
    <cfset var resultList = "">
    <cfquery name="resultList" datasource="#dsn.getName(true)#">
       select
       pollGroup.name as groupName,
       pollGroup._order as groupOrder,
       pollField._order as fieldOrder,
       pollField.label,
       pollField.id,
       pollValues.value,
      contact.first_name,
      contact.surname,
      contact.email,
      company.name,
      company.known_as,
      company.id as companyID,
      contact.id as contactID
       FROM
       poll,
       pollGroup,
       pollField,
       pollValues,
       contact,
       company
    where
       poll.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
       AND
       pollGroup.pollID = poll.id
       AND
      pollField.pollGroupID = pollGroup.id

       AND
       pollValues.metaID = pollField.id
       AND
       contact.id = pollValues.contactID
       AND
       company.id = contact.company_id
       order by groupOrder, fieldOrder
    </cfquery>
    <cfreturn resultList>
  </cffunction>

  <cffunction name="getQuestionResponses" returntype="query">
    <cfargument name="id">
    <cfset var resultList = "">
    <cfquery name="resultList" datasource="#dsn.getName(true)#">
       select
       pollField._order as fieldOrder,
       pollField.label,
       pollField.id,
       pollField.compare,
       pollValues.value,
      contact.first_name,
      contact.surname,
      contact.email,
      company.name,
      company.known_as,
      company.id as companyID,
      contact.id as contactID,
	pollFieldOption.id as optionID,
      pollFieldOption.label as optionLabel
       FROM
       pollField,
       pollValues  LEFT JOIN pollFieldOption on (pollFieldOption.id = pollValues.Value),
       contact,
       company
    where
       pollField.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
       AND
       pollValues.metaID = pollField.id
       AND
       contact.id = pollValues.contactID
       AND
       company.id = contact.company_id

    </cfquery>
    <cfreturn resultList>
  </cffunction>

  <cffunction name="companyResponses" returntype="query">
    <cfargument name="pollID" required="true">
    <cfargument name="companyID" required="true" default="0">
    <cfset var resultList = "">
    <cfquery name="resultList" datasource="#dsn.getName(true)#">
      select
      company.name,
      company.known_as,
      company.id as companyID,
      contact.id as contactID
       FROM
       poll,
       pollGroup,
       pollField,
       pollValues,
       contact,
       company
    where
       poll.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
       AND
       pollGroup.pollID = poll.id
       AND
      pollField.pollGroupID = pollGroup.id
       AND
       (
        (
          pollField._type = 'text' OR pollField._type = 'textarea'
        )
        AND
        pollField.requirenumeric = 'false'
      )
       AND
       pollValues.metaID = pollField.id
       AND
       contact.id = pollValues.contactID
       AND
       company.id = contact.company_id
       <cfif arguments.companyID neq "0">
       AND
       company.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companyID#">
       </cfif>
       order by known_as
    </cfquery>
    <cfreturn resultList>
  </cffunction>

  <cffunction name="answerList" returntype="query">
    <cfargument name="pollID">
    <cfset var resultList = "">
    <cfquery name="resultList" datasource="#dsn.getName(true)#">
      select
       pollGroup.name as groupName,
       pollGroup._order as groupOrder,
       pollField._order as fieldOrder,
       pollField.label,
       pollField.compare,
       pollField.id,
       pollValues.value,
      contact.first_name,
      contact.surname,
      contact.email,
      company.name,
      company.known_as,
      company.id as companyID,
      contact.id as contactID
       FROM
       poll,
       pollGroup,
       pollField,
       pollValues,
       contact,
       company
    where
       poll.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
       AND
       pollGroup.pollID = poll.id
       AND
      pollField.pollGroupID = pollGroup.id
       AND
       (
        (
          pollField._type = 'text' OR pollField._type = 'textarea'
        )
        AND
        pollField.requirenumeric = 'false'
      )
       AND
       pollValues.metaID = pollField.id
       AND
       contact.id = pollValues.contactID
       AND
       company.id = contact.company_id
       order by groupOrder, fieldOrder
    </cfquery>
    <cfreturn resultList>
  </cffunction>

  <cffunction name="sumList" returntype="query">
    <cfargument name="pollID">
    <cfset var resultList = "">
    <cfquery name="resultList" datasource="#dsn.getName(true)#">
      select
       pollGroup.name as groupName,
       pollGroup._order as groupOrder,
       pollField._order as fieldOrder,
       pollField.label,
       pollField.compare,
       pollField.id,
       SUM(pollValues.value) as value,
       AVG(pollValues.value) as average
       FROM
       poll,
       pollGroup,
       pollField,
       pollValues
    where
       poll.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
       AND
       pollGroup.pollID = poll.id
       AND
      pollField.pollGroupID = pollGroup.id
       AND
       (
        pollField._type = 'text'
        AND
        pollField.requirenumeric = 'true'
      )
       AND
       pollValues.metaID = pollField.id
       group by pollField.id
     order by groupOrder, fieldOrder
    </cfquery>
    <cfreturn resultList>
  </cffunction>

  <cffunction name="stepperList" returntype="query">
    <cfargument name="pollID">
    <cfset var resultList = "">
    <cfquery name="resultList" datasource="#dsn.getName(true)#">
      select
       pollGroup.name as groupName,
       pollGroup._order as groupOrder,
       pollField._order as fieldOrder,
       pollField.label,
       pollField.name as fieldName,
       pollField.compare,
       pollField.id,
       contact.first_name,
       contact.surname,
       company.known_as,
       pollValues.value
       FROM
       poll,
       pollGroup,
       pollField,
       pollValues,
       contact,
       company
    where
       poll.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
       AND
       pollGroup.pollID = poll.id
       AND
      pollField.pollGroupID = pollGroup.id
       AND
       (
        pollField._type = 'stepper'
      )
       AND
       pollValues.metaID = pollField.id
       and
       contact.id = pollValues.contactID
       AND
       company.id = contact.company_id
     order by groupOrder, fieldOrder
    </cfquery>
    <cfreturn resultList>
  </cffunction>

  <cffunction name="userCompleted" returntype="boolean">
    <cfargument name="contactID">
    <cfargument name="pollID">
    <cfset var invited = "">
    <cfquery name="invited" datasource="#dsn.getName()#">
        select
          completed
        from
          pollInvitation
        where
          pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
        AND
          contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">;
      </cfquery>
    <cfif isBoolean(invited.completed) and invited.completed>
      <cfreturn true>
      <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="deletePoll" returntype="void">
    <cfargument name="pollID">
    <cfquery name="d" datasource="#dsn.getName()#">
      delete from poll where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
    </cfquery>
  </cffunction>


  <cffunction name="save" returntype="void">
    <cfset var eGroup = request.eGroup>
    <cfset var u = "">
    <cfset var n = "">
    <cfif this.getid() eq 0 OR this.getid() eq "">
      <cfquery name="u" datasource="#dsn.getName()#">
          insert into poll (name,description,status,organiserID,protection,allowMultipleResponses,categoryID,existingAgreement,CoOrdinatorID,relatedTo,relatedID)
          VALUES
            (<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getname()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdescription()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getstatus()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getorganiserID()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getprotection()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getallowMultipleResponses()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcategoryID()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getexistingAgreement()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCoOrdinatorID()#" />,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getrelatedTo()#" />,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getrelatedID()#" />
            )
        </cfquery>
      <cfquery name="n" datasource="#dsn.getName()#">
          select LAST_INSERT_ID() as id from poll;
        </cfquery>
      <cfset this.setid(n.id)>
      <cfelse>
      <cfquery name="u" datasource="#dsn.getName()#">
          update poll
            set name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getname()#" />,
            description = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getdescription()#" />,
            status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getstatus()#" />,
            organiserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getorganiserID()#" />,
            protection = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getprotection()#" />,
            categoryID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcategoryID()#" />,
            CoOrdinatorID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getCoOrdinatorID()#" />,
            existingAgreement = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getexistingAgreement()#" />,
            allowMultipleResponses = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getallowMultipleResponses()#" />,
            relatedTo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getrelatedTo()#" />,
            relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getrelatedID()#" />
          where
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
        </cfquery>
    </cfif>
    <!--- permissions --->

    <cfquery name="delPerm" datasource="#dsn.getName()#">
      delete from dmsSecurity where securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="poll">
      AND
      relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
    </cfquery>
    <cfloop list="#getpermissions()#" index="p">
      <cfquery name="addPerm" datasource="#dsn.getName()#">
        insert into dmsSecurity (groupID,securityAgainst,relatedID)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="poll">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
        )
      </cfquery>
    </cfloop>
    <cftry>
      <cfset feed.createFeedItem('contact',eGroup.contactID,'poll',getid(),'editPoll','company',eGroup.companyID,0,"edited poll")>
      <cfcatch type="any">
        <cflog application="true" text="#cfcatch.Message#">
      </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="getPoll" access="public" returntype="query" >
    <cfargument name="id" type="numeric" required="yes">
    <cfset var eGroup = request.eGroup>
    <cfset var appDetail = "">
    <cfset var appointments = "">
    <cfquery name="pollDetail" datasource="#dsn.getName()#">
        select
          poll.*
        FROM
          poll
          LEFT JOIN dmsSecurity on (poll.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'poll')
         WHERE
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR dmsSecurity.priviledge = ''))
          AND poll.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      </cfquery>
    <cfreturn pollDetail>
  </cffunction>

  <cffunction name="getPollList" access="public" returntype="query" >
    <cfargument name="filter">
    <cfset var eGroup = request.eGroup>
    <cfset var appDetail = "">
    <cfset var appointments = "">
    <cfquery name="pollList" datasource="#dsn.getName()#">
        select
          poll.*,
          (
            select count(*) from pollInvitation where pollID = poll.id
          ) as invited,
          (
            select count(*) from pollInvitation where pollID = poll.id and completed = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
          ) as completed
        FROM
          poll
          LEFT JOIN dmsSecurity on (poll.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'poll')
         WHERE
          poll.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filter#">
          AND
          (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#eGroup.rolesids#">) OR (dmsSecurity.priviledge is NULL OR dmsSecurity.priviledge = ''))
		    group by poll.id
      </cfquery>
    <cfreturn pollList>
  </cffunction>

  <cffunction name="getUserPolls" returntype="query">
    <cfargument name="contactID" required="true" type="numeric">
    <cfargument name="completed" required="true" default="">

    <cfset var invited = "">
    <cfquery name="invited" datasource="#dsn.getName()#">
        select
          poll.*
        from
          poll,
          pollInvitation
        where
          pollInvitation.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
        <cfif arguments.completed neq "">
        AND
         pollInvitation.completed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.completed#">
        </cfif>
        AND
          poll.id = pollInvitation.pollID
        AND
          poll.status = <cfqueryparam cfsqltype="cf_sql_varchar" value="open">
      </cfquery>
   <cfreturn invited>
  </cffunction>

  <cffunction name="getInvitees" returntype="query">
    <cfargument name="pollID" required="true" default="0">
    <cfargument name="completed" required="true" default="">
    <cfset var invited = "">
    <cfquery name="invited" datasource="#dsn.getName()#">
        select
          pollInvitation.*,
          contact.*,
          CONCAT(contact.first_name," ",contact.surname) as name,
          company.*,
          company.id as companyID,
          contact.id as contactID
        from
          pollInvitation,
          contact,
          company
        where
          pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
        <cfif arguments.completed neq "">
        AND
         completed = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.completed#">
        </cfif>
        AND
        contact.id = pollInvitation.contactID
        AND
        company.id = contact.company_id
        order by company.id
      </cfquery>
   <cfreturn invited>
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
       data.appointmentName = "#appointment.getname()#";
       data.appointmentStartDate = DateFormat(appointment.getstartDate(),"DD/MM/YYYY");
       data.appointmentStartTime = TimeFormat(appointment.getstartDate(),"HH:MM");
       data.AppointmentEndDate = DateFormat(appointment.getendDate(),"DD/MM/YYYY");
       data.appointmentEndTime = TimeFormat(appointment.getendDate(),"HH:MM");
    </cfscript>
    <cfif arguments.notify eq "newonly">
      <cfquery name="unvitedOnly" dbtype="query">
        select * from attendees where emailSent = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
      </cfquery>
      <cfset thisList = unvitedOnly>
    <cfelse>
      <cfset thisList = attendees>
    </cfif>
    <cfloop query="thisList">
      <cfscript>
        contactQ = contact.getContactQuery(aid);
        data.appointmentConfirmationLink = "http://#cgi.HTTP_HOST#/calendar/confirm/id/#appointmentID#/cID/#aid#/canattend/yes";
        data.appointmentNoAttendLink = "http://#cgi.HTTP_HOST#/calendar/confirm/id/#appointmentID#/cID/#aid#/canattend/no";
        populated = populate_fields(template,data);
        contents = populated;
       </cfscript>
       <cfsavecontent variable="ics"><cfoutput>BEGIN:VCALENDAR
BEGIN:VEVENT
DTSTART:#DateFormat(appointment.getStartDate(),"YYYYMMDD")#T#TimeFormat(appointment.getStartDate(),"HHMMSS")#Z
DTEND:#DateFormat(appointment.getendDate(),"YYYYMMDD")#T#TimeFormat(appointment.getendDate(),"HHMMSS")#Z
LOCATION:#Replace(replace(appointment.getAddress(),chr(13),"","ALL"),CHR(10),"","ALL")#
DESCRIPTION:#appointment.getdescription()#
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
        aID = <cfqueryparam cfsqltype="cf_sql_integer" value="#aID#">
      </cfquery>
    </cfloop>
    <cfreturn true>
  </cffunction>

  <cffunction name="removeInvitees" access="remote" returntype="boolean">
    <cfargument name="id" type="numeric" required="true">
    <cfargument name="inviteList" type="string" required="true">
    <cfquery name="remove" datasource="#dsn.getName()#">
      delete from pollInvitation where pollID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      AND
      contactID IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#arguments.inviteList#">)
    </cfquery>
    <cfreturn true>
  </cffunction>
  <cffunction name="addInvitees" returntype="any">
    <cfargument name="pollID">
    <cfargument name="contactQ">
    <cfargument name="currentQ">
    <cfset var thisQ = contactQ>
    <cfset var newUsers = QueryNew("id,name,known_as")>

    <cfloop query="thisQ">
      <cfif isDefined("contactID")>
        <cfset thisKey = contactID>
      <cfelse>
        <cfset thisKey = id>
      </cfif>
      <cfquery name="exists" datasource="#dsn.getName()#">
        select contactID from pollInvitation
        where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#thisKey#">
        AND
        pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
      </cfquery>
      <cfif exists.recordCount eq 0>
        <!--- add them! --->
        <cfquery name="addPerson" datasource="#dsn.getName()#">
          insert into pollInvitation
          (pollID,completed,emailSent,contactID)
          VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#thisKey#">

            )
        </cfquery>
        <cfset QueryAddRow(newUsers)>
        <cfset QuerySetCell(newUsers,"id",thisKey)>
        <cfset QuerySetCell(newUsers,"name","#first_name# #surname#")>
        <cfset QuerySetCell(newUsers,"known_as","#known_as#")>
      </cfif>
    </cfloop>
    <cfreturn newUsers>
  </cffunction>


  <cffunction name="getUserResult" returntype="query">
    <cfargument name="pollID">
    <cfargument name="contactID">
    <cfquery name="pollDetails" datasource="#dsn.getName()#">
        select
          pollGroup.id as ergID,
          pollValues.value as fieldValue,
          pollField.encrypt as encrypted,
          pollField.id as fieldID,
          pollField.label as fieldLabel,
          pollFieldOption.label as optionLabel
        from
          poll,
          pollInvitation
          LEFT JOIN pollValues on (pollValues.contactID = pollInvitation.contactID AND pollValues.pollID = pollInvitation.pollID)
          LEFT JOIN pollField on pollField.id = pollValues.metaID
          LEFT JOIN pollGroup on pollGroup.id = pollField.pollGroupID
          LEFT JOIN pollFieldOption on pollFieldOption.id = pollValues.value
        WHERE
          pollInvitation.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
          AND
          pollInvitation.pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
          AND
          poll.id = pollInvitation.pollID
          order by ergID, fieldID
        </cfquery>
        <cfreturn pollDetails>
  </cffunction>


  <cffunction name="getPollGroups" returntype="query">
    <cfargument name="pollID" required="true">
    <cfquery name="groups" datasource="#dsn.getName()#">
      select * from pollGroup where pollID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pollID#">
      order by _order asc
    </cfquery>
    <cfreturn groups>
  </cffunction>

  <cffunction name="getPollFields" returntype="query">
    <cfargument name="groupID">
    <cfquery name="fields" datasource="#dsn.getName()#">
      select * from pollField where pollGroupID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.groupID#">
      order by _order asc
    </cfquery>
    <cfreturn fields>
  </cffunction>

  <cffunction name="getPollFieldOptions" returntype="query">
    <cfargument name="fieldID">
    <cfquery name="options" datasource="#dsn.getName()#">
      select * from pollFieldOption where pollFieldID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.fieldID#">
      order by _order asc
    </cfquery>
    <cfreturn options>
  </cffunction>



</cfcomponent>
