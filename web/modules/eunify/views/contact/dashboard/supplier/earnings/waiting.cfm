<div class="small tclothtable">
  <cfoutput><h2>Payments Paid by supplier but not yet receieved in #DateFormat(now(),"YYYY")#</h2></cfoutput>
  <div style="padding: 0pt 0.7em; margin: 5px 0px;" class="Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>What is this?</strong></p>
    <p>This table shows rebate that has been paid to the group - but which has not been received by you.</p>
    <p>You can toggle rebates that you have received from the group.</p>
    <p>This will help you keep track of your rebate payments.</p>
  </div>
  <table class="v tableCloth">
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
        <td>&pound;#numberFormat(rebatePayable,"9,999,999")#</td>
        <td>#rebateName#</td>
        <td class="tr" nowrap="nowrap">#DateFormat(periodTo,"MMM")#</td>
        <td class="tr" nowrap="nowrap">
            <input type="checkbox" class="markpaid" value="1" rel="#id#" #vm('true',paid,"checkbox")# />
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