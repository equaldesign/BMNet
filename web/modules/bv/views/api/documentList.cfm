<cfoutput>

  <cftry>
    <cfset layout = rc.buildingVine.preferences.layout.document_layout>
    <cfcatch type="any"><cfset layout = "largeicons"></cfcatch>
  </cftry>
  <!--- for some reason it returns a full node descripion! --->
  <cfset nr = ListToArray(rc.documents.parent," ")>
  <cfset nr = nr[ArrayLen(nr)]>
  <input type="hidden" id="folderNode" value="#nr#">
  <cfset tree =  ReplaceNoCase(rc.documents.path,"/Company Home","","ALL")>
  <cfset cFolder =  ReplaceNoCase(rc.documents.cFolder,"/Company Home","Home","ALL")>
  <cfset treeArray = ListToArray(tree,"/")>
  <cfset link = "">
  <div id="breadcrumb">
  <cfif treeArray[1] eq "Sites">
  <cfset startCounter = 3>
  <cfelse>
  <cfset startCounter = 2>
  </cfif>

  <cfset counter = 1>
  <cfloop array="#treeArray#" index="i">
    <cfif counter lt startCounter>
      <cfset link = "#link#/#i#">
    <cfelse>
      <cfset link = "#link#/#i#">
       <a class="bcrumbLink ajaxMain" rel="/documents/documentList?bc=#link#" href="/documents/documentList?v=Documents&bc=#link#">#i#</a> &raquo;
    </cfif>
    <cfset counter = counter +1 >
  </cfloop>
  #cFolder#
  </div>
<cfif rc.documents.metadata.permissions.userAccess.edit eq "YES" OR rc.documents.metadata.permissions.userAccess.delete eq "YES">
<div id="folderNav" class="greyBox">
  <ul>
    <cfset c = "inactive">
    <cfset d = "inactive">
  <cfif rc.documents.metadata.permissions.userAccess.edit eq "YES">
    <li><a href="##" class="createFolder">Create Folder</a></li>
    <li><a href="##" class="uploadFile">Upload File</a></li>
  </cfif>
  <cfif rc.documents.metadata.permissions.userAccess.delete eq "true">
    <li><a href="##" class="deleteFolder">Delete Folder</a></li>
    <li><a href="##" id="#nr#" class="permissions folderPermissions">Folder Permissions</a></li>

  </cfif>
  </ul>
</div>
</cfif>
<cfif rc.documents.metadata.permissions.userAccess.edit eq "YES">
  <cfif rc.documents.cDesc neq "">
<div class="ui-widget">
  <div  style="padding: 0pt 0.7em; margin-top: 20px;" class="ui-state-highlight ui-corner-all">
    <p><span title="this message is only seen by contributors" style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-info"/>
    #rc.documents.cDesc#</p>
  </div>
</div>
</cfif>
</cfif>
<br class="clear" />
<div id="createFolder" class="greyBox">
  <label for="folderName">Folder Name</label><input type="text" name="folderName" id="folderName" class="niceInput" /> <input id="button_createFolder" type="button" class="button" value="create &raquo;" />
  <div id="folderError"></div>
</div>
<div id="uploadFile" class="greyBox">
  <h2>Click on browse to choose your file</h2>
  <p>You can choose multiple files..</p>
  <div id="fileUpload"></div>
</div>
<!--- folder list --->
<cfif layout eq "largeicons">
<cfset i = 1>
<div id="folders">
<cfif rc.documents.metadata.itemCounts.folders gte 1><h2>Folders</h2></cfif>
<cfloop array="#rc.documents.items#" index="folder">
    <cfif folder.type eq "folder">
    <div rel="/documents/documentList?dir=#folder.nodeRef#" class="ajaxMain folderLink greyBoxHover">
    <div><img src="/includes/images/folders/folderLarge.png" /></div>
    <div><a class="folderTitle"  href="/documents/documentList?v=Documents&dir=#folder.nodeRef#" id="#folder.nodeRef#">#folder.displayName# (#folder.children#)</a></div>
    </div>
    <cfif i MOD(4) eq 0><br class="clear" /></cfif>
<cfset i = i + 1>
</cfif>
</cfloop>
</div>
<cfelse>
	<table class="tablesorter" cellspacing="1">
	  <thead>
	   <tr>
	     <th>Folder Name</th>
	   </tr>
	  </thead>
	  <tbody>
	  <cfloop array="#rc.documents.items#" index="folder">
     <cfif folder.type eq "folder">
	   <tr rel="/documents/documentList?dir=#folder.nodeRef#">
	     <td><a class="ajaxMain" rel="/documents/documentList?dir=#folder.nodeRef#" href="/documents/documentList?v=Documents&dir=#folder.nodeRef#" id="#folder.nodeRef#">#folder.displayName# (#folder.children#)</a></td>
	   </tr>
     </cfif>
	  </cfloop>
	  </tbody>
	 </table>
</cfif>

<br class="clear" />
<!--- document list --->
<cfif layout eq "largeicons">
<div id="documents">
<cfif rc.documents.metadata.itemCounts.documents gte 1><h2>Documents</h2></cfif>
<cfloop array="#rc.documents.items#" index="item">
  <cfif item.type eq "document" AND (item.actionSet neq "workingCopyOwner" AND item.actionSet neq "workingCopy")>
  <cfset nr = Replace(item.nodeRef,"://","/","ALL")>
 <div rel="/documents/documentDetail?file=#item.nodeRef#" class="greyBoxHover docLink">
   <div class="search_document_image">
    <img width="75" src="/alfresco/service/api/node/#nr#/content/thumbnails/doclib?ph=true&c=queue&#request.user_ticket#" />
   </div>
   <div class="floatleft documentDetail">
    <h2><cfif item.DisplayName neq "">#item.DisplayName#<cfelse>#item.fileName#</cfif></h2>
    <cfif item.description neq ""><p>#item.description#</p></cfif>
    <div>#fncFileSize(stripAllNum(item.size))#</div>
    <div class="search_date">#item.modifiedOn#</div>
  </div>
 <br class="clear" />
</div>
</cfif>
</cfloop>
<cfelse>
  <table class="tablesorter" cellspacing="1">
    <thead>
     <tr>
       <th>Document Name</th>
       <th>Size</th>
       <th>Last Modified</th>
     </tr>
    </thead>
    <tbody>
    <cfloop array="#rc.documents.items#" index="item">
     <cfif item.type eq "document" AND (item.actionSet neq "workingCopyOwner" AND item.actionSet neq "workingCopy")>
     <tr>
       <td><a class="ajaxMain" href="/documents/documentDetail?file=#item.nodeRef#&v=Documents" rel="/documents/documentDetail?file=#item.nodeRef#"><cfif item.DisplayName neq "">#item.DisplayName#<cfelse>#item.fileName#</cfif></a></td>
       <td>#fncFileSize(stripAllNum(item.size))#</td>
       <td>#DateFormat(cdt3(item.modifiedOn),"DD/MM/YYYY")# #TimeFormat(cdt3(item.modifiedOn),"HH:MM")#</td>
     </tr>
     </cfif>
    </cfloop>
    </tbody>
   </table>
</cfif>
</cfoutput>
</div>