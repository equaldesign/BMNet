<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","tableNoPage","tables")>
<h1>Contact List</h1>
<cfif isUserInRole("member")>
<div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
  <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
  <strong>Why not search?</strong></p>
  <p>Did you know you can search for contacts? It's quick and easy - just use the search box at the top right of the page</p>
  <p>You can search by contact name or by company</p>
</div>
</cfif>
<div id="tsort">
  <table id="contacts" class="dataTable">
    <thead>
      <tr>
        <th></th>
        <th><a href="#" class="fdTableSortTrigger" title="Sort on “PSA CATEGORY”">Name</a></th>
        <th><a href="#" class="fdTableSortTrigger" title="Sort on “PSA CATEGORY”">Company</a></th>
        <th>Tel</th>
        <th>Email</th>
        <!--- <cfif isUserInRole("ebiz")><th>Groups</th></cfif> --->
      </tr>
    </thead>
    <tbody>
      <cfoutput query="rc.contacts">
       <tr>
        <td><cfif isEmail(email)><img width="25" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(email)))#?size=25&&d=http://#cgi.HTTP_HOST#/#paramImage('company/#company_id#_square.jpg','website/unknown.jpg')#"></cfif></td>
        <td valign="top"><a href="#bl('contact.index','id=#id#')#">#first_name# #surname#</a></td>
        <td valign="top"><a href="#bl('company.index','id=#company_id#')#">#name#</a></td>
        <td>#tel#</td>
        <td><a href="mailto:#email#"><img border="0" src="https://d25ke41d0c64z1.cloudfront.net/images/icons/mail-send.png"></a></td>

        <!--- <cfif isUserInRole("ebiz")>
		      <td valign="top">#getModel('groups').getBaseSecurityGroups(id)#</td>
		    </cfif> --->

       </tr>
      </cfoutput>
    </tbody>
  </table>
</div>