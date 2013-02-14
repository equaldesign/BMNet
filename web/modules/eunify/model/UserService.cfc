<cfcomponent accessors="true"  name="contactService" output="true" cache="false" cacheTimeout="30" autowire="true">
  <!--- Dependencies --->

  <cfproperty name="securitygroups" inject="coldbox:moduleSettings:eunify" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="UserService" inject="id:bv.UserService">
  <cfproperty name="feed" inject="model:eunify.FeedService" />
  <cfproperty name="groups" inject="model:eunify.GroupsService" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
  <cfproperty name="utils" inject="coldbox:plugin:Utilities" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="logger" inject="logbox:root" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNet" />
  <cfscript>
  instance = structnew();
  </cfscript>
  <cffunction name="isUserInAnyRoles">
    <cfargument name="rolesList">
    <cfset var r = "">
    <cfloop list="#rolesList#" index="r">
      <cfif isUserInRole(r)>
        <cfreturn true>
        <cfbreak>
      </cfif>
    </cfloop>
    <cfreturn false>
  </cffunction>

  <cffunction name="setCustom" returntype="Any">
    <cfargument name="companyID">
    <cfargument name="contactID">
    <cfargument name="relatedType">
    <cfargument name="relatedID">
    <cfset var d = "">
    <cfset var i = "">
    <!--- first delete any existing customisations --->
    <cfquery name="d" datasource="#dsn.getName()#">
        delete from customContactMap
        where
        companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
        AND
        contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
        AND
        referenceType = <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">
      </cfquery>
    <cfquery name="i" datasource="#dsn.getName()#">
        insert into customContactMap (companyID,contactID,referenceType,referenceID)
        VALUES
        ( <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#relatedType#">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#relatedID#">
        )
      </cfquery>
  </cffunction>

  <cffunction name="getQuickLogin" returntype="any">
    <cfargument name="authStruct" required="true" type="struct">
    <cfset var returnStruct = {}>
    <cfquery name="findAuthenticatedUser" datasource="BMNet">
      select * from user2pass
      where identifier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#authStruct.profile.identifier#">
      AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfif findAuthenticatedUser.recordCount eq 0>
      <!--- if the provider is facebook or google, we can get their email and check if they already have an account --->
      <cfif authStruct.profile.providerName eq "Google" OR authStruct.profile.providerName eq "Facebook">
        <cfset alfUser = getUser(authStruct.profile.email)>
        <cfif StructKeyExists(alfUser,"email")>
          <!--- they are in alfresco, they just need to confirm --->
          <cfset returnStruct.status = "confirm">
          <cfset returnStruct.email = authStruct.profile.email>
          <cfset returnStruct.identifier = authStruct.profile.identifier>
        <cfelse>
          <!--- they don't have a Building Vine user account --->
          <cfif authStruct.profile.providerName eq "Google">
            <cfset this.setfirst_name("Google")>
            <cfset this.setsurname("User")>
            <cfset this.setemail(AuthStruct.profile.email)>
            <cfset this.setmobile("000")>
            <cfset this.setpassword1(MakePassword())>
            <cfset this.createUser()>
            <cfset setQuickLogin(getemail(),getpassword1(),authStruct.profile.identifier)>
            <cfset this.confirm(getemail())>
            <cfif isBoolean(this.logUserIn(getemail(),getpassword1()))>
              <cfset returnStruct.status="error">
            <cfelse>
              <cfreturn true>
            </cfif>
          <cfelse>
            <cfdump var="#authStruct#"><cfabort>
          </cfif>
        </cfif>
      <cfelse>
        <!--- they don't have a Building Vine user account, and we don't have their email address --->
        <cfset returnStruct.status="setup">
        <cfset returnStruct.identifier = authStruct.profile.identifier>
      </cfif>
    <cfelse>
      <!--- lets try logging them in --->
      <cfset ticket = logUserIn(findAuthenticatedUser.username,findAuthenticatedUser.pass)>
      <cfif isBoolean(ticket)>
        <cfset returnStruct.status="error">
      <cfelse>
        <cfreturn true>
      </cfif>
    </cfif>
    <cfreturn returnStruct>
  </cffunction>

  <cffunction name="getDigestContacts" returntype="query">
    <cfquery name="contacts" datasource="#dsn.getName()#">
      select * from contact where sendDigest = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
    </cfquery>
    <cfreturn contacts>
  </cffunction>

  <cffunction name="getCustomContact" returntype="query">
    <cfargument name="companyID" required="true" type="numeric" DEFAULT="0">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var customContact = "">
    <cfquery name="customContact" datasource="#dsnRead.getName()#">
        SELECT
          contact.*,
          customContactMap.id as lastestRef
        FROM
          contact,
          company,
          customContactMap
        WHERE
            (
              customContactMap.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
              AND
              contact.id = customContactMap.contactID
              AND
              (
                (
                  customContactMap.referenceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.contactID#">
                  AND
                  customContactMap.referenceType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
                )
                <cfif eGroup.branchID neq "">
                OR
                (
                  customContactMap.referenceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.branchID#">
                  AND
                  customContactMap.referenceType = <cfqueryparam cfsqltype="cf_sql_varchar" value="branch">
                )
                </cfif>
                OR
                (
                  customContactMap.referenceID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.companyID#">
                  AND
                  customContactMap.referenceType = <cfqueryparam cfsqltype="cf_sql_varchar" value="company">
                )
              )
            )
            OR
            (
              company.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
              AND
              contact.id = company.contact_id
            )
            order by lastestRef desc limit 0,1
      </cfquery>
    <cfreturn customContact>
  </cffunction>

  <cffunction name="permissionList" returnType="array">
    <cfset var sGroups = ArrayNew(1)>
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfset var g = "">
    <cfset var s = "">
    <cfset var m = "">
    <cfif isUserInRole("admin")>
      <cfloop array="#securityGroups.group#" index="g">
        <cfset arrayAppend(sGroups,g.id)>
      </cfloop>
    </cfif>
    <cfif BMNet.companyID eq this.getcompany_id() AND isUserInAnyRoles("ebiz,memberadmin")>
      <cfloop array="#securityGroups.members#" index="m">
        <cfset arrayAppend(sGroups,m.id)>
      </cfloop>
    </cfif>
    <cfif (BMNet.companyID eq this.getcompany_id() AND isUserInRole("supplieradmin")) OR isUserInAnyRoles("ebiz,edit,admin")>
      <cfloop array="#securityGroups.suppliers#" index="s">
        <cfset arrayAppend(sGroups,s.id)>
      </cfloop>
    </cfif>
    <cfreturn sGroups>
  </cffunction>

  <cffunction name="emailLoginInfo" access="public" returntype="void">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfmail subject="Your Login details" to="#this.getfirst_name()# #this.getsurname()# <#this.getemail()#>" from="#eGroup.name# <#eGroup.username#>">
      Dear #this.getfirst_name()#,

      Here are your login details for the intranet:

      Username: #this.getemail()# Password: #this.getpassword()# URL: http://#cgi.HTTP_HOST#/

      Thanks. #eGroup.name#
    </cfmail>
  </cffunction>

  <cffunction name="emailPassword" access="public" returntype="void">
    <cfargument name="emailAddress" required="true" type="string">
    <cfset var u = "">
    <cfquery name="u" datasource="#dsn.getName()#">
      select first_name, surname, email, password from contact where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.emailAddress#">
    </cfquery>
    <cfmail subject="Your Login details" to="#u.first_name# #u.surname# <#u.email#>" from="Intranet <no-reply@#cgi.HTTP_HOST#>">
      Dear #u.first_name#,

      Here are your login details for the intranet:

      Username: #u.email# Password: #u.password# URL: http://#cgi.HTTP_HOST#/

      Thanks.

      Intranet Password reminder service
    </cfmail>
  </cffunction>

  <cffunction name="userInterest" access="public" returntype="boolean" output="false">
    <cfargument name="contactID" required="yes">
    <cfargument name="buyingTeam" required="yes">
    <cfset var a = arguments>
    <cfset var getRebateType = "">
    <cfquery name="getRebateType" datasource="#dsnRead.getName()#">
        select * from emailListMember where contact_id = '#a.contactID#' and buying_group_id = '#a.buyingTeam#';
      </cfquery>
    <cfif getRebateType.recordCount gte 1>
      <cfreturn true>
      <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="calendarContacts" returnType="query">
    <cfset var c = "">
    <cfquery name="c" datasource="#dsnRead.getName()#">
      select
              contact.id,
              concat(contact.first_name," ",contact.surname) as name,
              company.known_as,
             contact.company_id
                from contact,
                company
              where
            company.id = contact.company_id
            order by name asc;
      </cfquery>
    <cfreturn c>
  </cffunction>

  <cffunction name="getUser" returntype="query" output="false">
    <cfargument name="userID" required="yes">
    <cfset var userData = "">
    <cfset var permissions = "">
    <cfquery name="userData" datasource="#dsnRead.getName()#">
        select * from user where id = '#arguments.userID#';
      </cfquery>

    <cfreturn userData>
  </cffunction>

  <cffunction name="getCompanyTypeContacts" returntype="query" output="false">
    <cfargument name="type" required="yes">
    <cfset var userData = "">
    <cfquery name="userData" datasource="#dsnRead.getName()#" >
        select cm.known_as as name, cn.id, cn.email, cn.first_name, cn.company_id, cn.surname, cn.tel from company as cm, contact as cn
        WHERE
        cm.type_id IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#type#" list="true">)
        AND
        cn.company_id = cm.id
        ORDER BY
        <cfif moduleSettings.eGroup.settings.siteName neq "cbagroup"><!--- they are difficult! --->
        surname  asc;
        <cfelse>
        known_as, surname  asc;
        </cfif>
      </cfquery>
    <cfreturn userData>
  </cffunction>

  <cffunction name="getAllContacts" returntype="query" output="false">
    <cfargument name="sortdir" type="string" required="yes">
    <cfargument name="sortcol" type="string" required="yes">
    <cfargument name="s" type="string" required="true" default="">
    <cfset var userData = "">
    <cfquery name="userData" datasource="#dsnRead.getName()#" >
        <cfif s neq "">
        select
          cn.id as contactID,
          cn.first_name,
          cn.surname,
          cn.email,
          cm.name,
          cm.known_as,
          MATCH (first_name,surname) AGAINST ('#s#') as score
          from contact as cn,
          company as cm
          where MATCH (first_name,surname) AGAINST ('#s#')
          and cm.id = cn.company_id
        <cfelse>
        select cm.known_as, cn.id as contactID, cn.email, cn.first_name, cn.company_id, cn.surname from company as cm, contact as cn
        WHERE
        cm.id = cn.company_id
        </cfif>

        <cfif sortcol neq "" AND sortdir neq "">
          order by
          #lcase(sortcol)# #lcase(sortdir)#
          </cfif>
      </cfquery>
    <cfreturn userData>
  </cffunction>

  <cffunction name="isActiveCompany" returntype="boolean" output="no">
    <cfargument name="companyID" required="yes">
    <cfset var active = "">
    <cfquery name="active" datasource="#dsnRead.getName()#">
      select status from company where id = '#arguments.companyID#';
     </cfquery>
    <cfif active.status eq "active">
      <cfreturn true>
      <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="isActiveContact" returntype="boolean" output="no">
    <cfargument name="contactID" required="yes">
    <cfset var company_id = getUserCompany(contactID)>
    <cfreturn isActiveCompany(company_id)>
  </cffunction>

  <cffunction name="getUserCompany" output="no">
    <cfargument name="contactID" type="numeric" required="yes">
    <cfset var getCompanyQ = "">
    <cfquery name="getCompanyQ" datasource="#dsnRead.getName()#">
      SELECT
        company_id
      FROM
        contact
      WHERE
        id = '#contactID#'
      </cfquery>
    <cfscript>
        if (getCompanyQ.RecordCount IS 0){
          return 0;
        } else {
          return getCompanyQ.company_id;
        }
      </cfscript>
  </cffunction>

  <cffunction name="getContactQuery" returntype="Query">
    <cfargument name="contactID" required="true">
    <cfset var contact = "">
    <cfquery name="contact" datasource="#dsnRead.getName()#">
        select * from contact where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
      </cfquery>
    <cfreturn contact>
  </cffunction>

  <cffunction name="getContactList" returntype="Query">
    <cfargument name="contactList" required="true">
    <cfquery name="contact" datasource="#dsnRead.getName()#">
        select
          contact.*,
          company.known_as
        from
          contact,
          company
        where
        contact.id IN (<cfqueryparam list="true" cfsqltype="cf_sql_integer" value="#contactList#">)
        AND
        company.id = contact.company_id
      </cfquery>
    <cfreturn contact>
  </cffunction>

  <cffunction name="getByEmail" returntype="Query">
    <cfargument name="emailAddress" required="true">
    <cfset var contact = "">
    <cfquery name="contact" datasource="#dsnRead.getName()#">
        select * from user where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailAddress#">
        AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
      </cfquery>
    <cfreturn contact>
  </cffunction>

  <cffunction name="deleteContact" returntype="Any" output="false">
    <cfargument name="cID" required="true">
    <cfargument name="datasource" default="">
    <cfset var d = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="d" datasource="#arguments.datasource#">
        delete from contact where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.cID#">
      </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="save" access="public" returntype="void" output="false">
    <cfargument name="method" required="true" default="update" type="string">
    <cfargument name="datasource" default="">
    <cfargument name="doFeed" default="false" type="boolean" required="true">
    <cfset var eGroup = UserStorage.getVar('eGroup')>
    <cfset var sendEmail = false>
    <cfset var companytld = "">
    <cfset var usertld = "">
    <cfset var i = "">
    <cfset var g = "">
    <cfset var n = "">
    <cfset var c = "">
    <cfset var getcompanyEmail = "">
    <cfset var clearImportance = "">
    <cfset var removeInterests = "">
    <cfset var creatinterest = "">
    <cfset var delFirst = "">
    <cfset var insertPermission = "">

    <cfif datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfif this.getid() eq 0 or this.getid() eq "">
      <cfset this.setpassword(this.generatePassword())>
      <cfquery name="c" datasource="#arguments.datasource#">
          insert into contact (first_name,surname,mobile,tel,email,password,jobTitle,company_id,localUser,sendDigest,sendImmediate)
          VALUES (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getfirst_name()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsurname()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getmobile()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettel()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpassword()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getjobTitle()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcompany_id()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getlocalUser()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsendDigest()#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsendImmediate()#">
          )
        </cfquery>
      <cfquery name="n" datasource="#arguments.datasource#">
          select LAST_INSERT_ID() as id from contact;
        </cfquery>
      <cfset this.setid(n.id)>
      <cfquery name="getcompanyEmail" datasource="#arguments.datasource#">
          select email from company where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcompany_id()#">
        </cfquery>
      <cfif isUserInRole("ebiz")>
        <cfset sendEmail = true>
      </cfif>
      <cfif this.getcompany_id() eq eGroup.companyID>
        <cfset sendEmail = true>
      </cfif>
      <cfif isEmail(getcompanyEmail.email)>
        <cfset companytld = ListGetAt(getcompanyEmail.email,2,"@")>
        <cfif isEmail(this.getemail())>
          <cfset usertld = ListGetAt(getemail(),2,"@")>
          <cfif usertld eq companytld>
            <cfset sendEmail = true>
          </cfif>
        </cfif>
      </cfif>
      <!--- only email contact details if the user was created by someone within their own company --->
      <cfif eGroup.companyID eq this.getcompany_id() OR sendEmail>
        <cfset this.emailLoginInfo()>
      </cfif>
      <cfelse>
      <cfquery name="c" datasource="#arguments.datasource#">
          update
            contact
          set
            first_name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getfirst_name()#">,
            surname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsurname()#">,
            tel = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettel()#">,
            mobile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getmobile()#">,
            company_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcompany_id()#">,
            email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">,
            buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getbuildingVine()#">,
            bvusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getbvusername()#">,
            bvpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getbvpassword()#">,
            password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpassword()#">,
            jobTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getjobTitle()#">,
            localUser = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getlocalUser()#">,
            branchID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getBranchID()#">,
            sendImmediate = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsendImmediate()#">,
            <cfif this.getfeedFilter neq "">
            feedFilter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getfeedFilter()#">,
            </cfif>
            sendDigest = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsendDigest()#">
          WHERE
            id = <cfqueryparam cfsqltype="cf_sql_integer"  value="#this.getid()#">
        </cfquery>
    </cfif>
    <!--- sort out the notifications --->
    <cfquery name="clearImportance" datasource="#arguments.datasource#">
          delete from contactPreference where contactID = '#this.getid()#' and name = 'emailImportance';
          </cfquery>
    <cfloop list="#this.getimportance()#" index="i">
      <cfquery name="c" datasource="#arguments.datasource#">
            insert into contactPreference (contactID,name,value)
            VALUES
            ('#this.getid()#','emailImportance',#i#);
          </cfquery>
    </cfloop>
    <cfquery name="removeInterests" datasource="#arguments.datasource#">
          delete from emailListMember where contact_id = '#this.getid()#';
        </cfquery>
    <cfloop list="#this.getinterests()#" index="i">
      <cfif i neq 0>
        <cfquery name="creatinterest" datasource="#arguments.datasource#">
              insert into emailListMember (contact_id,buying_group_id) VALUES ('#this.getid()#','#i#');
            </cfquery>
      </cfif>
    </cfloop>
    <cftry>
      <cfif arguments.doFeed>
      <cfset feed.createFeedItem(
                    so = 'contact',
                    sOID = eGroup.contactID,
                    tO = 'contact',
                    tOID = this.getid(),
                    action = 'editContact',
                    rO = 'company',
                    rOID = this.getcompany_id(),
                    memberID = 0,
                    companyID = this.getcompany_id(),
                      datasource = datasource
                    )>
      </cfif>
      <cfcatch type="any">
        <cflog application="true" text="#cfcatch.Message#">
      </cfcatch>
    </cftry>
    <!--- sort out permissions --->
    <cfquery name="delFirst" datasource="#arguments.datasource#">
          delete from contactGroupRelation where
          oType = <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">
          AND
          oID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
          AND
          parentID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#ArrayToList(permissionList())#">)
        </cfquery>
    <cflog application="true" text="delete from contactGroupRelation where oType = 'contact' AND oID = #this.getid()# AND parentID IN (#ArrayToList(permissionList())#)">
    <cfloop list="#this.getpermissions()#" index="g">
      <cfquery name="insertPermission" datasource="#arguments.datasource#">
            insert into contactGroupRelation
              (oType,oID,parentID) VALUES
              (<cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,<cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#g#">)
          </cfquery>
      <cflog application="true" text="Add permission #this.getid()# #g#">
    </cfloop>
  </cffunction>

  <cffunction name="recentlyViewed" returntype="query" output="false">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var psaList = "">
    <cfset var history = "">
    <cfset var chistory = "">
    <!--- select history of viewed agreements --->
    <cfquery name="history" datasource="#dsnRead.getName()#" result="chistory">
      select
        SUBSTRING_INDEX(SUBSTRING_INDEX(address,"/",5),"/",-1) as psaID,
        max(visitorLog.stamp) as timeViewed,
        arrangement.name,
        arrangement.period_from,
        arrangement.period_to,
        company.name as companyName,
        company.known_as as companyknown_as,
        company.id
      from
        visitorLog,
        arrangement,
        company
      where
        visitorLog.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.contactID#">
      AND
        left (address,17) = <cfqueryparam cfsqltype="cf_sql_varchar" value="/psa/index/psaid/">
      AND
      arrangement.id = SUBSTRING_INDEX(SUBSTRING_INDEX(address,"/",5),"/",-1)
      AND
      company.id = arrangement.company_id
      group by psaID
      order by timeViewed desc
            limit 0,5;

      </cfquery>
    <cfreturn history>
  </cffunction>

  <cffunction name="isIdle" returntype="boolean" output="false">
    <cfargument name="contactID" required="true" type="numeric">
    <!--- select history of viewed agreements --->
    <cfset var history = "">
    <cfquery name="history" datasource="#dsnRead.getName()#">
              select
                  count(id) as hits
              from
                visitorLog
              where
                stamp > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('n',-5,DateConvert('local2utc',now()))#">
              AND
                contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
              AND
                (
                address != <cfqueryparam cfsqltype="cf_sql_varchar" value="/contact/currentUsers/?">
                AND
                address != <cfqueryparam cfsqltype="cf_sql_varchar" value="/contact/recentlyViewed/?">
                )
          </cfquery>
    <cfif history.hits eq 0>
      <cfreturn true>
      <cfelse>
      <cfreturn false>
    </cfif>
  </cffunction>

  <cffunction name="logUserIn" returntype="any" output="false">
    <cfargument name="username" default="" required="true">
    <cfargument name="password" default="" required="true">
    <cfargument name="rememberMe" default="n" required="true">
    <cfset var userGrps = "">
    <cfset var groupNames = "">
    <cfset var groupIDs = "">
    <cfset var eGroup = UserStorage.getVar("eGroup")>
    <cfset var returnStruct = {}>
    <!--- they're logged in, but a session doesn't exist (it must have timed out) --->
    <cfquery name="user" datasource="#dsn.getName()#">
          select
            user.*,
            site.id as companyID,
            site.type_id as companyType,
            site.buildingVine as companyBV,
            site.bvsiteid,
            site.eGroup_datasource,
            site.known_as,
            user.buildingVine,
            user.bvusername,
            user.bvpassword,
            user.eGroupUsername,
            user.eGroupPassword,
            user.branchID
          from
            user,
            site
          where
            site.id = user.company_id
          AND
            <cfif username eq "" AND password eq "">
                user.email = <cfqueryparam value="#getAuthUser()#" cfsqltype="cf_sql_varchar">
            <cfelse>
              user.email = <cfqueryparam value="#username#" cfsqltype="cf_sql_varchar">
              AND
              user.password = <cfqueryparam value="#password#" cfsqltype="cf_sql_varchar">
            </cfif>
        </cfquery>
        <cfdump var="#user#">
    <cfif user.recordCount eq 0>
      <cfreturn false>
    <cfelse>
      <cfset userGrps = groups.getSecurity(user.id)>
      <cfset groupNames = ValueList(userGrps.name)>
      <cfif user.companyType eq 1>
        <cfset groupNames = listAppend(groupNames,"member",",")>
        <cfelseif user.companyType eq 2>
        <cfset groupNames =  listAppend(groupNames,"supplier",",")>
        <cfelse>
        <cfset groupNames = listAppend(groupNames,"member",",")>
        <cfset groupNames = listAppend(groupNames,"supplier")>
      </cfif>
      <cfset groupNames = listAppend(groupNames,"staff",",")>
      <cfset groupIDs = ValueList(userGrps.id)>

      <cfset logger.debug(groupNames)>
      <cfset var BMNet = {
            sessionReference = "#createUUID()#",
            userName = "#user.email#",
            name = "#user.first_name# #user.surname#",
            companyID = user.companyID,
            branchID = user.branchID,
            bmnet = false,
            showFavouritesOnly = CookieStorage.getVar("showFavouritesOnly",false),
            homepage = CookieStorage.getVar("homepage","feed"),
            editMode = CookieStorage.getVar("editMode",false),
            cacheDisabled = CookieStorage.getVar("cacheDisabled",false),
            companyknown_as = user.known_as,
            newsFilter = CookieStorage.getVar("filter",0),
            contactID = user.id,
            siteName = "buildersMerchant.net",
            isMemberContact = false
          }>
      <cfif user.buildingVine>
        <cfset var buildingVine = {
              active = user.buildingVine,
              username = user.bvusername,
              password = user.bvpassword,
              company = user.companyBV,
              siteID = user.bvsiteid,
              user_ticket = UserService.getTicket(user.bvusername,user.bvpassword),
              admin_ticket = UserService.getTicket("admin","bugg3rm33"),
              guest_ticket = UserService.getTicket("guest","")
            }>
        <cfelse>
        <cfset var buildingVine = {
              active = false,
              password = "",
              company = "",
              siteID = "",
              siteList = "",
              userTicket = "",
              adminTicket = "",
              guestTicket = ""
            }>
      </cfif>
      <cfset eGroup.datasource = user.eGroup_datasource>
      <cfset eGroup.username = user.eGroupUsername>
      <cfset eGroup.password = user.eGroupPassword>
      <cfset BMNet.roles = groupNames>
      <cfset BMNet.rolesIDs = groupIDs>
      <cfif user.companyType eq 1 OR user.companyType eq 3>
        <cfset BMNet.isMemberContact = true>
      </cfif>
      <cfset returnStruct.eGroup = eGroup>
      <cfset returnStruct.buildingVine = buildingVine>
      <cfset returnStruct.BMNet = BMNet>
      <cfreturn returnStruct>
    </cfif>
  </cffunction>

  <cffunction name="setfeedFilter" returntype="void">
    <cfargument name="filtercat">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfquery name="set" datasource="#dsn.getName()#">
      update user set feedFilter = <cfqueryparam cfsqltype="cf_sql_varchar" value="#filtercat#">
      where
      id = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMnet.contactID#">
    </cfquery>
  </cffunction>

  <cffunction name="suspectActivity" returntype="query">
    <cfset var act = "">
    <cfquery name="act" datasource="#dsn.getName()#">
          select
        count(distinct SUBSTRING_INDEX(SUBSTRING_INDEX(visitorLog.address,"/",5),"/",-1)) as deals,
        count(visitorLog.address) as allVisits,
        contact.id,
      contact.first_name,
      contact.surname,
      company.known_as,
        company.id,
        DATE_FORMAT(visitorLog.stamp, '%j') as doy,
        visitorLog.stamp as visitDate
      from
        visitorLog,
        contact,
        company
      where
       visitorLog.stamp > DATE_SUB(now(), INTERVAL 7 DAY)
       AND
        left (address,17) = '/psa/index/psaid/'
      AND
     contact.id = visitorLog.contactID
     AND
     company.id = contact.company_id
      group by doy,contact.id
      order by deals desc
      LIMIT 0,20
      </cfquery>
    <cfreturn act>
  </cffunction>

  <cffunction name="getSessStruct" returntype="struct">
    <cfargument name="emailAddress" required="true">
    <cfargument name="timeout" required="true" default="20">
    <cfset var contact = "">
    <cfquery name="contact" datasource="#dsnRead.getName()#">
        select sessStruct from user where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailAddress#">
      </cfquery>
    <cfif isJSON(contact.sessStruct)>
    <cfreturn DeSerializeJSON(contact.sessStruct)>
    <cfelse>
    <cfreturn StructNew()>
    </cfif>
  </cffunction>
  <cffunction name="setSessStruct" returntype="void">
    <cfargument name="emailAddress" required="true">
    <cfargument name="struct" required="true">
    <cfset var contact = "">
    <cfquery name="contactQ" datasource="#dsnRead.getName()#" result="contactQD">
        update user set sessStruct = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#SerializeJSON(arguments.struct)#"> where email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailAddress#">
      </cfquery>
  </cffunction>

  <cfscript>

  function generatePassword() {
    var placeCharacter = "";
    var currentPlace=0;
    var group=0;
    var subGroup=0;
    var numberofCharacters = 8;
    var characterFilter = 'O,o,0,i,l,1,I,5,S';
    var characterReplace = repeatString(",", listlen(characterFilter)-1);
    if(arrayLen(arguments) gte 1) {
      numberofCharacters = val(arguments[1]);
    }
    if(arrayLen(arguments) gte 2) {
      characterFilter = listsort(rereplace(arguments[2], "([[:alnum:]])", "\1,", "all"),"textnocase");
      characterReplace = repeatString(",", listlen(characterFilter)-1);
    }
    while (len(placeCharacter) LT numberofCharacters) {
      group = randRange(1,4, 'SHA1PRNG');
      switch(group) {
        case "1":
          subGroup = rand();
          switch(subGroup) {
            case "0":
              placeCharacter = placeCharacter & chr(randRange(33,46, 'SHA1PRNG'));
              break;
            case "1":
              placeCharacter = placeCharacter & chr(randRange(58,64, 'SHA1PRNG'));
              break;
          }
        case "2":
          placeCharacter = placeCharacter & chr(randRange(97,122, 'SHA1PRNG'));
          break;
        case "3":
          placeCharacter = placeCharacter & chr(randRange(65,90, 'SHA1PRNG'));
          break;
        case "4":
          placeCharacter = placeCharacter & chr(randRange(48,57, 'SHA1PRNG'));
          break;
      }
      if (listLen(characterFilter)) {
        placeCharacter = replacelist(placeCharacter, characterFilter, characterReplace);
      }
    }
    return placeCharacter;
  }
  </cfscript>
  <cffunction name="search" returntype="query">
    <cfargument name="query">
    <cfset var results = "">
    <Cfquery name="results" datasource="#dsnRead.getName()#">
        select
          cn.id,
          cn.first_name,
          cn.surname,
          cn.email,
          cm.name,
          cm.known_as,
          MATCH (first_name,surname) AGAINST ('#query#') as score
          from contact as cn,
          company as cm
          where
          (
            (
              cm.id = cn.company_id and MATCH (first_name,surname) AGAINST ('#query#')
            )
            OR
            (
              cm.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#query#%"> and cn.company_id = cm.id
            )
          )
          order by score desc limit 0,10;
      </Cfquery>
    <cfreturn results>
  </cffunction>
  <cffunction name="getPrefence" returntype="any">
    <cfargument name="cID">
    <cfargument name="pref">
    <cfset var getR = "">
    <cfquery name="getR" datasource="#dsnRead.getName()#">
      select value from contactPreference where name = 'emailImportance' and contactID = '#cID#' and value = '#pref#';
    </cfquery>
    <cfreturn getR.value>
  </cffunction>
  <cffunction name="getHistory" returntype="struct">
    <cfargument name="contactID" required="true">
    <cfargument name="sRow" required="true">
    <cfargument name="mRow" required="true">
    <cfargument name="dFrom" required="true">
    <cfargument name="dTo" required="true">
    <cfargument name="logFilter" required="true">
    <cfset var hCount = "">
    <cfset var history = "">
    <cfset var ret = structNew()>
    <cfquery name="hCount" datasource="#dsnRead.getName()#">
      select count(id) as count from visitorLog where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
      <cfif dFrom neq "">
      AND
      stamp >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(dFrom)#">
      </cfif>
      <cfif dTo neq "">
      AND
      stamp <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(dTo)#">
      </cfif>
      <cfif logFilter neq "">
      AND
      left (address,#len(logFilter)#) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#logFilter#">
      </cfif>
    </cfquery>
    <cfquery name="history" datasource="#dsnRead.getName()#">
      select * from visitorLog where contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
      <cfif dFrom neq "">
      AND
      stamp >= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(dFrom)#">
      </cfif>
      <cfif dTo neq "">
      AND
      stamp <= <cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(dTo)#">
      </cfif>
      <cfif logFilter neq "">
      AND
      left (address,#len(logFilter)#) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#logFilter#">
      </cfif>
      order by stamp desc LIMIT #sRow-1#,#mRow-sRow+1#;
    </cfquery>
    <cfset ret.count = hCount>
    <cfset ret.history = history>
    <cfreturn ret>
  </cffunction>
  <cffunction name="exportData" returntype="query">
    <cfargument name="typeid" required="true" type="numeric" default="1">
    <cfset var c = "">
    <cfset var securityGroups = "">
    <cfquery name="c" datasource="#dsnRead.getName()#">
    select
    contact.id,
    contact.first_name,
    contact.surname,
    contact.tel,
    contact.mobile,
    contact.email,
    company.name,
    company.known_as
  from
    contact,
    company
  where
    company.type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#typeid#">
  AND
    contact.company_id = company.id
    order by name asc
    </cfquery>
    <cfscript>
       var returnQuery = QueryNew("first_name,surname,tel,mobile,email,name,known_as,securityLevel");
    </cfscript>
    <cfloop query="c">
      <cfset securityGroups = groups.getBaseSecurityGroups(id)>
      <Cfset QueryAddRow(returnQuery)>
      <cfset QuerySetCell(returnQuery,"first_name",first_name)>
      <cfset QuerySetCell(returnQuery,"surname",surname)>
      <cfset QuerySetCell(returnQuery,"tel",tel)>
      <cfset QuerySetCell(returnQuery,"mobile",mobile)>
      <cfset QuerySetCell(returnQuery,"email",email)>
      <cfset QuerySetCell(returnQuery,"name",name)>
      <cfset QuerySetCell(returnQuery,"known_as",known_as)>
      <cfset QuerySetCell(returnQuery,"securityLevel",securityGroups)>
    </cfloop>
    <cfreturn returnQuery>
  </cffunction>
  <cfscript>
  function isEmail(str) {
      return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|mobi|jobs|travel))$",
  arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
  len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
  }
  </cfscript>
</cfcomponent>
