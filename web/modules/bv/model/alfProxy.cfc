<cfcomponent>
  <cfproperty name="bvUserService" inject="id:bv.UserService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />

  <cffunction name="checkUrl" returntype="any">
    <cfargument name="httpObject" required="true" type="struct">
    <cfargument name="ticketType" required="true" default="guest">
    <cfargument name="url" required="true" default="guest">
    <cfif httpObject.statusCode eq "401">
      <!--- it's unauthorised, maybe we should try redoing the session information --->
      <cfif ticketType eq "admin">
        <cfset request.buildingVine.admin_ticket = bvUserService.getTicket("admin","bugg3rm33")>
      <cfelseif ticketType eq "guest">
        <cfset request.buildingVine.guest_ticket = bvUserService.getTicket("website@buildingvine.com","f4ck5t41n")>
      <cfelseif request.buildingVine.username neq "" AND request.buildingVine.password neq "">        
        <cfset request.buildingVine.user_ticket = bvUserService.getTicket(request.buildingVine.username,request.buildingVine.password)>
      <cfelse>
        <cfset request.buildingVine.user_ticket = bvUserService.getTicket("website@buildingvine.com","f4ck5t41n")>
      </cfif>
      <cfset UserStorage.setVar("buildingVine",request.buildingVine)>            
    <cfelse>
      <cfreturn httpObject>
    </cfif>    
  </cffunction>
</cfcomponent>
