
<cfcomponent output="false" autowire="true">

	<!--- dependencies --->

	<cfproperty name="wikiService" inject="model:modules.bv.model.WikiService">
	<!--- index --->
	<cffunction name="index" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
				rc.wikipage = wikiService.getPage(rc.siteID,rc.name);
				event.setView("/wiki/page");

		</cfscript>
	</cffunction>

  <cffunction name="list" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.filter = event.getValue("filter","all");
      rc.wikipage = wikiService.getPageList(rc.siteID,rc.filter);
      event.setView("#rc.viewPath#/wiki/list");

    </cfscript>
  </cffunction>

  <cffunction name="bvPage" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.wikipage = wikiService.getPage("buildingVine",rc.name);
      event.setView("#rc.viewPath#/wiki/page");

    </cfscript>
  </cffunction>
</cfcomponent>