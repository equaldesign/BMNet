<cfcomponent>
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="groupService" inject="id:eunify.GroupsService" />
  <cfproperty name="FeedService" inject="id:eunify.FeedService" />
  <cfproperty name="CompanyService" inject="id:eunify.CompanyService" />
  <cfproperty name="ContactService" inject="id:eunify.ContactService" />
  <cfproperty name="Renderer" inject="coldbox:plugin:Renderer">
  <cfproperty name="Utilities" inject="coldbox:plugin:Utilities">
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">

  <cffunction name="list" returntype="query">
    <cfquery name="c" datasource="#dsn.getName()#">
      select
        emailCampaign.*,
        (select count(*) from emailCampaignRecipient where campaignID = emailCampaign.id) as recipients,
        (select
          count(*)
          from
            emailCampaignRecipientActivity
          where
            activity = 'read'
            AND
            campaignID = emailCampaign.id
          
        ) as emailreads,
        (select
          count(*)
          from
            emailCampaignRecipientActivity
          where
            activity = 'click'
            AND
            campaignID = emailCampaign.id
          
        ) as clicks
         from emailCampaign where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfreturn c>
  </cffunction>

  <cffunction name="addSubscriber" returntype="numeric">
    <cfargument name="contactID" required="true" default="0">
    <cfargument name="emailAddress" required="true" default="">
    <cfargument name="contactName" required="true" default="">
    <cfif arguments.contactID eq 0>
      <!--- add a new contact, if they don't already exist --->
      <!--- we can only really search by email address here --->
      <cfset contact = ContactService.getContactByEmail(arguments.emailAddress)>
      <cfif contact.recordCount neq 0>
        <cfset arguments.contactID = contact.id>
      <cfelse>
        <!--- create a new user --->  
        <!--- try to find an appropriate company --->
        <cfset company = CompanyService.getcompanyByTLD(arguments.emailAddress)>
        <cfset ContactService.setfirst_name(ListFirst(arguments.contactName," "))>
        <cfset ContactService.setsurname(ListLast(arguments.contactName," "))>
        <cfif company.recordCount neq 0>
          <cfset ContactService.setcompany_id(company.id)>
        </cfif>
        <cfset ContactService.setemail(arguments.emailAddress)>
        <cfset ContactService.save()>
        <cfset arguments.contactID = ContactService.getid()>
        <cfset ContactService.setfirst_name("")>
        <cfset ContactService.setsurname("")>
        <cfset ContactService.setemail("")>
        <cfset ContactService.setcompany_id(0)>
      </cfif>
    </cfif>
    <cfif arguments.contactID neq 0>
      <!--- just make sure they are not unsubscribed --->
      <cfset ContactService.subscribe(arguments.contactID)>
    </cfif> 
    <cfreturn arguments.contactID>   
  </cffunction>

  <cffunction name="getCampaign" returntype="query">
    <cfargument name="id">
    <cfquery name="c" datasource="#dsn.getName()#">
      select
        emailCampaign.*,
        (select count(*) from emailCampaignRecipient where campaignID = emailCampaign.id) as recipients,
        (select
          count(*)
          from
            emailCampaignRecipientActivity
          where
            activity = 'read'
            AND
            campaignID = emailCampaign.id          
        ) as emailreads,
        (select
          count(*)
          from
            emailCampaignRecipientActivity
          where
            activity = 'click'
            AND
            campaignID = emailCampaign.id          
        ) as clicks
         from emailCampaign where siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
         AND
         emailCampaign.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn c>
  </cffunction>
  <cffunction name="getRecipients" returntype="query">
    <cfargument name="campaignID">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxRows" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">

    <cfset var columnArray = ["name","known_as"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfquery name="c" datasource="#dsn.getName()#">
      select
         contact.id,
         concat(contact.first_name," ",contact.surname) as name,
         "contact" as oType,
         company.known_as,
         contact.first_name,
         company.name as companyname,
         contact.email as emailaddress,
         contact.surname,
        contact.company_id
           from
           emailCampaignRecipient,
           contact left join company on company.id = contact.company_id
         where
         emailCampaignRecipient.campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
         AND
         contact.id = emailCampaignRecipient.contactID
        <cfif arguments.searchQuery neq "">
        AND
        concat(contact.first_name," ",contact.surname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchQuery#">
        </cfif>
        order by #sortColName# #arguments.sortDir#
          limit #arguments.startRow#,#arguments.maxRows#
    </cfquery>
    <cfreturn c>
  </cffunction>

  <cffunction name="getRecipientCount" returntype="numeric">
    <cfargument name="campaignID">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfquery name="c" datasource="#dsn.getName()#">
      select
        count(*) as amount
           from
           emailCampaignRecipient,
           contact left join company on company.id = contact.company_id
         where
         emailCampaignRecipient.campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
         AND
         contact.id = emailCampaignRecipient.contactID
        <cfif arguments.searchQuery neq "">
        AND
        concat(contact.first_name," ",contact.surname) LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchQuery#">
        </cfif>
    </cfquery>
    <cfreturn c.amount>
  </cffunction>

  <cffunction name="save" returntype="numeric">
    <cfargument name="id" required="true">
    <cfargument name="name" required="true">
    <cfargument name="subject" required="true">
    <cfargument name="fromName" required="true">
    <cfargument name="fromEmail" required="true">
    <cfargument name="scheduled" required="true">
    <cfargument name="scheduleTime" required="true">
    <cfargument name="scheduleHour" required="true">
    <cfargument name="scheduleMinute" required="true">
    <cfif arguments.id eq "">
      <!--- create campaign --->
      <cfquery name="u" datasource="#dsn.getName()#">
        insert
          into
        emailCampaign
          (name,subject,fromName,fromEmail,scheduled,scheduleDate,siteID)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromName#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromEmail#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheduled#">,
          <cfif arguments.scheduled AND arguments.scheduleTime neq "">
            <cfset scheduleDate = createDateTime(YEAR(LSDateFormat(arguments.scheduleTime)),MONTH(LSDateFormat(arguments.scheduleTime)),DAY(LSDateFormat(arguments.scheduleTime)),arguments.scheduleHour,arguments.scheduleMinute,0)>
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#scheduleDate#">
          <cfelse>
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
          </cfif>,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        )
      </cfquery>
      <cfquery name="n" datasource="#dsn.getName()#">
        select LAST_INSERT_ID() as id from emailCampaign;
      </cfquery>
      <cfreturn n.id>
    <cfelse>
      <!--- edit campaign --->
      <cfquery name="u" datasource="#dsn.getName()#">
        update emailCampaign
        set
          name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">,
          subject = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.subject#">,
          fromName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromName#">,
          fromEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fromEmail#">,
          scheduled = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.scheduled#">,
          scheduleDate =
          <cfif arguments.scheduled AND arguments.scheduleTime neq "">
            <cfset scheduleDate = createDateTime(YEAR(LSDateFormat(arguments.scheduleTime)),MONTH(LSDateFormat(arguments.scheduleTime)),DAY(LSDateFormat(arguments.scheduleTime)),arguments.scheduleHour,arguments.scheduleMinute,0)>
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#scheduleDate#">
          <cfelse>
            <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
          </cfif>
        WHERE
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
      </cfquery>
      <cfreturn arguments.id>
    </cfif>
  </cffunction>

  <cffunction name="getTemplate" returntype="query">
    <cfargument name="templateID" required="true" default="1">
    <cfif arguments.templateID eq "">
      <cfset arguments.templateID = 1>
    </cfif>
    <cfquery name="c" datasource="#dsn.getName()#">
      select
         name,templateCode, siteID from emailTemplate where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.templateID#">

    </cfquery>
    <cfreturn c>
  </cffunction>
  <cffunction name="getTemplates" returntype="query">
    <cfquery name="c" datasource="#dsn.getName()#">
      select
         id, name, siteID from emailTemplate where siteID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="0,#request.siteID#" list="true">)
    </cfquery>
    <cfreturn c>
  </cffunction>

  <cffunction name="removeRecipient" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="id">
    <cfquery name="f" datasource="#dsn.getName()#">
      delete from emailCampaignRecipient where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
      AND
      contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
  </cffunction>

  <cffunction name="listQueries" returntype="query">
    <cfquery name="l" datasource="#dsn.getName()#">
      select * from emailCampaignQuery where siteID IN (<cfqueryparam cfsqltype="cf_sql_integer" value="0,#request.siteID#" list="true">)
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="getQuery" returntype="query">
    <cfargument name="id">
    <cfargument name="startRow" required="true" default="">
    <cfargument name="maxRows" required="true" default="">
    <cfquery name="q" datasource="#dsn.getName()#">
      select selectStatement from emailCampaignQuery where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfset str = q.selectStatement>
    <cfset settings = {}>
    <cfset settings.siteID = request.siteID>
    <cfquery name="l" datasource="#dsn.getName()#">
      #placeHolderReplacer(str,settings)#
      <cfif arguments.startRow neq "">
      limit #arguments.startRow#,#arguments.maxRows#
      </cfif>
    </cfquery>
    <cfreturn l>
  </cffunction>
  <cffunction name="getQueryCount" returntype="numeric">
    <cfargument name="id">
    <cfargument name="startRow">
    <cfargument name="maxRows">
    <cfquery name="q" datasource="#dsn.getName()#">
      select selectStatement from emailCampaignQuery where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfset str = q.selectStatement>
    <cfset settings = {}>
    <cfset settings.siteID = request.siteID>
    <cfquery name="l" datasource="#dsn.getName()#">
      #placeHolderReplacer(str,settings)#
    </cfquery>
    <cfreturn l.recordCount>
  </cffunction>

  <cffunction name="addRecipient" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="objectType">
    <cfargument name="id">
    <cfif objectType eq "group">
      <cfset childContacts = GroupService.getChildrenContacts(arguments.id,true)>
      <cfloop query="childContacts">
       <cfquery name="c" datasource="#dsn.getName()#">
          select id from emailCampaignRecipient where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
          AND
          contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
        </cfquery>
        <cfif c.recordCount eq 0>
          <cfquery name="aq" datasource="#dsn.getName()#">
            insert into emailCampaignRecipient (campaignID,contactID)
            VALUES
            (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
            )
          </cfquery>
        </cfif>
      </cfloop>
    <cfelse>
      <cfquery name="c" datasource="#dsn.getName()#">
        select id from emailCampaignRecipient where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND
        contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
      </cfquery>
      <cfif c.recordCount eq 0>
        <cfquery name="aq" datasource="#dsn.getName()#">
          insert into emailCampaignRecipient (campaignID,contactID)
          VALUES
          (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
          )
        </cfquery>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="addQueryRecipient" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="queryID">

      <cfset childContacts = getQuery(arguments.queryID)>
      <cfloop query="childContacts">
       <cfquery name="c" datasource="#dsn.getName()#">
          select id from emailCampaignRecipient where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
          AND
          contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
        </cfquery>
        <cfif c.recordCount eq 0>
          <cfquery name="aq" datasource="#dsn.getName()#">
            insert into emailCampaignRecipient (campaignID,contactID)
            VALUES
            (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#childContacts.id#">
            )
          </cfquery>
        </cfif>
      </cfloop>
  </cffunction>

  <cffunction name="setEmailBody" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="text">
    <cfquery name="e" datasource="#dsn.getName()#">
      update emailCampaign set emailBody = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#arguments.text#">
      WHERE
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
    </cfquery>
  </cffunction>

  <cffunction name="track" returntype="void">
    <cfargument name="campaignID">
    <cfargument name="contactID">
    <cfargument name="remoteAddress">
    <cfargument name="activity">
    <cfargument name="extra">
    <cfset geoLocate = getCoordinatesfromIP(remoteAddress)>
    <cfquery name="i" datasource="#dsn.getName()#">
      insert into emailCampaignRecipientActivity (campaignID,contactID,activity,ipaddress,activitymeta<cfif NOT isBoolean(geoLocate)>,latitude,longitude,city,country</cfif>)
      VALUES
      (<cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">,
      <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.activity#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#ListFirst(arguments.remoteAddress)#">,
      <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.extra#">
      <cfif NOT isBoolean(geoLocate)>,
        <cfqueryparam cfsqltype="cf_sql_float" value="#geoLocate.latitude#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#geoLocate.longitude#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#geoLocate.city#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#geoLocate.country_name#">
      </cfif>

      )
    </cfquery>
    <!--- create a feed item --->
    <cfset theContact = ContactService.getContact(arguments.contactID)>
    
    <cfset FeedService.createFeedItem(
      so = "contact",
      sOID = arguments.contactID,
      tO = "company",
      tOID = theContact.company_id, 
      action = "emailcampaign_#arguments.activity#",
      rO = "emailCampaign",
      rOID = arguments.campaignID,
      message = arguments.extra,
      siteID = request.siteID
     )>
  </cffunction>

  <cffunction name="getCoordinatesfromIP" returntype="any">
    <cfargument name="IP" required="true">
    <cfset IPaddress = Trim(ListFirst(arguments.IP))>
    <cfhttp url="http://freegeoip.net/json/#IPaddress#"></cfhttp>
    <cftry>
      <cfreturn DeSerializeJSON(cfhttp.fileContent)>
      <cfcatch type="any">
        <cfreturn false>
      </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="send" returntype="void">
    <cfargument name="campaignID">
    <cfset thisCampaign = getCampaign(arguments.campaignID)>
    <cfset thisrecipients = getRecipients(arguments.campaignID)>
    <cfloop query="thisrecipients">
      <cfset settingsObject = {
        firstname = "#first_name#",
        surname = "#surname#",
        browserlink = "<a href='http://#cgi.http_host#/cv/#arguments.campaignID#/#thisCampaign.templateID#/#id#'>view in browser</a>",
        companyname = "#companyname#",
        emailaddress = "#emailaddress#",
        unsubscribe = "<a href='http://#cgi.http_host#/marketing/email/recipient/unsubscribe?id=#id#&cID=#arguments.campaignID#'>unsubscribe</a>",
        contactID = id
      }>
      <cfset args = {}>
      <cfset args.campaignID = arguments.campaignID>
      <cfset args.tracker = true>
      <cfset args.contactID = id>
      <cfset args.emailBody = placeHolderReplacer(replaceLinks(thisCampaign.emailBody,arguments.campaignID,id),settingsObject)>
      <cfset local.Email = MailService.newMail().config(
        from     = "#thisCampaign.fromName# <#thisCampaign.fromEmail#>",
        to   = "#first_name# #surname# <#emailaddress#>",
        subject  = "#thisCampaign.subject#")>

      <!---
      /*
      // Add plain text email
      to   = "#first_name# #surname# <#emailaddress#>",
      local.Email.addMailPart(charset='utf-8',type='text/plain',body=local.Renderer.renderLayout("layout.email.plain"));
      */
      --->

      // Add HTML email
      <cfset local.Email.addMailPart(charset='utf-8',type='text/html',body=Renderer.renderLayout(layout="email/#getTemplate(thisCampaign.templateID).name#_#request.siteID#",args=args))>

      <cfset MailService.send(local.Email)>
      <cfquery name="u" datasource="#dsn.getName()#">
        update emailCampaignRecipient set sent = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
        WHERE
        campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND
        contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      </cfquery>
    </cfloop>
    <cfquery name="q" datasource="#dsn.getName()#">
      update emailCampaign set sent = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
      dateSent = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
      WHERE
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
    </cfquery>
  </cffunction>

  <cffunction name="dryRun" returntype="void">
    <cfargument name="campaignID">
    <cfset thisCampaign = getCampaign(arguments.campaignID)>
    <cfset settingsObject = {
      firstname = "#ListGetAt(request.BMNet.name,1,' ')#",
      surname = "#ListGetAt(request.BMNet.name,2,' ')#",
      companyname = "#request.BMNet.companyknown_as#",
      browserlink = "<a href='http://#cgi.http_host#/cv/#arguments.campaignID#/#thisCampaign.templateID#'>view in browser</a>",
      emailaddress = "#request.BMNet.username#",
      unsubscribe = "<a href='http://#cgi.http_host#/marketing/email/recipient/unsubscribe?id=#request.BMNet.contactID#&cID=#arguments.campaignID#'>unsubscribe</a>",
      contactID = request.BMNet.contactID
    }>
    <cfset args = {}>
    <cfset args.campaignID = arguments.campaignID>
    <cfset args.tracker = true>
    <cfset args.contactID = request.BMNet.contactID>
    <cfset args.emailBody = placeHolderReplacer(replaceLinks(thisCampaign.emailBody,arguments.campaignID,request.BMNet.contactID),settingsObject)>

    <cfscript>
    local.Email = MailService.newMail().config(
      from     = "#thisCampaign.fromName# <#thisCampaign.fromEmail#>",
      to   = "#request.BMNet.name# <#request.BMNet.username#>",
      subject  = "#thisCampaign.subject#");


    /*
    // Add plain text email
    local.Email.addMailPart(charset='utf-8',type='text/plain',body=local.Renderer.renderLayout("layout.email.plain"));
    */


    // Add HTML email
    local.Email.addMailPart(charset='utf-8',type='text/html',body=Renderer.renderLayout(layout="email/#getTemplate(thisCampaign.templateID).name#_#request.siteID#",args=args));

    // Send the email. MailResult is a boolean.
    local.mailResult = MailService.send(local.Email);    
    </cfscript>
  </cffunction>

  <cffunction name="doEval" returntype="string">
    <cfargument name="str">
    <cfargument name="settings">
    <cfset contactID = settings.contactID>
    <cfif ListLen(str,"!") gte 2>
      <cfset serviceName = ListFirst(str,"!")>
      <cfset methodName = ListLast(str,"!")>
      <cfset injector = createObject("component","coldbox.system.ioc.Injector").init()>
      <cfset thisService = injector.getInstance("bmnet.custom.#replaceNoCase(cgi.http_host,'.','','ALL')#.model.modules.marketing.#serviceName#")>
      <cfinvoke component="#thisService#" method="#methodName#" returnvariable="retVar">
        <cfinvokeargument name="contactID" value="#settings.contactID#">
      </cfinvoke>
      <cfreturn retVar>
    <cfelse>
      <cfreturn evaluate("#str#(#settings.contactID#)")>
    </cfif>

  </cffunction>




  <cffunction name="replaceLinks">
    <cfargument name="str"    required="true" type="any" hint="The string variable to look for replacements">
    <cfargument name="campaignID" required="true" default="">
    <cfargument name="contactID" required="true" default="">
    <!---************************************************************************************************ --->
    <cfscript>
      var pos=1;
      var tmp=0;
      var linkArray = [];
      var delimiter = ",";
      var endpos = "";
      var returnString = arguments.str; 
      var l = {};
         l.results = [];

         l.pattern = createObject("java", "java.util.regex.Pattern").compile(javacast("string", "href=[""']([^""|']*)[""'][^>]*>([^<]*)"));
         l.matcher = l.pattern.matcher(javacast("string", returnString));

         while(l.matcher.find()) {
             l.groups = {};

             for(l.i = 1; l.i <= l.matcher.groupCount(); l.i++) {
                 l.groups[l.i] = l.matcher.group(javacast("int", l.i));
             }

             arrayAppend(l.results, l.groups);

         }


    </cfscript>

    <cfloop array="#l.results#" index="x">      
      <cfset returnString = replaceNoCase(returnString,"#x.1#","http://#cgi.http_host#/rd?cmnpn=#arguments.campaignID#&ct=#arguments.contactID#&u=#URLEncodedFormat(x.1)#")>      
    </cfloop>
    <cfreturn returnString>
  </cffunction>

  <cffunction name="getMailBody" returntype="any">
    <cfargument name="campaignID" required="true">
    <cfargument name="contactID" required="true" default="#request.BMNet.contactID#">
    <cfset thisCampaign = getCampaign(arguments.campaignID)>
    <cfset settingsObject = {
      firstname = "#ListGetAt(request.BMNet.name,1,' ')#",
      surname = "#ListGetAt(request.BMNet.name,2,' ')#",
      companyname = "#request.BMNet.companyknown_as#",      
      browserlink = "<a href='http://#cgi.http_host#/mcv/#arguments.campaignID#/#thisCampaign.templateID#/#arguments.contactID#'>view in browser</a>",
      unsubscribe = "<a href='http://#cgi.http_host#/mus/#arguments.contactID#/#arguments.campaignID#'>unsubscribe</a>",
      emailaddress = "#request.BMNet.username#",
      contactID = "#arguments.contactID#"

    }>
    <cfset cBody = replaceLinks(thisCampaign.emailBody,arguments.campaignID,arguments.contactID)>
    <cfreturn placeHolderReplacer(cBody,settingsObject)>
  </cffunction>

  <cffunction name="googleURLShorten" output="false" returnType="string">
    <cfargument name="url" type="string" required="true">
    <cfargument name="apiKey" type="string" required="false" default="" hint="API key identifies your application to Google">

    <cfset var requestURL = "https://www.googleapis.com/urlshortener/v1/url">
    <cfset var httpResult = "">
    <cfset var result = "">
    <cfset var response = "">
    <cfset var body = {"longUrl"=arguments.url}>
    <cfset body = serializeJson(body)>

    <cfif arguments.apiKey NEQ "">
        <cfset requestURL=requestURL & "?key=" & arguments.apiKey>
    </cfif>

    <cfhttp url="#requestURL#" method="post" result="httpResult">
        <cfhttpparam type="header" name="Content-Type" value="application/json">
        <cfhttpparam type="body" value="#body#">
    </cfhttp>
    <cfset response=deserializeJSON(httpResult.filecontent.toString())>

    <cfif structkeyexists(response, 'error')>
        <cfset result=response.error.message>
    <cfelse>
        <!--- No Errors, return response.id (which is the shortened url) --->
        <cfset result=response.id>
    </cfif>

    <cfreturn result>
