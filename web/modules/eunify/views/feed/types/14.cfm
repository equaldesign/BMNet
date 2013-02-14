
<cfoutput>
  <cfset contact = getModel("eunify.ContactService").getContact(args.data.sourceID[currentRow])>
  <cfset blog = getModel("eunify.BlogService")>
  <cfset blogPost = blog.getBlogPost(args.data.relatedID[currentRow])>
  <cfset arrangement = getModel("eunify.PSAService")>
  <cfset arrangementQ = arrangement.getArrangement(blogPost.relatedID)>
  <cfset company = getModel("eunify.CompanyService").getCompany(arrangementQ.company_id)>
  <h3>#blogPost.title#</h3>
  <p>#paragraphFormat2(blogPost.body)#</p>
  <p class="newsSummary">Posted by <a href="#bl('contact.index','id=#contact.id#')#">#contact.first_name# #contact.surname#</a>
  in reference to the Agreement <a href="#bl('psa.index','psaid=#arrangementQ.id#')#">#arrangementQ.name#</a> with
  <a href="#bl('company.index','id=#company.ID#')#">#company.name#</a></p>
</cfoutput>
