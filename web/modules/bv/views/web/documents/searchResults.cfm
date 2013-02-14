<cfset getMyPlugin(plugin="jQuery").getDepends("form,upload,swfobject","documents/detail,documents/upload","secure/documents,uploadify,secure/search")>
<!--- show help screen to get them to setup webdav --->
<cfoutput>
<cfif rc.siteID neq "">
<div id="breadcrumb">
    <div id="blinks"><a class="ajax" href="/bv/documents/documentList?bc=/Sites/#rc.siteid#/documentLibrary&siteID=#rc.siteID#">Documents</a> &raquo; Search Results
    </div>
    #renderView("documents/search")#
  </div>
</cfif>
<cfif rc.siteID neq "">
  <cfset cl = "ajax">
<cfelse>
  <cfset cl = "">
</cfif>
<div id="results">
  <cfif isDefined('rc.documents.items')>
  <a class="webdav" href="##"></a>
  <h2>Search Results for <span class="searchterm">#rc.query#</span></h2>
  <cfif arrayLen(rc.documents.items) eq 0>
    <p>Sorry, no results matching your term were found.</p>
  </cfif>
  <cfset f = 1>
  <cfloop array="#rc.documents.items#" index="item">
    <cfif isDefined("item.site")>
      <cfset siteID = item.site.shortName>
    <cfelse>
      <cfset siteID = "">
    </cfif>
    <cfif item.type eq "folder">
      <a href="/documents/documentList?dir=#item.nodeRef#&siteID=#siteID#" class="#cl#">
	      <div class="folderLink greyBoxHover">
	        <div><img src="/includes/images/folders/folderLarge.png" /></div>
	        <div><a class="folderTitle ajax"  href="/bv/documents/documentList?v=Documents&dir=#item.nodeRef#&siteID=#siteID#" id="#item.nodeRef#">#item.displayName#</a></div>
	      </div>
      </a>
      <cfif f MOD(5) eq 0><br clear="all" class="clear" /></cfif>
      <cfset f++>
    <cfelse>
      <cfset nr = Replace(item.nodeRef,"://","/","ALL")>
      <a href="/documents/documentDetail?file=#item.nodeRef#&siteID=#siteID#" class="#cl#">
      <div class="greyBoxHover">
        <div class="search_document_image">
          <img width="75" src="http://www.buildingvine.com/alfresco/service/api/node/#nr#/content/thumbnails/doclib?ph=true&c=queue&alf_ticket=#request.user_ticket#" />
        </div>
        <div class="floatleft documentDetail">
          <h2><cfif item.DisplayName neq "">#item.DisplayName#<cfelse>#item.fileName#</cfif></h2>
          <cfif item.description neq ""><p>#item.description#</p></cfif>
            <div>#fncFileSize(stripAllNum(item.size))#</div>
            <div class="search_date">#item.modifiedOn#</div>
        </div>
        <br clear="all" class="clear" />
      </div>
      </a>
    </cfif>
 </cfloop>
 <cfelse>
 <h2>An error occurred when searching for <span class="searchterm">#rc.query#</span></h2>
 </cfif>
</div>
</cfoutput>
