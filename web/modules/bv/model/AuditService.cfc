<cfcomponent name="AuditService" cache="true">
  <cffunction name="getReach" returnType="numeric"> 
    <cfargument name="path" required="true">
    <cfhttp username="admin" password="bugg3rm33" url="http://www.buildingvine.com/alfresco/service/api/audit/query/alfresco-access?value=#arguments.path#&limit=1000&verbose=false" result="a">    
    </cfhttp>
    <cfreturn deserializeJSON(a.fileContent).count>
  </cffunction>
</cfcomponent> 