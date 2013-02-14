<cfset f = getModel("figures")>
<cfset p = getModel("psa")>
<cfoutput>
  <h2>#rc.answers.label#</h2>
  <cfif rc.poll.relatedID neq 0 and rc.poll.relatedTo eq "arrangement">
    <cfset psa = p.getPSA(rc.poll.relatedID)>
    <cfset yearsInDeal = dateDiff("yyyy",psa.period_from,psa.period_to)+1>
    <cfset monthsInDeal = dateDiff("m",psa.period_from,psa.period_to)+1>
    <cfset nextInputDate = f.getNextInputDate(rc.poll.relatedID)>
    <cfset monthsCompleted = dateDiff("m",psa.period_from,nextInputDate)>
    <cfif rc.answers.compare>
    <h3>#psa.name#</h3>
    <h4>#monthsCompleted# months of turnover completed</h4>
    </cfif>
  </cfif>
</cfoutput>
<table class="table table-condensed table-bordered table-striped">
  <thead>
    <tr>
      <th>Partner</th>
      <th>Response</th>
      <cfif rc.answers.compare>
      <th>Spend to date</th>
      <th>Performance</th>
      </cfif>
    </tr>
  </thead>
  <tbody>
    <cfset totalResponse = 0>
    <cfset totalSpend = 0>
    <cfoutput query="rc.answers">

      <tr>
        <td><cfif rc.poll.allowMultipleResponses>#first_name# #surname# (</cfif>#name#<cfif rc.poll.allowMultipleResponses>)</cfif></td>
        <td><cfif isNumeric(value)>&pound;#NumberFormat(value,"9,999,999")#<cfelse>#value#</cfif></td>
        <cfif rc.answers.compare>
          <cfset thisTurnover = getModel("figures").getTotalMemberThroughPut(rc.poll.relatedID,companyID)>
          <cfif thisTurnover.total neq "">
            <cfset totalSpend+=thisTurnover.total>
            <cfset totalTurnover = value*yearsInDeal>
            <cfset totalResponse +=totalTurnover>
            <cfset avg = thisTurnover.total/#monthsCompleted#>
            <cfset est = avg*monthsInDeal>
            <!--<small>(avg: #numberFormat(avg,"9,999")#, est: #numberFormat(est,"9,999")#, declared: #numberFormat(totalTurnover,"9,999")#)</small>-->
            </cfif>
        <td>&pound;#numberFormat(thisTurnover.total,"9,999")#</td>
        <td>
          <cfif est lt totalTurnover/100*90 AND (est neq 0 and totalTurnover neq 0)>
            <span class="label label-important tooltip" title="avg per month: &pound;#numberFormat(avg,"9,999")#, est over agreement period: &pound;#numberFormat(est,"9,999")#, declared for agreement period: &pound;#numberFormat(totalTurnover,"9,999")#">#numberFormat((est/totalTurnover)*100,"9,999")#%</span>
          <cfelseif est gt totalTurnover>
            <span class="label label-success tooltip" title="avg per month: &pound;#numberFormat(avg,"9,999")#, est over agreement period: &pound;#numberFormat(est,"9,999")#, declared for agreement period: &pound;#numberFormat(totalTurnover,"9,999")#">#numberFormat((est/totalTurnover)*100,"9,999")#%</span>
          <cfelse>
            <span class="label tooltip" title="avg per month: &pound;#numberFormat(avg,"9,999")#, est over agreement period: &pound;#numberFormat(est,"9,999")#, declared for agreement period: &pound;#numberFormat(totalTurnover,"9,999")#"><cfif est neq 0 and totalTurnover neq 0>#numberFormat((est/totalTurnover)*100,"9,999")#%</cfif></label>
          </cfif>
        </td>
        </cfif>
      </tr>
    </cfoutput>
  </tbody>
  <cfif rc.answers.compare>
  <tfoot>
    <tr>
      <th class="">Total</th>
      <th>&pound;<cfoutput>#numberFormat(totalResponse,"9,999,999")#</cfoutput></th>
      <th>&pound;<cfoutput>#numberFormat(totalSpend,"9,999,999")#</cfoutput></th>
      <th></th>
    </tr>
  </tfoot>
  </cfif>
</table>
