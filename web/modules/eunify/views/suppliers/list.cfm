<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","suppliers/table","tables")>
<h2>Supplier List</h2>
<table class="dataTable" id="supplierList">
  <thead>
    <tr>
      <th width="1%" nowrap="true">Account Number</th>
      <th width="40%">Name</th>
      <th>Address 1</th>
      <th>Address 2</th>
      <th>Postcode</th>
      <th>Tel</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>