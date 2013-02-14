<cfoutput>
<table class="table table-striped  table-bordered">
	<thead>
		<tr>
			<th>User Permission</th>
			<th></th>			
			<th>Name</th>
			<th></th>
		</tr>
	</thead>
	<tbody>
  <cfloop array="#rc.members#" index="member">
		<tr>
			<td>
				<select class="changeRole" rel="#member.url#"> 
		        <option #vm('SiteConsumer','#member.role#')# value="SiteConsumer">Consumer</option>
		        <option #vm('SiteContributor','#member.role#')# value="SiteContributor">Contributor</option>
		        <option #vm('SiteCollaborator','#member.role#')# value="SiteCollaborator">Collaborator</option>
		        <option #vm('SiteManager','#member.role#')# value="SiteManager">Manager</option>
        </select>
			</td>
			<td>
				<i class="authority_#member.authority.authorityType#">
			</td>
			<td>
        <cfif member.authority.authorityType eq "USER">
          <a href="/profile?id=#urlEncrypt(member.authority.userName)#">#member.authority.userName#</a>
        <cfelse>
          #member.authority.displayName#
        </cfif>
			</td>
			<td><a href="#member.url#?alf_ticket=#request.user_ticket#" class="ttip btn btn-danger deleteAuthority" title="remove this user/group from this site"></a></td>
		</tr>
	</cfloop>
	</tbody>
</table>
</cfoutput>
