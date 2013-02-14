<cfif not isDefined("rc.requestData.page.links")>
<cfset rc.linkData = getModel("sums.PageService").proxy(
    proxyurl="sums/page/homepage?alf_ticket=#request.buildingVine.admin_ticket#&siteID=#rc.siteID#",
    formCollection=form,
    method="get",
    JSONRequest="false",
    siteID = rc.siteID,
    jsonData = getHttpRequestData().content,
    alf_ticket=request.buildingVine.admin_ticket
  )>

<ul id="mainLinks" class="nav nav-list">
  <cfoutput>
    <cfloop array="#rc.linkData.page.links#" index="lnk">
      <li class="#IIF('/html/#rc.linkData.page.name#' eq lnk.linkURL,'"active"','""')#"><a href="#lnk.linkURL#" target="#lnk.linkTarget#" class="navigation inactive nochildren">
        #lnk.name#</a></li>
    </cfloop>
  </cfoutput>
</ul>

<cfelse>
<ul id="mainLinks" class="nav nav-list">
  <cfoutput>
    <cfif isDefined("rc.requestData.page.links")>
    <cfloop array="#rc.requestData.page.links#" index="lnk">
      <li class="#IIF('/html/#rc.requestData.page.name#' eq lnk.linkURL,'"active"','""')#"><a href="#lnk.linkURL#" target="#lnk.linkTarget#" class="navigation inactive nochildren">
        <i class="icon-chevron-right"></i>
        #lnk.name#</a></li>
    </cfloop>
    </cfif>
  </cfoutput>
</ul>


</cfif>