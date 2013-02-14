<cfcomponent name="psaService" accessors="true" output="true" cache="false" autowire="true">
  <cfproperty name="id" />
  <cfproperty name="internalReference" />
  <cfproperty name="name" />
  <cfproperty name="company_id" />
  <cfproperty name="dealData" />
  <cfproperty name="memberID" />
  <cfproperty name="keywords" />
  <cfproperty name="period_from" />
  <cfproperty name="period_to" />
  <cfproperty name="buyingTeamID" />
  <cfproperty name="contact_id" />
  <cfproperty name="PSA_status" />
  <cfproperty name="participation" />
  <cfproperty name="signedbygroup" />
  <cfproperty name="signedbyposition" />
  <cfproperty name="membersParticipating">
  <cfproperty name="signedbysupplierdate" />
  <cfproperty name="signedbysupplier" />
  <cfproperty name="priceperiod" />
  <cfproperty name="deal_type_id" />
  <cfproperty name="permissions" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="groups" inject="id:eunify.GroupsService" />
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="branch" inject="id:eunify.BranchService" />
  <cfproperty name="comment" inject="id:eunify.CommentService" />
  <cfproperty name="figuresModel" inject="id:eunify.FiguresService" />
  <cfproperty name="promotions" inject="id:eunify.PromotionsService" />
  <!--- <cfproperty name="calculations" inject="id:eunify.CalculationsService" /> --->

  <cfproperty name="feed" inject="id:eunify.FeedService" />
  <cfproperty name="dms" inject="id:eunify.DocumentService" />
  <cfproperty name="logger" inject="logbox:root" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:BMNetRead" />



  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="favourites" inject="id:eunify.FavouritesService" />

  <cfscript>
        function canEditPSA(psa) {
          if (IsUserInAnyRole("admin,principles,ebiz,edit")) {
            return true;
          } else if (isNumeric(psa.buyingTeamID) AND psa.buyingTeamID neq 0) {
            groupName = groups.getGroupName(psa.buyingTeamID);
            if (IsUserInRole("#groupName#")) {
              return true;
            } else {
              return false;
            }
          } else {
            if (isUserInRole("Categories")) {
              return true;
            } else {
              return false;
            }
          }
        }

    </cfscript>

  <cffunction name="getAllPSAs" returntype="query">
    <cfquery name="deals" datasource="#dsnRead.getName()#">
      select * from arrangement
    </cfquery>
    <cfreturn deals>
  </cffunction>
  <cffunction name="logUser" returntype="void">
    <cfargument name="psaID" required="true">
    <cfquery name="d" datasource="#dsn.getName()#">
      INSERT INTO PSAUserLog (psaID,contactID)
      VALUES (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">,
        <cfqueryparam cfsqltype="cf_sql_integer" value="#request.eGroup.contactID#">
      )
    </cfquery>
  </cffunction>
  <cffunction name="getDealTemplate" returnType="numeric" output="false">
    <cfset var eGroup = request.eGroup>
    <cfset var template = "">
    <cfset var createnewdeal = "">
    <cfset var n = "">

    <cfquery name="template" datasource="#dsnRead.getName()#">
        select id, dealData from template where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="Template">
      </cfquery>
    <cfquery name="createnewdeal" datasource="#dsn.getName()#">
        insert into arrangement
        ( company_id,
          dealData,
          name,
          period_from,
          period_to,
          contact_id,
          memberID,
          deal_type_id,
          originated_from,
          originating_id,
          created)
          VALUES
          ( <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
            <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#template.dealData#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="Insert Product Range Here">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(Year(dateAdd("y",1,now())),1,1)#">,
            <cfqueryparam cfsqltype="cf_sql_date" value="#createDate(Year(dateAdd("y",1,now())),12,31)#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.ContactID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="0">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="1">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="template">,
           <cfqueryparam cfsqltype="cf_sql_integer" value="#template.id#">,
           <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
            );
      </cfquery>
    <cfquery name="n" datasource="#dsn.getName()#">
        select LAST_INSERT_ID() as id from arrangement;
      </cfquery>
    <cfreturn n.id>
  </cffunction>

  <cffunction name="getArrangement" returntype="query" output="false">
    <cfargument name="id" required="yes">
    <cfset var eGroup = request.eGroup>
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
        select
              arrangement.*,
              dealType.desc
       from
        arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'),
        dealType
        where
        (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
        arrangement.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
        AND
        dealType.id = arrangement.deal_type_id
        and
         (arrangement.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
         OR
          arrangement.company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.companyID#">)
        </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="getArrangementAndSupplier" returntype="query" output="false">
    <cfargument name="id" required="yes">
    <cfset var eGroup = request.eGroup>
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
        select arrangement.*, company.known_as from arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'), company
        where
        (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
        AND
        arrangement.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
        AND
        company.id = arrangement.company_id
        and
         (arrangement.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
         OR
          arrangement.company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.companyID#">)
        </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="getPSA" returntype="query" output="false">
    <cfargument name="id" required="true" type="numeric">
    <cfset var psa = "">
    <cfset var bts = "">
    <cfquery name="psa" datasource="#dsnRead.getName()#">
        select * from arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement') where
      (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
      arrangement.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">;
      </cfquery>
    <cfquery name="bts" datasource="#dsnRead.getName()#">
        select categoryID from dealCategory where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
      </cfquery>
    <cfset psa.buyingTeamID = ValueList(bts.categoryID)>
    <cfreturn psa>
  </cffunction>

  <cffunction name="getPSAs" returntype="query" output="false">
    <cfargument name="id" required="true" type="string">
    <cfset var psa = "">
    <cfset var bts = "">
    <cfquery name="psa" datasource="#dsnRead.getName()#">
        select * from arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement') where
      (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
      arrangement.id IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.id#">);
      </cfquery>
    <cfreturn psa>
  </cffunction>

  <cffunction name="deleteArrangement" returntype="void" output="false" >
    <cfargument name="psaID" required="true" type="numeric">
    <cfset var d = "">
    <cfset var df = "">
    <cfquery name="d" datasource="#dsn.getName()#">
       delete from arrangement where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
     </cfquery>
    <cfquery name="df" datasource="#dsn.getName()#">
       delete from figuresEntry where psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
     </cfquery>
  </cffunction>

  <cffunction name="cloneArrangement" returnType="Numeric" output="false">
    <cfargument name="psaID" required="true" type="numeric">
    <cfset var eGroup = request.eGroup>
    <cfset var psa = getArrangement(psaID)>
    <cfset var newID = "">
    <cfset var cats = "">
    <cfset var figuresEntryIDs = "">
    <cfset var createduplicate = "">
    <cfset var n = "">
    <cfset var c = "">
    <cfquery name="createduplicate" datasource="#dsn.getName()#">
        insert into arrangement
        ( dealData,
          internalReference,
          keywords,
          name,
          company_id,
          contact_id,
          deal_type_id,
          lastModified,
          created,
          created_by,
          modified_by,
          period_from,
          period_to,
          buyingTeamID,
          originated_from,
          originating_id,
          signedbygroup)
          VALUES
          ( '#psa.dealdata#',
            '#psa.internalReference#',
            '#psa.keywords#',
            '#psa.name#',
            '#psa.company_id#',
            '#eGroup.ContactID#',
            '#psa.deal_type_id#',
            '#DateFormat(now(),"YYYY-MM-DD")# #TimeFormat(now(),"HH:MM;SS")#',
            '#DateFormat(now(),"YYYY-MM-DD")# #TimeFormat(now(),"HH:MM;SS")#',
            '#eGroup.contactID#',
            '#psa.modified_by#',
            '#DateFormat(psa.period_from,"YYYY-MM-DD")#',
            '#DateFormat(psa.period_to,"YYYY-MM-DD")#',
        '#psa.buyingTeamID#',
        'clone',
        '#psaID#',
        '');
      </cfquery>
    <cfquery name="n" datasource="#dsn.getName()#">
        select LAST_INSERT_ID() as id from arrangement;
      </cfquery>
    <cfset newID = n.id>
    <cfset cats = getdealCategories(psaID)>
    <cfloop query="cats">
      <cfquery name="c" datasource="#dsn.getName()#">
        insert into dealCategory (psaID,categoryID)
        VALUES (
         <cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">,
         <cfqueryparam cfsqltype="cf_sql_varchar" value="#categoryID#">
         )
        </cfquery>
    </cfloop>
    <cfset figuresEntryIDs = getFiguresEntryElements(psaID)>
    <cfloop query="figuresEntryIDs">
      <cfquery name="c" datasource="#dsn.getName()#">
        insert into figuresEntry (psaID,inputName,description,inputTypeID)
        VALUES (
         <cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">,
         <cfqueryparam cfsqltype="cf_sql_varchar" value="#inputName#">,
         <cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">,
         <cfqueryparam cfsqltype="cf_sql_integer" value="#inputTypeID#">
         )
        </cfquery>
    </cfloop>
    <cfreturn n.id>
  </cffunction>

  <cffunction name="getRecursiveDeals" returnType="string" output="true">
    <cfargument name="catID" required="true" default="0">
    <cfset var deals = "">
    <!--- get child categories --->
    <cfset var children = groups.getChildrenGroups(catID)>
    <cfset var thisTree = "">
      <cfsavecontent variable="thisTree">
        <cfoutput>
        <ul>
          <cfif children.recordCount gte 1>
            <cfloop query="children">
            <li class="categoryHeader"><h3>#name#</h3>
              #getRecursiveDeals(oid)#
            </li>
            </cfloop>
          </cfif>
          <cfquery name="deals" datasource="#dsnRead.getName()#">
            select
              psa.id,
              psa.name,
              psa.dealData,
              psa.company_id,
              psa.contact_id,
              psa.PSA_status,
              company.known_as,
              company.name as companyName,
              company.id as companyID,
              psa.period_from,
              psa.period_to
              from
              arrangement as psa LEFT JOIN dmsSecurity on (psa.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'),
              company,
              dealCategory
              where
              (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
              AND
              (
               period_from < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                AND
               period_to > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
              )
              AND
              company.id = psa.company_id
              AND
              dealCategory.categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#catID#">
              AND
              psa.id = dealCategory.psaID
              group by psa.id order by known_as
          </cfquery>
          <cfloop query="deals">
          <li class="agreement">
            <a href="#bl('psa.index','psaID=#id#')#">
              <img width="25" class="gravatar" src="#paramImage('company/#companyID#_square.jpg','website/unknown.jpg')#" alt="#known_as#" border="0" />
              <b>#companyName#</b>
              <p>#name# (#DateFormat(period_from,"MMM YY")# - #DateFormat(period_to,"MMM YY")#)</p></a>
          </li>
          </cfloop>
        </ul>
        </cfoutput>
      </cfsavecontent>
    <cfreturn thisTree>
  </cffunction>

  <cffunction name="getCurrentDeals" returnType="query" output="false">
    <cfargument name="periodFrom" required="true" default="#now()#" type="date">
  <cfargument name="periodTo" required="true" default="#DateAdd("m",-3,now())#" type="date">
  <cfargument name="periodEndType" required="true" default=">">
    <cfset var deals = "">
    <cfquery name="deals" datasource="#dsnRead.getName()#">
      SELECT
       psa.id,
       psa.name,
       psa.dealData,
       psa.company_id,
       psa.contact_id,
       maxPeriod.maxPeriod as lastDate,
       psa.period_from,
       psa.period_to,
       psa.PSA_status as status,
       com.known_as
      FROM
       arrangement psa USE INDEX (IDX_period) LEFT JOIN dmsSecurity on (psa.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement')
       INNER JOIN company com ON com.id = psa.company_id
       LEFT JOIN
       (
        select
         t.psaID,
         max(t.period) AS maxPeriod
        from
         turnover t
        group by
         t.psaID
       ) AS maxPeriod ON maxPeriod.psaID = psa.id
      WHERE
      (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
      AND
       period_from < <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodFrom#">
       AND period_to #arguments.periodEndType#  <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.periodTo#">

      </cfquery>
    <cfreturn deals>
  </cffunction>

  <cffunction name="getArrangementByCategory" returntype="query" output="false">
    <cfargument name="id" required="yes">
    <cfargument name="type" required="true" default="current">
    <cfset var eGroup = request.eGroup>
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
        select arrangement.*, company.*, company.id as companyID from arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'), company, dealCategory
        where
        (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
          AND
        dealCategory.categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        arrangement.id = dealCategory.psaID
        AND
        company.id = arrangement.company_id
      AND
      (
      <cfif type eq "current">
      arrangement.period_from < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> AND arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
      AND
      arrangement.PSA_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="confirmed">
      <cfelseif type eq "historic">
      arrangement.period_to < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
      <cfelse>
      arrangement.period_from < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> AND arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
      AND
      arrangement.PSA_status != <cfqueryparam cfsqltype="cf_sql_varchar" value="confirmed">
      </cfif>
      )
        and
         (arrangement.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
         OR
          company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.companyID#">)
         order by known_as asc;
        </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="getArrangementBySupplier" returntype="query" output="false">
    <cfargument name="supplierid" required="yes">
    <cfargument name="status" required="true" default="">
    <cfargument name="fromDate" required="true" default="">
    <cfargument name="toDate" required="true" default="">
    <cfargument name="exclude" required="true" default="">
    <cfset var eGroup = request.eGroup>
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
              select arrangement.* from arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement')
              where
              (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
                  AND
              company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.supplierid#">
              <cfif status neq "">
              and PSA_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
              </cfif>
                AND
                   (arrangement.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
                   OR
                    company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.companyID#">)
              <cfif fromDate neq "">
              AND period_from >= <cfqueryparam cfsqltype="cf_sql_date" value="#fromDate#">
              </cfif>
              <cfif toDate neq "">
              AND period_to >= <cfqueryparam cfsqltype="cf_sql_date" value="#toDate#">
              </cfif>
              <cfif exclude neq "">
              AND arrangement.id NOT IN (<cfqueryparam cfsqltype="cf_sql_integer" value="#exclude#" list="true">)
              </cfif>
              order by period_to desc, PSA_status asc;
              </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="getArrangementByNegotiator" returntype="query" output="false">
    <cfargument name="contactID" required="yes">
    <cfargument name="status" required="no" default="confirmed">
    <cfset var eGroup = request.eGroup>
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
                  select arrangement.*, company.known_as from arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'), company
                  where
                  (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
                          AND
                    arrangement.contact_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#contactID#">
                  <cfif isDefined('arguments.status')>
                  and PSA_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.status#">
                  </cfif>
                  AND
                   (arrangement.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#eGroup.companyID#">)
                   OR
                    company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.companyID#">)
                  AND
                  company.id = arrangement.company_id
                    order by period_to desc, PSA_status asc;
                  </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="getArrangementByTeam" returntype="query" output="false" access="remote">
    <cfargument name="team" required="yes">
    <cfset var thisyear = "#DateFormat(now(),'YYYY')#">
    <cfset var favList = "">
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
      select
        arrangement.name as name,
        company.known_as as cname,
        arrangement.PSA_status,
        arrangement.id
      from
        arrangement LEFT JOIN dmsSecurity on (arrangement.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'), company
     where
     (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
     AND
        PSA_status = 'confirmed'
        AND
        buyingTeamID = '#arguments.team#'
     and
        period_from <= '#DateFormat(now(),'YYYY-MM-')#-01'
    AND
        period_to >= '#DateFormat(now(),'YYYY-MM')#-01'

     AND
        company.id = arrangement.company_id
        and arrangement.memberID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="0,#UserStorage.getVar('eGroup.companyID')#">)
        <cfif CookieStorage.getVar("showFavouritesOnly",false)>
            <cfset favList = favourites.get()>
              AND arrangement.company_id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#ValueList(favList.id)#">)
        </cfif>
     order by cname;
      </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="DoBullets" returntype="string" access="public">
    <cfargument name="thetext" required="yes">
    <cfset var sRet = Replace(thetext,"[bp]","<ul><li>")>
    <cfset var sReturn = "">
    <cfset sRet = Replace(sRet,"[bp]","</li><li>","ALL")>
    <cfif Find("<li>",sRet) gte 1>
      <cfset sReturn = "#sRet#</li></ul>">
      <cfelse>
      <cfset sReturn = "#sRet#">
    </cfif>
    <cfreturn sReturn>
  </cffunction>

  <cffunction name="notifyMembers" returntype="any" access="public">
    <cfargument name="psaID">
    <cfargument name="title">
    <cfargument name="importance">
    <cfargument name="message">
    <cfset var eGroup = request.eGroup>
    <Cfset var psa = getArrangementAndSupplier(psaID)>
    <cfset var errorList = "">
    <cfset var contactDetails = "">
    <cfset var mailto = "">
    <cfset var from = "">
    <cfset var subject = "">
    <cfset var contactsToNotify = "">

    <cfset logger.debug("notifymembers")>

    <cfquery name="contactsToNotify" datasource="#dsnRead.getName()#">
       select
        emailListMember.contact_id,
        contact.email,
        company.name,
        company.known_as,
        company.type_id,
        company.id as companyID
      from
          emailListMember,
          contactPreference,
        company,
         contact,
         dealCategory
      where
        dealCategory.psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
        AND
        contactPreference.name = 'emailImportance'
        and
        contactPreference.value = 1
        and
        emailListMember.buying_group_id = dealCategory.categoryID
        and
        contactPreference.contactID = emailListMember.contact_id
        and
        contact.id = contactPreference.contactID
        and
        company.id = contact.company_id
        and
        company.type_id != 2
        group by contact_id
      </cfquery>
    <cfset errorList = "">
    <cfloop query="contactsToNotify">
      <cfset logger.debug("about to notifiy #contact_id#")>
      <cfif contact.isActiveContact(contact_id)>
        <cfset logger.debug("#contact_id# is active")>
        <cfset contactDetails = contact.getContactQuery(contact_id)>
        <cfif contactDetails.recordCount neq 0>
          <cfset logger.debug("#contact_id# has records")>
          <cfswitch expression="#importance#">
            <cfcase value="1">
            <cfset mailto = "#contactDetails.email#">
            <cfset from="#Ucase(eGroup.sitename)# Administrator <#eGroup.username#>">
            <cfset subject="#Ucase(psa.known_as)# - VERY IMPORTANT TRADING INFORMATION">
            <cftry>
              <cfmail to="#mailto#" from="#from#" subject="#subject#" server="127.0.0.1">
                <cfmailparam name = "Importance" value = "High">
                <cfmailparam name="X-Message-Flag" value="Follow up">
                AGREEMENT: "#psa.known_as# #psa.name#"
                MESSAGE TYPE: VERY IMPORTANT
                TITLE: #TITLE# NOTE: #MESSAGE# VIEW: To view this change please CLICK below
                http://#cgi.HTTP_HOST#/psa/index/psaID/#psaID#
              </cfmail>
              <cfcatch type="any">
                <cfset errorList = ListAppend(errorList,"#mailto#:#contactDetails.first_name# #contactDetails.surname#")>
              </cfcatch>
            </cftry>
            </cfcase>
            <cfcase value="2">
            <cfset mailto = "#contactDetails.email#">
            <cfset from="#Ucase(eGroup.sitename)# Administrator <#eGroup.username#>">
            <cfset subject="#Ucase(psa.known_as)# - IMPORTANT SUPPLIER PRICE MOVEMENTS">
            <cftry>
              <cfmail to="#mailto#" from="#from#" subject="#subject#" server="127.0.0.1">
                AGREEMENT: "#psa.known_as# #psa.name#"
                MESSAGE TYPE: IMPORTANT
                TITLE: #TITLE# NOTE: #MESSAGE# VIEW: To view this change please CLICK below
                http://#cgi.HTTP_HOST#/psa/index/psaID/#psaID#
              </cfmail>
              <cfcatch type="any">
                <cfset errorList = ListAppend(errorList,"#mailto#:#contactDetails.first_name# #contactDetails.surname#")>
              </cfcatch>
            </cftry>
            </cfcase>
            <cfcase value="3">
            <cfset mailto = "#contactDetails.email#">
            <cfset from="#Ucase(eGroup.sitename)# Administrator <#eGroup.username#>">
            <cfset subject="#Ucase(psa.known_as)# - PRICE LIST CHANGES">
            <cftry>
              <cfmail to="#mailto#" from="#from#" subject="#subject#" server="127.0.0.1">
                AGREEMENT: "#psa.known_as# #psa.name#"
                MESSAGE TYPE: PRICE LIST
                TITLE: #TITLE# NOTE: #MESSAGE# VIEW: To view this change please CLICK below
                http://#cgi.HTTP_HOST#/psa/index/psaID/#psaID#
              </cfmail>
              <cfcatch type="any">
                <cfset errorList = ListAppend(errorList,"#mailto#:#contactDetails.first_name# #contactDetails.surname#")>
              </cfcatch>
            </cftry>
            </cfcase>
            <cfcase value="4">
            <cfset mailto = "#contactDetails.email#">
            <cfset from="#Ucase(eGroup.sitename)# Administrator <#eGroup.username#>">
            <cfset subject="#Ucase(psa.known_as)# - PROMOTIONS & OFFERS">
            <cftry>
              <cfmail to="#mailto#" from="#from#" subject="#subject#" server="127.0.0.1">
                AGREEMENT: "#psa.known_as# #psa.name#"
                MESSAGE TYPE: PROMOTION/ OFFER
                TITLE: #TITLE# NOTE: #MESSAGE# VIEW: To view this change please CLICK below
                http://#cgi.HTTP_HOST#/psa/index/psaID/#psaID#
              </cfmail>
              <cfcatch type="any">
                <cfset errorList = ListAppend(errorList,"#mailto#:#contactDetails.first_name# #contactDetails.surname#")>
              </cfcatch>
            </cftry>
            </cfcase>
            <cfcase value="5">
            <cfset mailto = "#contactDetails.email#">
            <cfset from="#Ucase(eGroup.sitename)# Administrator <#eGroup.username#>">
            <cfset subject="#Ucase(psa.known_as)# - MINOR ADJUSTMENTS">
            <cftry>
              <cfmail to="#mailto#" from="#from#" subject="#subject#" server="127.0.0.1">
                AGREEMENT: "#psa.known_as# #psa.name#"
                TITLE: #TITLE# NOTE: #MESSAGE# VIEW: To view this change please CLICK below
                http://#cgi.HTTP_HOST#/psa/index/psaID/#psaID#
              </cfmail>
              <cfcatch type="any">
                <cfset errorList = ListAppend(errorList,"#mailto#:#contactDetails.first_name# #contactDetails.surname#")>
              </cfcatch>
            </cftry>
            </cfcase>
          </cfswitch>
        </cfif>
      </cfif>
    </cfloop>
    <cflog application="true" text="#errorList#">
  </cffunction>

  <cffunction name="getParticipatingMembers" returntype="query">
    <cfargument name="aID">
    <cfset var members = "">
    <cfquery name="members" datasource="#dsnRead.getName()#">
              select companyID from arrangementParticipation
              where arrangementID = <Cfqueryparam cfsqltype="cf_sql_varchar" value="#aid#">
            </cfquery>
    <cfreturn members>
  </cffunction>

  <cffunction name="getParicipants" returntype="Query">
    <cfargument name="psaID">
    <cfargument name="participation">
    <cfset var members = "">
    <cfset var memberList = "">
    <cfquery name="members" datasource="#dsnRead.getName()#">
        select companyID from arrangementParticipation
        where arrangementID = #psaID#;
      </cfquery>
    <cfquery name="memberList" datasource="#dsnRead.getName()#">
      select * from company where type_id = 1
      <cfif members.recordCount neq 0>
      AND id
      <cfif participation eq "exclusive">
      NOT IN (#ValueList(members.companyID)#)
      <cfelseif participation eq "inclusive">
      IN  (#ValueList(members.companyID)#)
      </cfif>
      </cfif>

      order by known_as asc;
    </cfquery>
    <cfreturn memberList>
  </cffunction>

  <cffunction name="getEmailTemplate" returntype="string">
    <cfargument name="tID" required="yes">
    <cfset var templateEmail = "">
    <cfquery name="templateEmail" datasource="#dsnRead.getName()#">
        select templateText from emailTemplate where id = '#arguments.tID#';
      </cfquery>
    <cfreturn templateEmail.templateText>
  </cffunction>

  <cffunction name="panelData" returntype="Struct">
    <cfargument name="panel" required="true">
    <cfargument name="psaID" required="true">
    <cfargument name="revisionID" required="true" default="0">
    <cfset var d = StructNew()>
    <cfset var eGroup = request.eGroup>
    <cfset var turnoverSets = "">
    <cfset var c = "">
    <cfswitch expression="#panel#">
      <cfcase value="overview">
      <cfscript>
            d.psa = getArrangement(psaID);
            d.company = company.getCompany(d.psa.company_id,request.siteID);
            if (revisionID neq 0) {
              d.xml = XmlParse(getRevison(revisionID).dealData);
            } else {
              d.xml = XmlParse(d.psa.dealData);
            }
            d.comments = comment.getComments(psaID,"arrangement");
            d.contact = contact.getContact(d.psa.contact_id);
            d.psaCategories = getdealCategories(psaID);
            d.priceLists = dms.getRelatedCategoryDocuments("deal",psaID,"prices",true);
            d.pendingPriceLists = dms.getRelatedCategoryDocuments("deal",psaID,"prices",true,"",true);
            d.promos = promotions.getCompanyPromotions(d.psa.company_id);
            d.promotions = d.promos.eGroup;
            if (StructKeyExists(d.promos,"buildingVine")) {
              d.bvPromotions = d.promos.buildingVine;
            }
            d.memberCompany = company.getCompany(d.contact.company_id,request.siteID);
            d.otherDeals = getArrangementBySupplier(d.psa.company_id,"","",now(),psaID);
            d.canEditPSA = canEditPSA(d.psa);
            if (d.company.contact_id neq "") {
              d.supplierContact = contact.getContactQuery(d.company.contact_id);
            }
          </cfscript>
      </cfcase>
      <cfcase value="psa">
      <cfscript>
            d.psa = getArrangement(psaID);
            d.company = company.getCompany(d.psa.company_id,request.siteID);
            if (d.company.contact_id neq "") {
            d.supplierContact = contact.getContact(d.company.contact_id);
            }
            if (revisionID neq 0) {
              d.xml = XmlParse(getRevison(revisionID).dealData);
            } else {
              d.xml = XmlParse(d.psa.dealData);
            }
            d.revisions = getRevisons(psaID);
            d.contact = contact.getContact(d.psa.contact_id);
            d.memberCompany = company.getCompany(d.contact.company_id);
            if (d.contact.BranchID neq "" AND d.contact.BranchID neq 0) {
              d.branch = branch.getBranch(d.contact.BranchID);
            }
            d.canEditPSA = canEditPSA(d.psa);
            d.supplierList = company.list(maxrow=100000,typeid=2,siteID=request.siteID);
            d.MemberContacts = contact.getCompanyTypeContacts(1);
            d.psaCategories = getdealCategories(psaID);
            d.memberList = company.list(maxrow=100000,typeid=1,siteID=request.siteID);
            d.dealTypes = getDeal();
            d.participatingMembers = getParticipatingMembers(psaID);
            d.participants = getParicipants(psaID,d.psa.participation);
          </cfscript>
      </cfcase>
      <cfcase value="marketing">
      <cfscript>
            d.psa = getArrangement(psaID);
            d.company = company.getCompany(d.psa.company_id);
            if (revisionID neq 0) {
              d.xml = XmlParse(getRevison(revisionID).dealData);
            } else {
              d.xml = XmlParse(d.psa.dealData);
            }
          </cfscript>
      </cfcase>
      <cfcase value="earnings">
      <cfset d.turnover = figuresModel.getCalculations(psaID)>
      <cfset d.calcStatus = calculations.pollStatus(psaID)>
      <cfquery name="c" dbtype="query">
        select periodName,xmlID from d.turnover group by xmlID,periodName
      </cfquery>
      <cfscript>
            d.c = c;
            d.psa = getArrangement(psaID);
            d.company = company.getCompany(d.psa.company_id);
            if (revisionID neq 0) {
              d.xml = XmlParse(getRevison(revisionID).dealData);
            } else {
              d.xml = XmlParse(d.psa.dealData);
            }
            d.contact = contact.getContact(d.psa.contact_id);
            d.memberCompany = company.getCompany(d.contact.company_id);
            d.canEditPSA = canEditPSA(d.psa);
            d.supplierList = company.getSuppliers();
            d.MemberContacts = contact.getCompanyTypeContacts(1);
            d.memberList = company.getMembers();
            d.dealTypes = getDeal();
            d.participatingMembers = getParticipatingMembers(psaID);
          </cfscript>
      </cfcase>
      <cfcase value="figures">
      <cfscript>
              d.psa = getArrangement(psaID);
            </cfscript>
      </cfcase>
      <cfcase value="turnover">
      <cfquery name="turnoverSets" datasource="#dsnRead.getName()#">
              select distinct(rebateIndexID) as types from turnover where psaID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#psaID#">
          </cfquery>
      <cfscript>
            d.turnoverSets = turnoverSets;
            d.psa = getArrangement(psaID);
            d.nextDate = figuresModel.getNextInputDate(psaID);
            d.upto = DateAdd("m",-1,d.nextDate);
          </cfscript>
      </cfcase>
      <cfcase value="updates">
      <cfset d.feed = feed.getFeed(sql='targetObject = "arrangement" AND targetID = "#psaID#"')>
      </cfcase>
    </cfswitch>
    <cfreturn d>
  </cffunction>

  <cffunction name="saveCurrentDealData">
    <cfargument name="psaID">
    <cfargument name="datasource" default="">
    <cfset var eGroup = request.eGroup>
    <cfset var savecurrent = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="savecurrent" datasource="#arguments.datasource#">
        insert into PSAHistory (psaID,dealData,contactID)
          select id, dealData, <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.contactID#"> from arrangement where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
      </cfquery>
  </cffunction>

  <cffunction name="getRevisons" returntype="query">
    <cfargument name="psaID" required="true">
    <cfset var revs = "">
    <cfquery name="revs" datasource="#dsnRead.getName()#">
        select
          PSAHistory.*,
          contact.first_name,
          contact.surname,
          contact.email,
          company.name,
          company.id as companyID,
          company.known_as
          from PSAHistory, contact, company
          where
          PSAHistory.psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">
          AND
          contact.id = PSAHistory.contactID
          AND
          company.id = contact.company_id
          order by id desc
      </cfquery>
    <cfreturn revs>
  </cffunction>

  <cffunction name="getRevison" returntype="query">
    <cfargument name="id" required="true">
    <cfset var revs = "">
    <cfquery name="revs" datasource="#dsnRead.getName()#">
        select
          PSAHistory.*

          from PSAHistory
          where
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
      </cfquery>
    <cfreturn revs>
  </cffunction>

  <cffunction name="isUserInARole" returntype="boolean">
    <cfargument name="roles" required="true">
    <cfset var userRole = false>
    <cfset var i = "">
    <cfloop list="#roles#" index="i">
      <cfif IsUserInRole(i)>
        <cfset userRole = true>
      </cfif>
    </cfloop>
    <cfreturn userRole>
  </cffunction>

  <cffunction name="getTemplates" returntype="query" output="false">
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
                select * from template;
              </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="getTemplate" returntype="query" output="false">
    <cfargument name="id" required="yes">
    <cfset var arrangement = "">
    <cfquery name="arrangement" datasource="#dsnRead.getName()#">
                select * from template where id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
              </cfquery>
    <cfreturn arrangement>
  </cffunction>

  <cffunction name="getDeal" returntype="query" output="false">
    <cfargument name="dealID" required="no">
    <cfset var SQLEnd = "">
    <cfset var deal = "">
    <cfif isDefined('arguments.dealID') AND arguments.dealID neq "">
      <cfset SQLEnd = " where id = #arguments.dealID#;">
      <cfelse>
      <cfset SQLEnd = "">
    </cfif>
    <cfquery name="deal" datasource="#dsnRead.getName()#">
            select * from dealType #SQLEnd#
          </cfquery>
    <cfreturn deal>
  </cffunction>

  <cffunction name="save" returnType="Any" output="false">
    <cfargument name="datasource" default="">
    <cfset var eGroup = request.eGroup>
    <cfset var category = "">
    <cfset var memberID = "">
    <cfset var updateDeal = "">
    <cfset var delCats = "">
    <cfset var insertCat = "">
    <cfset var deleteparticipation = "">
    <cfset var insertP = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <!--- save current dealData --->
    <cfset saveCurrentDealData(this.getid(),arguments.datasource)>
    <cfquery name="updateDeal" datasource="#arguments.datasource#">
           update arrangement set
           name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getname()#">,
           <cfif this.getinternalReference() neq "">
            internalReference = <cfqueryparam cfsqltype="cf_sql_integer"  value="#this.getinternalReference()#">,
           </cfif>
           company_id = <cfqueryparam cfsqltype="cf_sql_integer"  value="#this.getcompany_id()#">,
           keywords = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getkeywords()#">,
           period_from = <cfqueryparam cfsqltype="cf_sql_date"  value="#LSDateFormat(this.getperiod_from())#">,
           period_to = <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFOrmat(this.getperiod_to())#">,
           <!--- buyingTeamID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getbuyingTeamID()#">, --->
           contact_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getcontact_id()#">,
           PSA_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getPSA_status()#">,
           participation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getparticipation()#">,
           <cfif this.getsignedbygroup() neq "">
           signedbygroup = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsignedbygroup()#">,
           </cfif>
           <cfif this.getdealData() neq "">
           dealData = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getdealData()#">,
           </cfif>
           <cfif this.getsignedbyposition() neq "">
           signedbyposition = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsignedbyposition()#">,
           </cfif>
           <cfif this.getsignedbysupplierdate() neq "">
           signedbysupplierdate = <cfqueryparam cfsqltype="cf_sql_date" value="#this.getsignedbysupplierdate()#">,
           </cfif>
           <cfif this.getsignedbysupplier() neq "">
           signedbysupplier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getsignedbysupplier()#">,
           </cfif>
           <cfif this.getmemberID() neq "">
           memberID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getmemberID()#">,
           </cfif>
           priceperiod = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getpriceperiod()#">,
           deal_type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getdeal_type_id()#">
          where
          id = <cfqueryparam cfsqltype="cf_sql_integer" value="#getid()#">
         </cfquery>
    <cfquery name="delPerm" datasource="#dsn.getName()#">
      delete from dmsSecurity where securityAgainst = <cfqueryparam cfsqltype="cf_sql_varchar" value="arrangement">
      AND
      relatedID = <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
    </cfquery>
    <cfloop list="#getpermissions()#" index="p">
      <cfif p neq 0 AND p neq "">
      <cfquery name="addPerm" datasource="#dsn.getName()#">
        insert into dmsSecurity (groupID,securityAgainst,relatedID)
        VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_integer" value="#p#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="arrangement">,
          <cfqueryparam cfsqltype="cf_sql_integer" value="#this.getid()#">
        )
      </cfquery>
      </cfif>
    </cfloop>
    <!--- delete categories --->
    <cfquery name="delCats" datasource="#arguments.datasource#">
          delete from dealCategory where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getid()#">
         </cfquery>
    <cfloop list="#this.getbuyingTeamID()#" index="category">
      <cfquery name="insertCat" datasource="#arguments.datasource#">
            insert into dealCategory (psaID,categoryID) value (<cfqueryparam cfsqltype="cf_sql_integer" value="#getid()#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#category#">)
          </cfquery>
    </cfloop>
    <cfquery name="deleteparticipation" datasource="#arguments.datasource#">
          delete from arrangementParticipation where arrangementID = <cfqueryparam cfsqltype="cf_sql_integer" value="#getid()#">
          </cfquery>
    <cfloop list="#this.getmembersParticipating()#" index="memberID">
      <cfquery name="insertP" datasource="#arguments.datasource#">
            insert into arrangementParticipation (companyID,arrangementID)values (<cfqueryparam cfsqltype="cf_sql_integer" value="#memberID#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#getid()#">)
          </cfquery>
    </cfloop>
    <cftry>
      <cfset feed.createFeedItem('contact',eGroup.contactID,'arrangement',getid(),'editDeal','company',getcompany_id(),getmemberID(),"saved arrangement")>
      <cfcatch type="any">
        <cflog application="true" text="#cfcatch.Message#">
      </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="search" returnType="query" output="no">
    <cfargument name="searchQuery" required="true">
    <cfargument name="dateFrom" type="date">
    <cfargument name="dateFromOperator" type="string">
    <cfargument name="dateTo" type="date">
    <cfargument name="dateToOperator" type="string">
    <cfset var results = "">
    <cfset var favList = "">
    <Cfquery name="results" datasource="#dsnRead.getName()#">
                  select
                    deal.id,
                    deal.internalReference,
                    deal.dealData,
                    deal.name as name,
                    deal.period_from,
                    deal.period_to,
                    deal.keywords,
                    cm.name as company_name,
                    cm.known_as,
                    (MATCH (deal.name,deal.keywords) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#searchQuery#">) OR MATCH (cm.name,known_as,town,address1,cm.keywords) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#searchQuery#">)) as score
                    from arrangement as deal LEFT JOIN dmsSecurity on (deal.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'),
                    company as cm
                    where
                    (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
                              AND
                    <cfif isDefined("arguments.dateFrom")>
                      period_from #dateFromOperator# <cfqueryparam cfsqltype="cf_sql_date" value="#dateFrom#">
                      AND
                    </cfif>
                    <cfif isDefined("arguments.dateTo")>
                      period_from #dateToOperator# <cfqueryparam cfsqltype="cf_sql_date" value="#dateTo#">
                      AND
                    </cfif>
                    cm.id = company_id
                    AND
                      (MATCH (deal.name, deal.keywords) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#searchQuery#">) OR (cm.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchQuery#%"> OR cm.keywords LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchQuery#%"> OR cm.known_as LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#searchQuery#%">) OR deal.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchQuery#"> OR deal.internalReference = <cfqueryparam cfsqltype="cf_sql_varchar" value="#searchQuery#">)
                    <cfif CookieStorage.getVar("showFavouritesOnly",false)>
                        <cfset favList = favourites.get()>
                          AND company_id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#ValueList(favList.id)#">)
                    </cfif>
                    order by period_to desc limit 0,10;
                </Cfquery>
    <Cfreturn results>
  </cffunction>

  <cffunction name="advancedSearch" returntype="query">
    <cfargument name="q" required="true" type="struct">
    <cfset var results = "">
    <Cfquery name="results" datasource="#dsnRead.getName()#">
                  select
                    deal.id,
                    deal.name as name,
                    deal.internalReference,
                    deal.period_from,
                    deal.period_to,
                    deal.keywords,
                    <cfif q.elementID neq "">
                    ExtractValue(dealData,'//component[id="#q.elementID#"]/title/text()') as elementName,
                    ExtractValue(dealData,'//component[id="#q.elementID#"]/details/text()') as elementDetail,
                    </cfif>
                    <cfif q.status neq "">
                    PSA_status as status,
                    </cfif>
                    cm.name as company_name,
                    <cfif q.dealType neq "">
                    dt.desc,
                    </cfif>
                    <cfif q.keywords neq "">
                    (MATCH (deal.name,deal.keywords) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#q.keywords#">) OR MATCH (cm.name,known_as,town,address1,cm.keywords) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#q.keywords#">)) as score,
                    </cfif>
                    <cfif q.figuresType neq "">
                    inputName,
                    </cfif>
                    cm.known_as
                    from arrangement as deal LEFT JOIN dmsSecurity on (deal.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'),
                    <cfif q.dealType neq "">
                    dealType as dt,
                    </cfif>

                    <cfif q.figuresType neq "">
                    figuresEntry,
                    </cfif>
                    <cfif q.negotiatorCompany neq "">
                    contact as negotiator,
                    </cfif>
                    company as cm
                    where
                    (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
                    AND
                    cm.id = deal.company_id
                    <cfif q.elementID neq "">
                    AND
                    ExtractValue(dealData,'//component[id="#q.elementID#"]/details/text() !=""')
                    </cfif>
                    <cfif q.hideEmptyElements neq "">
                    AND
                    ExtractValue(dealData,'//component/id/text()="#q.elementID#"')
                    </cfif>
                    <cfif q.negotiatorCompany neq "">
                     AND
                     negotiator.company_id = <Cfqueryparam cfsqltype="cf_sql_integer" value="#q.negotiatorCompany#">
                     AND
                     deal.contact_id =  negotiator.id
                    </cfif>
                    <cfif q.negotiator neq "">
                      AND
                      deal.contact_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.negotiator#">
                    </cfif>
                    <cfif q.dealType neq "">
                      AND
                      dt.id = deal.deal_type_id
                      AND
                      deal_type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.dealType#">
                    </cfif>
                    <cfif q.status neq "">
                      AND
                      PSA_status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q.status#">
                    </cfif>
                    <cfif q.period_from neq "">
                      AND
                      period_from #q.period_from_operator# <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(q.period_from)#">
                    </cfif>
                    <cfif q.period_to neq "">
                      AND
                      period_to #q.period_to_operator# <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(q.period_to)#">
                    </cfif>
                    <cfif q.figuresType neq "">
                      AND
                      figuresEntry.psaID = deal.id AND figuresEntry.inputTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#q.figuresType#">
                    </cfif>
                      <cfif q.keywords neq "">
                      AND
                      (MATCH (deal.name, deal.keywords) AGAINST (<cfqueryparam cfsqltype="cf_sql_varchar" value="#q.keywords#">) OR cm.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#q.keywords#%"> OR deal.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q.keywords#">)
                      </cfif>
                    group by deal.id order by id desc;
                </Cfquery>
    <cfreturn results>
  </cffunction>

  <cffunction name="getFiguresEntryElements" returntype="Query" >
    <cfargument name="psaID" required="yes">
    <cfargument name="allowChaining" required="true" default="true">
    <cfargument name="inputTypeID" required="true" default="0">
    <cfset var results = "">
    <cfset var chainedDeals = getChainedDeals(psaID)>
    <cfif chainedDeals.recordCount eq 0 OR NOT allowChaining>
      <cfquery name="results" datasource="#dsnRead.getName()#">
              select
               f.id,
               f.psaID as streamPSAID,
               inputTypeID,
               inputName,
               f.description,
               display,
               arrangement.name as arrangementName,
               arrangement.period_from,
               arrangement.period_to,
               company.name as companyName
               from
                  figuresEntry as f,
                  unitType,
                  arrangement,
                  company
               where
               f.psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
               <cfif arguments.inputTypeID neq 0>
               AND
               f.inputTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inputTypeID#">
               </cfif>
               and
               unitType.id = f.inputTypeID
               AND
               arrangement.id = f.psaID
               AND
               company.id = arrangement.company_id
               order by id asc;
            </cfquery>
      <cfelse>
      <cfquery name="results" datasource="#dsnRead.getName()#">
              select
               f.id,
               f.psaID as streamPSAID,
               inputTypeID,
               inputName,
               f.description,
               display,
               arrangement.name as arrangementName,
               arrangement.period_from,
               arrangement.period_to,
               company.name as companyName
               from
                  figuresEntry as f,
                  unitType,
                  arrangement,
                  company
               where
               f.psaID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#psaID#,#valueList(chainedDeals.id)#">)
               <cfif arguments.inputTypeID neq 0>
               AND
               f.inputTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.inputTypeID#">
               </cfif>
               and
               unitType.id = f.inputTypeID
               AND
               arrangement.id = f.psaID
               AND
               company.id = arrangement.company_id
               order by id asc;
            </cfquery>
    </cfif>
    <cfreturn results>
  </cffunction>

  <cffunction name="addDealChain" returntype="query">
    <cfargument name="psaID">
    <cfargument name="chainID">
    <cfset var del = "">
    <cfset var i = "">
    <cfquery name="del" datasource="#dsn.getName()#">
            delete from dealChaining where psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#"> AND linkedPSAID = <cfqueryparam cfsqltype="cf_sql_integer" value="#chainID#">
          </cfquery>
    <cfquery name="i" datasource="#dsn.getName()#">
            insert into dealChaining (psaID,linkedPSAID) values (<cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">,<cfqueryparam cfsqltype="cf_sql_integer" value="#chainID#">)
          </cfquery>
    <cfreturn getChainedDeals(psaID)>
  </cffunction>

  <cffunction name="removeDealChain" returntype="any">
    <cfargument name="chainID">
    <cfargument name="datasource" default="">
    <cfset var del = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="del" datasource="#arguments.datasource#">
            delete from dealChaining where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#chainID#">
          </cfquery>
  </cffunction>

  <cffunction name="getChainedDeals" returntype="query">
    <cfargument name="psaID">
    <cfset var links = "">
    <cfquery name="links" datasource="#dsnRead.getName()#">
            select
              dealChaining.id as chainID,
              arrangement.*,
              company.known_as from
              dealChaining,
              arrangement,
              company
              where dealChaining.psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
              AND
              arrangement.id = dealChaining.linkedPSAID
              AND
              company.id = arrangement.company_id
          </cfquery>
    <cfreturn links>
  </cffunction>

  <cffunction name="getFiguresEntryElementsFromList" returntype="Query" >
    <cfargument name="figuresIDs" required="yes">
    <cfset var results = "">
    <cfquery name="results" datasource="#dsnRead.getName()#">
            select
             f.id,
             f.psaID,
             inputTypeID,
             inputName,
             description,
             display,
             a.period_from,
             a.period_to
             from figuresEntry as f, unitType,  arrangement as a
             where
             f.id IN (<cfqueryparam cfsqltype="cf_sql_integer" list="true" value="#figuresIDs#">)
             and
             unitType.id = f.inputTypeID
             AND
             a.id = f.psaID order by id asc;
          </cfquery>
    <cfreturn results>
  </cffunction>

  <cffunction name="getFiguresEntryElement" returntype="Query" >
    <cfargument name="elementID" required="yes">
    <cfset var results = "">
    <cfquery name="results" datasource="#dsnRead.getName()#">
            select
             f.id, inputTypeID, inputName, description, display,a.period_from,
             a.period_to, a.id as aPSAID
             from figuresEntry as f, unitType, arrangement as a
             where
             f.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#elementID#">
             and
             unitType.id = f.inputTypeID
             AND
             a.id = f.psaID
          </cfquery>
    <cfreturn results>
  </cffunction>

  <cffunction name="getInputTypes" returntype="Query">
    <cfset var results = "">
    <cfquery name="results" datasource="#dsnRead.getName()#">
            select
             * from unitType
          </cfquery>
    <cfreturn results>
  </cffunction>

  <cffunction name="editFiguresEntry" returntype="void">
    <cfargument name="id">
    <cfargument name="psaID">
    <cfargument name="inputTypeID">
    <cfargument name="description">
    <cfargument name="name">
    <cfset var eGroup = request.eGroup>
    <cfset var i = "">
    <cfquery name="i" datasource="#dsn.getName()#">
           update figuresEntry  set psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">,
           inputName=<cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
           description = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#description#">,
           inputTypeID = <cfqueryparam cfsqltype="cf_sql_integer" value="#inputTypeID#">
            where
            id = <cfqueryparam cfsqltype="cf_sql_integer"   value="#id#">
         </cfquery>
    <cftry>
      <cfset feed.createFeedItem('contact',eGroup.contactID,'arrangement',psaID,'editDeal','company',getPSA(psaID).company_id,eGroup.companyID,"saved arrangement")>
      <cfcatch type="any">
        <cflog application="true" text="#cfcatch.Message#">
      </cfcatch>
    </cftry>
  </cffunction>

  <cffunction name="hasFiguresEntry" returntype="boolean">
    <cfargument name="id">
    <cfset var i = "">
    <cfquery name="i" datasource="#dsnRead.getName()#">
           select * from turnover where figuresID = <cfqueryparam cfsqltype="cf_sql_integer"   value="#id#">
         </cfquery>
    <cfif i.recordCount eq 0>
      <cfreturn false>
      <cfelse>
      <cfreturn true>
    </cfif>
  </cffunction>

  <cffunction name="deleteFiguresEntry" returntype="void">
    <cfargument name="id">
    <cfargument name="datasource" default="">
    <cfset var i = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="i" datasource="#arguments.datasource#">
           delete from figuresEntry where id = <cfqueryparam cfsqltype="cf_sql_integer"   value="#id#">
         </cfquery>
  </cffunction>

  <cffunction name="createFiguresEntry" returntype="void">
    <cfargument name="psaID">
    <cfargument name="inputTypeID">
    <cfargument name="description">
    <cfargument name="name">
    <cfargument name="datasource" default="">
    <cfset var i = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfquery name="i" datasource="#arguments.datasource#">
           insert into figuresEntry (psaID,inputName,description,inputTypeID)
           VALUES
           (<cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#name#">,
           <cfqueryparam cfsqltype="cf_sql_varchar"  value="#description#">,
           <cfqueryparam cfsqltype="cf_sql_integer" value="#inputTypeID#">)
         </cfquery>
  </cffunction>

  <cffunction name="isInParticipatingList" returntype="string" output="no">
    <cfargument name="memberID" required="yes">
    <cfargument name="list" required="yes">
    <cfset var memberList = ValueList(list.companyID)>
    <cfif ListFind(memberList,memberID) gte 1>
      <cfreturn 'selected="selected"'>
    </cfif>
  </cffunction>

  <cffunction name="getRebateElement" returntype="any">
    <cfargument name="rebateQ" required="yes">
    <cfargument name="elementID" required="yes">
    <cfset var xmlDoc = xmlParse(rebateQ.dealData)>
    <cfset var xpathExp = "//parent::*//component[id='#ToString(elementID)#']">
    <cfset var rebateNode = XMLSearch(xmlDoc,xpathExp)>
    <cfreturn rebateNode[1]>
  </cffunction>

  <cffunction name="getTurnoverElements" returntype="array">
    <cfargument name="xml" required="yes">
    <cfset var rebateNodes = XMLSearch(xml,"//component[enterfigures='true']")>
    <cfreturn rebateNodes>
  </cffunction>

  <cffunction name="getElementByID" returntype="array">
    <cfargument name="elementID" required="true">
    <cfargument name="xml" required="true" default="">
    <cfargument name="psaID" required="true" default="">
    <cfset var node = "">
    <cfif arguments.psaID neq "" and arguments.xml eq "">
      <cfset arguments.xml = getPSA(psaID).dealData>
    </cfif>
    <cfset node = XMLSearch(arguments.xml,"//parent::*//component[id='#ToString(elementID)#']")>
    <cfreturn node>
  </cffunction>

  <cffunction name="moveElement" returntype="any">
    <cfargument name="option" required="yes">
    <cfargument name="psaID" required="yes">
    <cfargument name="xmlNodeName" required="yes">
    <cfargument name="datasource" default="">
    <cfset var psa = getPSA(psaID)>
    <cfset var xmlDoc = XmlParse(psa.dealData)>
    <cfset var currentArray = ArrayNew(1)>
    <cfset var params = ListToArray(option,"&")>
    <cfset var z = "">
    <cfset var x = "">
    <cfset var elementID = "">
    <cfset var i = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfloop from="1" to="#ArrayLen(params)#" index="z">
      <cfset x = ListToArray(params[z],"=")>
      <cfset elementID = Replace(x[2],"-",".","ALL")>
      <cfset ArrayAppend(currentArray,getElementByID(elementID,xmlDoc)[1])>
    </cfloop>
    <cfset arrayClear(xmlDoc.arrangement["#xmlNodeName#"].xmlChildren)>
    <cfloop from="1" to="#ArrayLen(currentArray)#" index="i">
      <cfset arrayAppend(xmlDoc.arrangement["#xmlNodeName#"].xmlChildren,currentArray[i])>
    </cfloop>
    <cfquery name="s" datasource="#dsn.getName()#">
      update arrangement set dealData = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#ToString(xmlDoc)#">
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.psaID#">
    </cfquery>
    <cfreturn true>
  </cffunction>

  <cffunction name="getdealCategories" returntype="Query">
    <cfargument name="psaID">
    <cfset var cats = "">
    <cfquery name="cats" datasource="#dsnRead.getName()#">
        select
          categoryID,
          name
        from
          dealCategory,
          contactGroup
        where dealCategory.psaID = <cfqueryparam cfsqltype="cf_sql_integer" value="#psaID#">
        AND
        contactGroup.id = dealCategory.categoryID
      </cfquery>
    <cfreturn cats>
  </cffunction>

  <cffunction name="getFavouriteDeals" returntype="query">
  <cfset var eGroup = request.eGroup>
  <cfset var favs = "">
  <cfquery name="favs" datasource="#dsnRead.getName()#">
    select
      company.id as companyID,
      company.name companyName,
      company.known_as,
      arrangement.name,
      arrangement.id as psaID
      from
      contactFavourite,
      company LEFT JOIN arrangement on arrangement.company_id = company.id
    where
      contactFavourite.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#eGroup.contactID#">
      AND
      company.id = contactFavourite.companyID
      AND
      arrangement.period_to >= now()
      order by companyName asc;
    </cfquery>
  <cfreturn favs>
</cffunction>

  <cffunction name="paramImage" returntype="string" output="false" >
    <cfargument name="path" hint="from /web root">
    <cfargument name="default" hint="from /web root">
    <cfif fileExists("#appRoot#/web/includes/images/sites/#siteName#/#trim(arguments.path)#")>
      <cfreturn trim("/includes/images/sites/#siteName#/#arguments.path#")>
    <cfelse>
      <cfreturn trim("/includes/images/#arguments.default#")>
    </cfif>

  </cffunction>
</cfcomponent>
