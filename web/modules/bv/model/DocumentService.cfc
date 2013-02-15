<cfcomponent outut="false" hint="The bvine module service layer" cache="true">

	<!--- Dependencies --->

	<cfproperty name="userService" inject="model:UserService"  scope="instance" />
  <cfproperty name="logBox" inject="logBox" />
	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

	<cffunction name="createFolder" access="public" returntype="any" output="false">
	    <cfargument name="nodeRef" required="true" type="string">
	    <cfargument name="newFolder" required="true" type="string">
	    <cfset var ticket = request.buildingVine.user_ticket>
	    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/docs/folders/create.xml?folder=#nodeRef#&name=#newName#&alf_ticket=#ticket#" result="folderList"></cfhttp>
	    <cfif folderList.StatusCode neq "200 OK">
	      <cfdump var="#folderList#">
	    <cfelse>
	     <cfset rc.folders = xmlParse(folderList.fileContent)>
	    </cfif>
	    <cfreturn documentList(folder=rc.folders.result.nodeRef.xmlText)>
  </cffunction>

  <cffunction name="getRecent" access="public" returntype="any" output="false">
      <cfargument name="nodeRef" required="true" type="string">      
      <cfset var ticket = request.buildingVine.user_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service//bv/recent/documents?nodeRef=#nodeRef#&alf_ticket=#ticket#" result="folderList"></cfhttp>      
      <cfreturn deserializeJSON(folderList.fileContent)>
  </cffunction>

  <cffunction name="brochureBrowser" access="public" returntype="any" output="false">       
      <cfset var ticket = request.buildingVine.admin_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/docs/brochures/list.json?alf_ticket=#ticket#" result="bb"></cfhttp>
      <cfreturn DeserializeJSON(bb.fileContent)>
  </cffunction>

	<cffunction name="deleteFile" access="public" returntype="void" output="false">
		<cfargument name="nodeRef" required="true" type="string">
		<cfset var ticket = request.buildingVine.user_ticket>
    <cfset nodeRef = Replace(nodeRef,":/","","all")>

		<cfhttp port="8080" method="delete" url="http://46.51.188.170/alfresco/service/api/node/#nodeRef#?alf_ticket=#ticket#" result="parentID"></cfhttp>
	</cffunction>

	<cffunction name="deleteFolder" access="public" returntype="any" output="false">
		<cfargument name="nodeRef" required="true" type="string">
		<cfset var ticket = request.buildingVine.user_ticket>
		<cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/docs/folders/delete.xml?folder=#nodeRef#&alf_ticket=#ticket#" result="parentID"></cfhttp>
		<cfif parentID.StatusCode neq "200 OK">
		  <cfdump var="#folderList#">
		<cfelse>
		  <cfset result = xmlParse(parentID.fileContent)>
		</cfif>
		<cfreturn documentList(folder=result.result.nodeRef.xmlText)>
	</cffunction>

	<!--- getParentListing --->
	<cffunction name="documentList" access="public" returntype="any" output="false">
	    <cfargument name="root" required="true" default="">
	    <cfargument name="file" required="true" default="">
	    <cfargument name="id" required="true" default="">
	    <cfargument name="folder" required="true" default="">
	    <cfargument name="bc" required="true" default="">
	    <cfargument name="encID" required="true" default="">
	    <cfargument name="userID" required="true" default="">
	    <cfset var ticket = request.buildingVine.user_ticket>
	    <cfif encID neq "">
	      <cfset userID = urlDecrypt(encID,"cockcheddar")>
	    </cfif>
	    <cfhttp port="8080" url="http://46.51.188.170:8080/alfresco/service/bvine/docs/list/document/site/buildingvine/documentLibrary?userID=#userID#&folderName=#URLEncodedFormat(bc)#&folder=#folder#&alf_ticket=#ticket#" result="documentList"></cfhttp>
        <cfreturn DeserializeJSON(documentList.fileContent)>
  	</cffunction>

	<cffunction name="documentDetail" access="public" returntype="any" output="false">
	    <cfargument name="file" required="true" type="string">
	    <cfset var ticket = request.buildingVine.user_ticket>
	    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/docs/files/getFile.json?file=#file#&alf_ticket=#ticket#" result="doc"></cfhttp>
	    <cfif doc.StatusCode neq "200 OK">
	      <cfdump var="#doc#">
	    <cfelse>
	   	 <!---<cfset documentDetail = xmlParse(documentDetail.fileContent)>--->
        <cftry>
	      <cfset documentDetail = DeserializeJSON(doc.fileContent)>
        <cfcatch type="any">
          <cfset documentDetail = doc.fileContent>
        </cfcatch>
        </cftry>
	    </cfif>
	    <cfreturn documentDetail>
  	</cffunction>

	<cffunction name="upload" access="public" returntype="Any" output="false">
		<cfargument name="nodeRef" required="true" type="string">
		<cfargument name="file" required="true">
		<cfset var ticket = request.buildingVine.user_ticket>
        <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/bvine/docs/files/upload.xml?alf_ticket=#ticket#" result="uploadFile">
        <cfhttpparam type="formfield" name="folder" value="#nodeRef#">
        <cfhttpparam type="file" name="file" mimetype="#getPageContext().getServletContext().getMimeType('#file#')#" file="#file#">
        </cfhttp>
        <cfscript>
        myLogger = logBox.getLogger(this);
      myLogger.info(uploadFile.fileContent);
        </cfscript>
        <cfreturn uploadFile.fileContent>
	</cffunction>

  <cffunction name="search" access="public" returntype="any" output="false">
      <cfargument name="query" required="true" type="string" default="">
      <cfargument name="siteID" required="true" type="string" default="">
      <cfargument name="container" required="true" type="string" default="">
      <cfargument name="startRow" required="true" type="numeric" default="1">
      <cfargument name="maxrow" required="true" type="numeric" default="10">
      <cfset var ticket = request.buildingVine.user_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/search/documents.json?term=#query#&site=#siteID#&container=#container#&maxrows=#maxRow#&startRow=#startRow#&alf_ticket=#ticket#" result="searchResult">
      <cfreturn DeserializeJSON(searchResult.fileContent)>
    </cffunction>

  <cffunction name="getAssociations" returntype="any">
    <cfargument name="nodeRef">
    <cfset var ticket = request.buildingVine.user_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/product/document/associations?nodeRef=#arguments.nodeRef#&alf_ticket=#ticket#" result="searchResult">
      <cfreturn DeserializeJSON(searchResult.fileContent)>
  </cffunction>

    <cffunction name="checkFolder" access="public" returntype="any" output="false">
      <cfargument name="path" required="true" default="">
      <cfargument name="siteID" required="true" default="">
      <cfset var ticket = request.buildingVine.admin_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/folder/check.json?f=#arguments.path#&siteID=#arguments.siteID#&alf_ticket=#ticket#" result="documentList"></cfhttp>
      <cfreturn DeserializeJSON(documentList.fileContent)>
    </cffunction>
</cfcomponent>