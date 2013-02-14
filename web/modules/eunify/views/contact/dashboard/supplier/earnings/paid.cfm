<cfset getMyPlugin(plugin="jQuery").getDepends("","psa/earnings")>
<div class="small tclothtable">
  <cfoutput><h2>Payments Received in #DateFormat(now(),"YYYY")#</h2></cfoutput>
  <div style="padding: 0pt 0.7em; margin: 5px 0px;" class="Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>What is this?</strong></p>
    <p>This table shows rebate you have toggled as paid.</p>
    <p>This will help you keep track of your rebate payments.</p>
  </div>
  <table class="v tableCloth">
    <thead>
      <tr>
        <th>Supplier</th>
        <th>Amount</th>
        <th>Period End</th>
        <th>Rebate</th>
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
        <cfset element = rc.psa.getElementByID(xmlID,dealData,psaID)>
        <cftry>
        <cfset element = element[1]>
        <cfcatch>
          <!-- hmmm -->
        </cfcatch>
        </cftry>
        <td class="tr" nowrap="nowrap">#DateFormat(periodTo,"MMM YY")#</td>
        <td class="tr" nowrap="nowrap">#rebateName#</td>
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
      </tr>
    </tfoot>
    </cfoutput>
  </table>
</div>
<br class="clear" />