<cfcomponent name="commentService" output="true" cache="true" cacheTimeout="30" autowire="true">

  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfproperty name="logger" inject="logbox:root" />
  <cfproperty name="psa" inject="id:eunify.PSAService" />
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="SubscriptionService" inject="id:eunify.SubscriptionService">
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">
  <cfscript>
  instance = structnew();
  </cfscript>

  <cffunction name="getComment" returntype="query">
    <cfargument name="id" required="true" type="Numeric">
    <cfquery name="comment" datasource="#dsn.getName()#">
      select * from comment where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn comment>
  </cffunction>

  <cffunction name="getComments" returntype="query">
    <cfargument name="relatedID" required="true" type="Numeric">
    <cfargument name="relatedType" required="true" type="String">
    <cfargument name="commentType" required="true" type="String" default="web,incoming_email,outgoing_email">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfset var comments = "">
    <cfquery name="comments" datasource="#dsnRead.getName()#" result="com">
        select comment.*,
        contact.first_name, contact.surname,
        site.known_as,
        contact.email,
        contact.id as contactID,
        contact.company_id from
        comment,
        contact,
        site
        where relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">
        AND
        comment.ctype IN (<cfqueryparam cfsqltype="cf_sql_varchar" value="#commentType#" list="true">)
        AND
        relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">
        AND
        (
          security = <cfqueryparam cfsqltype="cf_sql_varchar" value="public">
          OR
          (
            security = <cfqueryparam cfsqltype="cf_sql_varchar" value="private">
              AND
            comment.contactID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#BMNet.contactID#">
          )
          OR
          (
            security = <cfqueryparam cfsqltype="cf_sql_varchar" value="shared">
              AND
            (
              relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.contactID#">
                AND
              relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
            )
            OR
            (
              relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
                AND
              relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="company">
            )
            OR
            (
              contact.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
            )
            OR
            (
            contact.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.contactID#">
            )
          )
        )
        AND
        contact.id = comment.contactID
        AND
        site.id = contact.siteID
        order by id desc;
      </cfquery>
    <cfreturn comments>
  </cffunction>

  <cffunction name="addComment" returntype="any">
    <cfargument name="relatedID" required="true" type="Numeric">
    <cfargument name="relatedType" required="true" type="String">
    <cfargument name="title" required="true" type="String">
    <cfargument name="comment" required="true" type="String">
    <cfargument name="security" required="true" type="String" default="public">
    <cfargument name="ctype" required="true" default="web" type="string">
    <cfargument name="relatedURL" required="true" default="" type="string">
    <cfargument name="datasource" default="">
    <cfargument name="notify" required="true" default="false">
    <cfargument name="contactID" required="true">
    <cfargument name="commentKey" required="true" default="">

    <cfset var deal = "">
    <cfset var negotiator = "">
    <cfset var comments = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfif arguments.commentKey neq "">
      <cfset subscription = SubscriptionService.getSubscriptionbyKey(arguments.commentKey)>
      <cfset arguments.relatedID = subscription.relatedID>
      <cfset arguments.relatedType = subscription.relatedType>
    </cfif>
    <cfquery name="comments" datasource="#arguments.datasource#">
        insert into
        comment
        (title,content,contactID,relatedID,relatedType,security,relationshipURL)
        VALUES
        (<cfqueryparam cfsqltype="cf_sql_varchar" value="#title#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#comment#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#security#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedURL#">)
    </cfquery>
    <cfquery name="getNewComment" datasource="#dsn.getName()#">
      select LAST_INSERT_ID() as newID from comment;
    </cfquery>

    <cfif security eq "public">
    <cfset feed.createFeedItem(
              so = "contact",
              soID = arguments.contactID,
              to = "#relatedType#",
              ro = "company",
              roID = request.bmnet.companyID,
              toID = "#relatedID#",
              action = "addComment",
              message = "#comment#"
    )>
    </cfif>
    <cfset mentions = getEmails(comment)>
    <cfset SubscriptionService.add(arguments.relatedID,arguments.relatedType,arguments.contactID)>
    <cfif arrayLen(mentions) gte 1>
      <!--- email them that they've been mentioned --->
      <cfloop array="#mentions#" index="u">
        <cfset user = contact.getContactByEmail(u,1)>
        <cfset subscriptionID = SubscriptionService.add(arguments.relatedID,arguments.relatedType,user.id)>
      </cfloop>
    </cfif>
    <cfset SubscriptionService.notify(arguments.relatedID,arguments.relatedType,getNewComment.newID,arguments.contactID)>
  </cffunction>
  <cffunction name="deleteComment" returntype="any">
  <cfargument name="commentID" required="true" type="Numeric">
  <cfargument name="datasource" default="">
  <cfset var comments = "">
  <cfif arguments.datasource eq "">
    <cfset arguments.datasource = dsn.getName()>
  </cfif>
  <cfquery name="comments" datasource="#arguments.datasource#">
      delete from
      comment
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.commentID#">;
    </cfquery>
</cffunction>

<cffunction name="getEmails" returntype="array">
    <cfargument name="bigString" required="true">
    <cfset var email = "(['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.((aero|coop|info|museum|name|jobs|travel)|([a-z]{2,3})))">
    <cfset var res = []>
    <cfset var marker = 1>
    <cfset var matches = "">
    <cfscript>
      matches = reFindNoCase(email,bigString,marker,marker);
      while(matches.len[1] gt 0) {
        arrayAppend(res,mid(bigString,matches.pos[1],matches.len[1]));
        marker = matches.pos[1] + matches.len[1];
        matches = reFindNoCase(email,bigString,marker,marker);
      }
    </cfscript>
    <cfreturn res>
  </cffunction>
</cfcomponent>
