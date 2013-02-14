<cfcomponent name="commentService" output="true" cache="true" cacheTimeout="30" autowire="true">

  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:flo" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfproperty name="psa" inject="id:eunify.PSAService" />
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
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
    <cfargument name="security" required="true" type="String">
    <cfargument name="ctype" required="true" default="web" type="string">
    <cfargument name="datasource" default="">
    <cfset var deal = "">
    <cfset var negotiator = "">
    <cfset var comments = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="comments" datasource="#arguments.datasource#">
        insert into
        comment
        (title,content,contactID,relatedID,relatedType,security)
        VALUES
        (<cfqueryparam cfsqltype="cf_sql_varchar" value="#title#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#comment#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#request.contactID#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#security#">)
      </cfquery>
    <cfif security eq "public">
    <cfset feed.createFeedItem(
              so = "contact",
              soID = request.contactID,
              to = "#relatedType#",
              ro = "company",
              roID = request.companyID,
              toID = "#relatedID#",
              action = "addComment",
              message = "#comment#"
    )>
    </cfif>
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
</cfcomponent>
