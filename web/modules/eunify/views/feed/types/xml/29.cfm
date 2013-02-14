<!--- email campaign read 

@ sourceID = contactID for respondent
@ targetID = contact Company
@ relatedID = campaignID

--->
<cfoutput>
 <cfset cs = getModel("marketing.CampaignService")>
 <cfset co = getModel("eunify.ContactService")>
 <cfset cm = getModel("eunify.CompanyService")>
 <cfset user = co.getContact(args.data.sourceID[currentRow])>
 <cfset usercompany = getModel("eunify.CompanyService").getCompany(user.company_id)>
 <cfset emailCampaign = cs.getCampaign(args.data.relatedID[currentRow])>
<activityDetails>
  <ownerID>#user.id#</ownerID>
  <objectID>#createUUID()#</objectID>
  <applicationID>#args.data.actionID[currentRow]#</applicationID>
  <templateID>#args.data.actionID[currentRow]#</templateID>
  <publishDate>#DateFormat(args.data.tstamp[currentRow],'YYYY-MM-DD')#T#TimeFormat(args.data.tstamp[currentRow],"HH:MM:SS")#</publishDate>
  <templateVariables>
    <templateVariable type="publisherVariable">
      <name>Publisher</name>
      <id>#contact.id#</id>
      <nameHint>#user.first_Name# #user.surname#</nameHint>
      <profileUrl>http://www.buildersmerchant.net/eunify/contact/index/id/#user.id#</profileUrl>
    </templateVariable>
    <templateVariable type="linkVariable">
      <name>emailCampaignName</name>
      <text>#xmlFormat(emailCampaign.name)#</text>
      <value>http://www.buildersmerchant.net/marketing/email/campaign/detail/id/#emailCampaign.id#</value>
    </templateVariable>    
  </templateVariables>
</activityDetails>
</cfoutput>