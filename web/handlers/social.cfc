<cfcomponent>
  <cfproperty name="ContactService" inject="id:eunify.ContactService" >
  <cfproperty name="siteService" inject="id:eunify.SiteService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">

  <cffunction name="signin" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.token = event.getValue("token","")>
    <cfhttp url="https://rpxnow.com/api/v2/auth_info" method="post" result="auth">
      <cfhttpparam name="apiKey" value="b89d8d1eebb04f3ef9b2de93c53157ec083171a9" type="formfield">
      <cfhttpparam name="token" value="#rc.token#" type="formfield">
    </cfhttp>
    <cfset rc.socialStatus = ContactService.getQuickLogin(DeserializeJSON(auth.fileContent))>
    <cfif isBoolean(rc.socialStatus)>
      <!--- they are logged in or failed to login --->
      <cfcookie expires="never" name="alfticket" value="#IIF(getAuthUser() eq '',DE('0'), DE('#createUUID()#'))#" domain="buildingvine.com" path="/">
      <cfset setNextEvent(uri="/")>
    <cfelse>
      <cfset event.setView("social/#rc.socialStatus.status#")>
    </cfif>
  </cffunction>

  <cffunction name="confirmPass" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.password = event.getValue("password","")>
    <cfset rc.identifier = event.getValue("identifier","")>
    <cfset rc.email = event.getValue("email","")>
    <cfif NOT isBoolean(UserService.getTicket(rc.email,rc.password))>
      <cfset UserService.setQuickLogin(rc.email,rc.password,rc.identifier)>
      <cfset ticket = UserService.sUserInfo(rc.email,rc.password)>
      <cfif NOT isBoolean(ticket)>
        <cfset setNextEvent(uri="/")>
      </cfif>
    </cfif>
    <cfset event.setView("social/error")>
  </cffunction>
</cfcomponent>