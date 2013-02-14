<cfcomponent cache="true">
  <cfproperty name="userService" inject="id:bv.UserService">
  <cfproperty name="feed" inject="id:bv.FeedService">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">

  <cffunction name="index" access="public" returntype="void" output="false" cache="true">
    <cfargument name="Event" type="any">
    <cfset var rc = event.getCollection()>
    <cfset rc.title = "Building Vine // Enterprise collaborative networking">
    <cfset rc.v = "Main">
    <cfif rc.siteID eq "buildingvine">
      <cfset event.setLayout("www.buildingvine.com/#rc.layoutPath#/Layout.Homepage")>
      <cfset event.setView("#rc.viewPath#index")>
    <cfelse>
		  <cfif isDefined("rc.buildingVine.site.customProperties.companyType.value") AND rc.buildingVine.site.customProperties.companyType.value eq "Group">
		  	  <cfset setNextEvent(uri="/sums")>
		  <cfelse>
        <cfset setNextEvent(uri="/products")>
      </cfif>
    </cfif>
  </cffunction>

	<cffunction name="getTicket" returntype="string">
      <cfhttp url="http://#cgi.http_host#/alfresco/service/api/login?u=tom.miller@ebiz.co.uk&pw=f4ck5t41n" method="GET">
      <cfdump var="#XmlParse(Trim(cfhttp.FileContent))#">
      <cfscript>
         xmlTicketResponse = XmlParse(Trim(cfhttp.FileContent));
         ticket = xmlTicketResponse.ticket.xmlText;
         return ticket;
      </cfscript>
</cffunction>

  <cffunction name="userHome" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.title = "Building Vine // Enterprise collaborative networking">
    <cfset rc.v = "Main">
   <!---  <cfset rc.boundaries = getMyPlugin("Paging").getBoundaries(15)> --->
    <cfset rc.feed = feed.getFeed()>
	  <cfset rc.tasks = userService.getTasks()>
    <cfset Event.setLayout("secure/Layout.Main")>
    <cfset Event.setView("secure/home")>
  </cffunction>


  <cffunction name="debug">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset Event.setLayout("Layout.ajax")>
    <cfset event.setView("debug")>
  </cffunction>

  <cffunction name="emailTest">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
	  <cfhttp url="http://dev.buildersmerchant.net/eunify/email/fastFile" method="post">
	  	  <cfhttpparam type="formfield" name="username" value="ioan.kiss@gmail.com">
			  <cfhttpparam type="formfield" name="password" value="testing">
			  <cfhttpparam type="file" file="/tmp/attach.eml" name="filename">
	  </cfhttp>
	  <cfdump var="#cfhttp.fileContent#"><cfabort>
    <cfset Event.setLayout("Layout.ajax")>
    <cfset event.setView("debug")>
  </cffunction>

	<!--- Do Something Action --->
	<cffunction name="updateAllUsers" access="public" returntype="void" output="false">
		<cfargument name="Event" type="any">
		<!--- RC Reference --->
		<cfhttp url="http://www.buildingvine.com/alfresco/service/api/people" result="people" username="admin" password="bugg3rm33"></cfhttp>
		<cfset allPeople = DeSerializeJSON(people.fileContent)>
		<cfloop array="#allPeople.people#" index="person">
			<cfset jsonObject["username"] = person.username>
      <cfset jsonObject["properties"]["cm:emailFeedDisabled"] = true>
	    <cfhttp method="post" username="admin" password="bugg3rm33" result="preferences" url="http://www.buildingvine.com/alfresco/slingshot/profile/userprofile">
				<cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#serializeJSON(jsonObject)#">
			</cfhttp>
		</cfloop>
	</cffunction>

</cfcomponent>