<cfcomponent>
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="logger" inject="logbox:root">
  <cffunction name="getName" returntype="string">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfreturn eGroup.datasource>
  </cffunction>
</cfcomponent>