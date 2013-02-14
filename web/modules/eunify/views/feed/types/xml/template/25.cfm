<!--- NEW WORKFLOW ITEM --->
<cfoutput>
<activityTemplateContainer>
  <applicationID>#args.data.actionID[currentRow]#</applicationID>
  <templateID>#args.data.actionID[currentRow]#</templateID>
  <activityTemplate>
    <type>Other</type>
    <title>{publisher:Publisher} created a new workflow item {link:WorkflowItem}</title>
    <icon>http://www.microsoft.com/about/images/rss_button.gif</icon>
  </activityTemplate>
</activityTemplateContainer>
</cfoutput>