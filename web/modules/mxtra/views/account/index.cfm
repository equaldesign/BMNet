<cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/invoicing","sites/#request.siteID#/account")>
<cfoutput>
<cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy,validate.min,form","sites/#request.siteID#/turnbull","")>
<h1>Welcome #rc.userCompany.name#</h1>
<p>The your account pages of Turnbull 24-7 allow you to view all your previous invoices, and print them or save them as a pdf if required.</p>
<div class="page-heading">
  <h2>Recent Invoices</h2>
</div>
<cfif rc.invoices.recordCount neq 0>
<table class="table table-striped table-rounded">
  <thead>
    <tr>
    	<th></th>
      <th>Date.</th>
			<th>Invoice Number</th>
			<th>Order Number</th>
      <th>Total</th>
    </tr>
  </thead>
  <tbody>
  <cfloop query="rc.invoices">
  <tr>
  	<td><a target="_blank" href="/mxtra/account/invoiceDetail?output=pdf&id=#id#&orderID=#order_number#"><img src="http://d25ke41d0c64z1.cloudfront.net/images/icons/document-pdf.png" border="0" /></a></td>
    <td>#DateFormat(invoice_date,"D MMM YY")#</td>
		<td>#invoice_number#</td>
		<td>#order_number#</td>
    <td>&pound;#DecimalFormat(invoice_total)#</td>
  </tr>
  </cfloop>
</table>
</cfif>
<div class="page-heading">
  <h2>Recent Quotations</h2>
</div>
<cfif rc.quotations.recordCount neq 0>
<table class="table table-striped table-rounded">
  <thead>
    <tr>
      <th>Date.</th>
      <th>Reference</th>
    </tr>
  </thead>
  <tbody>
  <cfloop query="rc.quotations">
  <tr>
    <td><a href="/mxtra/shop/quote?id=#id#">#DateFormat(date,"D MMM YY")#</a></td>
    <td><a href="/mxtra/shop/quote?id=#id#">#reference#</a></td>
  </tr>
  </cfloop>
</table>
</cfif>
</cfoutput>