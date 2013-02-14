<cfcomponent displayname="Home page Template" hint="A template for the homepage">
 <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cffunction name="init">
    <cfreturn this>
  </cffunction>
  <cffunction name="getFeatures" returntype="any">

    <cfhttp url="http://www.buildingvine.com/alfresco/service/sums/page/search?siteID=#request.bvsiteID#&search_key=template&search_value=feature&alf_ticket=#request.user_ticket#" method="get" result="requestResult"></cfhttp>
    <cfreturn DeSerializeJSON(requestResult.fileContent)>
  </cffunction>
</cfcomponent>
