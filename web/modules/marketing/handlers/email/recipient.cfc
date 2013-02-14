<cfcomponent>
  <cfproperty name="campaignService" inject="id:marketing.CampaignService">
  <cfproperty name="FeedService" inject="id:eunify.FeedService">
  <cfproperty name="TagService" inject="id:eunify.TagService">
  <cfproperty name="groups" inject="id:eunify.GroupsService">
  <cfproperty name="contact" inject="id:eunify.ContactService">

  <cffunction name="list">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("campaignID",0)> 
    <cfset rc.maxRows = event.getValue("iDisplayLength",25)>
    <cfset rc.startRow = event.getValue("iDisplayStart",0)>
    <cfset rc.recipientCount = CampaignService.getRecipientCount(rc.id)>
    <cfset rc.recipients = CampaignService.getRecipients(rc.id,rc.startRow,rc.maxRows)>
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
        '<input type="hidden" name="recipient" value="#id#" /><button data-id="#id#" class="btn btn-small btn-sucess removeobject"><i class="icon-delete"></i>']>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>
  <cffunction name="add">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.recipients = CampaignService.addRecipient(rc.campaignID,rc.type,rc.id)>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="mailingList">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.email = event.getValue("email","")>
    <cfset rc.name = event.getValue("name")>
    <cfset rc.contactID = CampaignService.addSubscriber(0,rc.email,rc.name)>
    <cfset TagService.add("Mailing List","contact",rc.contactID)>
    <cfset event.setView("email/recipient/subscribe")>
  </cffunction>

  <cffunction name="addQuery">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.recipients = CampaignService.addQueryRecipient(rc.campaignID,rc.queryID)>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="remove">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset CampaignService.removeRecipient(rc.campaignID,rc.id)>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="t">
    <cfdump var="#groups.getRecursiveChildrenContacts(5)#"><cfabort>
  </cffunction>

  <cffunction name="unsubscribe">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
  </cffunction>

  <cffunction name="changed"> 
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
  </cffunction>

  <cffunction name="doUnsubscribe">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.reason = event.getValue("reason")>
    <cfset rc.removeFrom = event.getValue("removeFrom")>
    <cfset rc.contactID = urlDecrypt(event.getValue("userID"))>
    <cfset rc.campaignID = urlDecrypt(event.getValue("cID"))>
    <cfif rc.removeFrom eq "all">
      <cfset contact.unsubscribe(rc.contactID)>
    </cfif>
    <cfset FeedService.createFeedItem(
      so="contact",
      soID = rc.contactID,
      to="company",
      toID = contact.getContact(rc.contactID).company_id,
      ro="emailCampaign",
      roID=rc.campaignID,
      action="unsubscribe",
      message="#removeFrom# : #reason#"
    )>
  </cffunction>

  <cffunction name="query">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.maxRows = event.getValue("iDisplayLength",25)>
    <cfset rc.startRow = event.getValue("iDisplayStart",0)>
    <cfset rc.recipients = CampaignService.getQuery(rc.id,rc.startRow,rc.maxRows)>
    <cfset rc.recipientCount = CampaignService.getQueryCount(rc.id)>
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
        '<input type="hidden" name="recipient" value="#id#" /><button data-type="contact" data-id="#id#" class="btn btn-small btn-sucess addobject"><i class="icon-tick-circle-frame"></i></button>']>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>
</cfcomponent>