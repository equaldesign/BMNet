<cfcomponent name="blogService" accessors="true"  output="true" cache="false" cacheTimeout="30" autowire="true">

  <!--- static properties --->
  <cfproperty name="id" />
  <cfproperty name="title" />
  <cfproperty name="body" />
  <cfproperty name="date" />
  <cfproperty name="modified" />
  <cfproperty name="created" />
  <cfproperty name="createdBy" />
  <cfproperty name="importance">
  <cfproperty name="modifiedBy" />
  <cfproperty name="categoryID" />
  <cfproperty name="relatedTo" />
  <cfproperty name="relatedID" />

  <!--- injected properties --->
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNetRead" />

  <!--- methods --->
  <cffunction name="blogCategories" returntype="Query">
    <cfset var cats = "">
    <cfquery name="cats" datasource="#dsnRead.getName()#">
      select * from blogCategory WHERE siteID IN (0,<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">);
    </cfquery>
    <cfreturn cats>
  </cffunction>

  <cffunction name="count" returntype="query">
    <cfargument name="categoryID" required="true" default="0" type="numeric">
    <cfargument name="dateFrom" required="true" default="#createDate(1999,1,1)#" type="date">
    <cfargument name="dateTo" required="true" default="#DateAdd('d',1,now())#" type="date">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfset var list = "">
    <cfquery name="list" datasource="#dsnRead.getName()#">
      select
        count(*) as items
      from
        blog
      where
      siteID IN (0,<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">)
        AND
      date between <cfqueryparam cfsqltype="cf_sql_date" value="#dateFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#dateTo#">
      <cfif categoryID neq 0>
      AND
      categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#categoryID#">
      </cfif>
    </cfquery>
    <cfreturn list>
  </cffunction>

  <cffunction name="delete" returntype="void">
    <cfargument name="datasource" default="">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfset var u = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="u" datasource="#arguments.datasource#">
          delete from blog
          where
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getID()#" />
            AND
            siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
        </cfquery>
  </cffunction>

  <cffunction name="getBlogPost" returntype="struct">
    <cfargument name="id" required="true">
    <cfargument name="categoryID" required="true" default="">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfset var post = "">
    <cfquery name="post" datasource="#dsnRead.getName()#">
      select * from blog where
      siteID IN (0,<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">)
      AND
  		id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      <cfif categoryID neq "">
      AND categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#categoryID#">
      </cfif>
    </cfquery>
    <cfset beanFactory.populateFromQuery(this,post)>
    <cfreturn this>
  </cffunction>

  <cffunction name="list" returntype="query">

    <cfargument name="categoryID" required="true" default="0" type="numeric">
    <cfargument name="dateFrom" required="true" default="#createDate(1999,1,1)#" type="date">
    <cfargument name="dateTo" required="true" default="#DateAdd('d',1,now())#" type="date">
    <cfargument name="startRow" required="true" default="0">
    <cfargument name="maxRows" required="true" default="10">
    <cfargument name="contactID" required="true" default="">
    <cfargument name="applyFilter" required="true" default="false" type="boolean">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfset var list = "">
    <cfif arguments.applyFilter AND arguments.contactID neq "">

    <cfelse>
      <cfquery name="list" datasource="#dsnRead.getName()#">
        select
          blog.*,
          count(comment.id) as comments,
          contact.first_name,
          contact.surname,
          contact.email
        from
          blog left join comment on comment.relatedID = blog.id AND comment.relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="blog">,
          contact
        where
        blog.siteID IN (0,<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">)
        AND
        date between <cfqueryparam cfsqltype="cf_sql_date" value="#dateFrom#"> AND <cfqueryparam cfsqltype="cf_sql_date" value="#dateTo#">
        <cfif categoryID neq 0>
        AND
        categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#categoryID#">
        </cfif>
        AND
        contact.id = blog.createdBy
        group by blog.id
        order by blog.date desc, blog.id desc
        limit #startRow#,#maxRows-startRow#;
      </cfquery>
    </cfif>
    <cfreturn list>
  </cffunction>

  <cffunction name="listRelated" returntype="query">
    <cfargument name="relatedID" required="true" default="0" type="numeric">
    <cfargument name="relatedTo" required="true" default="arrangement" type="string">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfset var list = "">
    <cfquery name="list" datasource="#dsn.getName()#">
      select
        blog.*,
        count(comment.id) as comments,
        contact.first_name,
        contact.surname,
        contact.email
      from
        blog left join comment on comment.relatedID = blog.id AND comment.relatedType = <cfqueryparam cfsqltype="cf_sql_varchar" value="blog">,
        contact
      where
      blog.iteID IN (0,<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">)
      AND
      blog.relatedTo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedTo#">
      AND
      blog.relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">
      AND
      contact.id = blog.createdBy
      group by blog.id
      order by blog.id desc
    </cfquery>
    <cfreturn list>
  </cffunction>

  <cffunction name="save" returntype="void">
    <cfargument name="datasource" default="">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfset var u = "">
    <cfset var n = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfif this.getid() eq 0 OR this.getid() eq "">
      <cfquery name="u" datasource="#arguments.datasource#">
          insert into blog (title,body,date,created,createdBy,modifiedBy,relatedTo,relatedID,categoryID,importance,siteID)
          VALUES
            (<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettitle()#">,
  					<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getbody()#">,
  					<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(this.getdate())#">,
  					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
  					<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.contactID#">,
  					<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.contactID#">,
  					<cfqueryparam cfsqltype="cf_sql_varchar" value="#getrelatedTo()#">,
  					<cfqueryparam cfsqltype="cf_sql_varchar"  value="#getrelatedID()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar"  value="#getcategoryID()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#getimportance()#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">)
        </cfquery>
      <cfquery name="n" datasource="#arguments.datasource#">
          select LAST_INSERT_ID() as id from blog;
        </cfquery>
      <cfset this.setid(n.id)>
      <cfset feed.createFeedItem(so="contact",soID=eGroup.contactID,tO="#getrelatedTo()#",tOID=getrelatedID(),action="postNews",ro="blog",roID=n.id)>
      <cfelse>
      <cfquery name="u" datasource="#arguments.datasource#">
          update blog
            set title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettitle()#" />,
            body = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getbody()#" />,
            date = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(this.getdate())#" />,
            modifiedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#egroup.contactID#" />,
            relatedTo = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getrelatedTo()#" />,
            relatedID = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getrelatedID()#" />,
            categoryID = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#getcategoryID()#">,
            importance = <cfqueryparam cfsqltype="cf_sql_integer" value="#getimportance()#" />
          where
            id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
        </cfquery>
      <!--- <cfset feed.createFeedItem(so="contact",soID=egroup.contactID,tO="blog",tOID=this.getid(),action="postNews",ro="company",roID=eGroup.companyID)> --->
    </cfif>
  </cffunction>

  <cffunction name="search" returntype="query">
    <cfargument name="q">
    <cfset var s = "">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfquery name="s" datasource="#dsnRead.getName()#">
      select
          id,
          title,
          date,
          MATCH (body) AGAINST ('#q#') as score
          from blog
          where
          siteID IN (0,<cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">)
          AND
              MATCH (body) AGAINST ('#q#')
              OR
              title LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#q#%">
          order by date desc limit 0,10;
      </cfquery>
    <cfreturn s>
  </cffunction>

</cfcomponent>