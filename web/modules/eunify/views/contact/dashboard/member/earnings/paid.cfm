<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","psa/payments,psa/payments/paid","tables")>
<div class="small tclothtable">
  <cfoutput><h2>Payments Received in #DateFormat(now(),"YYYY")#</h2></cfoutput>
  <div style="padding: 0pt 0.7em; margin: 5px 0px;" class="Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>What is this?</strong></p>
    <p>This table shows rebate you have toggled as paid.</p>
    <p>This will help you keep track of your rebate payments.</p>
  </div>
  <table class="dataTable" id="paid">
    <thead>
      <tr>
        <th>Supplier</th>
        <th>Amount</th>
        <th>Period End</th>
        <th>Rebate</th>
        <th nowrap="nowrap">Paid?</th>
      </tr>
    </thead>
    <tbody>
      <cfquery name="monthTotal" dbtype="query">
        select sum(rebatePayable) as total from rc.yearrebatePayments;
      </cfquery>
      <cfoutput query="rc.yearrebatePayments">
      <tr>
        <td><a href="#bl('psa.index','psaID=#psaID#')#" class="tooltip" title="#name#">#known_as#</a></td>
        <td>&pound;#numberFormat(rebatePayable,"9,999,999.99")#</td>
        <td class="tr" nowrap="nowrap">#DateFormat(periodTo,"MMM YY")#</td>
        <td class="tr" nowrap="nowrap">#rebateName#</td>
        <td nowrap="nowrap">
          <select id="id_#id#" class="markpaid" rel="#id#">
            <option value="false" #vm('false',paid)#>no</option>
            <option value="incorrect" #vm('incorrect',paid)#>part</option>
            <option value="true" #vm('true',paid)#>yes</option>
          </select>
        </td>
      </tr>
      </cfoutput>
    </tbody>
    <cfoutput>
    <tfoot>
      <tr>
        <th>TOTAL</th>
        <th>&pound;#numberFormat(monthTotal.total,"9,999,999")#</th>
        <th></th>
        <th></th>
        <th></th>
      </tr>
    </tfoot>
    </cfoutput>
  </table>
</div>
<br class="clear" />