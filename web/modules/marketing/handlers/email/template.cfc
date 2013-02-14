<cfcomponent>
  <cfproperty name="campaignService" inject="id:marketing.CampaignService" >

  <cffunction name="getTemplate">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("templateID",0)>
    <cfset args = {}>
    <cfset args.campaignID = rc.campaignID>
    <cfset args.contactID = event.getValue("contactID",request.bmnet.contactID)>
    <cfset args.emailBody = campaignService.getMailBody(rc.campaignID,args.contactID)>
    <cfset rc.layout = campaignService.getTemplate(rc.id)>
    <cfif args.contactID eq request.bmnet.contactID>
      <cfset args.tracker = false>  
    <cfelse>
      <cfset args.tracker = true>
    </cfif>
    
    <cfset event.renderData(data=RenderLayout(layout="email/#rc.layout.name#_#rc.layout.siteID#",args=args),type="html")>
  </cffunction>
  <cffunction name="setContent">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset campaignService.setEmailBody(rc.campaignID,rc.emailBody)>
    <cfset setNextEvent(uri="/marketing/email/campaign/detail?id=#rc.campaignID#")>
  </cffunction>
</cfcomponent>