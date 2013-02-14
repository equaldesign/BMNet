<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="false">

  <cfproperty name="userEmail">
  <cfproperty name="emailToAddress">
  <cfproperty name="emailAddress">
  <cfproperty name="siteID">
  <cfproperty name="emailName">
  <cfproperty name="emailToName">
  <cfproperty name="nodeRef">
  <cfproperty name="subject">
  <cfproperty name="bvEmailService" inject="id:bv.EmailService">
  <cfproperty name="FeedService" inject="id:eunify.FeedService">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="ContactService" inject="id:eunify.ContactService" />
  <!--- methods --->

  <cffunction name="fileEmail" returntype="Any">
    <cfargument name="userID" required="true">
    <cfargument name="siteID" required="true">
    <cfargument name="emailStructure" required="true">
    <cfargument name="nodeRef" required="true">
    <cfargument name="e" required="true">
    <cfif arguments.userID neq arguments.e>
      <cfset contact = ContactService.getContactByEmail(e,2,request.siteID)>
      <cfif contact.recordCount eq 0>
	  	  <cfset thisContact = beanFactory.getModel("eunify.ContactService")>
        <cfset thisContact.setid(0)>
        <cfset thisContact.setemail(e)>
        <cfset thisContact.setsiteID(request.siteID)>
        <cfset thisContact.setemailLogin(false)>
        <cfset thisContact.save()>
        <cfset var contact = thisContact.getContact(ContactService.getid())>
      </cfif>
      <cfquery name="alreadyExists" datasource="#dsn.getName()#">
        select id from emailArchive
        where
        userID = <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.userID#">
        AND
        contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contact.id#">
        AND
        nodeRef = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.nodeRef#">
      </cfquery>
      <cfif alreadyExists.recordCount neq 0>
        <cfreturn "false">
      </cfif>
      <cfif arrayLen(arguments.emailStructure.attachments) gte 1>
        <cfset attachments = "true">
      <cfelse>
        <cfset attachments = "false">
      </cfif>
      <cfquery name="s" datasource="#dsn.getName()#">
         insert into emailArchive (userID,contactID,messageDate,subject,nodeRef,attachments)
         VALUES (
          <cfqueryparam  cfsqltype="cf_sql_integer" value="#arguments.userid#">,
          <cfqueryparam  cfsqltype="cf_sql_integer" value="#contact.id#">,
          <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#arguments.emailStructure.sentdate#">,
          <cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.emailStructure.subject#">,
          <cfqueryparam  cfsqltype="cf_sql_varchar" value="#arguments.nodeRef#">,
          <cfqueryparam  cfsqltype="cf_sql_varchar" value="#attachments#">
         )
      </cfquery>
      <cfquery name="n" datasource="#dsn.getName()#">
        select LAST_INSERT_ID() as id from emailArchive;
      </cfquery>
      <cfset logger.debug("Created Email Archive #n.id#")>
      <cfset FeedService.createFeedItem(
        so="contact",
        sOID=arguments.userid,
        tO="contact",
        tOID=contact.id,
        action="email",
        rO="emailArchive",
        rOID=n.id,
        siteID = arguments.siteID
      )>
     <cfelse>
     <cfset logger.debug("User is Email Address")>
     </cfif>
  </cffunction>

  <cffunction name="archive" returntype="String">
    <cfargument name="user" required="true">
	  <cfargument name="siteID" required="true">
	  <cfargument name="emailStructure" required="true">
	  <cfargument name="nodeRef" required="true">
	  <cfargument name="password" required="true">
    <cfset logger.debug("Doing archive...")>
    <cfset logger.debug("#ArrayLen(emailStructure.torecipients)# recipients...")>
    <cfloop array="#emailStructure.torecipients#" index="e">
	   <cfset fileEmail(arguments.user.id,siteID,emailStructure,nodeRef,e)>
    </cfloop>
    <cfset logger.debug("#ArrayLen(emailStructure.from)# froms...")>
    <cfloop array="#emailStructure.from#" index="e">
	   <cfset fileEmail(arguments.user.id,siteID,emailStructure,nodeRef,e)>
	  </cfloop>
    <cfset logger.debug("#ArrayLen(emailStructure.ccRecipients)# CCs...")>
	  <cfloop array="#emailStructure.ccRecipients#" index="e">
	  	<cfset fileEmail(arguments.user.id,siteID,emailStructure,nodeRef,e)>
	  </cfloop>
    <cfreturn "true">
  </cffunction>

  <cffunction name="list" returntype="query" output="false">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfargument name="contactID" required="true" type="string" default="0">
    <cfargument name="companyID" required="true" type="string" default="0">
    <cfset var columnArray = ["id","from","subject","messageDate"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfquery name="l" datasource="#dsn.getName()#">
      select
        emailArchive.id,
        subject,
        messageDate,
        first_name,
        surname,
        contact.id as contactID
      from
        emailArchive,
        contact
        WHERE
        <cfif arguments.contactID neq 0>
        contactID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactID#">
        <cfelseif arguments.companyID neq 0>
        contact.company_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companyID#">
        AND
        emailArchive.contactID = contact.id
        </cfif>
        AND
        contact.id = emailArchive.contactID
        <cfif arguments.searchQuery neq "">
        AND
        (

        subject like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">

        )
        </cfif>
        order by #sortColName# #arguments.sortDir#
        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="getEmail" returntype="query" output="false">
    <cfargument name="emailID" required="true" type="numeric" default="1">
    <cfquery name="l" datasource="#dsn.getName()#">
      select
        id,
        subject,
        messageDate,
        nodeRef
      from
        emailArchive
        WHERE
        id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailID#">
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="cCount" returntype="Numeric">
    <cfargument name="searchQuery" required="true" default="">
    <cfargument name="contactID" required="true" default="0">
    <cfargument name="companyID" required="true" default="0">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfquery name="s" datasource="#dsn.getName()#">
      select count(emailArchive.id) as records
      from
      emailArchive
      <cfif arguments.companyID neq 0>,
        contact
        </cfif>
      WHERE
      <cfif arguments.contactID neq 0>
        contactID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.contactID#">
      <cfelse>
        contact.company_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companyID#">
          AND
        emailArchive.contactID = contact.id
      </cfif>
      <cfif arguments.searchQuery neq "">
        AND
        (
        subject like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
      </cfif>
      <cfif arguments.contactID neq "0">

      </cfif>
    </cfquery>
    <cfreturn s.records>
  </cffunction>

  <cffunction name="sendToAlf" returntype="string">
  	<cfargument name="ticket" required="true">
	  <cfargument name="emailFile" required="true">
	  <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bmnet/addEmail?alf_ticket=#ticket#" method="post" result="emailNode">
	    <cfhttpparam type="file" file="#arguments.emailFile#" name="filedata" mimetype="message/rfc822">
	  </cfhttp>
	  <cfset logger.debug(emailNode.fileContent)>
	  <cfreturn emailNode.fileContent>
  </cffunction>

</cfcomponent>