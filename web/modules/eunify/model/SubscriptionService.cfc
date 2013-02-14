<cfcomponent cache="true" cacheTimeout="0" autowire="true">
	<cfproperty name="CommentService" inject="id:eunify.CommentService" />
  <cfproperty name="ContactService" inject="id:eunify.ContactService" />
	<cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="logger" inject="logbox:root" />

	<cffunction name="notify" returntype="void" access="public">
    <cfargument name="relatedID" required="true">
    <cfargument name="relatedType" required="true">
	  <cfargument name="commentID" required="true">
    <cfargument name="thisContactID" required="true" default="0">
    <cfquery name="getNotifyees" datasource="#dsn.getName(true)#">
      SELECT
       contact.id,
       contact.first_name,
       contact.surname,
       contact.email as emailAddress,
       subscriptions._key as commentKey
      from
        subscriptions,
        subscriptionList,
        contact
      where
        subscriptions.relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">
        AND
        subscriptions.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      AND
       subscriptions.relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relatedType#">
      AND
	     subscriptionList.subscriptionID = subscriptions.id
	     AND
       contact.id = subscriptionList.contactID
       AND
       contact.id != <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.thisContactID#">
       group by contact.id
    </cfquery>
    <cfset subject = "New comment: #getNotifyees.commentKey#">
    <cfset thiscomment = CommentService.getComment(id=arguments.commentID)>
    <cfswitch expression="#arguments.relatedType#">
      <cfcase value="blog">

        <cfset subject = "New comment: #getNotifyees.commentKey#">
        <cfloop query="getNotifyees">
<cfmail from="buildersmerchant.comment@buildersmerchant.net" subject="#subject#" to="#first_name# #surname# <#getNotifyees.emailAddress#>">
Hi #first_name#,

#thiscomment.first_name# #thiscomment.surname# added the following to a discussion about #relatedTitle# (you can respond directly by simply replying to this email).

======
#thiscomment.content#
</cfmail>
        </cfloop>
      </cfcase>
      <cfdefaultcase>
        <cfloop query="getNotifyees">
<cfmail from="buildersmerchant.comment@buildersmerchant.net" subject="#subject#" to="#first_name# #surname# <#getNotifyees.emailAddress#>">
#thiscomment.content#
</cfmail>
        </cfloop>
      </cfdefaultcase>
    </cfswitch>
  </cffunction>

  <cffunction name="add" returntype="numeric">
  	<cfargument name="relatedID" required="true" default="0">
	  <cfargument name="relatedType" required="true" default="">
	  <cfargument name="contactID" required="true" default="0">
	  <cfargument name="subscribe" required="true" default="true">
	  <!--- first, see if a subscription exists --->
	  <cfset subscriptionID = getSubscriptionID(arguments.relatedID,arguments.relatedType)>
    <cfset logger.debug("subscription: #subscriptionID#")>
	  <!--- make sure this user isn't already subscribed --->
	  <cfset instanceExists = subscriptionExists(subscriptionID,arguments.contactID)>
    <cfset logger.debug("instance exists: #instanceExists# #arguments.subscribe#")>
	  <cfif NOT instanceExists AND arguments.subscribe>
	  	<cfquery name="addThem" datasource="#dsn.getName()#">
		  	insert into subscriptionList (contactID,subscriptionID,siteID)
			  VALUES
			  (
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#subscriptionID#">,
         <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
			  )
		  </cfquery>
	  <cfelseif instanceExists AND NOT arguments.subscribe>
	  	<!--- remove them from the list --->
		  <cfquery name="addThem" datasource="#dsn.getName()#">
        delete from subscriptionList
    		WHERE
		      contactID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
		    AND
		      subscriptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#subscriptionID#">
        AND
          siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
	  </cfif>
	  <cfreturn subscriptionID>
  </cffunction>

  <cffunction name="subscriptionExists" returntype="boolean">
  	<cfargument name="subscriptionID">
	  <cfargument name="contactID">
	  <cfquery name="exists" datasource="#dsn.getName(true)#">
	  	select id from subscriptionList
		  where subscriptionID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.subscriptionID#">
		    AND
			contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">
        AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
	  </cfquery>
	  <cfif exists.recordCount neq 0>
	  	<cfreturn true>
		<cfelse>
			 <cfreturn false>
	  </cfif>
  </cffunction>

  <cffunction name="getSubscriptionID" returntype="Numeric">
    <cfargument name="relatedID">
	  <cfargument name="relatedType">
	  <cfquery name="exists" datasource="#dsn.getName(true)#">
	  	select id from subscriptions
		  where relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">
		    AND
			relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relatedType#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
	  </cfquery>
	  <cfif exists.recordCount eq 0>
	  	<!--- create a new subscription key --->
		  <cfset newKey = createUUID()>
		  <cfquery name="a" datasource="#dsn.getName()#">
		  	insert into subscriptions
			  (relatedID,relatedType,_key,siteID)
			  VALUES
			  (
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.relatedID#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.relatedType#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#newKey#">,
         <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
			  )
		  </cfquery>
		  <cfquery name="newID" datasource="#dsn.getName()#" >
		  	select LAST_INSERT_ID() as id from subscriptions
		  </cfquery>
		  <cfreturn newID.id>
	  <cfelse>
	  	<cfreturn exists.id>
	  </cfif>
	</cffunction>

	<cffunction name="getSubscriptionByID" returntype="string">
		<cfargument name="sID" required="true">
		<cfquery name="exists" datasource="#dsn.getName(true)#">
      select _key from subscriptions
      where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.sID#">
    </cfquery>
    <cfreturn exists._key>
	</cffunction>

	<cffunction name="getSubscriptionbyKey" returntype="query">
    <cfargument name="thekey">
    <cfquery name="exists" datasource="#dsn.getName(true)#">
      select * from subscriptions
      where _key = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.thekey#">
    </cfquery>
    <cfreturn exists>
  </cffunction>
 </cfcomponent>