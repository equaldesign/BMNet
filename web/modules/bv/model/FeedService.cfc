<cfcomponent outut="false" hint="The bvine module service layer" cache="true">

	<!--- Dependencies --->

	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage"  scope="instance" />

	<!--- init --->



	<!--- getParentListing --->
	<cffunction name="getFeed" output="false" access="public" returntype="any">
		<cfargument name="siteID" required="false" type="string" default="">
		<cfargument name="type" required="false" type="string" default="">
		<cfset var ticket = request.user_ticket>
		<cfset theURL = "http://46.51.188.170/alfresco/service/api/activities/feed/user?alf_ticket=#ticket#&format=json"> 
		<cfif arguments.siteID neq "">
			<cfset theURL = "#theURL#&s=#arguments.siteID#">
		</cfif>
		<cfif arguments.type neq "">
			<cfset theURL = "#theURL#&activityFilter=#arguments.type#">
		</cfif>
		<cfhttp port="8080" url="#theURL#" result="feed">
		<cfreturn DeSerializeJSON(feed.fileContent)>
   </cffunction>

   <cffunction name="getActivityFeedDB" returntype="query">
     <cfquery name="activityFeed" datasource="alfresco">
       select * from alf_activity_feed where post_date > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd("d",-7,now())#">
       order by feed_user_id, post_date desc
     </cfquery>
     <cfreturn activityFeed>
   </cffunction>

</cfcomponent> 