<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","sales/ledger","tables")>
<div class="widget widget-table">
<h2>Sales Ledger</h2>
<table class="table table-bordered table-striped table-condensed dataTable"  id="ledger">
  <caption>Invoice List</caption>
  <thead>
    <tr>
    	<th></th>
      <th width="1%" nowrap="true">Branch ID</th>
      <th>Account Number</th>
      <th width="40%">Name</th>
      <th>Order #</th>
      <th>Invoice #</th>
      <th>Date</th>
      <th>Goods Total</th>
      <th>Salesman</th>
      <th>POD?</th>
    </tr>
  </thead>
  <tbody></tbody>
</table>
</div>