
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  
  <!--- preHandler --->

  <!--- index --->
  <cffunction name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
        event.setView("web/tools/overview");

    </cfscript>
  </cffunction>
  <cffunction name="getticket" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      var ticket = request.user_ticket;
      event.renderData(type="json",data=ticket);
    </cfscript>
  </cffunction>
  <cffunction name="automation" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.doAuto = automaton.runIt();
      arguments.event.setView(name="debug",noLayout=true);
    </cfscript>
  </cffunction>
  <cffunction name="confirmAction" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.action = event.getValue("action","publishBlog");
      rc.actionURL = event.getValue("actionURL","");
      rc.doFunction = Evaluate("automaton.#rc.action#('#rc.actionURL#')");
      arguments.event.setView(name="web/blog/published",noLayout=true);
    </cfscript>
  </cffunction>
  <cffunction name="switchSite" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.buildingVine.siteID = lcase(rc.siteID);
      rc.buildingVine.defaultSite = siteService.siteDB(rc.buildingVine.siteID);
        event.setView("blank");

    </cfscript>
  </cffunction>

  <cffunction name="doCEMCOSites" rreturntype="void">
    <cfargument name="event">
	   
	  <cfset var rc = event.getCollection()>
	  <cfsetting requesttimeout="9000" >
	  <cfquery name="getCEMCOSites" datasource="eGroup_cemco">
	  	select * from company where type_id = 2 AND buildingVine = 'false' AND bvsiteid != '' group by bvsiteid
	  </cfquery>
	  <cfloop query="getCEMCOSites">
	     <!---
       <cfhttp username="admin" password="bugg3rm33" port="8080" method="post" url="http://46.51.188.170/alfresco/service/bvAPI/admin/createSite" result="siteDetail">
         <cfhttpparam type="formfield" name="sn" value="#bvsiteid#">
         <cfhttpparam type="formfield" name="title" value="#name#">
         <cfhttpparam type="formfield" name="visibility" value="PRIVATE">          
         <cfhttpparam type="formfield" name="siteType" value="Supplier">                  
       </cfhttp>
       <cfset js = StructNew()>
	     <cfset js["customData"]["companyType"] = "Manufacturer">
		   <cfset js["customData"]["address1"] = "#address1#">
		   <cfset js["customData"]["address2"] = "#address2#">
		   <cfset js["customData"]["address3"] = "#address3#">
	     <cfset js["customData"]["county"] = "#county#">
		   <cfset js["customData"]["postcode"] = "#postcode#">
	     <cfset js["customData"]["telephone"] = "#switchboard#">
		   <cfset js["customData"]["website"] = "#web#">
		   <cfset js["customData"]["email"] = "#email#">
       <cfset js["customData"]["communitySite"] = "true">
		   <cfset js["visibility"] = "PRIVATE">
	     <cfhttp username="admin" password="bugg3rm33" port="8080" method="post" url="http://46.51.188.170/alfresco/service/bvapi/sites/#bvsiteid#" result="siteDetail">
         <cfhttpparam type="header" name="content-type" value="application/json">
         <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
       </cfhttp>
       <cfhttp port="8080" method="get" url="http://46.51.188.170/share/page/modules/custom-site?shortName=#bvsiteid#" username="admin" password="bugg3rm33"></cfhttp>       
       --->
       <!--- add eBiz to membership --->
       <cfset js = StructNew()>
       <cfset js["group"]["fullName"] = "GROUP_eBiz">
       <cfset js["role"] = "SiteManager">
       <cfhttp username="admin" password="bugg3rm33" port="8080" method="put" url="http://46.51.188.170/alfresco/service/api/sites/#bvsiteid#/memberships" result="siteDetail">
         <cfhttpparam type="header" name="content-type" value="application/json">
         <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
       </cfhttp> 
	  </cfloop>
  </cffunction>

  <cffunction name="doCBA" returntype="void"> 
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
	  <cfsetting requesttimeout="99999" >
	  <!--- right, grab all CBA users --->
	  <cfquery name="cbaUsers" datasource="eGroup_cbagroup">
	  	select contact.*, contact.email as emailAddress, company.name as companyName, company.town as companyTown from contact, company where company.type_id = 1 and contact.company_id = company.id
	  </cfquery>
	  <cfloop query="cbaUsers">
	  	 <!--- first, create a BV user --->
			<cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvAPI/admin/createUser" username="admin" password="bugg3rm33" method="get" result="cUser">
				<cfhttpparam type="url" name="email" value="#emailAddress#">
				<cfhttpparam type="url" name="uid" value="#emailAddress#">
				<cfhttpparam type="url" name="fn" value="#first_name#">
				<cfhttpparam type="url" name="sn" value="#surname#">
				<cfhttpparam type="url" name="pw" value="#password#">
				<cfhttpparam type="url" name="mob" value="">
				<cfhttpparam type="url" name="o" value="#companyName#">
				<cfhttpparam type="url" name="g" value="buildingVine">
				<cfhttpparam type="url" name="jt" value="#jobTitle#">
				<cfhttpparam type="url" name="ct" value="#companyTown#">
				<cfhttpparam type="url" name="oid" value="#companyName#">
				<cfhttpparam type="url" name="permGroup" value="CBA">		      
				<cfhttpparam type="url" name="gpm" value="SiteConsumer">
			</cfhttp> 
			<!--- now update the contact in the CBA database --->
			<cfquery name="cbauser" datasource="eGroup_cbagroup">
			update 
			 contact 
			set 
			 buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
			 bvusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#emailAddress#">,
			 bvpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#password#">
			where
			 id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
			</cfquery>
			
			<!--- now grab all CBA suppliers, and make everyone a follower --->
			<cfquery name="cbaBVsuppliers" datasource="eGroup_cbagroup">
			select bvsiteid from company where buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
			</cfquery>
			<cfset thisEmail = emailAddress>
			<cfset thisPassword = password>
			<cfloop query="cbaBVsuppliers">
				<cfset jo = StructNew()>
				<cfset jo["role"] = "SiteConsumer">
				<cfset jo["person"]["userName"] = thisEmail>
				<cfhttp method="post" url="http://www.buildingvine.com/alfresco/service/api/sites/#bvsiteid#/memberships" username="#thisEmail#" password="#thisPassword#">
				  <cfhttpparam type="header" name="content-type" value="application/json">
				  <cfhttpparam type="body" name="json" value="#serializeJSON(jo)#">
				</cfhttp> 
			</cfloop> 
	  </cfloop>
	  <cfset event.noRender()>	
  </cffunction>
</cfcomponent>