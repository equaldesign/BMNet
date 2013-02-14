<cfset getMyPlugin(plugin="jQuery").getDepends("uploadify/ul,flexPaper,swfobject","dms/dms,dms/upload","documents/documents,documents/uploadify")>
<cfoutput>
<cftry>
<div id="breadcrumb">
  <a rev="docs" class="bcrumbLink ajax" rel="#bl('documents.categoryList','id=0')#" href="#bl('documents.categoryList','id=0')#">Documents</a>
  <cfloop array="#rc.tree#" index="item">
    <span class="dmssep ui-icon"></span>   <a rev="docs" class="bcrumbLink ajax" rel="#bl('documents.categoryList','id=#item.id#')#" href="#bl('documents.categoryList','id=#item.id#')#">#capFirstTitle(item.name)#</a>
  </cfloop>
  </div>

<input type="hidden" id="categoryID" value="#rc.document.categoryID#">
<input type="hidden" id="documentID" value="#rc.document.id#">
<input type="hidden" id="cfid" value="#cfid#" /><input type="hidden" id="cftoken" value="#cftoken#" /><input type="hidden" id="jsessionid" value="#jsessionid#" />
<cfif IsUserInAnyRole("admin,edit,Categories")>
<div id="folderNav" class="greyBox">
  <ul>
    <li><a rev="docs" rel="#bl('documents.categoryList','id=#rc.tree[ArrayLen(rc.tree)].id#')#" href="#bl('documents.categoryList','id=#rc.tree[ArrayLen(rc.tree)].id#')#" class="ajax backUp">Back/Up a Level</a></li>
    <cfif IsUserInAnyRole("admin,edit")>
    <li><a href="##" rev="" rel="" class="deleteDMSFile">Delete File</a></li>
    <li><a href="##" id="uploadNewVersion" class="uploadDMSFile">Upload New Version</a></li>
    <li><a href="##" class="DMSfileInfo" id="">File Info</a></li>
    </cfif>
  </ul>
  <br clear="all"/>
</div>
</cfif>
<cfcatch type="any"></cfcatch>
</cftry>
<div id="uploaddmsfiles"></div>
<div id="flexPaper" rel="/eGroup/documents/flexPaper/id/#rc.document.id#"></div>
<div id="documentWindow">
  <h1 id="documentName">#rc.document.name#</h1>
  <cfif rc.document.description neq "">
    <div class="blueBox" style="margin-bottom: 10px;">
      <p>#paragraphFormat2(rc.document.description)#</p>
      <cfif rc.document.timeSensitive>
        <span class="validityPeriod">Valid from: #DateFormatOrdinal(rc.document.validFrom,"DDDD D MMMM YYYY")# until #DateFormatOrdinal(rc.document.validTo,"DDDD D MMMM YYYY")#</span>
      </cfif>
    </div>
  </cfif>
  <div id="documentPreview">
    <cfif rc.document.timeSensitive>
      <cfif DateCompare(rc.document.validFrom,now()) lte 0 AND DateCompare(rc.document.validTo,now()) gte 0>
        <div class="dmsNotification_large active"></div>
      <cfelseif DateCompare(rc.document.validFrom,now()) gte 0>
        <div class="dmsNotification_large inactive"></div>
      <cfelse>
        <div class="dmsNotification_large expired"></div>
      </cfif>
    </cfif>
    <img width="280" src="/modules/eGroup/includes/images/thumbnails/#rc.moduleSettings.eGroup.settings.siteName#/#rc.document.id#.jpg" />
  <cfif isUserInAnyRole("admin,author")>
  <div><b>Link:</b> <input type="text" size="30" value="http://#cgi.http_host##bl('eGroup.documents.download','id=#rc.document.id#')#" /></div>
   <div><b>Embed Link:</b> <input type="text" size="30" value="http://#cgi.http_host##bl('eGroup.documents.inline','id=#rc.document.id#')#" /></div>
  </cfif>
  </div>
  <div class="documentMeta">
    <div id="documentDownload">
    <h2><img class="fileExt" src="/modules/eGroup/images/icons/fileExtentions/#uCase(rc.document.filetype)#.png" border="0" />
      <a class="noAjax fileDownload" href="#bl('documents.download','id=#rc.document.id#')#">download file</a>
      <a class="noAjax fileView" rel="" href="##">view file</a><br />
    </h2>
      <br><br><br><h3>#fncFileSize(stripAllNum(rc.document.size))# </h3>
    </div>
    <br clear="all" class="clear" />
    <div id="documentAttributes" class="silver">
      <cfif rc.document.timeSensitive>
      <h2 class="validity">Validity Period</h2>
      <p>From #dateFormatOrdinal(rc.document.validFrom,"D MMMM YYYY")# until #dateFormatOrdinal(rc.document.validTo,"D MMMM YYYY")#</p>
      </cfif>
      <h3>Document Details</h3>
      <div>
        <dl>
        <dt>Updated on:</dt>
          <dd>#dateFormatOrdinal(rc.document.modified,"DDDD DD MMMM YYYY")# at #TimeFormat(rc.document.modified,"SHORT")#</dd>
        <dt>Size:</dt>
          <dd>#fncFileSize(stripAllNum(rc.document.size))#</dd>

        <cfif rc.document.filetype eq "pdf" AND isDefined("rc.pdfInfo.author")>
        <dt>Author:</dt>
          <dd>#rc.pdfInfo.author#</dd>
        <dt>Pages:</dt>
          <dd>#rc.pdfInfo.totalPages#</dd>
        <dt>Created:</dt>
          <dd>#rc.pdfInfo.created#</dd>
        <dt>Modified:</dt>
          <dd>#rc.pdfInfo.modified#</dd>
        </cfif>

        </dl>
         <br class="clear" />

        <cfif isUserInRole("edit") AND rc.sess.buildingVine.user_ticket neq "">
        <cfif (rc.document.filetype eq "xls" OR rc.document.filetype eq "xlsx")>

          <cfset topLevel = getModel("dms").getParentsUntil(rc.document.categoryID,"","company","")>
          <cfif NOT isBoolean(topLevel)>
            <cfset rc.company = getModel("company").getCompany(topLevel.relatedID)>
          </cfif>
          <cfif rc.company.getbuildingVine() eq "true">
            <!--- the document is related to a company, and that company in in Building Vine --->
            <a href="/bv/tools/importPrices?siteID=#rc.company.getbvsiteid()#&docID=#rc.id#" class="noAjax dialog importBV">
              <h4>Import Price List</h4>
              <p>Import this price list into Building Vine&trade;</p>
            </a>
          <cfelse>
            Building Vine not active
          </cfif>
        </cfif>
        </cfif>

      </div>
    </div>
  </div>
  <br clear="all" class="clear" />
</div>
</cfoutput>



