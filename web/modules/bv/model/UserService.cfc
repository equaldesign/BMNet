<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">

<cfproperty name="id" />
<cfproperty name="first_name" />
<cfproperty name="surname" />
<cfproperty name="email" />
<cfproperty name="password1" />
<cfproperty name="gender" />
<cfproperty name="dob" />
<cfproperty name="skype" />
<cfproperty name="mobile" />
<cfproperty name="companyName">
<cfproperty name="siteID" default="buildingVine"> 
<cfproperty name="primarySite" />


	<!--- Dependencies --->
  <cfproperty name="bvAddress" inject="coldbox:setting:bvAddress">
  <cfproperty name="siteService" inject="id:bv.SiteService"> 
	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
	<cfproperty name="logger" inject="logbox:root">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">

  <cffunction name="getFeedControls" returntype="array" access="public">        
    <cfhttp port="8080" throwOnError="true" result="feedControls" url="http://46.51.188.170/alfresco/service/api/activities/feed/controls?format=json&alf_ticket=#request.buildingVine.user_ticket#"></cfhttp>
    <cfreturn DeSerializeJSON(feedControls.fileContent)>
  </cffunction>

  <cffunction name="isValidTicket" returntype="boolean" access="public">
    <cfargument name="ticket" required="true" type="string">
    <cftry>
      <cfhttp port="8080" throwOnError="true" result="validTicket" url="http://46.51.188.170/alfresco/service/api/login/ticket/#arguments.ticket#?alf_ticket=#arguments.ticket#"></cfhttp>
      <cfcatch type="any">
        <!--- ticket isn't valid --->
        <cfset logger.debug("Ticket was not valid: #cfcatch.message#")>

        <cfreturn false>
      </cfcatch>
    </cftry>
    <cfset logger.debug("Ticket was valid!")>
    <cfreturn true>
  </cffunction>

  <cffunction name="confirm" returntype="any">
    <cfargument name="userID">
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvAPI/admin/confirm" username="admin" password="bugg3rm33" method="post" result="cUser">
      <cfhttpparam type="url" name="uid" value="#arguments.userID#">
        
      
    </cfhttp>
  </cffunction>

	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

  <cffunction name="resetpassword" returntype="string">
    <cfargument name="username">    
    <cfset var password = MakePassword()>
    <cfhttp port="8080" result="mleh" url="http://www.buildingvine.com/alfresco/service/bvine/resetpassword" method="post" username="admin" password="bugg3rm33">
      <cfhttpparam type="formfield" name="username" value="#arguments.username#">
        
      
      <cfhttpparam type="formfield" name="password" value="#arguments.password#">
      
    </cfhttp>
    <cfreturn password>
  </cffunction>

  <cffunction name="doBuyingGroups" returntype="void">
    <cfargument name="siteShortName" required="true">
    <cfquery name="tryCEMCO" datasource="eGroup_cemco">
      select
        contact.id as contactID,
        company.id as companyID
      from
        contact,
        company
      where
        contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">
        AND
        company.id = contact.company_id
    </cfquery>
    <cfif tryCEMCO.recordCount neq 0>
      <!--- sweet, we've found them --->
      <cfquery name="u" datasource="eGroup_cemco">
        update contact set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">,
        bvpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpassword1()#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCEMCO.contactID#">
      </cfquery>
      <cfquery name="doFeed" datasource="eGroup_cemco">
        insert into newsFeed
          (sourceObject,sourceID,targetObject,targetID,actionID)
        VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCEMCO.contactID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="company">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCEMCO.companyID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="21">
            )
      </cfquery>
      <cfquery name="uu" datasource="eGroup_cemco">
        update company set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteShortName#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCEMCO.companyID#">
      </cfquery>
    </cfif>
    <cfquery name="tryCBA" datasource="eGroup_cbagroup">
      select
        contact.id as contactID,
        company.id as companyID
      from
        contact,
        company
      where
        contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">
        AND
        company.id = contact.company_id
    </cfquery>
    <cfif tryCBA.recordCount neq 0>
      <!--- sweet, we've found them --->
      <cfquery name="u" datasource="eGroup_cbagroup">
        update contact set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">,
        bvpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpassword1()#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCBA.contactID#">
      </cfquery>
      <cfquery name="doFeed" datasource="eGroup_cemco">
        insert into newsFeed
          (sourceObject,sourceID,targetObject,targetID,actionID)
        VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCBA.contactID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="company">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCBA.companyID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="21">
            )
      </cfquery>
      <cfquery name="uu" datasource="eGroup_cbagroup">
        update company set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteShortName#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryCEMCO.companyID#">
      </cfquery>
    </cfif>
    <cfquery name="tryHB" datasource="eGroup_handbgroup">
      select
        contact.id as contactID,
        company.id as companyID
      from
        contact,
        company
      where
        contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">
        AND
        company.id = contact.company_id
    </cfquery>
    <cfif tryHB.recordCount neq 0>
      <!--- sweet, we've found them --->
      <cfquery name="u" datasource="eGroup_handbgroup">
        update contact set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">,
        bvpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpassword1()#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryHB.contactID#">
      </cfquery>
      <cfquery name="doFeed" datasource="eGroup_cemco">
        insert into newsFeed
          (sourceObject,sourceID,targetObject,targetID,actionID)
        VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryHB.contactID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="company">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryHB.companyID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="21">
            )
      </cfquery>
      <cfquery name="uu" datasource="eGroup_handbgroup">
        update company set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteShortName#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryHB.companyID#">
      </cfquery>
    </cfif>
    <cfquery name="tryNBG" datasource="eGroup_nbg">
      select
        contact.id as contactID,
        company.id as companyID
      from
        contact,
        company
      where
        contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">
        AND
        company.id = contact.company_id
    </cfquery>
    <cfif tryNBG.recordCount neq 0>
      <!--- sweet, we've found them --->
      <cfquery name="u" datasource="eGroup_nbg">
        update contact set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvusername = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getemail()#">,
        bvpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#this.getpassword1()#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryNBG.contactID#">
      </cfquery>
      <cfquery name="doFeed" datasource="eGroup_cemco">
        insert into newsFeed
          (sourceObject,sourceID,targetObject,targetID,actionID)
        VALUES
          (
            <cfqueryparam cfsqltype="cf_sql_varchar" value="contact">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryNBG.contactID#">,
            <cfqueryparam cfsqltype="cf_sql_varchar" value="company">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="#tryNBG.companyID#">,
            <cfqueryparam cfsqltype="cf_sql_integer" value="21">
            )
      </cfquery>
      <cfquery name="uu" datasource="eGroup_nbg">
        update company set buildingVine = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">,
        bvsiteid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.siteShortName#">
        where
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#tryNBG.companyID#">
      </cfquery>
    </cfif>
  </cffunction>

	<cffunction name="createUser" output="false" access="public" returntype="boolean" hint="Constructor">

		<!--- this creates a new user in Building Vine --->
		<cfset success = false>
		<!---
    <cfif arguments.sitename neq ""><!--- if there is already a site --->
			<cfif arguments.company.gettype_id() eq 2>
				<cfset gpm = "SiteCollaborator"><!--- all suppliers join their own sites as collaborators --->
			<cfelse>
				<!--- it's a member, so add them to their site with cba member privs --->
				<cfif isUserInRole("memberadmin")>
					<cfset gpm = "SiteManager">
				<cfelseif isUserInRole("memberedit")>
					<cfset gpm = "SiteCollaborator">
				<cfelseif isUserInRole("memberrebate")>
					<cfset gpm = "SiteContributor">
				<cfelse>
					<cfset gpm = "SiteConsumer">
				</cfif>
			</cfif>
		<cfelse>
			<cfset gpm=""><!--- else don't assign a level --->
		</cfif>
    --->
    <cfset gpm="">
    <cfset permGroup = "">
    <cfset spm = "SiteCollaborator">
    <!---
		<cfset permGroup = ""> <!--- set an empty default for the BV Group to assign the user to --->

		<cfif company.gettype_id() eq 1>
			<!--- they are a member, so therefore assign them to a group --->
			<cfif isUserInRole("admin")>
				<cfset permGroup = "cbaadmin">
				<cfset spm = "SiteManager">
			<cfelseif isUserInRole("edit")>
				<cfset permGroup = "cbaedit">
				<cfset spm = "SiteCollaborator">
			<cfelseif isUserInRole("figures")>
				<cfset permGroup = "cbafigures">
				<cfset spm = "SiteCollaborator">
			<cfelseif isUserInRole("viewrebate")>
				<cfset permGroup = "cbaviewrebate">
				<cfset spm = "SiteContributor">
			<cfelse>
				<cfset permGroup = "cbaview">
				<cfset spm = "SiteConsumer">
			</cfif>
		<cfelse>
		  <cfset permGroup = "">
      <cfset spm = "SiteCollaborator">
		</cfif> --->
    <cfif getsiteID() eq "">
      <cfset setsiteID("buildingVine")>
    </cfif>

		<!--- now create the user --->
		<cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvAPI/admin/createUser" username="admin" password="bugg3rm33" method="get" result="cUser">
		  <cfhttpparam type="url" name="email" value="#getemail()#">
		  <cfhttpparam type="url" name="uid" value="#getemail()#">
		  <cfhttpparam type="url" name="fn" value="#getfirst_name()#">
		  <cfhttpparam type="url" name="sn" value="#getsurname()#">
		  <cfhttpparam type="url" name="pw" value="#getpassword1()#">
		  <cfhttpparam type="url" name="mob" value="">
		  <cfhttpparam type="url" name="o" value="#getsiteID()#">
      <cfhttpparam type="url" name="s" value="buildingVine">
      <cfhttpparam type="url" name="oid" value="#getsiteID()#">
		  <cfhttpparam type="url" name="permGroup" value="#permGroup#">
		  <cfhttpparam type="url" name="spm" value="#spm#">
		  <cfhttpparam type="url" name="gpm" value="#gpm#">
		</cfhttp>

		<cfmail from="tom@ebiz.co.uk" to="tom.miller@ebiz.co.uk" subject="newusersignup" server="46.51.188.170"><cfoutput>#getemail()#:#getpassword1()# signed up</cfoutput></cfmail>
		<cfif cUser.StatusCode eq "200 OK">

			<cfset success = true>
		</cfif>
    <cfreturn success>
	</cffunction>

  <cffunction name="createSiteUser" output="false" access="public" returntype="boolean" hint="Constructor">
    <cfargument name="permission" required="true" default="SiteConsumer">
    <!--- this creates a new user in Building Vine --->
    <cfset success = false>
    <cfset gpm="">
    <cfset permGroup = "">
    <cfset spm = "SiteCollaborator">
    <cfif getsiteID() eq "">
      <cfset setsiteID("buildingVine")>
    </cfif>

    <!--- now create the user --->
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvAPI/admin/createUser" username="admin" password="bugg3rm33" method="get" result="cUser">
      <cfhttpparam type="url" name="email" value="#getemail()#">
      <cfhttpparam type="url" name="uid" value="#getemail()#">
      <cfhttpparam type="url" name="fn" value="#getfirst_name()#">
      <cfhttpparam type="url" name="sn" value="#getsurname()#">
      <cfhttpparam type="url" name="pw" value="#getpassword1()#">
      <cfhttpparam type="url" name="mob" value="#getmobile()#">
      <cfhttpparam type="url" name="o" value="#getsiteID()#">
      <cfhttpparam type="url" name="s" value="#getsiteID()#">
        <cfhttpparam type="url" name="oid" value="#getsiteID()#">
      <cfhttpparam type="url" name="permGroup" value="#permGroup#">
      <cfhttpparam type="url" name="spm" value="#arguments.permission#">
      <cfhttpparam type="url" name="gpm" value="#gpm#">
    </cfhttp>

    <cfmail from="tom@ebiz.co.uk" to="tom.miller@ebiz.co.uk" subject="newusersignup" server="46.51.188.170"><cfoutput>#getemail()#:#getpassword1()# signed up</cfoutput></cfmail>
    <cfif cUser.StatusCode eq "200 OK">
      <cfset success = true>
    </cfif>
    <cfreturn success>
  </cffunction>

	<!--- getParentListing --->
	<cffunction name="isActive" output="false" access="public" returntype="boolean">
		<cfset eGroup = UserStorage.getVar("eGroup")>
		<cfset ret = StructNew()>
		<cfif eGroup.bvactive>
			<cfif structKeyExists(eGroup,"alf_ticket")>
				<!--- check the ticket is valid --->
				<cfset ticket = eGroup.alf_ticket>
				<cfif validTicket(ticket,eGroup.bvusername,eGroup.bvpassword)>
					<cfreturn true> <!--- all good --->
				<cfelse>
					<!--- ticket must have timed out --->
					<cfset ticket = getTicket(eGroup.bvusername,eGroup.bvpassword)>
					<cfif ticket neq "false">
						<cfset eGroup.alf_ticket = ticket>
						<cfreturn true>
					<cfelse>
						<!--- hmm, login was incorrect!? --->
						<cfreturn false>
					</cfif>
				</cfif>
			<cfelse>
				<!--- create a new one --->
				<cfset ticket = getTicket(eGroup.bvusername,eGroup.bvpassword)>
				<cfif ticket neq "false">
					<cfset eGroup.alf_ticket = ticket>
					<cfreturn true>
				<cfelse>
					<!--- hmm, login was incorrect!? --->
					<cfreturn false>
				</cfif>
			</cfif>
		<cfelse>
			<!--- the user isn't even registered! --->
			<cfreturn false>
		</cfif>

	</cffunction>

  <cffunction name="getUserGroups" returntype="array">
    <cfhttp port="8080" result="groups" url="http://46.51.188.170/alfresco/service/bvine/security/usergroups?alf_ticket=#request.user_ticket#"></cfhttp>
    <cfreturn DeserializeJSON(groups.fileContent)>
  </cffunction>

	<!--- get Ticket --->
	<cffunction name="getTicket" returntype="any" access="public">
     <cfargument name="username" required="true" type="string">
     <cfargument name="password" required="true" type="string">
      <cfset js = StructNew()>
      <cfset js["username"] = username>
      <cfset js["password"] = password>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/login" method="POST">
	      <cfhttpparam type="header" name="content-type" value="application/json">
	      <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
      </cfhttp>
      <cfscript>        
        if (cfhttp.Status_Code eq "200") {
         xmlTicketResponse = DeserializeJSON(Trim(cfhttp.FileContent));
         ticket = xmlTicketResponse.data.ticket;
         return ticket;
        } else { 
          logger.debug(cfhttp.FileContent); 
          return false;
        }
      </cfscript>
  </cffunction>

  <cffunction name="getUserTicket" returntype="string" access="public">
    <cfargument name="admin" required="true" default="false" type="boolean">
	  <cfargument name="guest" required="true" default="false" type="boolean">
    <cfset var buildingVine = request.buildingVine>
    <cfif admin>
      <cfif isValidTicket(buildingVine.admin_ticket)>
        <cfreturn buildingVine.admin_ticket>
      <cfelse>
        <cfset adminTicket = getTicket("admin","bugg3rm33")>
		    <cfif isStruct(buildingVine)>
	        <cfset buildingVine.admin_ticket = adminTicket>
	        <cfset UserStorage.setVar("buildingVine",buildingVine)>
			  </cfif>
        <cfreturn adminTicket>
      </cfif>
    <cfelse>
      <cfif buildingVine.user_ticket eq "">
        <cfif isValidTicket(buildingVine.guest_ticket)>
          <cfreturn buildingVine.guest_ticket>
        <cfelse>
          <cfset guestTicket = getTicket("guest","")>
          <cfset buildingVine.guest_ticket = guestTicket>
          <cfset UserStorage.setVar("buildingVine",buildingVine)>
          <cfreturn guestTicket>
        </cfif>
      <cfelse>
        <cfif buildingVine.user_ticket neq "" AND isValidTicket(buildingVine.user_ticket)>
          <cfreturn buildingVine.user_ticket>
        <cfelse> 
          <cfset userTicket = getTicket(buildingVine.username,buildingVine.password)>
          <cfset buildingVine.user_ticket = userTicket>
          <cfset UserStorage.setVar("buildingVine",buildingVine)>
          <cfreturn userTicket>
        </cfif>
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="listSites" returntype="array" access="public">
     <cfset var ticket = request.buildingVine.user_ticket>
     <cfset var email = request.buildingVine.username>
     <cfhttp port="8080" result="sites" url="http://46.51.188.170/alfresco/service/api/people/#email#/sites?alf_ticket=#ticket#"></cfhttp>
     <cfreturn DeserializeJSON(sites.fileContent)>
  </cffunction>

  <cffunction name="allPeople" returntype="struct" access="public">
     <cfhttp port="8080" username="admin" password="bugg3rm33" result="peeps" url="http://46.51.188.170/alfresco/service/api/people"></cfhttp>
     <cfreturn DeserializeJSON(peeps.fileContent)>
  </cffunction>
	<cffunction name="getTasks" returntype="struct">
	    <cfset var ticket = UserStorage.getVar("alf_ticket")>
	    <cfset var email = UserStorage.getVar("username")>
	    <cfset var retStruct = StructNew()>
	    <cfhttp port="8080" result="userTasks" method="get" url="http://46.51.188.170/alfresco/service/slingshot/dashlets/my-tasks?alf_ticket=#ticket#"></cfhttp>
	    <cfreturn DeserializeJSON(userTasks.fileContent)>
	</cffunction>

  <cffunction name="getUser" returntype="struct">
    <cfargument name="userID">
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/profile/#userID#?format=json&alf_ticket=#request.user_ticket#" result="profile"></cfhttp>
    <cfreturn DeSerializeJSON(profile.FileContent)>
  </cffunction>

  <cffunction name="resetPassword" returntype="string">
  	<cfargument name="username">	  
	  <cfset var newPass = MakePassword()>	   
	  <cfhttp method="post" port="8080" url="http://46.51.188.170/alfresco/service/bvine/resetpassword" username="admin" password="bugg3rm33" result="invites">
      <cfhttpparam type="formfield" name="username" value="#arguments.username#">
	    <cfhttpparam type="formfield" name="password" value="#newPass#">
	  </cfhttp> 
    <cfreturn newPass>
  </cffunction>
  
  
  <cffunction name="getInvitations" returntype="struct">
    <cfargument name="userID">
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/invitations?inviteeUserName=#arguments.userID#&alf_ticket=#request.user_ticket#" result="invites"></cfhttp>
    <cfreturn DeSerializeJSON(invites.FileContent)>
  </cffunction>
  
  <cffunction name="startInvite" returntype="void">
    <cfargument name="userName">
    <cfargument name="inviteID">	  
	  <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/task-instances?authority=#arguments.username#" result="invites" username="admin" password="bugg3rm33"></cfhttp>
    <cfset userTasks = DeSerializeJSON(invites.FileContent)>	      
	  <cfloop array="#userTasks.data#" index="task">
	  	<cfset invID = ListLast(task.path,"/")>		  
		  <cfset js["prop_bpm_comment"] = "">
		  <cfset js["prop_inwf_inviteOutcome"] = "accept">
		  <cfset js["prop_transitions"] = "next">  
		  <cfif invID eq arguments.inviteID>		  	
		    <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/api/task/#URLencodedFormat(task.id)#/formprocessor" result="invites" username="admin" password="bugg3rm33">
				  <cfhttpparam type="header" name="content-type" value="application/json">
          <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
			  </cfhttp>  			 
			  <cfset thisUserPrefence = getUserPreferences(arguments.userName)>
			  <cfif NOT StructKeyExists(thisUserPrefence,"defaultSite") OR thisUserPrefence.defaultSite eq "buildingVine">				  	  
				  <cfset buildingVine.preferences["defaultSite"] = task.properties.inwf_resourceName>
		      <cfhttp port="8080" method="post" username="admin" password="bugg3rm33" result="preferences" url="http://46.51.188.170/alfresco/service/api/people/#arguments.username#/preferences">
		        <cfhttpparam type="header" name="content-type" value="application/json">
		        <cfhttpparam type="body" name="json" value="#serializeJSON(buildingVine["preferences"])#">
		      </cfhttp> 
			  </cfif>
			  <cfbreak>	
		  </cfif>	  
	  </cfloop> 
  </cffunction>
  
  <cffunction name="getUserSites" returntype="Any"> 
  	<cfargument name="userID" required="true">
	  <!--- getParentListing --->
    <cfhttp port="8080" method="get" url="http://46.51.188.170/alfresco/service/api/people/#arguments.userID#/sites?size=500" username="admin" password="bugg3rm33" result="siteMembers">
    <cfreturn DeserializeJSON(sitemembers.fileContent)>
  </cffunction>    

  <cffunction name="getUserPreferences" returntype="struct">
    <cfargument name="userID">
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/people/#userID#/preferences?alf_ticket=#getUserTicket(true)#" result="profile"></cfhttp>
    <cfreturn DeSerializeJSON(profile.FileContent)>
  </cffunction>


  <cffunction name="logUserIn" returntype="any">
    <cfargument name="username" required="true">
    <cfargument name="password" required="true">
	  <cfargument name="rememberMe" required="true" default="false">
    <cfset var ticket = getTicket(arguments.username,arguments.password)>
	  <cfset var buildingVine = {}>
    <cfif isBoolean(ticket)>
      <cfreturn false>
    </cfif>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/api/people/#username#?alf_ticket=#ticket#" result="profile"></cfhttp>
    <cfset profile = DeSerializeJSON(profile.FileContent)>
	  <cfhttp port="8080" username="admin" password="bugg3rm33" result="siteList" url="http://46.51.188.170/alfresco/service/api/people/#username#/sites?size=500&pos=1"></cfhttp>
	  <cfhttp port="8080" username="admin" password="bugg3rm33" result="preferences" url="http://46.51.188.170/alfresco/service/api/people/#username#/preferences"></cfhttp>
	  <cfset siteListA = DeserializeJSON(siteList.FileContent)>
	  <cfset sitesManaged = ArrayNew(1)>
	  <cfloop array="#siteListA#" index="site">
	  	<cfloop array="#site.siteManagers#" index="manager">
		  	<cfif manager eq arguments.username>
			  	<cfset arrayAppend(sitesManaged,site.shortName)>
        </cfif>
      </cfloop>
	  </cfloop>
    <cfset buildingVine["userProfile"] = profile>
	  <cfset buildingVine["preferences"] = DeserializeJSON(preferences.FileContent)>
	  <cfif NOT StructKeyExists(buildingVine.preferences,"defaultSite")>
	  	<cfif profile.organization eq "">
        <cfset defaultSite = "buildingVine">
      <cfelse>
        <cfset defaultSite = "#profile.organization#">
      </cfif>
	  	<cfset buildingVine.preferences["defaultSite"] = defaultSite>
      <cfhttp port="8080" method="post" username="admin" password="bugg3rm33" result="preferences" url="http://46.51.188.170/alfresco/service/api/people/#profile.username#/preferences">
        <cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#serializeJSON(buildingVine["preferences"])#">
      </cfhttp>
	  </cfif>
    <cfset buildingVine["sitesManaged"] = sitesManaged>
    <cfset siteDB = siteService.siteDB(buildingVine.preferences.defaultSite)>
    <cfset buildingVine["siteID"] = siteDB.shortName>
	  <cfset buildingVine["siteDB"] = siteDB>    
    <cfset id = urlEncrypt(arguments.username,"cockcheddar")>
    <cfset buildingVine["user_ticket"] = "#ticket#">
	  <cfset buildingVine["admin_ticket"] = getTicket("admin","bugg3rm33")>
	  <cfset buildingVine["guest_ticket"] = getTicket("guest","")>
    <cfset buildingVine["active"] = true> 
    <cfset buildingVine["ticketTimeOut"] = dateAdd("n", 15, now())>
    <cfset buildingVine["ticketTimeOutAdmin"] = dateAdd("n", 15, now())>
    <cfset buildingVine["ticketTimeOutGuest"] = dateAdd("n", 15, now())>
    <cfset buildingVine["productLayout"] = CookieStorage.getVar("productLayout","standard")>
    <cfset buildingVine["defaultSearch"] = CookieStorage.getVar("defaultSearch","products")>
    <cfset buildingVine["myProfile"] = id>
    <cfset buildingVine["username"] = arguments.username>
	  <cfset buildingVine["password"] = arguments.password>
	  <cfset CookieStorage.setVar("basketID",createUUID(),DateAdd("d",1,now()))>	      
    <cfreturn buildingVine>
