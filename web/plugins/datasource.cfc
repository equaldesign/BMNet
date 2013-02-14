<cfcomponent   name="datasource"  output="false" >
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="logger" inject="logbox:root">
  <cffunction name="getName" returntype="string">  	
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var event = controller.getRequestService().getContext()>
    <cfreturn eGroup.datasource>
  </cffunction>
</cfcomponent>