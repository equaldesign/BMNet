<cfcomponent displayname="Home page Template" hint="A template for the homepage">
 <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cffunction name="init">
    <cfreturn this>
  </cffunction>
  <cffunction name="getFeatures" returntype="any">
   <cfset var buildingVine = UserStorage.getVar("buildingVine")>
    <cfhttp url="http://www.buildingvine.com/alfresco/service/sums/page/search?siteID=tuckerfrench&search_key=template&search_value=feature&alf_ticket=#buildingVine.admin_ticket#" method="get" result="requestResult"></cfhttp>
    <cfreturn DeSerializeJSON(requestResult.fileContent)>
  </cffunction>
  <cffunction name="getDownloads" returntype="any">
   <cfargument name="node" required="true" default="workspace://SpacesStore/ef220e47-5dcb-4102-8681-518c3a2fa2e0">
   <cfset var buildingVine = UserStorage.getVar("buildingVine")>
    <cfhttp url="http://www.buildingvine.com/alfresco/service/bv/docs/treelist?nodeRef=#arguments.node#&alf_ticket=#buildingVine.admin_ticket#" method="get" result="requestResult"></cfhttp>
    <cfreturn DeSerializeJSON(requestResult.fileContent)>
  </cffunction>

</cfcomponent>