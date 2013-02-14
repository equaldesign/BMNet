<cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
<cfset company = getModel("eunify.CompanyService").getCompany(contact.companyID)>
<cfset meeting = getModel("eunify.CalendarService").getAppointment(args.data.targetID[currentRow])>
<cfif meeting.recordCount neq 0>
<cfoutput>
<a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
from (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) edited the meeting
<a href="#bl('calendar.detail','id=#meeting.id#')#">#meeting.name#</a></cfoutput>
</cfif>