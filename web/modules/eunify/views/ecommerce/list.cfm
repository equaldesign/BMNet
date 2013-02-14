<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","ecommerce/table","tables")>
<cfoutput>
  <input type="hidden" id="filterBy" value="#rc.filter#" />
  <input type="hidden" id="filterID" value="#rc.filterID#" />
</cfoutput>
<h2>Online Orders</h2>
<table class="table table-striped table-bordered dataTable" id="ecommerceList">
  <thead>
    <tr>
      <th width="1%" nowrap="true">ID</th>
      <th>Contact</th>
      <th width="40%">Address</th>
      <th>PostCode</th>
      <th>Total</th>
      <th>Status</th>
			<th>Date</th>
      <th>Delivered</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>
