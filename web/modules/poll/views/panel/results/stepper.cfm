<cfset grandTotalItems = 0>
<cfset grandTotalValue = 0>
<div class="accordion2" id="stepperResults">
<cfoutput query="rc.stepperList" group="label">
  <h3><a href="##">#label# priced at &pound;#fieldName# EA.</a></h3>
  <div>
  <table class="table table-bordered table-striped table-condensed">
    <thead>
      <tr>
        <th>Partner</th>
        <th>Quantity</th>
        <th>Total Spend</th>
      </tr>
    </thead>
    <cfset thisTotalitems = 0>
    <cfset thisTotalValue = 0>
    <tbody>
      <cfoutput>
      <tr>
        <td>#known_as#</td>
        <td>#value#</td>
        <td>&pound;#fieldName*value#</td>
      </tr>
      <cfset thisTotalitems+= value>
      <cfset thisTotalValue+= fieldName*value>
      <cfset grandTotalItems += value>
      <cfset grandTotalValue += fieldName*value>
      </cfoutput>
    </tbody>
    <tfoot>
      <tr>
        <th>TOTAL</th>
        <th>#thisTotalitems#</th>
        <th>&pound;#thisTotalValue#</th>
      </tr>
    </tfoot>
  </table>
  </div>
</cfoutput>
</div>
<cfoutput>
  <h2>Total Order Value: &pound;#grandTotalValue#</h2>
</cfoutput>