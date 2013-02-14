<cfcomponent displayname="Home page Template" hint="A template for the homepage">
 <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cffunction name="init">
    <cfreturn this>
  </cffunction>
  <cffunction name="getFeatures" returntype="any">
   <cfset var buildingVine = UserStorage.getVar("buildingVine")>
    <cfhttp url="http://www.buildingvine.com/alfresco/service/slingshot/doclib/doclist/documents/node/workspace/SpacesStore/f86ac19e-a314-422c-a435-57b02b4e266f?alf_ticket=#buildingVine.admin_ticket#" method="get" result="requestResult"></cfhttp>
    <cfreturn DeSerializeJSON(requestResult.fileContent)>
  </cffunction>
</cfcomponent>