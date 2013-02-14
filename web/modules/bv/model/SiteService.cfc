<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">

  <cfproperty name="shortName" />
	<cfproperty name="companyName" />
  <cfproperty name="description" />
	<cfproperty name="website" />
  <cfproperty name="email" />
	<cfproperty name="companyAddress" />
	<cfproperty name="town" />
	<cfproperty name="postcode" />
	<cfproperty name="tel" />
	<cfproperty name="fax" />
  <cfproperty name="companyType" />
  <cfproperty name="host" />
  <cfproperty name="companyLogo" /> 
  <cfproperty name="group" /> 
	<!--- Dependencies --->
  <cfproperty name="logger" inject="logbox:root" />
	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage"  scope="instance" />
  <cfproperty name="templateCache" inject="cachebox:template" />
	<cfproperty name="UserService" inject="id:bv.UserService" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage"  scope="instance" />

	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

  <cffunction name="settwitter" returntype="void">
    <cfargument name="token">
    <cfargument name="secret">
    <cfset siteID = instance.UserStorage.getVar('defaultSite').shortName>
    <cfquery name="setSiteInfo" datasource="bvine">
      update site
      set
        twitter_secret = <cfqueryparam cfsqltype="cf_sql_varchar" value="#secret#">,
        twitter_token = <cfqueryparam cfsqltype="cf_sql_varchar" value="#token#">
      WHERE
        shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.UserStorage.getVar('defaultSite').shortName#">
    </cfquery>
    <cfquery name="gs" datasource="bvine">
      select * from site where shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#instance.UserStorage.getVar('defaultSite').shortName#">
    </cfquery>
    <cfset instance.UserStorage.setVar("defaultSite",gs)>
  </cffunction>

  <cffunction name="getBuyingGroups" returntype="Struct">
  	<cfargument name="siteID" required="true" default="">
	  <!--- try CEMCO --->
	  <cfset returnOb = structNew()>
	  <cfquery name="cemco" datasource="eGroup_cemco">
	  	select * from company where bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
	  </cfquery>
	  <cfset returnOb.cemco = cemco>
	  <cfquery name="cba" datasource="eGroup_cbagroup">
      select * from company where bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
    </cfquery>
    <cfset returnOb.cba = cba>
	  <cfquery name="handb" datasource="eGroup_handbgroup">
      select * from company where bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
    </cfquery>
    <cfset returnOb.handb = handb>
	  <cfquery name="nbg" datasource="eGroup_nbg">
      select * from company where bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
    </cfquery>
    <cfset returnOb.nbg = nbg>
	  <cfreturn returnOb>  
  </cffunction>

  <cffunction name="createSite" access="public" returntype="string" output="false">
    <cfargument name="user">
    <cfset this.setshortName(makeSiteID(this.getcompanyName()))>
     <cfset js = StructNew()>
     <cfset js["shortName"] = "#this.getshortName()#">
     <cfset js["sitePreset"] = "site-dashboard">
     <cfset js["title"] = "#this.getcompanyName()#">
     <cfset js["description"] = "">
     <cfset js["visibility"] = "PUBLIC">
     <cfset js["siteType"] = "#this.getcompanyType()#">
     <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/api/sites"  username="#user.getemail()#" password="#user.getpassword1()#" result="siteDetail">
       <cfhttpparam type="header" name="content-type" value="application/json">
       <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
     </cfhttp>
     <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/bvAPI/admin/createSite" username="admin" password="bugg3rm33" result="cSite">
       <cfhttpparam type="formfield" name="sn" value="#this.getshortName()#">
       <cfhttpparam type="formfield" name="visibility" value="PUBLIC">
       <cfhttpparam type="formfield" name="siteType" value="#this.getcompanyType()#">
       <cfif ListFind(getgroup(),"cba") neq 0>
         <cfhttpparam type="formfield" name="cba" value="true">
       </cfif>
       <cfif ListFind(getgroup(),"cemco") neq 0>
         <cfhttpparam type="formfield" name="cemco" value="true">
       </cfif>
       <cfif ListFind(getgroup(),"hbgroup") neq 0>
         <cfhttpparam type="formfield" name="hbgroup" value="true">
       </cfif>
     </cfhttp>
     <cfhttp port="8080" method="get" url="http://46.51.188.170/share/page/modules/custom-site?shortName=#this.getshortName()#" username="admin" password="bugg3rm33"></cfhttp>
     <cfset logger.debug(cSite.StatusCode)>
     <cfset logger.debug(cSite.fileContent)>
     <cfif cSite.StatusCode eq "200 OK">
       <cfquery name="insertSite" datasource="bvine">
         insert into site (shortName,title,description,siteType,website,email,address1,town,postcode,tel,fax)
         VALUES (
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getshortName()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcompanyName()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcompanyType()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getwebsite()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getcompanyAddress()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettown()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpostcode()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.gettel()#">,
           <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getfax()#">
         )
       </cfquery>
       <cftry>
       <cfdirectory action="create" directory="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#">
       <cfif this.getcompanyLogo() neq "">
        <cffile action="upload" filefield="companyLogo" destination="ram://" result="result" nameconflict="overwrite">
        <cfimage name="logo" action="read" source="ram://#result.serverFile#" />
        <cfimage name="imgOb" action="read" source="ram://#result.serverFile#" />
        <cfif imgOb.width gt imgOb.height>
          <cfset ImageResize(imgOb,"","46")>
          <cfelse>
          <cfset ImageResize(imgOb,"46","")>
        </cfif>
        <cfset ImageCrop(imgOb,0,0,"46","46")>
        <cfimage quality="0.95" source="#imgOb#" action="write" destination="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#/small.jpg" overwrite="yes">
        <cfif logo.height lt logo.width>
          <cfimage action="resize" width="300" height="" overwrite="yes" destination="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#/large.jpg"  source="#logo#">
          <cfimage action="resize" width="300" height="" overwrite="yes" destination="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#_web.png"  source="#logo#">
          <cfimage action="resize" width="" height="40" overwrite="yes" destination="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#.png"  source="#logo#">
        <cfelse>
          <cfimage action="resize" height="150" width="" overwrite="yes" destination="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#/large.jpg"  source="#logo#">
          <cfimage action="resize" height="150" width="" overwrite="yes" destination="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#_web.png"  source="#logo#">
          <cfimage action="resize" height="40" width="" overwrite="yes" destination="#instance.ApplicationStorage.getVar('appRoot')#/includes/images/companies/#this.getshortName()#.png"  source="#logo#">
        </cfif>

      </cfif>
      <cfcatch type="any"><cfmail from="sitesetup@bvine.net" to="tom.miller@ebiz.co.uk" subject="Error creating site" server="46.51.188.170"><cfdump var="#cfcatch#"></cfmail></cfcatch>
        </cftry>
     </cfif>
  </cffunction>

  <cffunction name="getImportStatus" returntype="query" output="false">
    <cfargument name="siteID">
    <cfquery name="u" datasource="bvine">
      select productImportStatus, importStatusLastTime from site
      where shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteID#">
    </cfquery>
    <cfreturn u>
  </cffunction>

  <!--- filter Sites --->
  	
  <cffunction name="totalSites" returntype="Any">
    <cfargument name="filter" required="true" default="">
    <cfargument name="size" required="true" default="10">
    <cfargument name="startRow" required="true" default="1">  
    <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/api/sites?alf_ticket=#request.buildingVine.user_ticket#" result="siteList">
    <cfreturn ArrayLen(DeSerializeJSON(siteList.fileContent))>
  </cffunction>	
  	
  <cffunction name="filterList" returntype="Any">
  	<cfargument name="filter" required="true" default="">
    <cfargument name="typeFilter" required="true" default="">
	   <cfargument name="updateFilter" required="true" default="">
      <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/bvapi/siteList?roles=user&nf=#arguments.filter#&tf=#arguments.typeFilter#&uf=#arguments.updateFilter#&alf_ticket=#request.buildingVine.user_ticket#" result="siteList">
      <cfset theList = DeSerializeJSON(siteList.fileContent)>
      <cfreturn theList>  
  </cffunction>
  
  <cffunction name="fullList" returntype="Any">
    <cfargument name="filter" required="true" default="">
    <cfargument name="size" required="true" default="10">
    <cfargument name="startRow" required="true" default="1">     
    <cfset cacheKey = "siteList_#arguments.filter#_#arguments.size#_#arguments.startRow#"> 
    <cfif templateCache.lookup(cacheKey)>
      <cfset logger.debug("cacheKey found: #cacheKey#")>
      <cfreturn templateCache.get(cacheKey)>
    <cfelse>  
      <cfset logger.debug("cacheKey not found: #cacheKey#")>
      <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/bvapi/sites?roles=user&alf_ticket=#request.buildingVine.user_ticket#" result="siteList">
      <cfset theList = DeSerializeJSON(siteList.fileContent)>
      <cfset templateCache.set(cacheKey,theList,180,180)>
      <cfreturn theList>  
    </cfif>
  </cffunction> 
  
	<!--- getParentListing --->
	<cffunction name="getMembers" access="public" returntype="Query" output="false">
	  <cfargument name="siteID" required="true">
    <cfargument name="limit" required="true" default="60">
    <cfset var cacheKey = "siteMembers#arguments.siteID##arguments.limit#">
    <cfif templateCache.lookup(cacheKey)>
      <cfset logger.debug("cacheKey found: #cacheKey#")>
      <cfreturn templateCache.get(cacheKey)>
    <cfelse>
      <cfset logger.debug("cacheKey not found: #cacheKey#")> 
  	  <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/bvapi/sites/#siteID#/memberships?size=#limit#" username="admin" password="bugg3rm33" result="siteMembers">
  	  <cfset members = DeserializeJSON(sitemembers.fileContent)>
      <cfset memberQ = QueryNew("firstname,lastName,company,role,userName")>
      <cfloop array="#members#" index="member">
        <cfset queryAddRow(memberQ)>
        <cfset querySetCell(memberQ,"firstname","#member.authority.firstName#")>
        <cfset querySetCell(memberQ,"lastName","#member.authority.lastName#")>
        <cfset querySetCell(memberQ,"company","#member.authority.organization#")>
        <cfset querySetCell(memberQ,"role","#member.role#")>
        <cfset querySetCell(memberQ,"userName","#member.authority.userName#")>
      </cfloop>
      <cfquery name="retMembers" dbtype="query">
        select * from memberQ order by lastName asc;
      </cfquery>
      <cfset templateCache.set(cacheKey,retMembers,180,180)>
      <cfreturn retMembers>
    </cfif>    
	</cffunction>

  <cffunction name="getMembership" access="public" returntype="Array" output="false">
    <cfargument name="siteID" required="true">
    <cfargument name="userRole" required="true" default="">
	  <cfargument name="authType" required="true" default="">
	  <cfset var theURL = "http://46.51.188.170/alfresco/service/api/sites/#arguments.siteID#/memberships?rf=#arguments.userRole#&alf_ticket=#request.buildingVine.user_ticket#">
	  <cfif authType neq "">
	  	<cfset theURL = "#theURL#&authorityType=#arguments.authType#">
	  </cfif>
    <cfhttp port="8080" method="get" url="#theURL#" result="siteMembers">
    <cfreturn DeserializeJSON(siteMembers.fileContent)>
  </cffunction>
  <cffunction name="thisRole" access="public" returntype="string" output="false">
    <cfargument name="memberList" required="true">
    <cfargument name="emailaddress" required="true" default="">
    <cfquery name="retMembers" dbtype="query">
      select role from memberList where username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailaddress#">;
    </cfquery>
    <cfreturn retMembers.role>
  </cffunction>

  <!--- getParentListing --->
  <cffunction name="listSites" access="public" returntype="any" output="false">
    <cfargument name="siteID">
    <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/bvapi/sites/#siteID#/memberships" username="admin" password="bugg3rm33" result="siteMembers">
    <cfreturn DeserializeJSON(sitemembers.fileContent)>
  </cffunction>

  <!--- getParentListing --->
  <cffunction name="invite" access="public" returntype="any" output="false">
    <cfargument name="siteID" required="true">
    <cfargument name="userName" required="true"> 
	  <cfargument name="first_name" required="true">
	  <cfargument name="surname" required="true">
	 	<cfargument name="siteRole" required="true">
		<cfargument name="password" required="true">
		<cfargument name="ticket" required="true">
		<cfset var jsonObject["invitationType"] = "NOMINATED">
		<cfset var jsonObject["inviteeUserName"] = "#arguments.userName#">
		<cfset var jsonObject["inviteeFirstName"] = "#arguments.first_name#">
		<cfset var jsonObject["inviteeLastName"] = "#arguments.surname#">
		<cfset var jsonObject["inviteeRoleName"] = "#arguments.siteRole#">
		<cfset var jsonObject["newPassword"] = "#arguments.password#">
		<cfset var jsonObject["serverPath"] = "http://46.51.188.170/">
		<cfset var jsonObject["acceptURL"] = "signup/accept">
		<cfset var jsonObject["rejectURL"] = "signup/reject">
    <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/bvapi/sites/#arguments.siteID#/invitations" username="admin" password="bugg3rm33" result="siteInvitation">
	     <cfhttpparam type="header" name="content-type" value="application/json">
       <cfhttpparam type="body" name="json" value="#serializeJSON(jsonObject)#">
	  </cfhttp>
    <cfreturn DeserializeJSON(siteInvitation.fileContent)>
  </cffunction>

  <cffunction name="listSuppliers" access="public" returntype="any" output="false">
    <cfquery name="sites" datasource="bvine">
      select * from site where active = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
      order by status desc, siteType desc, title asc
    </cfquery>
    <cfreturn sites>
  </cffunction>

  <cffunction name="siteDB" returntype="query">
    <cfargument name="id">
    <cfquery name="siteinfo" datasource="bvine">
      select * from site where shortname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#id#">
    </cfquery>
    <cfreturn siteinfo>
  </cffunction>
  
  <cffunction name="getSite" returntype="any">
    <cfargument name="siteID">
    <cfset var cacheKey = "siteDetail#arguments.siteID#">
    <cfif templateCache.lookup(cacheKey)>
      <cfset logger.debug("cacheKey found: #cacheKey#")>
      <cfreturn templateCache.get(cacheKey)>
    <cfelse>
      <cfset logger.debug("cacheKey not found: #cacheKey#")>
      <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/bvapi/sites/#siteID#?alf_ticket=#request.user_ticket#" result="siteDetail">
      <cfset thisSiteList = DeserializeJSON(siteDetail.fileContent)>
      <cfset templateCache.set(cacheKey,thisSiteList,180,180)>
      <cfreturn thisSiteList>
    </cfif>
  </cffunction>
  
  <cfscript> 
        function makeSiteID(str) {
          str = ReReplaceNoCase(str,"[^A-Za-z]","","ALL");
          str = lcase(str);
          return str;
        }
