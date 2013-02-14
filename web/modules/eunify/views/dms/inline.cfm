<cfif rc.document.recordCount neq 0>
<cfcontent file="#rc.fileName#" type="#getPageContext().getServletContext().getMimeType('#rc.fileName#')#">
<cfelse>

<h4>Access Denied/File not found</h4>
<p>Either the file no longer exists, or you do not have permission to access this resource.</p>
</cfif>