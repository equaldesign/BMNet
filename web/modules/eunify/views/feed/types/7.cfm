  <cfset foundRelationShip = false>
  <cfset relatedWord = "">
  <cfset relatedHREF = "">
  <cfset relatedLinkBody = "">
  <cfset documentID = args.data.relatedID[currentRow]>
  <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(contact.company_id)>
  <cfset company = getModel("eunify.CompanyService").getCompany(args.data.targetID[currentRow])>
  <cfoutput>
  <cfset dms = getModel("eunify.DocumentService")>
  <cfset document = dms.getDocument(documentID)>
  <cfif document.categoryID neq "">
    <cfset category = dms.getCategory(document.categoryID)>
    <cfset agreementQ = dms.getParentsUntil(document.categoryID,"","deal")>
    <cfif NOT isQuery(agreementQ)>
    <a href="#bl('contact.index','id=[source.id]')#">#contact.first_name# #contact.surname#</a> from (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) uploaded a document (but it looks as though it's been deleted)
    <cfelse>
      <cfif fileExists("#rc.app.appRoot#dms/documents/thumbnails/#documentID#_small.jpg")>
         <a href="/documents/detail/id/#documentID#"><img align="left"  border="0" width="45" src="/includes/images/thumbnails/#getSetting('siteName')#/#documentID#_small.jpg" rel="#getSetting('siteName')#_#documentID#" class="docTip priceListFile glow" /></a>
      </cfif>
      <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a> from
        (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) uploaded the document
        <a href="/documents/detail/id/#documentID#">#document.name#</a> which is related to the
      <cfif agreementQ.recordCount neq 0>
        <!--- it's related to an agreement - so let's get that --->
        <cfset psa = getModel("eunify.PSAService").getArrangementAndSupplier(agreementQ.relatedID)>
        <cfset foundRelationship = true>
        agreement <a href="/psa/index/psaid/#psa.id#">#psa.name#</a> (<a href="/company/index/id/#psa.company_id#">#psa.known_as#</a>)
      <cfelse>
        <!--- is it related to a company? --->
        <cfset company = dms.getParentsUntil(document.categoryID,"","company")>
        <cfif company.recordCount neq 0>
          <!--- it's related to a company --->
          <cfset companyO = getModel("eunify.CompanyService").getCompany(company.relatedID)>
          company <a href="/company/index/id/#companyO.getid()#">#companyO.getknown_as()#</a>
          <cfset foundRelationship = true>
        <cfelse>
          <!--- is it related to an appointment? --->
          <cfset appointment = dms.getParentsUntil(document.categoryID,"","appointment")>
          <cfif appointment.recordCount neq 0>
             <cfset appointmentO =  getModel("eunify.CalendarService").getAppointment(appointment.relatedID)>
             <!--- it's related to an appointment --->
              event <a href="/appointment/detail/id/#appointmentO.id#">#appointmentO.name#</a> (on #DateFormat(appointmentO.startDate,"DD/MM/YYYY")# at #TimeFormat(appointmentO.startDate,"HH:MM")#)
             <cfset foundRelationship = true>
          </cfif>
        </cfif>
      </cfif>
    </cfif>
  <cfelse>
  <a href="#bl('contact.index','id=[source.id]')#">#contact.first_name# #contact.surname#</a> from (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) uploaded a document (but it looks as though it's been deleted)
  </cfif>
  </cfoutput>
<br class="clear" />
