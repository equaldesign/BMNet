<div class="tclothtable">
				<table class="v tableCloth">
					<thead>
					<cfoutput>
					<tr>
						<th>psaID</th>
						<th>Supplier</th>
						<th>Product Range</th>
					</tr>
				  </cfoutput>
				  </thead>
				  <tbody>
				  <cfoutput query="rc.aggList">
				  	<tr>
				  	<td><a href="/psa?psaID=#psaID#">#psaID#</a></td>
				    <td><a href="/psa?psaID=#psaID#">#suppliername#</a></td>
				    <td><a href="/psa?psaID=#psaID#">#name#</a></td>
				  </tr>
				 	</cfoutput>
			  	</tbody>
				</table>
				</div>