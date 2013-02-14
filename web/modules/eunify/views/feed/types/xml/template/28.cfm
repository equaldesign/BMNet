<!--- NEW TASK ASSIGN --->
<cfset user = co.getContact(args.data.sourceID[currentRow])>
<cfset contact = co.getContact(args.data.targetID[currentRow])>
<cfoutput>
<activityTemplateContainer>
  <applicationID>#args.data.actionID[currentRow]#</applicationID>
  <templateID>#args.data.actionID[currentRow]#</templateID>
  <activityTemplate>
    <type>Other</type>
    <title>{publisher:Publisher} <cfif user.id neq contact.id>assigned the task<cfelse>took ownership of the task</cfif> {link:WorkflowTaskName} <cfif user.id neq contact.id>to {link:WorkflowActor}</cfif></title>
    <icon>http://www.microsoft.com/about/images/rss_button.gif</icon>
  </activityTemplate>
</activityTemplateContainer>
</cfoutput>