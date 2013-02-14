<cfset getMyPlugin(plugin="jQuery").getDepends("","menus,contact/view")>
<cfif rc.user.id eq "">
    <h2>No user</h2>
    <p>The user you requested no-longer exists</p>
    <cfabort>
</cfif>
<div class="relative">
<cfoutput>
<div style="height: 100px;">
	<img width="75" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.user.email)))#?size=75&d=http://#cgi.HTTP_HOST#/#paramImage('company/#rc.company.id#_square.jpg','website/unknown.jpg')#" />
	<h2>#rc.user.first_name# #rc.user.surname#
	<cfif rc.user.buildingVine><a href="##" class="bvenabled" title="Building Vine enabled!"></a></cfif>
	<cfif rc.BMNet.contactID = rc.user.id OR isUserInRole("admin")>
		<a href="#bl('user.edit','id=#rc.user.id#')#" class="editContact">edit this user</a><br />
    <a href="##" rel="#bl('user.delete','id=#rc.user.id#')#" class="deleteContact">delete this user</a>
    <a href="#bl('user.passwordReminder','email=#rc.user.email#')#" class="remindPassword">send password reminder</a>
	</cfif>
	</h2>
	<h4>#rc.user.jobTitle#</h4>
	<p>Email: <cfif isEmail(rc.user.email)><a href="mailto:#lcase(rc.user.email)#">#lCase(rc.user.email)#</a><cfelse>#lcase(rc.user.email)#</cfif><br />
		Tel: #rc.user.tel#<br />
		Mobile: #rc.user.mobile#
	</p>
</div>
	<br class="clear" />
	<div id="tabs" class="Aristo">
		<ul>
			<li><a class="overview" href="#bl('user.view','id=#rc.user.id#')#"><span>Overview</span></a></li>
			<li><a class="company" href="#bl('company.view','id=#rc.company.id#')#"><span>Company Info</span></a></li>
      <cfif isUserInRole("member")>
			<!---<li><a class="updates" href="#bl('user.feed','id=#rc.user.id#')#">Updates</a></li>--->
			<li><a class="negotiating" href="#bl('user.negotiating','id=#rc.user.id#')#"><span>Negotiating</span></a></li>
			<li><a class="favourites" href="#bl('user.favourites','id=#rc.user.id#')#"><span>Favourites</span></a></li>
      <li><a class="commentIcon" href="#bl('comment.list','relatedID=#rc.user.id#&relatedType=user')#"><span>Notes</span></a></li>
			<li><a class="buildingvine" href="/bv/user/index?active=#rc.user.buildingVine#&bvusername=#rc.user.bvusername#&companyID=#rc.company.id#&userID=#rc.user.id#">Building Vine&trade;</a></li>
			</cfif>
		</ul>

	</div>
</cfoutput>
</div>