<cfoutput>
 <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(args.data.relatedID[currentRow],request.siteID)>
  <cfset calendar = getModel("eunify.CalendarService").getAppointment(args.data.targetID[currentRow])>
  <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
  from
  (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>)
  will be attending the <a href="#bl('calendar.detail','id=#calendar.id#')#">#calendar.name#</a>
  scheduled for #DateFormatOrdinal('#calendar.startDate#',"DDDD DD MMMM YY")#</cfoutput>