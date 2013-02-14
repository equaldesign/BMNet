<cfif rc.fe.recordCount gte 1>
<h2>This agreement's input streams</h2>
<cfoutput>
<table id="inputStreams" class="tableCloth v Aristo">
   <thead>
     <tr>
       <th width="32"></th>
       <th>Type</th>
       <th>Name</th>
     </tr>
   </thead>
   <tbody>
    <cfloop query="rc.fe">
    <tr>
      <td><a href="##" class="noAjax delete" rel="#id#">&nbsp;</a><a href="##" class="noAjax edit" rel="#id#">&nbsp;</a></td>
      <td>#display#</td>
      <td>#inputName#</td>
    </tr>
    </cfloop>
   </tbody>
  </table>
</cfoutput>
</cfif>