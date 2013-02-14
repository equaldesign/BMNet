<cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
<cfset company = getModel("eunify.CompanyService").getCompany(args.data.relatedID[currentRow],request.siteID)>
<cfset paymentInfo = getModel("eunify.PSAService").getArrangementAndSupplier(args.data.targetID[currentRow])>
<cfoutput>
<a href="#bl('contact.index','id=[source.id]')#">#contact.first_name# #contact.surname#</a>
from (<a href="#bl('company.index','id=[related.id]')#">#company.known_as#</a>) acknowledged the group received a payment from
<a href="#bl('company.index','id=#paymentInfo.company_id#')#">#paymentInfo.known_as#</a>  for the agreement <a href="#bl('psa.index','psaID=#paymentInfo.id#')#">#paymentInfo.name#</a>
</cfoutput>