<cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy,validate.min,form","sites/#request.siteID#/turnbull,sites/#request.siteID#/checkout","")>

  <form action="/mxtra/account/emailinvoices" method="post">
  <input class="pull-right btn btn-success" type="submit" disabled="true" id="emailInvoices" value="email invoices/PODs" />
<cfoutput><h2>Invoices Between #DateFormat(rc.fromDate,"DD MMM YY")# - #DateFormat(rc.toDate,"DD MMM YY")#</h2></cfoutput>

<table class="table table-striped table-bordered">
  <thead>
    <tr>
      <th></th>
			<th></th>
      <th>Invoice Number</th>
      <th>Order Number</th>
      <th>Branch</th>
      <th>Items</th>
      <th>Date</th>
      <th>Total</th>
      <th>POD?</th>
    </tr>
  </thead>
  <tbody>
    <cfoutput query="rc.invoices" group="invoice_num">
      <tr>
        <th><input name="invoiceNumber" type="checkbox" class="emailinvoice" value="#invoice_num#" /></th>
				<td><a target="_blank" href="/mxtra/account/invoiceDetail?output=pdf&id=#id#&orderID=#order_number#"><img src="http://d25ke41d0c64z1.cloudfront.net/images/icons/document-pdf.png" border="0" /></a></td>
        <td>#invoice_num#</td>
        <td>#order_number#</td>
        <td>#name#</td>
        <td>#items#</td>
        <td>#DateFormat(invoice_date,"DD/MM/YYYY")#</td>
        <td>&pound;#DecimalFormat(line_total+line_vat)#</td>
        <td><cfif PODFile neq 0><a href="/mxtra/account/getPOD?PODFile=#PODFile#"><img src="/images/icons/document-pdf.png" border="0" /></cfif></td>
      </tr>
    </cfoutput>
    <cfif rc.invoices.recordCount eq 0>
    <tr>
      <td colspan="9">No invoices found</td>
    </tr>
    </cfif>
  </tbody>
</table>
</form>
