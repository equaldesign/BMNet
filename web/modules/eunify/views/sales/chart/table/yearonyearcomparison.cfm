<table class="v">
  <thead>
    <tr>
      <th>This Year</th>
      <th>Date</th>
      <th>Last Year</th>
      <th>Date</th>
      <th>%</th>
    </tr>
  </thead>
  <cfoutput query="rc.data">
    <tr>
      <td>&pound;#DecimalFormat(ValueThis)#</td>
      <td>#DateFormat(DateThis,"MMM YY")#</td>
      <td>&pound;#DecimalFormat(ValueLast)#</td>
      <td>#DateFormat(DateLast,"MMM YY")#</td>
      <td>
        <cfif valueThis neq "" AND valueLast neq "">
          <cfset value = round(((int(valueThis)-int(valueLast))/int(ValueLast))*100)>
          #value#%
        <cfelseif valueThis neq "">
          100%
        <cfelseif valueLast neq "">
          -100%
        <cfelse>
          0
        </cfif>
      </td>
    </tr>
  </cfoutput>
</table>
