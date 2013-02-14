<cfset rd =   rc.requestData.page>
<cfoutput>
<ul class="nav nav-list" id="dashboardShortcuts">
	<li class="nav-header">Pages</li>	  
	<li><div class="jstree" id="pageTree" rel="#rc.siteID#"></div></li>	
	<cfif isUserLoggedIn() AND rc.siteManager>
	<li class="divider"></li>
	<li class="nav-header">Pages</li>
	<cfif isDefined("rc.requestData.page.nodeID")>
    <li><a class="shortcut new_page" href="/sums/page/#createUUID()#?template=blank&mode=edit&parentNodeRef=workspace://SpacesStore/#rc.requestData.page.nodeID#">Add new page</a>
	<cfelse>	
    <li><a class="shortcut new_page" href="/sums/page/newpage">Add new page</a></li>
	</cfif>
		<cfif isDefined("rc.requestData.page.title")>
			<cfif rc.mode eq "view">
				<li><a class="shortcut adminLink edit_page" href="/sums/page/checkout/#rc.requestData.page.name#?mode=edit">Edit page</a></li>
			</cfif>
		</cfif>	
		<cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.publish AND isDefined("rc.requestData.page.isWorkingCopy") AND rc.requestData.page.isWorkingCopy>
      <li><a href="/sums/page/checkin/a?nodeRef=#rc.requestData.page.nodeRef#" class="shortcut adminLink publish_page">Publish</a></li>
      <li><a href="/sums/page/cancelcheckout/a?nodeRef=#rc.requestData.page.nodeRef#" class="shortcut adminLink cancel_checkout">Cancel Changes</a></li>
    </cfif>
    <cfif isDefined("rc.requestData.page.checkedOut") AND rc.requestData.page.checkedOut>
      <li><a href="/sums/page/a?nodeRef=#rc.requestData.page.workingCopy.nodeRef#" class="shortcut adminLink working_copy" title="#rc.requestData.page.workingCopy.owner# has a working copy of this page">View working copy</a></li>
    </cfif>
    <cfif isDefined("rc.requestData.page.permissions") AND rc.requestData.page.permissions.edit>
      <li><a href="/sums/page/a?nodeRef=#rc.requestData.page.nodeRef#" class="shortcut adminLink delete_page" title="Delete this page">Delete</a></li>
    </cfif>
	</cfif>
</ul>
</cfoutput>
