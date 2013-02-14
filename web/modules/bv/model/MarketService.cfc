<cfcomponent accessors="true" output="true" hint="The bvine module service layer" cache="true">
 
	<cffunction name="getFeatures" returntype="struct">   
		<cfargument name="siteID" required="true" default="">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" timeout="999999" url="http://46.51.188.170/:8080/alfresco/service/market/features?siteID=#arguments.siteID#&alf_ticket=#ticket#" result="marketFeatures"></cfhttp>    
    <cfreturn DeSerializeJSON(marketFeatures.fileContent)>
  </cffunction>
  
  <cffunction name="getItem" returntype="struct">   
    <cfargument name="nodeRef" required="true" default="">
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" timeout="999999" url="http://46.51.188.170/alfresco/service/market/item?nodeRef=#arguments.nodeRef#&alf_ticket=#ticket#" result="marketFeatures"></cfhttp>    
    <cfreturn DeSerializeJSON(marketFeatures.fileContent)>
  </cffunction>
  
  <cffunction name="list" returntype="struct" >   
    <cfargument name="siteID" required="true" default="">
	  <cfargument name="startRow" required="true" default="0">
	  <cfargument name="maxRows" required="true" default="10">
	  <cfargument name="sortBy" required="true" default="price">
	  <cfargument name="sortOrder" required="true" default="desc">
	  <cfargument name="type" required="true" default="all">
	  <cfargument name="minPrice" required="true" default="0">
	  <cfargument name="maxPrice" required="true" default="0">  
	  <cfargument name="billboards" required="true" default="false">
	  <cfargument name="features" required="true" default="false">  	  
    <cfset var ticket = request.user_ticket>
	  <cfset var uri = "http://46.51.188.170/alfresco/service/market/items?siteID=#arguments.siteID#&startRow=#arguments.startRow#&maxRows=#arguments.maxRows#&type=#arguments.type#&sortBy=#arguments.sortBy#&billboards=#arguments.billboards#&features=#arguments.features#&minPrice=#arguments.minPrice#&sortOrder=#arguments.sortOrder#&maxPrice=#arguments.maxPrice#&alf_ticket=#ticket#">
	 
    <cfhttp port="8080" timeout="999999" url="#uri#" result="marketItems"></cfhttp>        
    <cftry>
    <cfreturn DeSerializeJSON(marketItems.fileContent)>
	  <cfcatch type="any"><cfabort></cfcatch>
	</cftry> 

  </cffunction>
  
  <cffunction name="prepareFilter" returntype="struct">
  	<cfargument name="fullMarketList">
	  <cfset var returnStruct = {}>
	  <cfset var thisQ = QueryNew("site,price")>
	  <cfloop array="#arguments.fullMarketList.items#" index="index">
	  	<cfset QueryAddRow(thisQ)>
		  <cfset QuerySetCell(thisQ,"site",index.site)>
		  <cfset QuerySetCell(thisQ,"price",index.price)>  
	  </cfloop>
	  <cfquery name="allSites" dbtype="query">
	  	select count(*),site from thisQ group by site;
	  </cfquery>	  
	  <cfquery name="minPrice" dbtype="query">
      select MIN(price) as P from thisQ;
    </cfquery>
    <cfquery name="maxPrice" dbtype="query">
      select MAX(price) as P from thisQ;
    </cfquery>    
	  <cfset returnStruct.sites = ListToArray(ValueList(allSites.site))>
	  <cfset returnStruct.priceLow = minPrice.P>
	  <cfset returnStruct.priceHigh = maxPrice.P>
	  <cfreturn returnStruct>  
  </cffunction>
  
</cfcomponent>