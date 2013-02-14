<cfcomponent name="blog" output="false" cache="true" cacheTimeout="30"  autowire="true">
  <cfproperty name="groups" inject="id:eunify.GroupsService">
  <cfproperty name="contact" inject="id:eunify.ContactService">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage">

  <cffunction name="administrator" access="public" returntype="void">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.showMenu = false>
    <cfset rc.contacts = groups.getContactsRemote()>
    <cfset rc.groups = groups.fullGroupList(request.siteID)>
    <cfset arguments.event.setView("groups/administrator")>
  </cffunction>

	<cffunction name="buildTree" access="remote" output="no" returnType="xml">
    <cfreturn xmlParse(groups.buildTree())>
	</cffunction>
  <cffunction name="getChildGroupsAndContacts" access="remote" returnType="query">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.groupID = arguments.event.getValue("groupID",0)>
    <cfreturn groups.getChildGroupsAndContacts(rc.groupID)>
  </cffunction>
  <cffunction name="getChildContacts" access="remote" returnType="query">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.groupID = arguments.event.getValue("groupID",0)>
    <cfset rc.hideNoEmail = arguments.event.getValue("hideNoEmail",false)>
    <cfreturn groups.getAllChildContactsforGrid(rc.groupID,rc.hideNoEmail)>
  </cffunction>
  <cffunction name="updateGroupRelationships" returnType="query" access="remote" output="no">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.groupID = arguments.event.getValue("groupID",0)>
    <cfset rc.dataGrid = arguments.event.getValue("datagrid","")>
    <cfreturn groups.updateGroupRelationships(rc.dataGrid,rc.groupID)>
  </cffunction>

  <cffunction name="createGroup" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.parentID = event.getValue("parentID","")>
    <cfset rc.groupName = event.getValue("groupName","")>
    <cfset rc.newID = groups.createGroup(rc.parentID,rc.groupName)>
    <cfset rc.json = {}>
    <cfset rc.json["groupID"] = rc.newID>
    <cfset rc.json["groupName"] = rc.groupName>
    <cfset event.renderData(type='JSON', data=rc.json)>
  </cffunction>

  <cffunction name="renameGroup" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id","")>
    <cfset rc.name = event.getValue("name","")>
    <cfset rc.newID = groups.renameGroup(rc.id,rc.name)>
    <cfset event.renderData(type='JSON',data="")>
  </cffunction>

  <cffunction name="delete" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id","")>
    <cfset groups.remove(rc.id)>
    <cfset event.renderData(type='JSON',data="")>
  </cffunction>

  <cffunction name="move" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.newParent = event.getValue("newParent",0)>
    <cfset rc.oringinalParent = event.getValue("oringinalParent",0)>
    <cfset rc.oID = event.getValue("oID",0)>
    <cfset rc.oType = event.getValue("oType",0)>
    <cfset groups.move(rc.originalParent,rc.newParent,rc.oID,rc.oType)>
    <cfset event.renderData(type='JSON',data="")>
  </cffunction>

  <cffunction name="deleteFromGroup" returnType="void">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset rc.parentID = arguments.event.getValue("parentID",0)>
    <cfset rc.oType = arguments.event.getValue("oType",0)>
    <cfset groups.deleteFromGroup(rc.id,rc.parentID,rc.oType)>
    <cfset event.renderData(type='JSON',data="")>
  </cffunction>

  <cffunction name="addToGroup" returnType="void">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset rc.parentID = arguments.event.getValue("parentID",0)>
    <cfset rc.oType = arguments.event.getValue("oType",0)>
    <cfset groups.addToGroup(rc.id,rc.parentID,rc.oType)>
    <cfset event.renderData(type='JSON',data="")>
  </cffunction>

  <cffunction name="tree" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id",0);
      rc.showUsers = arguments.event.getValue("showUsers",false);
      rc.tree = groups.getChildGroupsAndContacts(rc.id,rc.showUsers);

    </cfscript>
    <cfset rc.listItems = ArrayNew(1)>
    <cfloop query="rc.tree">
      <cfset rc.d = StructNew()>
      <cfset rc.d["attr"]["id"] = "#id#">
      <cfset rc.d["data"]["title"] = name>
      <cfset rc.d["data"]["attr"]["id"] = "#id#">
      <cfset rc.d["data"]["attr"]["title"] = "#name#">
      <cfset rc.d["attr"]["rev"] = "#oType#">
      <cfset rc.d["data"]["icon"] = "#oType#">

      <cfif oType eq "group">
      <cfset rc.d["state"] = "closed">
      </cfif>
      <cfset arrayAppend(rc.listItems,rc.d)>
    </cfloop>
    <cfset rc.json = SerializeJSON(rc.listItems)>
    <cfset arguments.event.setView("renderJSON")>
  </cffunction>
</cfcomponent>