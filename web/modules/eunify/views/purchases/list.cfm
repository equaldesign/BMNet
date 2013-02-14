<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","purchase/table","tables")>
<cfoutput>
  <input type="hidden" id="filterBy" value="#rc.filter#" />
  <input type="hidden" id="filterID" value="#rc.filterID#" />
  <input type="hidden" id="t" value="#rc.t#" />
</cfoutput>
<h2>Invoice List</h2>
<table class="dataTable" id="customerList">
  <thead>
    <tr>
      <th width="1%" nowrap="true">ID</th>
      <th>Account Number</th>
      <th width="40%">Name</th>
      <th>Order #</th>
      <th>Invoice #</th>
      <th>Date</th>
      <th>Goods Total</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>