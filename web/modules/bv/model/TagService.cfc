<cfcomponent outut="false" hint="The bvine module service layer" cache="true">
  <cfproperty name="templateCache" inject="cachebox:template" />
    <!--- getParentListing --->
  <cffunction name="getTagScopes" output="false" access="public" returntype="any">
    <cfargument name="siteID" required="false" type="string" default="">
    <cfargument name="container" required="false" type="string" default="">    
    <cfset var ticket = request.buildingVine.user_ticket>
    <cfset var cacheKey = "tagScopes_#arguments.container#_#arguments.siteID#">
    <cfif templateCache.lookup(cacheKey)>
      <cfreturn templateCache.get(cacheKey)>
    <cfelse>
      <cfif arguments.container neq "">      
        <cfset theURL = "http://46.51.188.170/alfresco/service/api/tagscopes/site/#arguments.siteID#/#arguments.container#/tags?alf_ticket=#ticket#"> 
      <cfelse>
        <cfset theURL = "http://46.51.188.170/alfresco/service/api/tagscopes/site/#arguments.siteID#/tags?alf_ticket=#ticket#"> 
      </cfif>    
      <cfhttp port="8080" url="#theURL#" result="tags">
      <cfset r = DeSerializeJSON(tags.fileContent)>
      <cfset templateCache.set(cacheKey,r,180,180)>
      <cfreturn r>
    </cfif>    
  </cffunction>
  
  <cffunction name="getTags" output="false" access="public" returntype="any">
    <cfargument name="nodeRef" required="false" type="string" default="">    
    <cfset var ticket = request.buildingVine.user_ticket>    
    <cfset theURL = "http://46.51.188.170/alfresco/service/api/node/workspace/SpacesStore/#arguments.nodeRef#/tags?alf_ticket=#ticket#"> 
    <cfhttp port="8080" url="#theURL#" result="tags">
    <cfreturn DeSerializeJSON(tags.fileContent)>
   </cffunction>
</cfcomponent> 