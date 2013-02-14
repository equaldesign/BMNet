<cfoutput>
  <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(args.data.relatedID[currentRow],request.siteID)>
  <cfset psa = getModel("eunify.PSAService").getPSA(args.data.targetID[currentRow])>
  <a href="/contact/index/id/#args.data.sourceID[currentRow]#">#contact.first_name# #contact.surname#</a> from (<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) entered figures against <a href="#bl('psa.index','psaid=#psa.id#')#">#psa.name#</a>
</cfoutput>