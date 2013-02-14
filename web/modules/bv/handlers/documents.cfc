
<cfcomponent cache="true" output="false" autowire="true">

	<!--- dependencies --->
	<cfproperty name="userService" inject="id:bv.UserService">
	<cfproperty name="documentService" inject="id:bv.DocumentService">
	<cfproperty name="commentService" inject="id:bv.CommentService">
	<cfproperty name="searchService" inject="id:bv.SearchService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="AuditService" inject="id:bv.AuditService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
	<!--- index --->
	<cffunction cache="true" name="index" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
      rc.dir = event.getValue("dir","");
      rc.bc = event.getValue("bc","Sites/#request.bvsiteID#/documentLibrary");
			rc.documents = documentService.documentList(folder=rc.dir,bc=rc.bc);
      rc.folder = event.getValue("folder","");
      rc.layout = event.getValue("layout","");
      if (NOT isDefined("request.buildingVine.maxRows")) {
        request.buildingVine.maxRows = 10;
        UserStorage.setVar("buildingVine",request.buildingVine);
      }
      if (NOT isDefined("request.buildingVine.layout")) {
        request.buildingVine.layout = "grid";
        UserStorage.setVar("buildingVine",request.buildingVine);
      }
      if ((rc.layout neq "" AND rc.layout neq request.buildingVine.layout)) {
      	request.buildingVine.layout = rc.layout;
      	UserStorage.setVar("buildingVine",request.buildingVine);
      }
      rc.documentRoot = documentService.checkFolder(path="/documentLibrary",siteID=request.bvsiteID).nodeRef;
			event.setView("#rc.viewPath#/documents/grid");
		</cfscript>
	</cffunction>

  <cffunction name="getFolder" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();      
      rc.folder = event.getValue("folder","");
      rc.documents = documentService.checkFolder(path=rc.folder,siteID=request.bvsiteID);
      setNextEvent(uri="/bv/documents/index?dir=#rc.documents.nodeRef#&useAjax=#event.getValue('useAjax',false)#");
    </cfscript>
  </cffunction>

	<cffunction name="createFolder" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.nodeRef = event.getValue("nodeRef","");
			rc.newFolder = event.getValue("newName","");
			rc.documents = documentService.createFolder(nodeRef=rc.nodeRef,newFolder=rc.newFolder);
				event.setLayout("Layout.ajax");
				event.setView("documents/list");

		</cfscript>
	</cffunction>

	<cffunction name="deleteFile" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.nodeRef = event.getValue("nodeRef","");
			rc.dir = event.getValue("parent","");
			documentService.deleteFile(nodeRef=rc.nodeRef);
			rc.documents = documentService.documentList(folder=rc.dir);
			event.setLayout("Layout.ajax");
			event.setView("documents/list");

		</cfscript>
	</cffunction>

	<cffunction name="deleteFolder" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.nodeRef = event.getValue("nodeRef","");
			rc.documents = documentService.deleteFolder(nodeRef=rc.nodeRef);
				event.setLayout("Layout.ajax");
				event.setView("documents/list");

		</cfscript>
	</cffunction>



	<cffunction cache="true" name="detail" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.file = event.getValue("file","");
			rc.document = documentService.documentDetail(rc.file);
      if (isUserInRole("admin_#request.bvsiteID#")) {
        rc.reach = AuditService.getReach(rc.document.qName);
      }
			rc.comments = commentService.getComments("/node/#Replace(rc.file,'://','/','ALL')#/comments");
			rc.documentRoot = documentService.checkFolder(path="",siteID=rc.siteID).nodeRef;
      rc.commentsURL = "/node/#Replace(rc.file,'://','/','ALL')#/comments";
		  rc.nodeRef = rc.document.properties.guid;
		  if (rc.document.permissions.edit) {
		    rc.documentRelationships = documentService.getAssociations("workspace://spacesStore/#rc.nodeRef#");
		  }

		  event.setView("#rc.viewPath#/documents/detail");

		</cfscript>
	</cffunction>

	<cffunction name="search" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
      var rc = event.getCollection();
      rc.query = event.getValue("query","");

      rc.boundaries = getMyPlugin(plugin="Paging").getBoundaries();
      rc.documents = searchService.search(rc.query,rc.siteID,"",rc.boundaries.startRow,rc.boundaries.maxrow);
      event.setView("documents/searchResults");
		</cfscript>

	</cffunction>


	<cffunction name="upload" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			event.setLayout("Layout.ajax");
			rc.nodeRef = event.getValue("nodeRef","");
			rc.fileData = event.getValue("fileData","");
			rc.filename = event.getValue("filename","speng");
		</cfscript>
		<cffile action="copy" source="#rc.fileData#" destination="/tmp/#rc.filename#">
		<cfscript>
			rc.documents = documentService.upload(nodeRef=rc.nodeRef,file="/tmp/#rc.filename#");
      myLogger = logBox.getLogger(this);
      myLogger.info(rc.nodeRef);
			event.setView("blank");
		</cfscript>

	</cffunction>

  <cffunction name="tree" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = event.getCollection();
      rc.id = event.getValue("id","");
      rc.documents = documentService.documentList(folder=rc.id);
    </cfscript>
    <cfset listItems = ArrayNew(1)>
    <cfloop array="#rc.documents.items#" index="item">
      <cfset x = StructNew()>
        <cfset x["data"]["title"] = "#left(item.displayName,30)#">
        <cfset x["attr"]["id"] = "#item.nodeRef#">
        <cfset x["data"]["attr"]["id"] = "#item.nodeRef#">
        <cfset x["data"]["attr"]["class"] = "ajax">
        <cfif item.type eq "document">
          <cfset x["data"]["attr"]["href"] = "/documents/detail?file=#item.nodeRef#">
          <cfset x["data"]["icon"] = "#ListLast(item.fileName,'.')#">
        <cfelse>
          <cfif item.children eq 0>
          <cfelse>
            <cfset x["state"] = "closed">
            <cfset x["attr"]["class"] = "jstree-drop">

          </cfif>
          <cfset x["data"]["attr"]["href"] = "/documents?dir=#item.nodeRef#">
        </cfif>
        <cfset arrayAppend(listItems,x)>
    </cfloop>


    <cfset rc.json = SerializeJSON(listItems)>
    <cfset event.setView("renderJSON")>
  </cffunction>

</cfcomponent>