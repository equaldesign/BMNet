<h2>Search Results</h2>
<cfoutput>
<div class="searchResultSummary">
  #ArrayLen(rc.contacts.items)# results were found for your search <span class="red">#rc.query#</span>
</div>

<cfloop array="#rc.contacts.items#" index="contact">
<div>
  <h5>
      <a class="maxWindow ajax" href="/bv/contact?noderef=#contact.noderef#">#contact.firstName# #contact.lastName#</a>
      <span class="small">(<cfif ArrayLen(contact.companies) gte 1><a href="/bv/company/detail?nodeRef=#contact.companies[1].nodeRef#">#contact.companies[1].name#</a></cfif>)</span>
  </h5>
</div>
</cfloop>
</cfoutput>