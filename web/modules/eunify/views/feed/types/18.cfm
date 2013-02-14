  <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset company = getModel("eunify.CompanyService").getCompany(contact.company_id)>
  <cfset wiki = getModel("wiki").getWikiPage(args.data.targetID[currentRow])>
<cfoutput>
<a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a> from (
<a href="#bl('company.index','id=#company.id#')#">#company.known_as#</a>) created the wiki item
<a href="#bl('wiki.page','id=#wiki.getid()#')#">#wiki.gettitle()#</a>
</cfoutput>