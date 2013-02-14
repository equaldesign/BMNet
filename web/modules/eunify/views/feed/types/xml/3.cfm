<!--- CONTACT UPDATE --->
<cfset rc.contact = getModel("eunify.ContactService")>
<cfset rc.company = getModel("eunify.CompanyService")>
<cfset contact = rc.contact.getContact(args.data.sourceID[currentRow])>
<cfset company = rc.company.getCompany(contact.company_id)>
<cfset rcontact = rc.contact.getContact(args.data.targetID[currentRow])>
<cfset rcompany = rc.company.getCompany(rcontact.company_Id)>

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
    <templateVariable type="linkVariable">
      <name>ContactName</name>
      <text>#xmlFormat(rcontact.first_name)# #xmlFormat(rcontact.surname)#</text>
      <value>http://www.buildersmerchant.net/eunify/contact/index/id/#rcontact.id#</value>
    </templateVariable>
  </templateVariables>
</activityDetails>
</cfoutput>