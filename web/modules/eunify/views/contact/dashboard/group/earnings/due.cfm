<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","psa/payments,psa/payments/due","tables")>
<div class="tclothtable small">
  <cfoutput><h2>Payments not yet paid by supplier in #DateFormat(now(),"YYYY")#</h2></cfoutput>
  <div style="padding: 0pt 0.7em; margin: 5px 0px;" class="Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>What is this?</strong></p>
    <p>This table shows rebate due to you, where a supplier has entered enough figures to guaranteed a correct calculation.</p>
    <p>If rebate is payable direct to members, then you can toggle this rebate as received (if you have received it from the supplier).</p>
    <p>This will help you keep track of your rebate payments.</p>
  </div>
  <table id="due" class="dataTable">
    <thead>
      <tr>
        <th nowrap="nowrap">Supplier</th>
        <th nowrap="nowrap">Amount</th>
        <th nowrap="nowrap">Period End</th>
        <th nowrap="nowrap">Rebate</th>
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
        <td>&pound;#NumberFormat(rebatePayable,"9,999,999.99")#</td>
        <td nowrap="nowrap">#DateFormat(periodTo,"MMMM YYYY")#</td>
        <td>#rebateName#</td>
        <td nowrap="nowrap">
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
<cfset getMyPlugin(plugin="jQuery").getDepends("","psa/payments","")>