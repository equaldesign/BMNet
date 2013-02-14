
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <!--- preHandler --->

  <!--- index --->
  <cffunction name="index" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.userName = urlDecrypt(event.getValue("id",urlEncrypt(request.buildingVine.username)));
      rc.user = userService.getUser(rc.username);
      rc.userPreferences = userService.getUserPreferences(rc.username);
      event.setView("web/profile/index");
    </cfscript>
  </cffunction>
  
  <cffunction name="edit" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript> 
      var rc = event.getCollection();
      rc.userName = request.buildingVine.username;
      rc.user = userService.getUser(request.buildingVine.username);
      rc.userSites = userService.getUserSites(request.buildingVine.username);      
      rc.userPreferences = userService.getUserPreferences(request.buildingVine.username);
      event.setView("web/profile/edit");
    </cfscript>
  </cffunction>
  <cffunction name="password" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.userName = request.buildingVine.username;
      rc.user = userService.getUser(request.buildingVine.username);
      rc.userPreferences = userService.getUserPreferences(request.buildingVine.username);
      event.setView("web/profile/password");
    </cfscript>
  </cffunction>
  <cffunction name="notifications" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.userName = request.buildingVine.username;
      rc.user = userService.getUser(request.buildingVine.username);      
      rc.siteList = userService.getUserSites(request.buildingVine.username);
      rc.controls = userService.getFeedControls();
      event.setView("web/profile/notifications");
    </cfscript>
  </cffunction>
</cfcomponent>