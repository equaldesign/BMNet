
<cfcontent type="application/javascript">
<cfsavecontent variable="test">
<cfoutput>
  <cfif StructKeyExists(rc.product.product,"productDocuments")>
  <div class="page-header">
    <h2>Documents</h2>
  </div>
  <table cellpadding="5" cellspacing="0">
    <cfloop array="#rc.product.product.productDocuments#" index="doc">
      <tr>
        <td width="15%">
          <a target="_blank" href="https://www.buildingvine.com/alfresco#doc.downloadUrl#?ticket=#trim(request.buildingVine.user_ticket)#">
            <img class="thumbnail" src="https://www.buildingvine.com/api/productImage?nodeRef=#listlast(doc.nodeRef,"/")#&size=75" border="0">
          </a>
        </td>
        <td valign="top">
          <h4><a target="_blank" href="https://www.buildingvine.com/alfresco#doc.downloadUrl#?ticket=#trim(request.buildingVine.user_ticket)#">#doc.title#</a></h4>
          <cfset docIcon = listFirst(listLast(doc.icon,"/"),".")>
          <p><i class="icon-filetype-#docicon#"></i> #getFileTypeName(docicon)#</p>
          <p>#fncFileSize(replace(doc.size,",","","ALL"))#</p>
        </td>
      </tr>
    </cfloop>
  </table>
    <cfif ArrayLen(rc.product.product.productDocuments) eq 0>
      <p>No documents relating to this product</p>
    </cfif>
  </cfif>
</cfoutput>
</cfsavecontent>
<cfset rc.json  = StructNew()>
<cfset rc.json["productID"] = rc.productID>
<cfset rc.json["docs"] = test>
<cfif  StructKeyExists(rc.product.product,"productDocuments") AND ArrayLen(rc.product.product.productDocuments) GTE 1>
  <cfset rc.json["hasDocs"] = true>
<cfelse>
  <cfset rc.json["hasDocs"] = false>
</cfif>
<cfset rc.json = serializeJSON(rc.json)>
<cfoutput>#rc.jsoncallback#(#rc.json#)</cfoutput>