</cfscript>
  <cffunction name="getRole" access="public" returntype="any" output="false">
    <cfargument name="siteID">
    <cfargument name="userID">
    <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/api/sites/#siteID#/memberships/#userID#" username="admin" password="bugg3rm33" result="siteMembers">
    <cfif sitemembers.StatusCode neq "200 OK">
      <cfreturn {"role" = "SiteConsumer"}>
    <cfelse>
    <cfreturn DeserializeJSON(sitemembers.fileContent)>
    </cfif>
  </cffunction>
  <cffunction name="getLocaStockists" returntype="query">
    <cfargument name="siteID">
    <cfargument name="lat">
    <cfargument name="lng">
    <cfquery name="getLocals" datasource="eGroup_cemco">
        select
          branch.id as branchID, branch.tel, branch.name, branch.address1,branch.town,branch.maplat,branch.maplong,
          member.id as memberID, member.name as memberName, member.known_as,
          (3959 * acos( cos( radians(<cfqueryparam cfsqltype="cf_sql_float" value="#lat#">) ) * cos( radians( maplat ) ) * cos( radians( maplong ) - radians(<cfqueryparam cfsqltype="cf_sql_float" value="#lng#">) ) + sin( radians(<cfqueryparam cfsqltype="cf_sql_float" value="#lat#">) ) * sin( radians( maplat ) ) ) ) AS distance
        from
          branch,
          company,
          company as member,
          arrangement,
          turnover
        where
          company.bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#siteID#">
            AND
            arrangement.company_id = company.ID
            AND
            arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
            AND
            turnover.psaID = arrangement.id
            AND
            turnover.value > 0
            AND
            turnover.period > <cfqueryparam cfsqltype="cf_sql_date" value="#Year(now())#">
            AND
            member.id = turnover.memberID
            AND
            branch.company_id = member.id
       group by branch.id
          HAVING
        distance < 20
       ORDER BY distance LIMIT 0 , 20;
    </cfquery>
    <cfreturn getLocals>
  </cffunction>

  <cffunction name="getAllLocaStockists" returntype="query">    
    <cfquery name="sites" datasource="bvine">select * from site where siteType= <cfqueryparam cfsqltype="cf_sql_varchar" value="Supplier"> AND active = <cfqueryparam cfsqltype="cf_sql_varchar" value="true"> order by shortName;</cfquery>
    <cfloop query="sites">
      
        
      
      <cfquery name="getLocals" datasource="eGroup_cemco">
        insert into buildingVine.stockistLocator
          (bvSiteID,buyingGroup,branchID,companyID,companyName,branchLat,branchLong,branchName,branchTel,branchTown,branchPostcode,branchAddress1)
          
           
            select
            '#shortName#',
            'eGroup_cemco',
            branch.id,
            member.id,
            member.name,
            branch.maplat,
            branch.maplong, 
            branch.name,
            branch.tel,
            branch.town,
            branch.postcode,
            branch.address1

          from
            eGroup_cemco.branch,
            eGroup_cemco.company,
            eGroup_cemco.company as member,
            eGroup_cemco.arrangement,
            eGroup_cemco.turnover
          where
            company.bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">
            AND
            arrangement.company_id = company.ID
            AND
            arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            turnover.psaID = arrangement.id
            AND
            turnover.value > 0
            AND
            turnover.period > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            member.id = turnover.memberID
            AND
            branch.company_id = member.id
         group by branch.id
         
      </cfquery>
      <cfquery name="getLocals" datasource="eGroup_cbagroup">
          insert into buildingVine.stockistLocator
          (bvSiteID,buyingGroup,branchID,companyID,companyName,branchLat,branchLong,branchName,branchTel,branchTown,branchPostcode,branchAddress1)
          select
            '#shortName#',
            'eGroup_cbagroup',
            branch.id,
            member.id,
            member.name,
            branch.maplat,
            branch.maplong,
            branch.name,
            branch.tel,
            branch.town,
            branch.postcode,
            branch.address1

          from
            eGroup_cbagroup.branch,
            eGroup_cbagroup.company,
            eGroup_cbagroup.company as member,
            eGroup_cbagroup.arrangement,
            eGroup_cbagroup.turnover
          where
            company.bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">
            AND
            arrangement.company_id = company.ID
            AND
            arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            turnover.psaID = arrangement.id
            AND
            turnover.value > 0
            AND
            turnover.period > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            member.id = turnover.memberID
            AND
            branch.company_id = member.id
         group by branch.id
         
      </cfquery>
      <cfquery name="getLocals" datasource="eGroup_handbgroup">
          insert into buildingVine.stockistLocator
          (bvSiteID,buyingGroup,branchID,companyID,companyName,branchLat,branchLong,branchName,branchTel,branchTown,branchPostcode,branchAddress1)
          
          select
            '#shortName#',
            'eGroup_handbgroup',
            branch.id,
            member.id,
            member.name,
            branch.maplat,
            branch.maplong,
            branch.name,
            branch.tel,
            branch.town,
            branch.postcode,
            branch.address1

          from
            eGroup_handbgroup.branch,
            eGroup_handbgroup.company,
            eGroup_handbgroup.company as member,
            eGroup_handbgroup.arrangement,
            eGroup_handbgroup.turnover
          where
            company.bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">
            AND
            arrangement.company_id = company.ID
            AND
            arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            turnover.psaID = arrangement.id
            AND
            turnover.value > 0
            AND
            turnover.period > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            member.id = turnover.memberID
            AND
            branch.company_id = member.id
         group by branch.id
         
      </cfquery>
      <cfquery name="getLocals" datasource="eGroup_nbg">
          insert into buildingVine.stockistLocator
          (bvSiteID,buyingGroup,branchID,companyID,companyName,branchLat,branchLong,branchName,branchTel,branchTown,branchPostcode,branchAddress1)
          
          select
            '#shortName#',
            'eGroup_nbg',
            branch.id,
            member.id,
            member.name,
            branch.maplat,
            branch.maplong,
            branch.name,
            branch.tel,
            branch.town,
            branch.postcode,
            branch.address1

          from
            eGroup_nbg.branch,
            eGroup_nbg.company,
            eGroup_nbg.company as member,
            eGroup_nbg.arrangement,
            eGroup_nbg.turnover
          where
            company.bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#shortName#">
            AND
            arrangement.company_id = company.ID
            AND
            arrangement.period_to > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            turnover.psaID = arrangement.id
            AND
            turnover.value > 0
            AND
            turnover.period > <cfqueryparam cfsqltype="cf_sql_date" value="2012-01-01">
            AND
            member.id = turnover.memberID
            AND
            branch.company_id = member.id 
         group by branch.id
         
      </cfquery>
      
    </cfloop>
    <cfset instance.UserStorage.setVar("processedLocations",true)>
    <cfreturn getLocals>
  </cffunction>

  <cffunction name="getSiteHost" returntype="query">
  <cfif ListFirst(cgi.HTTP_HOST,".") eq "m" OR ListFirst(cgi.HTTP_HOST,".") eq "x" OR  ListFirst(cgi.HTTP_HOST,".") eq "connect">
      <cfset siteID = ListGetAt(cgi.HTTP_HOST,2,".")>
      <cfif siteID neq "buildingvine">
        <cfquery name="site" datasource="bvine">
          select shortName from site where shortname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#siteID#">
        </cfquery>
      <cfelse>
        <cfquery name="site" datasource="bvine">
          select shortName from site where shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="buildingvine">
        </cfquery>
      </cfif>
    <cfelse>
      <cfquery name="site" datasource="bvine">
        select shortName from site where host RLIKE "(^|,)#cgi.host#($|,)"
      </cfquery>
    </cfif>
    <cfreturn site>
  </cffunction>
</cfcomponent>