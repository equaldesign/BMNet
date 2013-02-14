<table class="v">
  <thead>
    <tr>
      <th>This Month</th>
      <th>Date</th>
      <th>Last Month</th>
      <th>Date</th>
      <th>%</th>
    </tr>
  </thead>
  <cfoutput query="rc.data">
    <tr>
      <td>&pound;#DecimalFormat(ValueThis)#</td>
      <td>#DateFormat(DateThis,"DD MMM")#</td>
      <td>&pound;#DecimalFormat(ValueLast)#</td>
      <td>#DateFormat(DateLast,"DD MMM")#</td>
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
