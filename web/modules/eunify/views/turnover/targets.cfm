<h1>Turnover Targets</h1>
<cfoutput><p>The deals below are within #rc.difference#% of hitting the next rebate earnings band.</p>
<div class="form-signUp">
  <form action="#bl('figures.targets')#">
  <div>
    <label for="difference">Difference</label>
    <input size="3" type="text" name="difference" value="#rc.difference#"><input class="doIt" type="submit" name="submit" value="go &raquo;">
  </div>
  </form>
</div>
</cfoutput>
<div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
  <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
  <strong>No brainers</strong></p>
  <p>No-Brainers are highlighted in Red - this means the amount needed to spend to hit the next band is less than the rebate you will get back.</p>
  <p>This table does NOT take into account compound rebates</p>
</div>
<table class="small v tableCloth">
  <thead>
    <tr>
      <th>Supplier</th>
      <th>OTE</th>
      <th>%+</th>
      <th>Next Step</th>
      <th>Gain</th>
      <th>Difference</th>
      <th>Value</th>
      <th>Possible</th>
    </tr>
  </thead>
  <tbody>
  <cfset differenceTotal = 0>
  <cfoutput query="rc.fullList">
    <cfset difference = requiredTurnover-currentOTETurnover>
    <cfset sumdiff = payout-difference>
    <cfif sumdiff gte 0>
      <cfset nobrainer = true>
    <cfelse>
      <cfset nobrainer = false>
    </cfif>
    <tr class="#Iif(nobrainer,"'highlightMember'","''")#">
      <td><a class="tooltip" title="#rebateName#" href="/intranet/main/psa_view?psaID=#dealID#">#supplier#</a></td>
      <td>&pound;#Trim(NumberFormat(currentOTETurnover,"9,999,999"))#</td>
      <td>#Trim(NumberFormat(percentIncrease,"0.00"))#%</td>
      <td>&pound;#Trim(NumberFormat(requiredTurnover,"9,999,999"))#</td>
      <td>&pound;#Trim(NumberFormat(payout,"9,999,999"))#</td>
      <td>&pound;#Trim(NumberFormat(difference,"9,999,999"))#</td>
      <td>#currentValue#%</td>
      <td>#possibleValue#%</td>
    </tr>
    <cfset differenceTotal = differenceTotal + difference>
  </cfoutput>
  <cfquery name="totalGain" dbtype="query">
    select sum(payout) as payout from rc.workers;
  </cfquery>
  <tr>
    <th colspan="4">Total to gain</th>
    <th><Cfoutput>&pound;#Trim(NumberFormat(totalGain.payout,"9,999,999.00"))#</Cfoutput></th>
    <th colspan="3"><Cfoutput>&pound;#Trim(NumberFormat(differenceTotal,"9,999,999.00"))#</Cfoutput></th>
  </tr>
  </tbody>
</table>
