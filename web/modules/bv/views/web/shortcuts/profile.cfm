<cfoutput>
<ul class="nav nav-list" id="mainLinks">
	<cfif rc.username eq request.buildingVine.userName>
  <li class="nav-header">Your Profile</li>
  <li><a class="shortcut ajax userdetails" href="/bv/profile/edit"><i class="icon-pencil"></i> Edit Your details</a></li>
  <li><a class="shortcut ajax password" href="/bv/profile/password"><i class="icon-key"></i> Change Password</a></li>
	<li><a class="shortcut ajax email" href="/bv/profile/notifications"><i class="icon-mail--pencil"></i> Email Settings</a></li>
	<!---<li class="divider"></li>
  <li class="nav-header">Integration</li>
  <li><a class="shortcut ajax password" href="/profile/groups">Buying Group Integration</a></li> 
	<li><a class="shortcut ajax api" href="/profile/api">API Access</a></li>--->
	<cfelse>
	<li class="nav-header">#rc.user.firstname#'s Profile</li>
	</cfif>
</ul>
</cfoutput>