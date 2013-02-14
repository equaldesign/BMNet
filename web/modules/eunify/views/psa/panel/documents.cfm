<h2>Supporting Documents</h2>
<p>The following documents are presented alongside this Agreement. Click on the filename to download it</p>
<cfoutput>
<cfset documents = dms.getAllRelatedDocuments("deal",psaID)>
    <div class="tclothtable">
    <table name="tcloth">
        <tr>
        <th>Filename</th>
        <th>Size</th>
        <th>Type</th>
      </tr>
     <cfloop query="documents">
     <cfif groups.canViewDoc(id)>
        <tr>
        <td><a class="#fileType#" target="_blank" href="/intranet/dms/viewFile?id=#id#">#name#
                        <div class="dmsDescription">#description#</div></a>
        </td>
        <td>#dms.getFileSize(size)#</td>
        <td>#dms.getFileTypeDescription(fileType)#</td>
      </tr>
      </cfif>
         </cfloop>
     </table>
   </div>
<cfif em AND canEditPSA()>
<h2>Add Documents</h2>
<cftry>
<cfset dmsRelated.id = psaID>
<cfset dmsRelated.type = "deal">
<cfset dmsRelated.name = "">
<cfinclude template="../../../dms/view/uploadDMSDocument.cfm">
<cfcatch type="any">
  <h2>Document connection is severed!</h2>
</cfcatch>
</cftry>
</cfif>
</cfoutput>