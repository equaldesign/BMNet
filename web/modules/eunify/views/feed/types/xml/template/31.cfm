<!--- email unsubscribe

@ sourceID = contactID for respondent
@ targetID = contact Company
@ relatedID = campaignID

--->
<cfoutput> 
<activityTemplateContainer>
  <applicationID>#args.data.actionID[currentRow]#</applicationID>
  <templateID>#args.data.actionID[currentRow]#</templateID>
  <activityTemplate>
    <type>Other</type>
    <title>{publisher:Publisher} unsubscribed (from {text:unsubscribeType}) from the campaign {link:emailCampaignName} because {text:reason}</title>
    <icon>http://www.microsoft.com/about/images/rss_button.gif</icon>
  </activityTemplate>
</activityTemplateContainer>
</cfoutput>