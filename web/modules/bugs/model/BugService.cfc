<cfcomponent accessors="true" outut="false" hint="The bvine module service layer" cache="false">

  <cfproperty name="id">
  <cfproperty name="title">
  <cfproperty name="ticket">
  <cfproperty name="description">
  <cfproperty name="status">
  <cfproperty name="priority">
  <cfproperty name="reproduce">
  <cfproperty name="url">
  <cfproperty name="contactID">
  <cfproperty name="email">
  <cfproperty name="request">
  <cfproperty name="username">
  <cfproperty name="version">
  <cfproperty name="component">
  <cfproperty name="assignee">
  <cfproperty name="fixVersion">
  <cfproperty name="fixDate">
  <cfproperty name="system">
  <cfproperty name="site">
  <cfproperty name="created">
  <cfproperty name="modified">
  <cfproperty name="type">
  <cfproperty name="browser">
  <cfproperty name="formVars">
  <cfproperty name="urlVars">
  <cfproperty name="comments">
  <cfproperty name="attachments">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage"  scope="instance" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage"  scope="instance" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="bugsystem" inject="coldbox:setting:bugsystem" />
  <cfproperty name="dsn" inject="coldbox:datasource:bugs" scope="instance" />

  <!--- getParentListing --->
  <cffunction name="getBug" output="false" access="public" returntype="any">
    <cfargument name="id" required="true" type="string" default="">
    <cfargument name="ticket" required="true" type="string" default="">
    <cfset var bug = "">
    <cfquery name="bug" datasource="bugs">
      select
        *
      from
        bug
      where
      <cfif arguments.id neq "">
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
      <cfelse>
        ticket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ticket#">
      </cfif>
    </cfquery>
    <cfset instance.beanFactory.populateFromQuery(this,bug)>
    <cfif bug.recordCount neq 0>
    <cfset this.comments = getComments(bug.id)>
    <cfset this.attachments = getAttachments(bug.ticket)>
    </cfif>
    <cfreturn this>
  </cffunction>
  <cffunction name="getComments">
    <cfargument name="id">
    <cfset var comments = "">
    <cfquery name="comments" datasource="bugs">
      select * from comment where bugID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn comments>
  </cffunction>
  <cffunction name="getAttachments">
    <cfargument name="id">
    <cfset var comments = "">
    <cfquery name="comments" datasource="bugs">
      select * from attachment where ticket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
    </cfquery>
    <cfreturn comments>
  </cffunction>

  <cffunction name="getAttachment">
    <cfargument name="id">
    <cfquery name="comments" datasource="bugs">
      select * from attachment where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn comments>
  </cffunction>

  <cffunction name="save" returntype="void">
    <cfset var bugs = instance.UserStorage.getVar("eGroup")>
    <cfset var u = "">
    <cfset var n = "">
    <cfif this.getid() eq 0 OR this.getid() eq "">
      <cfif this.getEmail() eq "">
        <cfset this.setEmail(bugs.username)>
        <cfset this.setUserName(bugs.name)>
      </cfif>
      <cfset this.setticket(createUUID())>
      <cfquery name="u" datasource="#instance.dsn.getName()#">
        insert into bug (title,ticket,description,reproduce,status,priority,url,contactID,email,username,type,created,site)
        VALUES
          (<cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettitle()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getticket()#" />,
          <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#this.getdescription()#" />,
          <cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#this.getreproduce()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getstatus()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getpriority()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.geturl()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#bugs.contactID#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getEmail()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getUserName()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.gettype()#" />,
          <cfqueryparam cfsqltype="cf_sql_timestamp"  value="#now()#" />,
          <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getsite()#" />)
      </cfquery>
      <cfquery name="n" datasource="#instance.dsn.getName()#">
        select LAST_INSERT_ID() as id from bug;
      </cfquery>
      <cfset this.setid(n.id)>

    <cfelse>
      <cfquery name="u" datasource="#instance.dsn.getName()#">
        update bug
          set title = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettitle()#" />,
          description = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#this.getdescription()#" />,
          reproduce = <cfqueryparam cfsqltype="cf_sql_longvarchar"  value="#this.getreproduce()#" />,
          status = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getstatus()#" />,
          priority = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getpriority()#" />,
          url = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.geturl()#" />,
          system = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getsystem()#" />,
          site = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getsite()#" />,
          type = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.gettype()#" />,
          assignee = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getassignee()#" />,
          fixVersion = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getfixVersion()#" />,
          fixDate = <cfqueryparam cfsqltype="cf_sql_date"  value="#this.getfixDate()#" />,
          component = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getcomponent()#" />,
          version = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#this.getversion()#" />
        where
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
      </cfquery>
    </cfif>
  </cffunction>

  <cffunction name="chartOverview" returntype="Array">
    <cfset var eGroup = instance.UserStorage.getVar('eGroup')>
    <cfquery name="allData" datasource="bugs">
        select count(*) as issues,
        UNIX_TIMESTAMP(created)*1000 as epochdate
        from
        bug
        WHERE
        type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
        <cfif NOT isUserInRole("ebiz")>
		    AND
        site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#">
        </cfif>
        group by DATE(created)
    </cfquery>
    <cfset returnArray = []>
    <cfloop query="allData">
      <cfset ArrayAppend(returnArray,[epochdate,issues])>
    </cfloop>
    <cfreturn returnArray>
  </cffunction>

  <cffunction name="dashBoardData" rreturntype="Struct">
  	<cfset var eGroup = instance.UserStorage.getVar('eGroup')>
  	<cfquery name="issuedThisMonth" datasource="bugs">
      select
	  (select
        count(*) as res
      from
        bug
      where
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>
      AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#">
      </cfif>
	    AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as thisSite,
	   (select
        count(*) as res
      from
        bug
      where
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">

      AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as average
    </cfquery>
    <cfquery name="closedThisMonth" datasource="bugs">
     select
      (select
        count(*)
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>
      AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#">
      </cfif>
	    AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as thisSite,
	    (select
        count(*)
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">

      AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as average
    </cfquery>

    <cfquery name="issued" datasource="bugs">
     select
      (select
        count(*)
      from
        bug
      where
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>) as thisSite,
	    (select
        count(*)
      from
        bug
      where
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      ) as average
    </cfquery>
    <cfquery name="closed" datasource="bugs">
      select

      (select
        count(*) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>) as thisSite,
	   (select
        count(*) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
     ) as average
    </cfquery>

  	<cfquery name="averageCloseTime" datasource="bugs">
	  	select
	  	(select
        avg(timestampdiff(DAY, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>
      AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>) as thisSite,
	  (select
        avg(timestampdiff(DAY, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz")>
      AND
      site != <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>) as average
	  </cfquery>
	  <cfquery name="maxCloseTime" datasource="bugs">
      select
        MAX(timestampdiff(DAY, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
    </cfquery>
    <cfquery name="minCloseTime" datasource="bugs">
      select
        MIN(timestampdiff(MINUTE, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz")>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
    </cfquery>
    <cfquery name="avgResponseTime" datasource="bugs">
      SELECT
      (select
        AVG(timestampdiff(HOUR, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
	    ) as thisSite,
	    (select
        AVG(timestampdiff(HOUR, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz")>AND
      site != <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>) as average
    </cfquery>
    <cfquery name="maxResponseTime" datasource="bugs">
      select
        MAX(timestampdiff(DAY, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
     <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()> AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
    </cfquery>
    <cfquery name="minResponseTime" datasource="bugs">
      select
        MIN(timestampdiff(MINUTE, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
    </cfquery>
    <cfquery name="averageCloseTimeM" datasource="bugs">
      select
      (select
        avg(timestampdiff(DAY, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
	    AND
		  created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as thisSite,
		  (select
        avg(timestampdiff(DAY, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site != <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
      AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as average
    </cfquery>
    <cfquery name="maxCloseTimeM" datasource="bugs">
      select
        MAX(timestampdiff(DAY, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
	    AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">
    </cfquery>
    <cfquery name="minCloseTimeM" datasource="bugs">
      select
        MIN(timestampdiff(MINUTE, created, modified)) as res
      from
        bug
      where
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
	    AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">
    </cfquery>
    <cfquery name="avgResponseTimeM" datasource="bugs">
      select
      (select
        AVG(timestampdiff(HOUR, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
	    AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as thisSite,
	    (select
        AVG(timestampdiff(HOUR, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site != <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
      AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">) as average
    </cfquery>
    <cfquery name="maxResponseTimeM" datasource="bugs">
      select
        MAX(timestampdiff(DAY, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
	    AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">
    </cfquery>
    <cfquery name="minResponseTimeM" datasource="bugs">
      select
        MIN(timestampdiff(MINUTE, bug.created, comment.datestamp)) as res from bug, comment where comment.bugID = bug.id
      AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
      AND
      type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
      <cfif NOT isUserInRole("ebiz") AND isUserLoggedIn()>AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#"></cfif>
	    AND
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd("m",-1,now())#">
    </cfquery>
    <cfset returnStructure["averageCloseTime"] = averageCloseTime>
	  <cfset returnStructure["maxCloseTime"] = "#decimalFormat(maxCloseTime.res)#">
	  <cfset returnStructure["minCloseTime"] = "#decimalFormat(minCloseTime.res)#">
	  <cfset returnStructure["avgResponseTime"] = avgResponseTime>
	  <cfset returnStructure["maxResponseTime"] = "#decimalFormat(maxResponseTime.res)#">
	  <cfset returnStructure["minResponseTime"] = "#decimalFormat(minResponseTime.res)#">

	  <cfset returnStructure["issuedThisMonth"] = issuedThisMonth>
	  <cfset returnStructure["closedThisMonth"] = closedThisMonth>
	  <cfset returnStructure["issued"] = issued>
	  <cfset returnStructure["closed"] = closed>

	  <cfset returnStructure["averageCloseTimeM"] = averageCloseTimeM>
    <cfset returnStructure["maxCloseTimeM"] = "#decimalFormat(maxCloseTimeM.res)#">
    <cfset returnStructure["minCloseTimeM"] = "#decimalFormat(minCloseTimeM.res)#">
    <cfset returnStructure["avgResponseTimeM"] = avgResponseTimeM>
    <cfset returnStructure["maxResponseTimeM"] = "#decimalFormat(maxResponseTimeM.res)#">
    <cfset returnStructure["minResponseTimeM"] = "#decimalFormat(minResponseTimeM.res)#">
	  <cfreturn returnStructure>
  </cffunction>

  <cffunction name="chartServer" returntype="Array">
    <cfset var eGroup = instance.UserStorage.getVar('eGroup')>
    <cfquery name="allData" datasource="bugs">
        select count(*) as issues,
        UNIX_TIMESTAMP(created)*1000 as epochdate
        from
        bug
        WHERE
        site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#">
        AND
        type = <cfqueryparam cfsqltype="cf_sql_varchar" value="server">
        group by DATE(created)
    </cfquery>
    <cfset returnArray = []>
    <cfloop query="allData">
      <cfset ArrayAppend(returnArray,[epochdate,issues])>
    </cfloop>
    <cfreturn returnArray>
  </cffunction>

   <cffunction name="chartResolved" returntype="Array">
    <cfset var eGroup = instance.UserStorage.getVar('eGroup')>
    <cfquery name="allData" datasource="bugs">
        select count(*) as issues,
        UNIX_TIMESTAMP(modified)*1000 as epochdate
        from
        bug
        WHERE
        site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#">
        AND
        type = <cfqueryparam cfsqltype="cf_sql_varchar" value="help">
		    AND
			  status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
        group by DATE(modified)
    </cfquery>
    <cfset returnArray = []>
    <cfloop query="allData">
      <cfset ArrayAppend(returnArray,[epochdate,issues])>
    </cfloop>
    <cfreturn returnArray>
  </cffunction>

  <cffunction name="list" returntype="query" output="false">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="searchQuery" required="true" type="string" default="">
	  <cfargument name="hideclosed" default="true" type="boolean" required="true">
	  <cfargument name="sortStatement" required="true" type="string" default="">
    <cfargument name="showMine" required="true" type="string" default="false">
    <cfquery name="l" datasource="bugs" result="bugResult">
      select
        bug.id as id,
        (
         select count(*)  from comment where bugID = bug.id
        ) as commentCount,
        ticket,
        title,
        status,
        user.name as assigneeName,
        priority,
        username,
        version,
        component as componentType,
        type,
        created,
        modified,
        fixDate,
        fixVersion,
        site,
        description
      from bug, user
      WHERE
      <cfif NOT isUserInRole("ebiz") OR bugsystem neq "">
      <cfif bugsystem eq "intranet">
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.eGroup.siteName#">
      AND
      </cfif>
      system = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bugsystem#">
      AND
      </cfif>
      type != <cfqueryparam cfsqltype="cf_sql_varchar" value="server">
        <cfif hideclosed>
        AND
        status != <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
        </cfif>
        <cfif showMine>
        AND
        email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getAuthUser()#">
        </cfif>
        <cfif arguments.searchQuery neq "">
        AND
        (
        title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        username like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
		    OR
			  ticket = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.searchQuery#">
        )
        </cfif>
        AND
        user.emailAddress = bug.assignee
      #sortStatement#

        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>

    <cfreturn l>
  </cffunction>
  <cffunction name="cCount" returntype="Numeric">
    <cfargument name="searchQuery" required="true" default="">
	  <cfargument name="hideclosed" default="true" type="boolean" required="true">
    <cfargument name="showMine" required="true" type="string" default="false">
    <cfquery name="s" datasource="bugs">
      select count(id) as records
      from
      bug
      WHERE
      <cfif NOT isUserInRole("ebiz") OR bugsystem neq "">
      <cfif bugsystem eq "intranet">
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#request.eGroup.siteName#">
      AND
      </cfif>
      system = <cfqueryparam cfsqltype="cf_sql_varchar" value="#bugsystem#">
      AND
      </cfif>

      type != <cfqueryparam cfsqltype="cf_sql_varchar" value="server">
        <cfif hideclosed>
        AND
        status != <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">
        </cfif>
      <cfif showMine>
      AND
      email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getAuthUser()#">
      </cfif>
        <cfif arguments.searchQuery neq "">
        AND
        (
        title like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        username like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
        </cfif>
    </cfquery>
    <cfreturn s.records>
  </cffunction>
  <cffunction name="summary" output="false" access="public"  returntype="query">
    <cfset var bugs = instance.UserStorage.getVar('eGroup')>
    <cfset var bugSummary = "">
    <cfquery name="bugSummary" datasource="bugs">
      select
        AVG(TIMESTAMPDIFF(DAY,created,modified)) as average,
        MIN(TIMESTAMPDIFF(SECOND,created,modified)) as quickest,
        MAX(TIMESTAMPDIFF(DAY,created,modified)) as slowest
      from bug
        left join comment on comment.bugID = bug.id
      where
      bug.id < 100000000000
        AND
      status = <cfqueryparam cfsqltype="cf_sql_varchar" value="closed">


    </cfquery>
    <cfreturn bugSummary>
  </cffunction>
  <cffunction name="changePriority" output="false" access="public" returntype="any">
    <cfargument name="id">
    <cfargument name="p">
    <cfscript>
      var a = "";
      if (arguments.p == 3) {
        arguments.p = 1;
      } else {
        arguments.p++;
      }
    </cfscript>
    <cfquery name="a" datasource="#instance.dsn.getName()#">
      update bug set priority = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.p#">
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>
    <cfreturn arguments.p>
  </cffunction>
  <cffunction name="changeStatus" output="false" access="public" returntype="string">
    <cfargument name="id">
    <cfargument name="s">
    <cfscript>
      var a = "";

      getBug(id);
      if (arguments.s == "open") {
        arguments.s = "pending";
      } else if (arguments.s == "pending"){
        arguments.s = "closed";
      } else {
        arguments.s = "open";
      }
    </cfscript>
    <cfquery name="a" datasource="#instance.dsn.getName()#">
      update bug set status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.s#">
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>
    <!---<cfmail server="email-smtp.us-east-1.amazonaws.com" username="AKIAI3EY3YSOVJF37TRA" password="AsBr0dGv8iX6TJf0RPnihRzMhtw42VAeRWu/9rpuToD7" subject="Ticket: #this.getticket()#" to="#this.getusername()# <#this.getemail()#>" from="eBiz Support <support@ebiz.co.uk>">
Your ticket has been updated. The status of this ticket has changed to: #arguments.s#

You can view the status of this ticket and any associcted comments by clicking below:

http://#cgi.http_host#/bugs/detail/id/#id#

If you any any queries, you can reply to this email.

Many Thanks,

eBiz Support.
    </cfmail>--->
    <cfreturn s>
  </cffunction>
  <cffunction name="addComment" returntype="void">
    <cfargument name="bugID">
    <cfargument name="comment">
    <cfset var bugs = instance.UserStorage.getVar("eGroup")>
    <cfset var c = "">
    <cfquery name="c" datasource="#instance.dsn.getName()#">
      insert into comment (email,username,comment,bugID)
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#bugs.username#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#bugs.name#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#comment#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#bugID#">
      )
    </cfquery>

  </cffunction>
  <cffunction name="delete" output="false" access="public" returntype="boolean">
    <cfargument name="id">
    <cfset var a = "">
    <cfquery name="a" datasource="#instance.dsn.getName()#">
      delete from bug
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="overViewData" returntype="Struct">
    <cfset var eGroup = instance.UserStorage.getVar("eGroup")>
    <cfset var bugData = "">
    <cfset var commentData = "">
    <cfset var ret = "">
    <cfquery name="bugData" datasource="bugs">
      select
        count(*) as instance,
			  DATE(created) as createdDate
			from
			  bug
      WHERE
      created > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-14,now())#">
      AND
      site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#">

			group by createdDate
			order by createdDate desc
    </cfquery>
    <cfquery name="commentData" datasource="bugs">
      select
        count(*) as instance,
        DATE(datestamp) as createdDate
      from
        comment,
        bug
      WHERE
      comment.bugid = bug.id
      AND
      comment.datestamp > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('d',-14,now())#">
      AND
      bug.site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#eGroup.siteName#">
      group by createdDate
      order by createdDate desc
    </cfquery>
    <cfset ret = StructNew()>
    <cfset ret.bugs = bugData>
    <cfset ret.comments = commentData>
    <cfreturn ret>
  </cffunction>

  <cffunction name="dataTables">
  <cfargument name="query">
  <cfset var returnObject = {}>
  <cfset returnObject["aaData"] = ArrayNew(1)>
  <cfset returnObject["aoColumns"] = ArrayNew(1)>
  <cfloop array="#query.getMeta().getColumnLabels()#" index="col">
    <cfset colOb = {}>
    <cfset colOb["sTitle"] = col>
    <cfset ArrayAppend(returnObject.aoColumns,colOb)>
  </cfloop>
  <cfloop query="arguments.query">
    <cfset var colArr = []>
    <cfloop array="#query.getMeta().getColumnLabels()#" index="col">
      <cfset arrayAppend(colArr,"#arguments.query[col][currentRow]#")>
    </cfloop>
    <cfset arrayAppend(returnObject["aaData"],colArr)>
  </cfloop>
  <cfreturn returnObject>
</cffunction>

  <cffunction name="escalate" returntype="void">
    <cfargument name="ticket" required="true">
    <cfset getBug(ticket=arguments.ticket)>
    <cfset settype("bug")>
    <cfset save()>
    <cfmail server="email-smtp.us-east-1.amazonaws.com" username="AKIAI3EY3YSOVJF37TRA" password="AsBr0dGv8iX6TJf0RPnihRzMhtw42VAeRWu/9rpuToD7" subject="Ticket: #arguments.ticket#" to="#getemail()#" from="eBiz Support <support@ebiz.co.uk>" bcc="tom.miller@ebiz.co.uk,james.colin@ebiz.co.uk">
Your issue has been upgraded to a priority ticket, and you will be notified when it has been resolved or it's status changes.


Many Thanks,


eBiz Support.


Ticket details
--------------------------------------
Ticket: #getticket()#
Title: #gettitle()#
DETAILS: #getdescription()#
                </cfmail>
  </cffunction>

</cfcomponent>