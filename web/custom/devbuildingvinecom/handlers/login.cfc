<cfcomponent extends="bmnet.handlers.login">
  <cfproperty name="UserService" inject="id:bv.UserService" >
  <cfproperty name="ContactService" inject="id:eunify.ContactService" />
  <cfproperty name="logger" inject="logbox:root" />
  <cfproperty name="contact" inject="id:eGroup.contact" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cffunction name="doLogin" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <cfargument name="bypass" default="false" required="true" type="boolean">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.rememberMe = event.getValue("rememberMe","false")>
    <cfset rc.target = event.getValue("target","")>
    <cfset ticket = UserService.logUserIn(rc.j_username,rc.j_password,rc.rememberMe)>

    <cfif isBoolean(ticket)>
      <cfset logger.debug(ticket)>
      <cfset logger.debug("#rc.j_username# #rc.j_password#")>
      <cfdump var="#ticket#"><cfabort>
      <cfset setNextEvent(uri="/login/error")>
    <cfelse>
      <cfset eUnifyContact = ContactService.getContactByEmail(ticket.username,2,request.siteID)>
      <cfif eUnifyContact.recordCount eq 0>
        <!--- add them to eUnify - it can't hurt --->
        <cfset var contact = getModel("eunify.ContactService")>
        <cfset contact.setfirst_name(ticket.userProfile.firstName)>
        <cfset contact.setsurname(ticket.userProfile.lastName)>
        <cfset contact.setmobile(ticket.userProfile.mobile)>
        <cfset contact.settel(ticket.userProfile.telephone)>
        <cfset contact.setemail(ticket.username)>
        <cfset contact.setpassword(ticket.password)>
        <cfset contact.getjobTitle(ticket.userProfile.jobtitle)>
        <cfset contact.save()>
      </cfif>
      <cfset UserStorage.setVar("buildingVine",ticket)>      
      <cfset allRoles = "view">
      <cfloop array="#ticket.sitesManaged#" index="s">
        <cfset allRoles = ListAppend(allRoles,"admin_#s#")>        
        
        <cfif s eq "buildingVine">
          <!--- log them into BMNet --->          
          <cfset rc.loggedIn = ContactService.logUserIn(rc.j_username,rc.j_password,rc.rememberMe)>
          <cfif isBoolean(rc.loggedIn)>
            <cfset setNextEvent(uri="/login/index?error=#URLEncodedFormat('Username/password error!')#")>
          </cfif>

          <cfset UserStorage.setVar("BMNet",rc.loggedIn.BMNet)>
          <cfset UserStorage.setVar("eGroup",rc.loggedIn.eGroup)>
          <cfif rc.loggedIn.eGroup.username eq ""> 
            <cfset eGroup = false>
          <cfelse>
            <cfset eGroup = contact.logUserIn(rc.loggedIn.eGroup.username,rc.loggedIn.eGroup.password)>
          </cfif>
          <cfif rc.rememberMe neq "false">
            <cfset loginStruct = {}>
            <cfset loginStruct.username = rc.j_username>
            <cfset loginStruct.password = rc.j_password>
            <cfset CookieStorage.setVar(name="SecuredLoginDetails",value=serializeJSON(loginStruct),expires=365,secure=true)>
          </cfif> 
          <cfset allRoles = ListAppend(allRoles,rc.loggedIn.BMNet.roles)>          
          <cfif NOT isBoolean(eGroup)>
            <cfset eGroup.eGroup.datasource = rc.loggedIn.eGroup.datasource>
            <cfset UserStorage.setVar("eGroup",eGroup.eGroup)>
            <cfloop list="#eGroup.eGroup.roles#" index="r">
              <cfset allRoles = ListAppend(allRoles,r)>
            </cfloop>
          </cfif>                  
        </cfif>
      </cfloop>
      <cfset logger.debug("roles: #allRoles#")> 
      <cflogin>
        <cfloginuser name="#rc.j_username#" password="#rc.j_password#" roles="#trim(allRoles)#">
      </cflogin> 
      <cfif NOT arguments.bypass>
        <cfif rc.target neq "">
          <cfset setNextEvent(uri="#rc.target#")>  
        <cfelse>      
          <cfset setNextEvent(uri="/site/#ticket.siteDB.shortName#")>  
        </cfif>     
      </cfif>
      
            
    </cfif>
  </cffunction>
  <cffunction name="reset" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.j_username = urlDecrypt(event.getValue("id",urlEncrypt(request.buildingVine.username)));
      rc.j_password = userService.resetpassword(rc.j_username);
      runEvent(event="login.doLogin",eventArguments={bypass=true});
      event.setView(name="web/profile/showPassword",module="bv");
    </cfscript>
  </cffunction>
</cfcomponent>