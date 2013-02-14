<div class="page-header">
	<h1>Site Followers</h1>
</div>
<cfoutput>
<div class="row">
<cfloop array="#rc.members#" index="person">
<div class="span4">
	<div class="span1">
		<!--- thumbnail --->
		<img width="45" height="45" class="thumbnail" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(person.authority.userName)))#?size=45&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" />
	</div>
	<div>
		<h3><a href="/profile?id=#urlencrypt(person.authority.username)#">#person.authority.firstName# #person.authority.lastName#</a></h3>
		<cftry><p>#person.authority.jobtitle# at #person.authority.organization#</p><cfcatch type="any"></cfcatch></cftry>		
	</div>
</div>
</cfloop>
</div>
<br />
</cfoutput>