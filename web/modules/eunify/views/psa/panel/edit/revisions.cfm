<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","tables","tables")>
<h1>4. Revisions</h1>
<cfoutput>
<table id="revisions" class="dataTable tableCloth v Aristo">
   <thead>
     <tr>
       <th width="32">##</th>
       <th>Date</th>
       <th>Modifier</th>
     </tr>
   </thead>
   <tbody>
    <cfloop query="rc.panelData.revisions">
    <tr>
      <td><a href="/psa/index/psaid/#psaID#/revisionID/#id#" >#id#</a></td>
      <td>#DateFormat(datemodified,"full")# at #TimeFormat(datemodified,"medium")#</td>
      <td><a href="/contact/index/id/#contactid#">#first_name# #surname# (#name#)</td>
    </tr>
    </cfloop>
   </tbody>
  </table>
</cfoutput>