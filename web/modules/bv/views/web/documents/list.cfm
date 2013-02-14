<cfset getMyPlugin(plugin="jQuery").getDepends("form,swfobject","secure/permissions,secure/documents/detail,secure/documents/upload","secure/documents/documents,secure/documents/uploadify")>
<div id="docWin" class="ajaxWindow">
<!--- show help screen to get them to setup webdav --->
<cfoutput>
#renderView("web/documents/header")#
<cfif rc.hasCategories>
<div class="page-header"><h3>Folders</h3></div>
<table class="table table-bordered table-striped">
 <thead>
 	 <th></th>
 	 <th>Name</th>
	 <th>Sub Folders/Documents</th>
 </thead>
 <tbody>
  <cfset i = 1>
	<cfloop array="#rc.documents.items#" index="folder">
	    <cfif folder.type eq "folder">
	    <tr>
	    	<td><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/folder-horizontal-open.png" width="16" height="16" /></td>
	    	<td><a href="#bl("documents.index","v=Documents&dir=#folder.nodeRef#&siteID=#rc.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#")#" id="#folder.nodeRef#">#folder.displayName#</a></td>
				<td>#folder.children#</td>
	    </tr>
	    </cfif>
	</cfloop>
  </tbody>
</table>
</cfif>
<cfset hasDocuments = false>
<cfloop array="#rc.documents.items#" index="item">
  <cfif item.type eq "document" AND (item.actionSet neq "lockOwner" AND item.actionSet neq "locked")>
    <cfset hasDocuments = true>
    <cfbreak>
  </cfif>
</cfloop>
<cfif hasDocuments>
<div class="page-header"><h3>Documents</h3></div>
<!--- document list --->
<table class="table table-bordered table-striped">
 <thead>
 	 <th width="16"></th>
	 <th width="25"></th>

   <th>Name</th>
   <th>Size</th>
 </thead>
 <tbody>

<cfloop array="#rc.documents.items#" index="item">
  <cfif item.type eq "document" AND (item.actionSet neq "lockOwner" AND item.actionSet neq "locked")>
  <cfset nr = Replace(item.nodeRef,"://","/","ALL")>
  <tr>
  	<td><img src="https://www.buildingvine.com/alfresco/#item.icon#" /></td>
  	<td><img align="center" src="https://www.buildingvine.com/api/productImage?nodeRef=#ListLast(item.nodeRef,"/")#&size=25"></td>
		<td><a href="#bl("documents.detail","file=#item.nodeRef#&siteID=#rc.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#")#"><cfif item.DisplayName neq "">#item.DisplayName#<cfelse>#item.fileName#</cfif></td>
		<td>#item.size#</td>
  </tr>
  </cfif>
</cfloop>
</tbody>
</table>
</cfif>
</cfoutput>
</div>
</div>
