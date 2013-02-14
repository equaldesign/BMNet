
<cfif rc.invitees.recordCount gte 1>
  <table  class="table table-striped table-rounded table-condensed" border="0" cellspacing="0" >
	  <thead>
		  <tr>
		      <th></th>
		      <th>Name</th>
		      <th>Company</th>
		      <th>Completed?</th>
		  </tr>
	  </thead>
	  <tbody>
    <cfoutput query="rc.invitees">
        <tr>
          <td width="20"><img width="20" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(email)))#?size=20&d=http://#cgi.HTTP_HOST#/#paramImage('company/#company_id#_square.jpg','website/unknown.jpg')#" /></td>
          <td>#first_name# #surname#</td>
          <td>#known_as#</td>
          <td width="16"><cfif completed><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/tick-circle-frame.png"><cfelse><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/cross-circle-frame.png"></cfif></td>
        </tr>
    </cfoutput>
	</tbody>
    </table>
</cfif>