<cfcomponent name="wiki" output="false" cache="true" cacheTimeout="30"  autowire="true">
  <cfproperty name="wiki" inject="model:WikiService">
  <cfproperty name="contact" inject="id:eunify.ContactService">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage">


  <cffunction name="tree">
    <cfargument name="event">

    <cfscript>
    var rc = arguments.event.getCollection();
    rc.id = arguments.event.getValue("id",0);
		rc.tree = wiki.list(rc.id);
		</cfscript>
    <cfset rc.logEvent = false>
		<cfset rc.listItems = ArrayNew(1)>
		<cfloop query="rc.tree">
      <cfset rc.x = StructNew()>
      <cfif children neq 0>
        <cfset rc.x["attr"]["id"] = "#id#">
	      <cfset rc.x["data"]["title"] = "#title#">
	      <cfset rc.x["data"]["attr"]["href"] = "/wiki/page/#id###wiki">
	      <cfset rc.x["state"] = "closed">
      <cfelse>
	      <cfset rc.x["data"]["title"] = title>
	      <cfset rc.x["data"]["attr"]["id"] = "#id#">
	      <cfset rc.x["data"]["attr"]["title"] = "#title#">
	      <cfset rc.x["data"]["attr"]["class"] = "tooltip">
	      <cfset rc.x["data"]["attr"]["href"] = "#arguments.event.buildLink(linkTo='wiki.page',queryString='id=#id###wiki')#">
        <cfset rc.x["data"]["icon"] = "/images/icons/language-document.png">
      </cfif>
      <cfset arrayAppend(rc.listItems,rc.x)>
    </cfloop>
    <cfset rc.json = SerializeJSON(rc.listItems)>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("renderJSON")>
  </cffunction>

	<cffunction name="page" returntype="void" output="false">
	 <cfargument name="event">

	 <cfset var rc = arguments.event.getCollection()>
	 <cfset rc.id = arguments.event.getValue("id",0)>
	 <cfset rc.parentID = arguments.event.getValue("parentID","")>
   <cfset rc.wikiPage = wiki.getWikiPage(rc.id)>
   <cfif rc.wikiPage.getid() neq "">
    <cfset rc.createdBy = contact.getContact(rc.wikiPage.getcreatedBy())>
    <cfset rc.modifiedBy = contact.getContact(rc.wikiPage.getmodifiedBy())>
   </cfif>
   <cfset arguments.event.setView("wiki/page")>
	</cffunction>

  <cffunction name="view" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.id = arguments.event.getValue("id",0)>
   <cfset rc.sess.eGroup.editMode = false>
   <cfset setNextEvent(uri="/wiki/page/#rc.id#")>
  </cffunction>

	  <cffunction name="edit" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.id = arguments.event.getValue("id",0)>
   <cfset rc.sess.eGroup.editMode = true>
   <cfset setNextEvent(uri="/wiki/page/#rc.id#")>
  </cffunction>

  <cffunction name="delete" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.id = arguments.event.getValue("id",0)>
   <cfset rc.wikiPage = wiki.getWikiPage(rc.id)>
   <cfset rc.parent = rc.wikiPage.getparentID()>
   <cfset rc.wikiPage.delete()>
   <cfset setNextEvent(uri="/wiki/page/#rc.parent#")>
  </cffunction>

  <cffunction name="doEdit" returntype="void" output="false" hint="My main event">
      <cfargument name="event">

      <!--- should probably use a bean for this - but time is of the essence! --->
      <cfscript>
        var rc = arguments.event.getCollection();
        rc.id = arguments.event.getValue('id',0);
        if (rc.id neq 0 and rc.id neq "") {
          rc.wikiPage = wiki.getWikiPage(rc.id);
          rc.wikiPage = populateModel(rc.wikiPage);
        } else {
          rc.wikiPage = populateModel(wiki);
        }
        arguments.event.setLayout('Layout.Main');
        arguments.event.setView('debug');
        rc.wikiPage.save();
				rc.sess.eGroup.editMode = false;
        setNextEvent(uri="/wiki/page/#rc.wikiPage.getid()###wiki");
      </cfscript>

    </cffunction>
</cfcomponent>
