<cfoutput>
  <cfloop array="#rc.companies.items#" index="company">
    <div>
      <a href="/bv/company/detail?nodeRef=#company.noderef#" class="ajax maxWindow">
      <cfif company.bvSiteID neq "">
        <img class="left" src="/includes/images/companies/#company.bvsiteID#/small.jpg" width="50" height="50">
      </cfif>
      <h5>#company.name#</h5>
      </a>
    </div>
  </cfloop>
<cfdump var="#rc.companies#">
</cfoutput>