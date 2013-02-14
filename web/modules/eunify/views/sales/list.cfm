<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","sales/table","tables")>
<cfoutput>
  <input type="hidden" id="filterBy" value="#rc.filter#" />
  <input type="hidden" id="filterID" value="#rc.filterID#" />
  <input type="hidden" id="t" value="#rc.t#" />
</cfoutput>
<div class="widget widget-table small">
<h2>Invoice List</h2>
<table class="table table-bordered table-striped dataTable" id="customerList">
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