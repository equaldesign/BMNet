<cfset getMyPlugin(plugin="jQuery").getDepends("uploadify/ul,flexPaper,swfobject","dms/dms,dms/upload","documents/documents,documents/uploadify")>
<div id="docs" class="ajaxWindow">

<input id="baseDMSURL" value="" type="hidden" />
<cfoutput>
<cfif isDefined("rc.tree")>
  <div id="breadcrumb">
    <a rev="docs" class="ajax bcrumbLink" rel="address:#bl('documents.categoryList','id=0')#" href="#bl('documents.categoryList','id=0')#">Documents</a>
    <cfloop array="#rc.tree#" index="item">
       <span class="dmssep ui-icon"></span>  <a rev="docs" class="ajax bcrumbLink" rel="address:#bl('documents.categoryList','id=#item.id#')#" href="#bl('documents.categoryList','id=#item.id#')#">#capFirstTitle(item.name)#</a>
    </cfloop>
    </div>
  <input type="hidden" id="categoryID" value="#rc.category.id#">

  <div id="folderNav" class="greyBox">
    <ul>
      <cfif ArrayLen(rc.tree) gt 1>
        <cfset parentCat = rc.tree[ArrayLen(rc.tree)-1].id>
      <cfelse>
        <cfset parentCat = rc.tree[ArrayLen(rc.tree)].id>
      </cfif>
      <li><a rev="docs" rel="#bl('documents.categoryList','id=#parentCat#')#" href="#bl('documents.categoryList','id=#parentCat#')#" class="ajax backUp">Back/Up a Level</a></li>
      <cfif IsUserInAnyRole("admin,edit,Categories")>
      <li><a href="##" class="createDMSFolder">Create Folder</a></li>
      <li><a href="##" id="uploadDMSFile" class="uploadDMSFile">Upload File</a></li>
      <cfif IsUserInAnyRole("admin,edit")>
      <li><a href="##" class="deleteDMSFolder">Delete Folder</a></li>
      <li><a href="##" class="DMSfolderInfo">Folder Info</a></li>
      </cfif>
      </cfif>
    </ul>
    <br clear="all" />
  </div>

  <br class="clear" />
  <div id="createDMSFolder" class="greyBox">
    <label for="folderName">Folder Name</label><input type="text" name="DMSfolderName" id="DMSfolderName" class="niceInput" /> <input id="button_createDMSFolder" type="button" class="button" value="create &raquo;" />
    <div id="folderError"></div>
  </div>
  <div id="uploaddmsfiles"></div>
  <cfif rc.category.description neq "">
  <div class="blueBox">
    <h3>#rc.category.name#</h3>
    <p>#paragraphFormat2(rc.category.description)#</p>
    <cfif rc.category.timeSensitive>
      <span class="validityPeriod">Valid from: #DateFormatOrdinal(rc.category.validFrom,"DDDD D MMMM YYYY")# until #DateFormatOrdinal(rc.category.validTo,"DDDD D MMMM YYYY")#</span>
    </cfif>
  </div>
  </cfif>
</cfif>
<cfset i = 1>
<div id="folders">
<a class="webdav" href="##"></a>
<cfloop query="rc.folders">
    <a rev="docs" class="ajax" href="#bl('documents.categoryList','id=#id#')#">
      <div class="folderLink greyBoxHover">
        <div class="search_folder_image">
          <cfif timeSensitive AND (isDate(validFrom) AND isDate(validTo))>
          <cfif DateCompare(validFrom,now()) lte 0 AND DateCompare(validTo,now()) gte 0>
            <div class="dmsNotification_small active"></div>
          <cfelseif DateCompare(validFrom,now()) gte 0>
            <div class="dmsNotification_small inactive"></div>
          <cfelse>
            <div class="dmsNotification_small expired"></div>
          </cfif>
        </cfif>
          <img border="0" src="/modules/eGroup/includes/images/folders/folderLarge.png" />
        </div>
        <div>#name#</div>
      </div>
    </a>
    <cfif currentRow MOD(4) eq 0><br clear="all" class="clear" /></cfif>
</cfloop>
</div>


<br clear="all" class="clear" />
<!--- document list --->
<div id="documents">
<cfloop query="rc.documents">
  <a rev="docs" class="ajax" href="#bl('documents.detail','id=#id#')#">
    <div class="greyBoxHover">
     <div class="search_document_image">
      <cfif timeSensitive>
        <cfif DateCompare(validFrom,now()) lte 0 AND DateCompare(validTo,now()) gte 0>
          <div class="dmsNotification_small active"></div>
        <cfelseif DateCompare(validFrom,now()) gte 0>
          <div class="dmsNotification_small inactive"></div>
        <cfelse>
          <div class="dmsNotification_small expired"></div>
        </cfif>
      </cfif>
      <img border="0" width="75" src="/modules/eGroup/includes/images/thumbnails/#rc.moduleSettings.eGroup.settings.siteName#/#id#_small.jpg" />
     </div>
     <div class="floatleft documentDetail">
      <h2>#name#</h2>
      <cfif description neq ""><p>#description#</p></cfif>
      <div>#fncFileSize(stripAllNum(size))#</div>
      <div class="search_date">Updated on #dateFormatOrdinal(modified,"DDDD DD MMMM YYYY")# at #TimeFormat(modified,"short")#</div>
    </div>
    <br clear="all" class="clear" />
    </div>
  </a>
</cfloop>

</cfoutput>
</div>

</div>