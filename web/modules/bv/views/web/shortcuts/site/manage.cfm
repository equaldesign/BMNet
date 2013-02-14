<cfoutput>
<ul class="nav nav-list" id="dashboardShortcuts">
  <li class="nav-header">Manage Site Users</li>
	<li><a class="shortcut manageusers" href="/site/manage">Edit Users/Groups</a></li>
	<li><a class="shortcut inviteusers" href="/site/invite">Invite new Users</a></li>
	<li><a class="shortcut existingusers" href="/site/invite?inviteType=existingUser">Invite existing Users</a></li>
	<li><a class="shortcut userlist" href="/site/fullUserList">Full User List</a></li>
	<li class="nav-header">Manage Site Details</li>
	<li><a class="shortcut sitecolour" href="/site/settings">Edit Details</a></li>
	<li><a class="shortcut sitelogo" href="/site/logo">Change Logo</a></li>
	<li class="nav-header">Order Fulfillment</li>
	<cfset siteType = paramValue("rc.buildingVine.site.customProperties.companyType.value","Merchant")> 
	<cfif siteType eq "Manufacturer" OR siteType eq "Distributor">  	  
    <li><a class="shortcut fullfilment" href="/delivery/siteoptions">Fullfilment options</a></li>
	<cfelseif siteType eq "Merchant">
		<li><a class="shortcut fullfilment" href="/delivery/overage">Fulfillment options</a></li> 
	</cfif>
	<li class="nav-header">Integration</li>
	<li><a class="shortcut siteBuyingGroups" href="/site/buyinggroups">Buying Group Integration</a></li>
</ul> 
</cfoutput>
