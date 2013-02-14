<cfcomponent>
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="groupService" inject="id:eunify.GroupsService" />

  <cfproperty name="Renderer" inject="coldbox:plugin:Renderer">
  <cfproperty name="Utilities" inject="coldbox:plugin:Utilities">
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">

  <cffunction name="pieoverview" returntype="struct">
    <cfargument name="id">
    <cfset var returnArray = []>
    <cfset s = {}>
    <cfset s["name"] = "Interactions">
    <cfset s["data"] = []>
    <cfset s["type"] = "pie">
    <cfquery name="allData" datasource="#dsn.getName()#">
        select
          (select count(*) from emailCampaignRecipientActivity where
          activity = 'click' and campaignID = emailCampaign.id) as emailclicks,
          (select count(*) from emailCampaignRecipientActivity where
          activity = 'read' and campaignID = emailCampaign.id) as emailreads,
          (select count(*) from emailCampaignRecipientActivity where
          activity = 'bounce' and campaignID = emailCampaign.id) as emailbounces,
          (select count(*) from emailCampaignRecipientActivity where
          activity = 'unsubscribe' and campaignID = emailCampaign.id) as emailunsubsribes,
          (select count(*) from emailCampaignRecipient where campaignID = emailCampaign.id) as emailssent,
          emailCampaign.*
        from
          emailCampaign
        WHERE
          emailCampaign.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfset s["emailssent"] = allData.emailssent>
    <cfset clicks = {}>
    <cfset clicks["name"] = "Clicks">
    <cfset clicks["y"] = allData.emailclicks>
    <cfset clicks["sliced"] = true>
    <cfset clicks["selected"] = true>
    <cfset ArrayAppend(s.data,["Emails Read",allData.emailreads])>
    <cfset ArrayAppend(s.data,clicks)>
    <cfset ArrayAppend(s.data,["Bounced Emails",allData.emailbounces])>
    <cfset ArrayAppend(s.data,["Unsubscribes",allData.emailunsubsribes])>
    <cfreturn s>
  </cffunction>

  <cffunction name="overview" returntype="array">
    <cfargument name="id">
    <cfset var returnArray = []>
    <!--- get the clicks --->
    <cfset clicks = {}>
    <cfset clicks["name"] = "Click throughs">
    <cfset clicks["data"] = []>
    <cfset clicks["marker"] = {}>
    <cfset clicks["marker"]["enabled"] = true>
    <cfset clicks["marker"]["radius"] = 3>
    <cfset clicks["shadow"] = true>
    <cfquery name="allData" datasource="#dsn.getName()#">
        select count(*) as actclicks,
        UNIX_TIMESTAMP(tstamp)*1000 as epochdate
        from
        emailCampaignRecipientActivity
        where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        activity = <cfqueryparam cfsqltype="cf_sql_varchar" value="click">

        group by epochdate
    </cfquery>
    <cfif allData.recordCount neq 0>
      <cfset clicks["dataGrouping"] = {}>
      <cfset clicks["dataGrouping"]["forced"] = true>
      <cfset clicks["dataGrouping"]["units"] = [['day',[1]]]>
      <cfset clicks["dataGrouping"]["approximation"] = "sum">
    </cfif>
    <cfloop query="allData">
      <cfset ArrayAppend(clicks.data,[epochdate,actclicks])>
    </cfloop>
    <!--- get the reads --->
    <cfset reads = {}>
    <cfset reads["name"] = "Email Reads">
    <cfset reads["data"] = []>
    <cfset reads["marker"] = {}>
    <cfset reads["marker"]["enabled"] = true>
    <cfset reads["marker"]["radius"] = 3>
    <cfset reads["shadow"] = true>
    <cfquery name="allData" datasource="#dsn.getName()#">
        select count(*) as actreads,

        UNIX_TIMESTAMP(tstamp)*1000 as epochdate
        from
        emailCampaignRecipientActivity
        where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        activity = <cfqueryparam cfsqltype="cf_sql_varchar" value="read">

        group by epochdate
    </cfquery>
    <cfif allData.recordCount neq 0>
      <cfset reads["dataGrouping"] = {}>
      <cfset reads["dataGrouping"]["forced"] = true>
      <cfset reads["dataGrouping"]["units"] = [['day',[1]]]>
      <cfset reads["dataGrouping"]["approximation"] = "sum">
    </cfif>
    <cfloop query="allData">
      <cfset ArrayAppend(reads.data,[epochdate,actreads])>
    </cfloop>
    <!--- get the bounces --->
    <cfset bounces = {}>
    <cfset bounces["name"] = "Bounces">
    <cfset bounces["data"] = []>
    <cfset bounces["marker"] = {}>
    <cfset bounces["marker"]["enabled"] = true>
    <cfset bounces["marker"]["radius"] = 3>
    <cfset bounces["shadow"] = true>
    <cfquery name="allData" datasource="#dsn.getName()#">
        select count(*) as actbounces,
        UNIX_TIMESTAMP(tstamp)*1000 as epochdate
        from
        emailCampaignRecipientActivity
        where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        activity = <cfqueryparam cfsqltype="cf_sql_varchar" value="bounce">

        group by epochdate
    </cfquery>
    <cfif allData.recordCount neq 0>
      <cfset bounces["dataGrouping"] = {}>
      <cfset bounces["dataGrouping"]["forced"] = true>
      <cfset bounces["dataGrouping"]["units"] = [['day',[1]]]>
      <cfset bounces["dataGrouping"]["approximation"] = "sum">
    </cfif>
    <cfloop query="allData">
      <cfset ArrayAppend(bounces.data,[epochdate,actbounces])>
    </cfloop>
     <!--- get the unsubscribes --->
    <cfset unsubscribes = {}>
    <cfset unsubscribes["name"] = "Unsubscribes">
    <cfset unsubscribes["data"] = []>
    <cfset unsubscribes["marker"] = {}>
    <cfset unsubscribes["marker"]["enabled"] = true>
    <cfset unsubscribes["marker"]["radius"] = 3>
    <cfset unsubscribes["shadow"] = true>
    <cfquery name="allData" datasource="#dsn.getName()#">
        select count(*) as actunsubscribes,
        UNIX_TIMESTAMP(tstamp)*1000 as epochdate
        from
        emailCampaignRecipientActivity
        where campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        activity = <cfqueryparam cfsqltype="cf_sql_varchar" value="unsubscribe">

        group by epochdate
    </cfquery>
    <cfif allData.recordCount neq 0>
      <cfset unsubscribes["dataGrouping"] = {}>
      <cfset unsubscribes["dataGrouping"]["forced"] = true>
      <cfset unsubscribes["dataGrouping"]["units"] = [['day',[1]]]>
      <cfset unsubscribes["dataGrouping"]["approximation"] = "sum">
    </cfif>
    <cfloop query="allData">
      <cfset ArrayAppend(unsubscribes.data,[epochdate,actunsubscribes])>
    </cfloop>


    <cfset ArrayAppend(returnArray,clicks)>
    <cfset ArrayAppend(returnArray,reads)>
    <cfset ArrayAppend(returnArray,bounces)>
    <cfset ArrayAppend(returnArray,unsubscribes)>

    <cfreturn returnArray>
  </cffunction>

  <cffunction name="responsesBy" returntype="query">
    <cfargument name="campaignID" required="true" default="0">
    <cfargument name="contactID" required="true" default="0">
    <cfargument name="companyID" required="true" default="0">
    <cfquery name="responses" datasource="#dsn.getName()#">
      select
        count(*) as actions,
        campaign.id as campaignID,
        campaign.name,
        campaign.dateSent,
        response.activity,
        response.activitymeta,
        response.city,
        response.tstamp as responsedate,
        company.name as companyName,
        company.id as companyID,
        contact.first_name,
        contact.surname,
        contact.id as contactID
      from
        emailCampaign as campaign,
        emailCampaignRecipientActivity as response,
        <cfif companyID eq 0>
        contact LEFT JOIN company on company.id = contact.company_id
        <cfelse>
        contact,
        company
        </cfif>
      WHERE
        campaign.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
          <cfif campaignID neq 0>
            AND
            campaign.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
            AND
            response.campaignID = campaign.id
          </cfif>
          <cfif contactID neq 0>
            AND
            response.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
            AND
            campaign.id = response.campaignID
          </cfif>
          <cfif companyID neq 0>
            AND
            company.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.companyID#">
            AND
            contact.company_id = company.id
            AND
            response.contactID = contact.id
            AND
            campaign.id = response.campaignID
          </cfif>
        group by activity,campaignID,contactID
        order by responsedate desc
    </cfquery>
    <cfreturn responses>
  </cffunction>

  <cffunction name="cCount" returntype="numeric">
    <cfargument name="searchQuery">
    <cfargument name="campaignID">
    <cfargument name="type">
    <cfquery name="r" datasource="#dsn.getName()#">
      select
        count(*) as records
      from
        <cfif arguments.type neq "">emailCampaignRecipientActivity<cfelse>emailCampaignRecipient</cfif>,
        contact left join company on company.id = contact.company_id
      where
        <cfif arguments.type eq "">
        emailCampaignRecipient.campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND

        contact.id = emailCampaignRecipient.contactID
        <cfelse>
        emailCampaignRecipientActivity.campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND
        emailCampaignRecipientActivity.activity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
        AND
        contact.id = emailCampaignRecipientActivity.contactID
        </cfif>
        <cfif arguments.searchQuery neq "">
          AND
          (
            activitymeta LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            OR
            contact.first_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            OR
            contact.surname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            OR
            company.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
          )
        </cfif>
    </cfquery>
    <cfreturn r.records>
  </cffunction>

  <cffunction name="list" returntype="struct">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfargument name="campaignID">
    <cfargument name="type">
    <cfset var columnArray = ["contactID","companyID","name","companyName","tstamp","ipaddress","activitymeta"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfquery name="r" datasource="#dsn.getName()#">
      select
        contact.id as contactID,
        company.id as companyID,
        CONCAT(contact.first_name," ",contact.surname) as name,
        company.name as companyName,
        contact.email,
        tstamp
        <cfif arguments.type neq "" AND arguments.type neq "bounce" AND arguments.type neq "unsubscibe">,
          ipaddress
          <cfif arguments.type eq "click">,
            activitymeta
          </cfif>
        </cfif>
      from
        <cfif arguments.type eq "">
           emailCampaignRecipient,
        <cfelse>
          emailCampaignRecipientActivity,
        </cfif>

        contact left join company on company.id = contact.company_id
      where
        <cfif arguments.type neq "">
        emailCampaignRecipientActivity.campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND
        emailCampaignRecipientActivity.activity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.type#">
        AND
        contact.id = emailCampaignRecipientActivity.contactID
        <cfelse>
        emailCampaignRecipient.campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND
        contact.id = emailCampaignRecipient.contactID
        </cfif>
        <cfif arguments.searchQuery neq "">
        AND
          (
            activitymeta LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            OR
            contact.first_name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            OR
            contact.surname LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            OR
            company.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
          <cfif arguments.type neq "bounce" AND arguments.type neq "unsubscibe">
            <cfif arguments.type neq "">
            OR
            ipaddress LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            </cfif>
            <cfif arguments.type eq "click">
            OR
            activitymeta LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
            </cfif>
          </cfif>
          )
        </cfif>
        order by #sortColName# #arguments.sortDir#
        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>
    <cfreturn dataTables(r)>
  </cffunction>

  <cffunction name="listMap" returntype="array">
    <cfargument name="campaignID">
    <cfargument name="type">
    <cfquery name="r" datasource="#dsn.getName()#">
      select
        contact.id as contactID,
        company.id as companyID,
        CONCAT(contact.first_name," ",contact.surname) as name,
        company.name as companyName,
        contact.email as emailaddress,
        tstamp,
        ipaddress,
        activitymeta,
        emailCampaignRecipientActivity.activity,
        emailCampaignRecipientActivity.latitude,
        emailCampaignRecipientActivity.longitude,
        emailCampaignRecipientActivity.city,
        emailCampaignRecipientActivity.country
      from
        emailCampaignRecipientActivity,
        contact left join company on company.id = contact.company_id
      where
        emailCampaignRecipientActivity.campaignID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.campaignID#">
        AND
        contact.id = emailCampaignRecipientActivity.contactID
    </cfquery>
    <cfset var returnObject = []>
    <cfloop query="r">
      <cfset thisStruct = {}>
      <cfset thisStruct["id"] = contactID>
      <cfset thisStruct["title"] = "#name#">
      <cfset thisStruct["activity"] = "#activity#">
      <cfset thisStruct["icon"] = "#activity#icon">
      <cfsavecontent variable="html">
          <cfoutput>
              <img width="40" class="thumbnail gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(emailaddress)))#?size=40&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
              <h4>#emailaddress#</h4>
              <p><i class="icon-pushpin"></i>#city#,#country#</p>
              <p><i class="icon-time"></i>#DateFormat(tstamp,"DD/MM")# @ #TimeFormat(tstamp,"HH:MM")#</p>
              <cfif activitymeta neq "">
                <p><i class="icon-link"></i>#activitymeta#</p>
              </cfif>
          </cfoutput>
      </cfsavecontent>
      <cfset thisStruct["html"] = "#html#">
      <cfset thisStruct["latitude"] = latitude>
      <cfset thisStruct["longitude"] = longitude>
      <cfset ArrayAppend(returnObject,thisStruct)>
    </cfloop>
    <cfreturn returnObject>
  </cffunction>

  <cffunction name="dataTables">
  <cfargument name="query">
  <cfset var returnObject = {}>
  <cfset returnObject["aaData"] = ArrayNew(1)>
  <cfset returnObject["aoColumns"] = ArrayNew(1)>
  <cfset var counter = 1>
  <cfloop list="#query.getColumnlist(true)#" index="col">
    <cfset colOb = {}>
    <cfset colOb["sTitle"] = col>
    <cfif counter lt 3>
      <cfset colOb["bVisible"] = false>
      <cfset colOb["bSearchable"] = false>
    </cfif>
    <cfset ArrayAppend(returnObject.aoColumns,colOb)>
    <cfset counter++>
  </cfloop>
  <cfloop query="arguments.query">
    <cfset var colArr = []>
    <cfloop list="#query.getColumnlist(true)#" index="col">
      <cfif isNumeric(arguments.query[col][currentRow])>
        <cfset theVal = NumberFormat(arguments.query[col][currentRow],"99999.00")>
      <cfelse>
        <cfset theVal = arguments.query[col][currentRow]>
      </cfif>
      <cfset arrayAppend(colArr,"#theVal#")>
    </cfloop>
    <cfset arrayAppend(returnObject["aaData"],colArr)>
  </cfloop>
  <cfreturn returnObject>
</cffunction>
</cfcomponent>