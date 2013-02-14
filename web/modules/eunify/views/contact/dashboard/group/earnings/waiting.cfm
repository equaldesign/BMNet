<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","psa/payments,psa/payments/waiting","tables")>
<div class="small tclothtable">
  <cfoutput><h2>Payments Paid by supplier but not yet receieved in #DateFormat(now(),"YYYY")#</h2></cfoutput>
  <div style="padding: 0pt 0.7em; margin: 5px 0px;" class="Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>What is this?</strong></p>
    <p>This table shows rebate that has been paid to the group - but which has not been received by you.</p>
    <p>You can toggle rebates that you have received from the group.</p>
    <p>This will help you keep track of your rebate payments.</p>
  </div>
  <table class="dataTable" id="waiting">
    <thead>
      <tr>
        <th>Supplier</th>
        <th>Amount</th>
        <th>Period End</th>
        <th>Rebate</th>
        <th>Paid?</th>
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
        <td nowrap="nowrap">#DateFormat(periodTo,"MMM")#</td>
        <td>#rebateName#</td>
        <td class="tr" nowrap="nowrap">
          <select class="markpaid" rel="psaID_#psaID#-xmlID_#xmlID#-periodName_#periodName#">
            <option value="false" #vm('false',paid)#>no</option>
            <option value="incorrect" #vm('incorrect',paid)#>part</option>
			<option value="holding" #vm('holding',paid)#>paid to group</option>
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
        <th>&pound;#DecimalFormat(monthTotal.total)#</th>
        <th></th>
        <th></th>
        <th></th>
      </tr>
    </tfoot>
    </cfoutput>
  </table>
</div>
<br class="clear" />