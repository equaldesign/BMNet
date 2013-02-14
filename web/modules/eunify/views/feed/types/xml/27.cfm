<!--- NEW WORKFLOW TASK --->
<cfset flo = getModel("flo.TaskService")>
 <cfset co = getModel("eunify.ContactService")>
 <cfset user = co.getContact(args.data.sourceID[currentRow])>
 <cfset usercompany = getModel("eunify.CompanyService").getCompany(user.company_id)>
 <cfset contact = co.getContact(args.data.targetID[currentRow])>
 <cfset floTask = flo.getActivity(args.data.relatedID[currentRow])>
 <cfset floItem = flo.getTask(floTask.itemID)>
<cfoutput>
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
      <name>WorkflowItem</name>
      <text>#xmlFormat(floItem.task.name)#</text>
      <value>http://www.buildersmerchant.net/flo/item/detail/id/#floItem.task.id#</value>
    </templateVariable>
    <templateVariable type="textVariable">
      <name>TaskDueDate</name>
      <value>#xmlFormat(DateFormat(floTask.dueDate,"DD/MM/YY"))#</value>
    </templateVariable>
    <templateVariable type="linkVariable">
      <name>WorkflowTaskName</name>
      <text>#xmlFormat(floTask.name)#</text>
      <value>http://www.buildersmerchant.net/flo/item/detail/id/#floItem.task.id#</value>
    </templateVariable>
  </templateVariables>
</activityDetails>
</cfoutput>