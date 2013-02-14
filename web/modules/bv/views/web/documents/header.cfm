<cfoutput>
<cfif rc.documents.metadata.permissions.userAccess.edit eq "YES" OR rc.documents.metadata.permissions.userAccess.delete eq "YES">
<div class="subnav">
  
  <ul class="pull-left">
    <cfset c = "inactive">
    <cfset d = "inactive">  
  <cfif rc.documents.cFolder neq "#request.bvsiteID#" AND rc.isAjax>
  <li><a href="/bv/documents/index?v=Documents&dir=#rc.documents.parentParent#" class=""><i class="icon-arrow-curve-090"></i> Up a Folder</a></li>  
  </cfif>
  
  <cfif IsUserLoggedIn()>
  
  <cfif rc.documents.metadata.permissions.userAccess.edit eq "YES">
    <li><a href="##" class="createFolder">Create Folder</a></li>
    <li><a id="uploadFile">Upload File</a></li>
  </cfif>
  <cfif rc.documents.metadata.permissions.userAccess.delete eq "true" AND rc.documents.parent neq rc.documentRoot>
    <li><a href="##" class="deleteFolder" rel="#rc.documents.parent#" rev="#rc.documents.parentParent#">Delete Folder</a></li>
    <li><a href="#bl("security.getSecurity","node=#rc.documents.parent#")#" class="dialog permissions folderPermissions">Folder Permissions</a></li>
  </cfif>
  </cfif>
  </ul>

</div>
</cfif>
<!---<cfif cFolder eq "Documents" AND isUserLoggedIn()>
<div class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <p><strong>Did you know...</strong> you can map a network drive to this site for easy uploading and downloading?</p>
  <p>Once setup, you can drag and drop files directly from within My Computer, and they get updated on within Building Vine&trade; straight away!</p>
  <p>Setup takes less than a few minutes.</p>
  <p><a href="/pages/Network_Drives_for_users_of_Windows_XP" class="btn btn-success dialog">View the documentation here</a></p>

</div>
</cfif>--->
<br class="clear" />
<div id="createFolder">
<form class="form-inline">
 <div class="input-append">
   <input placeholder="Enter a name" type="text" name="folderName" id="folderName"  /> <input id="button_createFolder" type="button" class="btn" value="create &raquo;" />
 </div>
</form>
 <div id="folderError"></div>
</div>
<div id="uploadQueue"></div>
<div class="clearfix">
<a class="webdav" href="##"></a>
<cfset rc.hasCategories = false>
<cfloop array="#rc.documents.items#" index="folder">
  <cfif folder.type eq "folder">
    <cfset rc.hasCategories = true>
    <cfbreak>
  </cfif>
</cfloop>
</cfoutput>