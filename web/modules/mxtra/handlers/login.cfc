<cfcomponent output="false">

<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->

  <cffunction name="logout">
        <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
         <cfscript>
           target   = event.getValue('target','/');
          // logout
          StructClear(Session);
          runEvent("main.onSessionStart");
       </cfscript>
       <cfif target NEQ ''>
          <!--- redirect to target --->
          <cflocation url="#target#">
       <cfelseif isDefined('CGI.HTTP_REFERRER')>
          <!--- redirect to the referring page --->
          <cflocation url="#CGI.HTTP_REFERRER#">
       <cfelse>
          <!--- redirect to the root page --->
          <cflocation url="/">
       </cfif>
  </cffunction>
  <cffunction name="index" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.username = "">
    <cfset rc.password = "">
    <cfset rc.error = "">
    <cfset event.setLayout('Layout.Login')>
    <cfset event.setView('login')>
  </cffunction>
  <cffunction name="login" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfscript>
       rc.username    = event.getValue('j_username','');
       rc.password = event.getValue('j_password','');
       rc.rememberMe = event.getValue("rememberme","");
    </cfscript>
    <!--- get the user record --->
       <cfquery name="logindb" datasource="cbagroup">
         select id, first_name, surname from contact where email = '#rc.username#' and password = '#rc.password#';
       </cfquery>
       <cfif logindb.recordCount eq 1>
         <cfset x = getSecurity(logindb.id)>
         <cflogin>
         <cfloginuser name="#cflogin.name#"  password="#cflogin.password#" roles="#trim(x)#">
         </cflogin>
         <cfif rc.rememberMe neq "">
           <cfset x = getPlugin("CookieStorage").setVar(expires=1,name="cbalogin",value="#cflogin.name#;#cflogin.password#")>
         <cfelse>
           <cfset getPlugin("CookieStorage").deleteVar(name="cbalogin")>
         </cfif>
         <cfset variables.contactID = logindb.id>
         <cfquery name="contact" datasource="cbagroup">
             select * from contact where email = '#rc.username#';
         </cfquery>
         <cfset rc.sess.eGroup.username = "mleh">
         <cfset rc.sess.eGroup.companyID = "#contact.company_id#">
         <cfset rc.sess.eGroup.name = "#logindb.first_name# #logindb.surname#">
         <cfset rc.companyID = contact>
         <cfset event.setView("yay")>
       <cfelse>
         <cfset rc.error = "Your username and password were not recognised">
         <cfset event.setView("yay")>
       </cfif>
  </cffunction>


  <cffunction name="getSecurity" returntype="string">
    <cfargument name="contactID">
    <cfset userGroups = ArrayNew(1)>
    <cfquery name="defaultGroups" datasource="cbagroup">
      select parentID from contactGroupRelation where oID = '#arguments.contactID#' and oType = 'contact';
    </cfquery>
    <cfloop query="defaultGroups">
      <cfset x = getGroupNames(parentID)>
    </cfloop>
    <cfquery name="gNames" datasource="cbagroup">
      select name from contactGroup where id IN(#ArrayToList(userGroups)#);
    </cfquery>
    <cfreturn ValueList(gNames.name)>
  </cffunction>

  <cffunction name="getGroupNames" returntype="any">
    <cfargument name="pID">
    <cfif arrayFind(userGroups,pID) eq 0>
      <cfset x = ArrayAppend(userGroups,pID)>
      <cfquery name="childGroups" datasource="cbagroup">
        select parentID from contactGroupRelation where oID = '#pID#' and oType = 'group';
      </cfquery>
      <cfloop query="childGroups">
      <cfif parentID neq 0>
        <cfset x = getGroupNames(parentID)>
      </cfif>
      </cfloop>
    </cfif>
  </cffunction>
</cfcomponent>