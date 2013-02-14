<!--- NEW COMMENT --->
 <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(contact.company_id)>
  <cfset comment = getModel("eunify.CommentService").getComment(args.data.targetID[currentRow])>
<cfoutput>
<activityDetails>
  <ownerID>#contact.id#</ownerID>
  <objectID>#createUUID()#</objectID>
  <applicationID>#args.data.actionID[currentRow]#</applicationID>
  <templateID>#args.data.actionID[currentRow]#</templateID>
  <publishDate>#DateFormat(args.data.tstamp[currentRow],'YYYY-MM-DD')#T#TimeFormat(args.data.tstamp[currentRow],"HH:MM:SS")#</publishDate>
  <templateVariables>
    <templateVariable type="publisherVariable">
      <name>Publisher</name>
      <id>#contact.id#</id>
      <nameHint>#contact.first_Name# #contact.surname#</nameHint>
      <profileUrl>http://www.buildersmerchant.net/eunify/contact/index/id/#contact.id#</profileUrl>
    </templateVariable>
    <templateVariable type="textVariable">
      <name>commentText</name>
      <value>#xmlFormat(args.data.message[currentRow])#</value>
    </templateVariable>
  </templateVariables>
</activityDetails>
</cfoutput>