</cffunction>
  <cfscript>
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
  </cfscript>

  <cffunction name="placeHolderReplacer" access="public" returntype="any" hint="PlaceHolder Replacer for strings containing ${} patterns" output="false" >
    <!---************************************************************************************************ --->
    <cfargument name="str"    required="true" type="any" hint="The string variable to look for replacements">
    <cfargument name="settings" required="true" type="any" hint="The structure of settings to use in replacing">
    <!---************************************************************************************************ --->
    <cfscript>
      var returnString = arguments.str;
      var regex = "\$\{([0-9a-z\-\.\,\!\? \_\'\(\)}]+)\}";
      var lookup = 0;
      var varName = 0;
      var varValue = 0;
      /* Loop and Replace */
      while(true){
        var defaultVal = "";
        /* Search For Pattern */
        lookup = reFindNocase(regex,returnString,1,true);
        /* Found? */
        if( lookup.pos[1] ){
          /* Get Variable Name From Pattern */
          varName = mid(returnString,lookup.pos[2],lookup.len[2]);
          if (ListLen(varName,",") gte 2) {
            defaultVal =  ListGetAt(varName,2,",");
            varName = ListGetAt(varName,1,",");
          }
          /* Lookup Value */
          if( structKeyExists(arguments.settings,varname) ){
            varValue = arguments.settings[varname];
          } else if (ListLen(varname,"_") gte 2) {
            varValue = doEval(ListLast(varname,"_"),settings);
          } else if (isDefined("arguments.settings.#varName#") ){
            varValue = Evaluate("arguments.settings.#varName#");
          }
          else{
            varValue = "#defaultVal#";
          }
          /* Remove PlaceHolder Entirely */
          returnString = removeChars(returnString, lookup.pos[1], lookup.len[1]);
          /* Insert Var Value */
          returnString = insert(varValue, returnString, lookup.pos[1]-1);
        }
        else{
          break;
        }
      }
      /* Return Parsed String. */
      return returnString;
    </cfscript>
  </cffunction>

</cfcomponent>