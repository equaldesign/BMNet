<cfcomponent>
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="BeanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="PageService" inject="id:sums.PageService" />
  <cfproperty name="WireBox" inject="wirebox">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">

  <cffunction name="newPage" returntype="any">
    <cfargument name="event">
    <cfargument name="returnTemplates" required="true" default="false">
    <cfset var rc = event.getCollection()>
    <cfset var modelPaths = WireBox.getBinder().getScanLocations()>

    <cfset var pathArray = []>
    <cfset rc.templatePath = "#ExpandPath('./')#modules/sums/model/templates">
    <cfset rc.componentPath = "modules.sums.model.templates">
    <cfset rc.templates = QueryNew("name,path")>
    <cfloop collection="#modelPaths#" item="k">
      <cfset shortName = k>
      <cfif findNoCase("sums",k)>
        <cfif ListLast(k,".") eq "sums">
          <cfset ArrayAppend(pathArray,[modelPaths[k],k])>
        <cfelse>
          <cfset ArrayAppend(pathArray,[modelPaths[k],k])>
        </cfif>
      </cfif>
    </cfloop>
    <cfloop array="#patharray#" index="p">
      <cfdirectory name="templates" sort="name ASC"  action="list" directory="#p[1]#/templates" filter="*.cfc" listinfo="name" type="file">
      <cfloop query="templates">
        <cfset QueryAddRow(rc.templates)>
        <cfset QuerySetCell(rc.templates,"name",name)>
        <cfset QuerySetCell(rc.templates,"path","#p[2]#.templates")>
      </cfloop>
    </cfloop>
    <!--- now just get the unique templates --->
    <cfquery name="t" dbtype="query">
      select name, min(path) as path from rc.templates group by name
    </cfquery>
    <cfset rc.templates = t>
    <cfif arguments.returnTemplates>
      <cfreturn rc.templates>
    <cfelse>
      <cfset event.setView("admin/templates/list")>
    </cfif>
  </cffunction>

  <cffunction name="adminBar">
  	<cfargument name="event">
	  <cfset var rc = event.getCollection()>
	  <cfset rc.show = event.getValue("show")>
	  <cfif rc.show>
	  	<cfset CookieStorage.setVar("SUMSAdminBar","none",365)>
		<cfelse>
			<cfset CookieStorage.setVar("SUMSAdminBar","block",365)>
	  </cfif>
	  <cfset event.renderData(data="ok")>
	</cffunction>

  <cffunction name="emulate" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.device = event.getValue("device","iphone")>
    <cfset rc.address = event.getValue("address","http://www.buildersmerchant.net")>
    <cfset rc.orientation = event.getValue("orientation","vertical")>
    <cfset event.setLayout("Layout.ajax")>
    <cfset event.setView("admin/emulator/#rc.device#/#rc.orientation#")>
  </cffunction>

  <cffunction name="publish" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset pageName = PageService.publish(rc.nodeRef)>
    <cfset setNextEvent(uri="/html/#pageName#")>
  </cffunction>

  <cffunction name="links">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset var buildingVine = UserStorage.getVar("buildingVine")>
    <cfset rc.pageNodeRef = event.getValue("page","")>
    <cfset rc.page = PageService.proxy(
      proxyurl="sums/page/a?nodeRef=#rc.pageNodeRef#&alf_ticket=#buildingVine.user_ticket#",
      method="get",
      JSONRequest=false,
      formCollection=form,
      siteID = rc.siteID,
      alf_ticket=buildingVine.user_ticket
    ).page>
    <cfset rc.links = PageService.proxy(
      proxyurl="sums/links?pageNodeRef=#rc.pageNodeRef#&alf_ticket=#buildingVine.user_ticket#",
      method="get",
      formCollection=form,
      JSONRequest=false,
      siteID = rc.siteID,
      alf_ticket=buildingVine.user_ticket
    )>

    <cfset rc.allPages = PageService.proxy(
      proxyurl="sums/page/tree?listType=all&siteID=#rc.siteID#&alf_ticket=#buildingVine.user_ticket#",
      method="get",
      JSONRequest=false,
      formCollection=form,
      siteID = rc.siteID,
      alf_ticket=buildingVine.user_ticket
    )>
    <cfset event.setView("admin/links/list")>
  </cffunction>
</cfcomponent>