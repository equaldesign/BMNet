<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","tables","tables")>
<h2>Customer Warnings</h2>
<cfoutput>
<p>The following customers had at least 50 invoices between #DateFormat(DateAdd("m",-7,now()),"MMMM")# and #DateFormat(DateAdd("m",-1,now()),"MMMM")#, but haven't made any purchases since then</p>
</cfoutput>
<table class="dataTable table table-bordered table-striped" id="customerList">
  <thead>
    <tr>
      <th width="1">Account Number</th>
      <th width="70%">Name</th>
      <th>Invoice Count</th>
			<th>Spend</th>
    </tr>
  </thead>
  <tbody>
    <cfoutput query="rc.data">
    <tr>
      <td>#id#</td>
      <td><a href="/eunify/company/detail/id/#id#">#name#</a></td>
      <td>#invoice_count#</td>
			<td>&pound;#DecimalFormat(spend)#</td>
    </tr>
    </cfoutput>
  </tbody>
</table>