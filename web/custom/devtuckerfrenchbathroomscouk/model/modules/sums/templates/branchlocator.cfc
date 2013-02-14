<cfcomponent displayname="Branch Template" hint="Branch Detail Template">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cffunction name="init">
    <cfreturn this>
  </cffunction>
  <cffunction name="getBranches" returntype="any">
   <cfset var buildingVine = UserStorage.getVar("buildingVine")>
    <cfhttp url="http://www.buildingvine.com/alfresco/service/sums/page/search?siteID=tuckerfrench&search_key=template&search_value=branch&alf_ticket=#buildingVine.admin_ticket#" method="get" result="requestResult"></cfhttp>
    <cfreturn DeSerializeJSON(requestResult.fileContent)>
  </cffunction>
</cfcomponent>