</cffunction>

  <cffunction name="setQuickLogin" returntype="void">
    <cfargument name="email">
    <cfargument name="pass">
    <cfargument name="identifier">
    <cfquery name="findAuthenticatedUser" datasource="bvine">
      insert into user2pass (username,pass,identifier)
      VALUES  (
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.email#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.pass#">,
        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.identifier#">
      )

    </cfquery>
  </cffunction>

  <cffunction name="getQuickLogin" returntype="any">
    <cfargument name="authStruct" required="true" type="struct">
    <cfset var returnStruct = {}>
    <cfquery name="findAuthenticatedUser" datasource="bvine">
      select * from user2pass
      where identifier = <cfqueryparam cfsqltype="cf_sql_varchar" value="#authStruct.profile.identifier#">
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

<cffunction name="getRole" returntype="any">
  <cfargument name="siteID" required="true">
  <cfargument name="userID" required="true">
  <cfhttp port="8080" username="admin" password="bugg3rm33" url="http://46.51.188.170/alfresco/service/api/sites/#siteID#/memberships/#userID#" result="r"></cfhttp>
  <cfset s = DeserializeJSON(r.FileContent)>
  <cfif isDefined("s.role")>
    <cfreturn s.role>
  <cfelse>
    <cflog application="true" text="#SerializeJSON(s)#">
    <cfreturn "SiteConsumer">
  </cfif>
