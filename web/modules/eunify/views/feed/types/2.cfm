<cfoutput>
  <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(args.data.relatedID[currentRow],request.siteID)>
  <cfset psa = getModel("psa").getPSA(args.data.targetID[currentRow])>
  <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
  edited the agreement <a href="#bl('psa.index','psaid=#psa.id#')#">#psa.name#</a>
  (<a href="#bl('company.index','id=[related.id]')#">#company.known_as#</a>)
</cfoutput>