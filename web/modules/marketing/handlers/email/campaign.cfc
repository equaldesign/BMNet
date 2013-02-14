<cfcomponent>
  <cfproperty name="campaignService" inject="id:marketing.CampaignService" >
  <cfproperty name="groups" inject="id:eunify.GroupsService">
  <cfproperty name="contact" inject="id:eunify.ContactService">

  <cffunction name="list" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.campaigns = CampaignService.list()>
  </cffunction>
  <cffunction name="detail">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.contactList = groups.getContactsRemote()>
    <cfset rc.groupList = groups.fullGroupList(request.siteID)>
    <cfset rc.campaign = CampaignService.getCampaign(rc.id)>

    <cfset rc.prequeries = CampaignService.listQueries()>
    <cfset rc.template = campaignService.getTemplate(rc.campaign.templateID)>
  </cffunction>
  <cffunction name="view">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.contactList = groups.getContactsRemote()>
    <cfset rc.groupList = groups.fullGroupList(request.siteID)>
    <cfset rc.campaign = CampaignService.getCampaign(rc.id)>

    <cfset rc.prequeries = CampaignService.listQueries()>
    <cfset rc.template = campaignService.getTemplate(rc.campaign.templateID)>
    <cfset event.setView("email/campaign/panel/#rc.view#")>
  </cffunction>


  <cffunction name="edit">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id","")>
    <cfset rc.scheduled = event.getValue("scheduled",false)>
    <cfset rc.campaign = CampaignService.save(rc.id,rc.name,rc.subject,rc.fromname,rc.fromEmail,rc.scheduled,rc.scheduleTime,rc.scheduleHour,rc.scheduleMinute)>
    <cfset setNextEvent(uri="/marketing/email/campaign/detail/id/#rc.campaign#")>
  </cffunction>

  <cffunction name="recipients">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfscript>
      rc.id = event.getValue("id",0);
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.categoryID = event.getValue("categoryID",0);
      rc.sortColumn = event.getValue("iSortCol_0",0);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.recipients = CampaignService.getRecipients(rc.id,rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery);
      rc.recipientCount = CampaignService.getRecipientCount(rc.id,rc.searchQuery);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.recipientCount;
      rc.json["iTotalDisplayRecords"] = rc.recipientCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.recipients">
      <cfset thisRow = [
        "#name#",
        "#known_as#",
        '<input type="hidden" name="recipient" value="#id#" /><button  data-type="group" data-id="#id#" class="btn btn-small btn-sucess removeobject"><i class="icon-delete"></i>']>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>


  <cffunction name="dryRun" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset campaignService.dryRun(rc.campaignID)>
    <cfset event.setView("email/campaign/drysend")>
  </cffunction>

  <cffunction name="send" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset campaignService.send(rc.campaignID)>
    <cfset event.setView("email/campaign/sent")>
  </cffunction>

  <cffunction name="track" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cftry>
      <cfset remoteAdd = GetHttpRequestData().headers['X-Forwarded-For']>
    <cfcatch type="any">
      <cfset remoteAdd = cgi.REMOTE_ADDR>
    </cfcatch>
    </cftry>
    <cfset campaignService.track(rc.cmnpn,rc.ct,remoteAdd,"read","")>

    <cfset event.norender()>
  </cffunction>

  <cffunction name="clickthrough" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.cmnpn = event.getValue("cmnpn",0)>
    <cfset rc.ct = event.getValue("ct",0)> 
    <cfset rc.u = event.getValue("u",0)> 
    <cftry>
      <cfset remoteAdd = GetHttpRequestData().headers['X-Forwarded-For']>
    <cfcatch type="any">
      <cfset remoteAdd = cgi.REMOTE_ADDR>
    </cfcatch>
    </cftry>    
    <cfset campaignService.track(rc.cmnpn,rc.ct,remoteAdd,"click","#rc.u#")>
    <cfset setNextEvent(uri="#rc.u#")>
  </cffunction>

</cfcomponent>