</cffunction>
  <cfscript>
        function makeSiteID(str) {
          str = ReReplaceNoCase(str,"[^A-Za-z]","","ALL");
          str = lcase(str);
          return str;
        }
        function urlEncrypt(queryString){
    // encode the string
    var key = "cockcheddar";
    var uue = cfusion_encrypt(queryString, key);

    // make a checksum of the endoed string
    var checksum = left(hash(uue & key),2);

    // assemble the URL
    queryString = uue & checksum ;

    return queryString;
}

  function MakePassword()
{
var valid_password = 0;
var loopindex = 0;
var this_char = "";
var seed = "";
var new_password = "";
var new_password_seed = "";
while (valid_password eq 0){
new_password = "";
new_password_seed = CreateUUID();
for(loopindex=20; loopindex LT 35; loopindex = loopindex + 2){
this_char = inputbasen(mid(new_password_seed, loopindex,2),16);
seed = int(inputbasen(mid(new_password_seed,loopindex/2-9,1),16) mod 3)+1;
switch(seed){
case "1": {
new_password = new_password & chr(int((this_char mod 9) + 48));
break;
}
    case "2": {
new_password = new_password & chr(int((this_char mod 26) + 65));
break;
}
case "3": {
new_password = new_password & chr(int((this_char mod 26) + 97));
break;
}
} //end switch
}
valid_password = iif(refind("(O|o|0|i|l|1|I|5|S)",new_password) gt 0,0,1);
}
return new_password;
}
function urlDecrypt(queryString){
    var key = "cockcheddar";
    var scope = "url";
    var stuff = "";
    var oldcheck = "";
    var newcheck = "";
    var i = 0;
    var thisPair = "";
    var thisName = "";
    var thisValue = "";





        // grab the old checksum
          if (len(querystring) GT 2) {
          oldcheck = right(querystring, 2);
          querystring = rereplace(querystring, "(.*)..", "\1");
          }

          // check the checksum
          newcheck = left(hash(querystring & key),2);
          if (newcheck NEQ oldcheck) {
          return querystring;
          }

        //decrypt the passed value
        queryString = cfusion_decrypt(queryString, key);


    return queryString;
}
</cfscript>
</cfcomponent>