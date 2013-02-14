<cfoutput>
<cfset document = rc.documentDetail.document>

<input type="hidden" name="nodeRef" value="#document.docNodeRef.xmlText#" />
  <cfset tree =  ReplaceNoCase(document.path.xmlText,"/Company Home","","ALL")>
  <cfset cFolder =  document.properties.title.xmlText>
  <cfif cFolder eq "">
    <!--- this is a document, and doesn't have a title --->
    <cfset cFolder =  document.properties.name.xmlText>
  </cfif>
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
      <cfset link = "#link#/#URLEncodedFormat(i)#">
    <cfelse>
      <cfset link = "#link#/#URLEncodedFormat(i)#">
       <a class="bcrumbLink ajaxMain" rel="/documents/documentList?bc=#link#" href="/documents/documentList?v=Documents&bc=#link#">#i#</a> &raquo;
    </cfif>
    <cfset counter = counter +1 >
  </cfloop>
  #cFolder#
  </div>


<div id="folderNav" class="greyBox">
  <ul>
    <cfset c = "inactive">
    <cfset d = "inactive">
  <cfif document.permissions.edit.xmlText eq "true">
    <li><a href="##" class="uploadFile">Upload File</a></li>
    <cfset c = "active">
  </cfif>
  <cfif document.permissions.delete.xmlText eq "true">
    <cfset d = "active">
    <li><a href="##" id="#document.parent.xmlText#" rel="#document.docNodeRef.xmlText#" class="deleteFile">Delete File</a></li>
    <li><a href="##" class="permissions filePermissions" id="#document.docNodeRef.xmlText#">File Permissions</a></li>
  </cfif>

  </ul>
</div>
<div id="uploadFile" class="greyBox">
  <h2>Click on browse to choose your file</h2>
  <p>You can choose multiple files..</p>
  <div id="fileUpload"></div>
