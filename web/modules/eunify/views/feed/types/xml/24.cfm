<!--- EMAIL ARCHIVE --->
<cfset user = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
<cfset usercompany = getModel("eunify.CompanyService").getCompany(user.company_id)>
<cfset contact = getModel("eunify.ContactService").getContact(args.data.targetID[currentRow])>
<cfset emailOb = getModel("eunify.EmailService").getEmail(args.data.relatedID[currentRow])>

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
      <name>EmailSubject</name>
      <text>#xmlFormat(emailOb.subject)#</text>
      <value>http://www.buildersmerchant.net/eunify/email/detail/id/#args.data.relatedID[currentRow]#</value>
    </templateVariable>
  </templateVariables>
</activityDetails>
</cfoutput>