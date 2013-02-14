<cfset getMyPlugin(plugin="jQuery").getDepends("","tables","")>
<div class="widget-box">
  <div class="widget-title">
    <h5>Contacts</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-hover table-striped table-condensed dataTable" id="customerList">
    	<thead>
    		<tr>
    			<th></th>
    			<th>Name</th>
    			<th>Position</th>
    			<th>Tel</th>
    			<th>Mobile</th>
    			<th>Email</th>
    		</tr>
    	</thead>
    	<tbody>
    	<cfoutput query="rc.contacts">
    		<tr>
    			<td><cfif isEmail(email)><img class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(email)))#?size=25&d=mm"></cfif></td>
    			<td><a href="#bl('contact.index','id=#id#')#">#first_name# #surname#</a></td>
    			<td>#jobTitle#</td>
    			<td>#tel#</td>
    			<td>#mobile#</td>
    			<td><cfif isEmail(email)><a href="mailto:#lcase(email)#"><img src="/images/icons/email.png" border="0"></a></cfif></td>
    		</tr>
    	</cfoutput>
    	</tbody>
    </table>
  </div>
</div>