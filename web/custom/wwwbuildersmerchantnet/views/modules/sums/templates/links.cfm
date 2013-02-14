<cfif isDefined("rc.requestData.page.nodeRef")>
<cfset rc.linkData = getModel("PageService").proxy(
    proxyurl="sums/linktree?pageNodeRef=#rc.requestData.page.nodeRef#&alf_ticket=#request.buildingVine.admin_ticket#&siteID=#rc.siteID#",
    formCollection=form,
    method="get",
    JSONRequest="false",
    siteID = rc.siteID,
    jsonData = getHttpRequestData().content,
    alf_ticket=request.buildingVine.admin_ticket
  )>
  <cfoutput>#createLinks(rc.linkData)#</cfoutput>
</cfif>
<cffunction name="createLinks" output="true">
  <cfargument name="d">
  <cfargument name="top" default="true" required="true">
  <cfif ArrayLen(d.links) neq 0>
    <cfif arguments.top>
      <ul id="mainLinks" class="nav nav-list">
    <cfelse>
      <ul class="nav nav-list">
    </cfif>
      <cfloop array="#d.links#" index="lnk">
        <li class="#IIF('/html/#rc.requestData.page.name#' eq lnk.linkURL,'"active"','""')#">
          <a href="#lnk.linkURL#" target="#lnk.linkTarget#" class="navigation">
            <i class="icon-chevron-right"></i>
            #lnk.linkName#
          </a>
          <cfif ArrayLen(lnk.children) neq 0>
            <cfoutput>#createLinks(lnk.children[1],false)#</cfoutput>
          </cfif>
        </li>
      </cfloop>
      </ul>
  </cfif>
</cffunction>