</div>
<cfset flashURL = URLEncodedFormat('')>
<div id="documentWindow">
       <!---<embed type="application/x-shockwave-flash"
       src="/includes/flash/WebPreviewer.swf"
       width="670px"
       height="670px"
       id="WebPreviewer"
       name="WebPreviewer"
       quality="high"
       allowscriptaccess="sameDomain"
       allowfullscreen="true"
       wmode="transparent"
       flashvars="fileName=#document.properties.name.xmlText#&paging=true&url=/alfresco#document.properties.downloadURL.xmlText#?c=force&noCacheToken=1257980553515&alf_ticket=#rc.buildingVine.document_ticket#&show_fullscreen_button=true" />--->

 <h1><cfif document.properties.title.xmlText neq "">#document.properties.title.xmlText#<cfelse>#document.properties.name.xmlText#</cfif></h1>
 <div id="documentPreview">

    <img width="280" src="/alfresco/service/api/node/workspace/SpacesStore/#document.properties.guid.xmlText#/content/thumbnails/imgpreview?ph=true&c=queue&#request.user_ticket#" />
  </div>
 <div class="documentMeta">
    <div id="documentDownload">
      <h2><a href="/alfresco#document.properties.downloadURL.xmlText#?ticket=#rc.buildingVine.document_ticket#">
        <img hspace="5" align="left" src="/includes/images/fileExtentions/#uCase(getextension(document.properties.name.xmlText))#.png" border="0" />download file</a></h2>
        <h3>#fncFileSize(stripAllNum(document.properties.size.xmlText))#</h3>
    </div>
    <br class="clear" />
    <div id="documentAttributes" class="silver">
      <div class="accordion">
        <h5><a href="##">Document Details</a></h5>
        <div>
			    <dl>
			    <dt>Updated:</dt>
			      <dd>#document.properties.modified.xmltext#</dd>
			    <dt>Created:</dt>
			      <dd>#document.properties.created.xmltext#</dd>
			    <dt>Size:</dt>
			      <dd>#fncFileSize(stripAllNum(document.properties.size.xmlText))#</dd>
			    <dt>Modifed By:</dt>
			      <dd><a href="/profile/index?id=#urlEncrypt(document.properties.modifier.xmltext)#">#document.properties.modifier.xmltext#</a></dd>
			    <dt>Created By:</dt>
			      <dd><a href="/profile/index?id=#urlEncrypt(document.properties.creator.xmltext)#">#document.properties.creator.xmltext#</a></dd>
			    <dt>Versions: </dt>
			      <dd><cfif document.properties.versions.xmlAttributes.versioningEnabled eq "false">
			      <div class="bubbleInfo">N/A
						  <a href="/documents/enableVersioning?node=#document.docNodeRef.xmlText#" rel="/documents/enableVersioning?node=#document.docNodeRef.xmlText#" class="ajaxMain" id="makeversionable">(enable?)</a>&nbsp;<a herf="##" class="help"><img src="/images/icons/information.png" border="0" alt="help" /></a>
						  <div class="popup greyBox">
						    <h3>What is a versionable document?</h3>
			          <p>A versionable document is one that when overwritten updates automatically with the newer version, and keeps copies of the older version.</p>
						  </div>
						</div>
			      <cfelse>
			        <ul>
			        <cfloop array="#xmlsearch(document,'/document/properties/versions/version')#" index="version">
			          <li><a href="/alfresco/d/a/versionStore/version2Store/#version.nodeRef.xmlText#/#document.properties.name.xmlText#?ticket=#rc.buildingVine.document_ticket#">#version.versionNumber.xmlText#</a><br /> (#DateFormat(version.date.xmlText,"DD/MM/YY")# #TimeFormat(version.date.xmlText,"HH:MM")#)</li>
			        </cfloop>
			        </ul>
			      </cfif></dd>
			    </dl>
  		    <br class="clear" />
        </div>
        <cfif document.permissions.edit.xmlText eq "true">
        <h5><a href="##">Check In / Check Out</a></h5>
        <div></div>
        <h5><a href="##">Transform</a></h5>
        <div></div>
        <cfif uCase(getextension(document.properties.name.xmlText)) eq "CSV" AND ArrayFind(treeArray,"Product Data Files") GTE 1 AND ArrayFind(treeArray,"Sites") GTE 1>
          <cfset siteID = treeArray[ArrayFind(treeArray,"Sites")+1]>
        <h5><a href="##">Product File Import</a></h5>
        <div>
         <!---  <select id="importType">
            <option value="fullImport">Full complete import</option>
            <option value="update">update only</option>
            <option value="delete">delete the products in this file</option>
          </select>
          <input class="importProduct button">
          <table>
            <tr>
              <td><input type="radio" name=""></td>
            </tr>
          </table> --->
          <h4><a href="##" id="#siteID#" class="importProducts" rel="#document.properties.downloadURL.xmlText#">Import this file as your product data file.</a></h4>
          <div id="progressbar"></div>
          <div id="statusMessage"
        </div>
        </cfif>
        </cfif>
      </div>
    </div>
 </div>
 <br class="clear" />
</div>
<div id="newsFeed">
  <h1>updates</h1>
  <div id="feedContents">
    <cfif rc.comments.nodePermissions.create eq "YES">
    <div class="form-container">
      <a id="commentRespond"></a>
      <form id="doComment" action="/comment/doComment" method="post">
        <input type="hidden" name="nodeRef" value="#rc.nodeRef#">
        <input id="v" type="hidden" name="v" value="Site">
        <fieldset><legend>Add Comment</legend>
        <div><label for="title">Title</label>
              <input type="text" name="title" size="30">
        </div>
        <div><label for="comment">Comment</label><textarea name="comment" cols="23" rows="5" ></textarea></div>
        </fieldset>
        <div>
          <label for="submit">&nbsp;</label><input name="submit" type="submit" class="button" value="Add Comment &raquo;" />
        </div>
      </form>
      </div>
    </cfif>
  </div>
</div>
</cfoutput>