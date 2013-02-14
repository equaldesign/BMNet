<!--- email campaign read 

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
    <title>{publisher:Publisher} read the campaign email {link:emailCampaignName}</title>
    <icon>http://www.microsoft.com/about/images/rss_button.gif</icon>
  </activityTemplate>
</activityTemplateContainer>
</cfoutput>