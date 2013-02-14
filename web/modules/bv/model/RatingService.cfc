<cfcomponent outut="false" hint="The bvine module service layer" cache="true">

	<cfproperty name="userService" inject="model:UserService"  scope="instance" />
    <cffunction name="getRating" access="public" returntype="struct" output="false">
    <cfargument name="nodeRef" required="true" type="string" >
    <!--- RC Reference --->
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/node/workspace/SpacesStore/#nodeRef#/ratings?alf_ticket=#ticket#" result="productDetail"></cfhttp>
    <cfset rating = productDetail.fileContent>
    <cfreturn DeSerializeJSON(rating)>
  </cffunction>
</cfcomponent>