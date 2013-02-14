
<cfcomponent cache="true" output="false" autowire="true">
  <cfproperty name="SiteService" inject="id:bv.SiteService" scope="instance">
  <cfproperty name="ProductService" inject="id:bv.ProductService" scope="instance">
  <cfproperty name="BlogService" inject="id:bv.BlogService" scope="instance">
  <cfproperty name="PromotionService" inject="id:bv.PromotionService" scope="instance">
  <cfproperty name="UserService" inject="id:bv.UserService" scope="instance">
  <cfproperty name="logger" inject="logbox:root" scope="instance">
  <!--- dependencies --->

  <!--- index --->
  <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      if (NOT rc.isAjax) {
        setNextEvent(uri="/bv/site/overview?siteID=#rc.siteID#");
      } else {
        request.bvsiteID = rc.siteID;
        rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER");
        event.setView("web/sites/menu");
      }
      rc.leftMenu = "site/overview";
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="menu" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      event.setView("web/sites/menu");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="buyinggroups" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.groupInfo = instance.SiteService.getBuyingGroups(request.bvsiteID);
      rc.site = instance.SiteService.getSite(request.bvsiteID);
      rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER");
      event.setView("#rc.viewPath#/sites/manage/buyingGroups");
      rc.leftMenu = "site/overview";
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="followers" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.site = instance.SiteService.getSite(request.bvsiteID);
      rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER");
      rc.leftMenu = "site/overview";
      event.setView("#rc.viewPath#/sites/followers");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="list" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.leftMenu = "feed";
      rc.q = event.getValue("q","");
      rc.type = event.getValue("type","");
      rc.ut = event.getValue("ut","");
      rc.sites = instance.SiteService.filterList(rc.q,rc.type,rc.ut);      
      rc.numberOfSites = instance.SiteService.totalSites();
      rc.invitations = instance.UserService.getInvitations(request.buildingVine.username);
      rc.leftMenu = "site/list";
      event.setView("web/sites/list");
    </cfscript>
  </cffunction>

  <cffunction name="filter" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.q = event.getValue("q","")>
    <cfset rc.type = event.getValue("type","")>
    <cfset rc.ut = event.getValue("ut","")>
    <cfset rc.startRow = event.getValue("startRow",0)>
    <cfset rc.leftMenu = "site/list">
    <cfset rc.invitations = instance.UserService.getInvitations(request.buildingVine.username)>
    <cfset rc.sites = instance.SiteService.filterList(rc.q,rc.type,rc.ut)>
    <cfset event.setView("#rc.viewPath#/sites/filterList")>
  </cffunction>

  <cffunction cache="true" name="logo" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.site = instance.SiteService.getSite(request.bvsiteID);
      rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER");
      rc.leftMenu = "site/overview";
      event.setView("#rc.viewPath#/sites/manage/editLogo");
    </cfscript>
  </cffunction>

  <cffunction name="headerDo" returntype="void">
  	<cfargument name="event">
	  <cfset var rc = event.getCollection()>
	  <cfset rc.colour = event.getValue("colour","inherit")>
	  <cfquery name="updateSite" datasource="bvine">
	  	update site set headerColour = <cfqueryparam cfsqltype="cf_sql_varchar" value="###rc.colour#">
		  where
		  shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">
	  </cfquery>
	  <cfset setNextEvent(uri="/site/header/siteID/#rc.siteID#")>
  </cffunction>
  <cffunction name="crop" rreturntype="void">
  	<cfargument name="event">
	  <cfset var rc = event.getCollection()>
	  <cfswitch expression="#rc.size#">
	  	<cfcase value="large">
        <cfimage action="read" name="logo" source="#rc.app.appRoot#/includes/images/companies/#rc.site#/temp.jpg" >
		    <cfset imageCrop(logo,rc.x,rc.y,rc.w,rc.h)>
			  <cfimage action="write" destination="#rc.app.appRoot#/includes/images/companies/#rc.site#/large.jpg" source="#logo#" overwrite="true">
		  </cfcase>
		  <cfcase value="thumb">
        <cfimage action="read" name="logo" source="#rc.app.appRoot#/includes/images/companies/#rc.site#/temp_thumb.jpg" >
        <cfset imageCrop(logo,rc.x,rc.y,rc.w,rc.h)>
        <cfimage action="write" destination="#rc.app.appRoot#/includes/images/companies/#rc.site#/small.jpg" source="#logo#" overwrite="true">
      </cfcase>
      <cfcase value="transparent">
        <cfimage action="read" name="logo" source="#rc.app.appRoot#/includes/images/companies/#rc.site#/temp.png" >
        <cfset imageCrop(logo,rc.x,rc.y,rc.w,rc.h)>
        <cfimage action="write" destination="#rc.app.appRoot#/includes/images/companies/#rc.site#.png" source="#logo#" overwrite="true">
      </cfcase>
	  </cfswitch>
	  <cfset event.renderData(data="ok",type="text")>
  </cffunction>

  <cffunction name="overview" rreturntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
	  <cfset rc.leftMenu = "site/overview">
    <cfset rc.site = instance.SiteService.getSite(request.bvsiteID)>
	  <cfset rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER")>
    <cfset event.setView("#rc.viewPath#/sites/detail")>
  </cffunction>

  <cffunction name="settings" rreturntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.site = instance.SiteService.getSite(request.bvsiteID)>
    <cfset rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER")>
    <cfset rc.leftMenu = "site/overview">
    <cfset  event.setView("#rc.viewPath#/sites/manage/settings")>
  </cffunction>

  <cffunction cache="true" name="uploadLogo" returntype="void" output="false">
    <cfargument name="Event">
    <cfset var rc = event.getCollection()>
    <cfset rc.size = event.getValue("size","large")>
    <cfset rc.site = event.getValue("siteID","")>
    <cfswitch expression="#rc.size#">
      <cfcase value="large">
	  	  <cffile action="upload" filefield="fileData" nameconflict="overwrite" destination="ram://#rc.siteID#.jpg">
        <cfimage action="read" name="logo" source="ram://#rc.site#.jpg">
				<cfimage action="resize" height="100" source="#logo#" width="" name="logo">
				<cfif logo.width GT 400>
				  <cfimage action="resize" height="" source="#logo#" width="350" name="logo">
				</cfif>
			  <cfimage action="write" overwrite="yes" destination="#rc.app.appRoot#/includes/images/companies/#rc.site#/temp.jpg" source="#logo#">
      </cfcase>
      <cfcase value="thumb">
	  	  <cffile action="upload" filefield="fileData" nameconflict="overwrite" destination="ram://#rc.siteID#.jpg">
        <cfimage action="read" name="logo" source="ram://#rc.site#.jpg">
		    <cfif logo.width GT logo.height>
          <cfimage action="resize" height="46" source="#logo#" width="" name="logo">
		    <cfelse>
				  <cfimage action="resize" height="" source="#logo#" width="46" name="logo">
			  </cfif>
        <cfimage action="write" overwrite="yes" destination="#rc.app.appRoot#/includes/images/companies/#rc.site#/temp_thumb.jpg" source="#logo#">
      </cfcase>
      <cfcase value="transparent">
	  	  <cffile action="upload" filefield="fileData" nameconflict="overwrite" destination="ram://#rc.siteID#.png">
        <cfimage action="read" name="logo" source="ram://#rc.site#.png">
        <cfimage action="resize" height="75" source="#logo#" width="" name="logo">
		    <cfif logo.width GT 400>
          <cfimage action="resize" height="" source="#logo#" width="350" name="logo">
        </cfif>
        <cfimage action="write" overwrite="yes" destination="#rc.app.appRoot#/includes/images/companies/#rc.site#/temp.png" source="#logo#">
      </cfcase>
    </cfswitch>
    <cfset event.renderData(data="ok",type="text")>
  </cffunction>

  
  <cffunction name="robots" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("robots",true)>
  </cffunction>

  <cffunction name="updateStatus" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.siteID = event.getValue("siteID",0)>
    <cfset rc.percentDone = event.getValue("percentDone",0)>
    <cfquery name="u" datasource="bvine">
      update site set productImportStatus = <cfqueryparam cfsqltype="cf_sql_integer" value="#rc.percentDone#">,
      importStatusLastTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
      where shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">
    </cfquery>
    <cfset event.renderData(data="OK - #rc.siteID#, #rc.percentDone#")>
  </cffunction>

  <cffunction name="getImportStatus" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset var jsonoutput = {}>
    <cfset rc.siteID = event.getValue("siteID",0)>
    <cfset result = instance.SiteService.getImportStatus(rc.siteID)>
    <cfset jsonoutput.status = result.productImportStatus>
    <cfset jsonoutput.secondsAgo = result.importStatusLastTime>
    <cfset event.renderData(data=jsonoutput,type="JSON")>
  </cffunction>

  <cffunction name="manage" returntype="void" output="false" cache="true" cacheTimeout="0">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.leftMenu = "site/overview">
    <cfset rc.site = instance.SiteService.getSite(request.bvsiteID)>
    <cfset rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER")>
    <cfset event.setView("web/sites/manage/list")>
  </cffunction>

  <cffunction name="listUsers" returntype="void" output="false" cache="true" cacheTimeout="0">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.role = event.getValue("role","SiteConsumer")>
    <cfset rc.site = instance.SiteService.getSite(request.bvsiteID)>
    <cfset rc.members = instance.siteService.getMembership(rc.siteID,rc.role)>
    <cfset event.setView("web/sites/manage/userList")>
  </cffunction>

  <cffunction name="invite" returntype="void" output="false" cache="true" cacheTimeout="0">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.leftMenu = "site/overview">
    <cfset rc.site = instance.SiteService.getSite(request.bvsiteID)>
    <cfset rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER")>
    <cfset rc.inviteType = event.getValue("inviteType","newUser")>
    <cfset event.setView("web/sites/manage/invite/#rc.inviteType#")>
  </cffunction>

  <cffunction name="detail" returntype="void" output="false" cache="true" cacheTimeout="0">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.siteDetail = instance.siteService.getSite(request.bvsiteID)>
    <cfset rc.members = instance.SiteService.getMembership(request.bvsiteID,"","USER")>
    <cfset rc.products = instance.productService.listProducts(nodeRef=0,siteID=request.bvsiteID,startRow=1,maxrows=10)>
    <cfset rc.blogs = instance.BlogService.getPosts(request.bvsiteID)>
    <cfset rc.promotions = instance.PromotionService.list(request.bvsiteID)>
    <cfset rc.leftMenu = "site/homepage">
    <cfset event.setView("web/sites/homepage")>
  </cffunction>
</cfcomponent>