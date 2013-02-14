<cfset getMyPlugin(plugin="jQuery").getDepends("form,swfobject,upload","secure/permissions,secure/documents/detail,secure/documents/upload","secure/documents/documents,secure/documents/uploadify")>
<div id="docWin" class="ajaxWindow">
<!--- show help screen to get them to setup webdav --->
<cfoutput>
#renderView("web/documents/header")#

<br />

<ul class="thumbnails">
<cfset i = 1>
<cfloop array="#rc.documents.items#" index="folder">
    <cfif folder.type neq "document">
    <li class="span2">
	    <a class="thumbnail doc" href="#bl("documents.index","v=Documents&dir=#folder.nodeRef#&siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#")#" id="#folder.nodeRef#">
	      <img align="center" border="0" src="/includes/images/secure/documents/folders/folderLarge.png" /><br />
	      <p class="wordbreak">#left(folder.displayName,20)# (#folder.children#)</p>
	    </a>
		</li>
    </cfif>
</cfloop>
</ul>
<!--- document list --->
<ul class="thumbnails">
<cfloop array="#rc.documents.items#" index="item">
  <cfif item.type eq "document" AND (item.actionSet neq "lockOwner" AND item.actionSet neq "locked")>
  <cfset nr = Replace(item.nodeRef,"://","/","ALL")>
  <li class="span2">
  <a href="#bl("documents.detail","file=#item.nodeRef#&siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#")#" class="ttip thumbnail doc ajax" title="<cfif item.DisplayName neq "">#item.DisplayName#<cfelse>#item.fileName#</cfif>">
    <img class="img-polaroid" align="center" src="https://www.buildingvine.com/api/productImage?nodeRef=#ListLast(item.nodeRef,"/")#&size=100&crop=true">
    <span class="#item.actionSet#"></span>
    <p class="wordbreak"><cfif item.DisplayName neq "">#left(item.DisplayName,20)#<cfelse>#left(item.fileName,20)#</cfif></p>
  </a>
	</li>
  </cfif>
</cfloop>
</ul>
</cfoutput>
</div>
</div>
