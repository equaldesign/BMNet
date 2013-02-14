<cfset getMyPlugin(plugin="jQuery").getDepends("","psa/earnings")>
<div class="tclothtable small">
  <cfoutput><h2>Payments not yet paid by you in #DateFormat(now(),"YYYY")#</h2></cfoutput>
  <div style="padding: 0pt 0.7em; margin: 5px 0px;" class="Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>What is this?</strong></p>
    <p>This table shows rebate due to be paid by you, where you have entered enough figures to guaranteed a correct calculation - and where a member has not indicated they have been paid.</p>
  </div>
  <table class="v tableCloth">
    <thead>
      <tr>
        <th nowrap="nowrap">Member</th>
        <th nowrap="nowrap">Amount</th>
        <th nowrap="nowrap">Period End</th>
        <th nowrap="nowrap">Rebate</th>
      </tr>
    </thead>
    <tbody>
      <cfquery name="monthTotal" dbtype="query">
        select sum(rebatePayable) as total from rc.yearrebatePayments;
      </cfquery>
      <cfoutput query="rc.yearrebatePayments">
      <tr>
        <td><a href="#bl('psa.index','psaID=#psaID#')#" class="tooltip" title="#name#">#known_as#</a></td>
        <td class="tr">&pound;#DecimalFormat(rebatePayable)#</td>
        <cfset element = rc.psa.getElementByID(xmlID,dealData,psaID)>
        <cftry>
        <cfset element = element[1]>
        <cfcatch>
          <!-- hmmm -->
        </cfcatch>
        </cftry>
        <td nowrap="nowrap">#DateFormat(periodTo,"MMMM YYYY")#</td>
        <td>#rebateName#</td>
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
      </tr>
    </tfoot>
    </cfoutput>
  </table>
</div>
<br class="clear" />