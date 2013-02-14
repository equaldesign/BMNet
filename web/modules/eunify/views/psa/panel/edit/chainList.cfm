<cfif rc.chains.recordCount gte 1>
<h2>Current chained agreements</h2>
<cfoutput>
<table class="tableCloth v Aristo">
   <thead>
     <tr>
       <th width="20"></th>
       <th>Name</th>
       <th>Supplier</th>
     </tr>
   </thead>
   <tbody>
    <cfloop query="rc.chains">
    <tr>
      <td><a href="##" class="delete" rel="#chainID#">&nbsp;</a>&nbsp;</a></td>
      <td>#name#</td>
      <td>#known_as#</td>
    </tr>
    </cfloop>
   </tbody>
  </table>
</cfoutput>
</cfif>