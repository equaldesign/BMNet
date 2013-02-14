<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","tables","tables")>
<h2>Customer Warnings</h2>
<cfoutput>
<p>The following customers had at least 50 invoices between #DateFormat(DateAdd("m",-8,now()),"MMMM")# and #DateFormat(DateAdd("m",-2,now()),"MMMM")#, but haven't made any purchases since then</p>
</cfoutput>
<table class="dataTable" id="customerList">
  <thead>
    <tr>
      <th width="1">Account Number</th>
      <th width="70%">Name</th>
      <th>Invoice Count</th>
    </tr>
  </thead>
  <tbody>
    <cfoutput query="rc.data">
    <tr>
      <td>#id#</td>
      <td><a href="/customers/detail/id/#id#">#name#</a></td>
      <td>#spend#</td>
    </tr>
    </cfoutput>
  </tbody>
</table>