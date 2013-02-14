<cfoutput>
<cfif StructKeyExists(rc.companies,"companies")>
<div class="clearfix">
#getMyPlugin(plugin="Paging").renderit(rc.companies.companies,"/bv/company/ajaxList?letter=#rc.letter#&type=#rc.type#&page=@page@","ajax")#
Showing #rc.companies.startRow# to #rc.companies.endRow# of #rc.companies.companies#
</div>
<cfloop array="#rc.companies.results#" index="company">
  <div class="companyList">
    <a rev="whiteBox" href="/bv/company/detail?nodeRef=#company.nodeRef#" class="ajax maxWindow">
    <cfif company.bvSiteID neq "">
    <cfset cImage = paramImage("companies/#lcase(company.bvSiteID)#/small.jpg","/bv/companies/generic_large.jpg")>
    <img src="/bv/includes/images/#cImage#" width="25" height="25" class="glow">
    </cfif>
      #company.name#</a>
  </div>
</cfloop>
</cfif>
</cfoutput>