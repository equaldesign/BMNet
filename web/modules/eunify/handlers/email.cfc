<cfcomponent name="general" cache="true" output="false"  autowire="true">
  <cfproperty name="EmailService" inject="id:eunify.EmailService">
  <cfproperty name="bvEmailService" inject="id:bv.EmailService">
  <cfproperty name="bvUserService" inject="id:bv.UserService">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="ContactService" inject="id:eunify.ContactService" />
  <cfproperty name="company" inject="id:eunify.CompanyService" />

  <cffunction name="fastFile" returntype="void" cache="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.doRailo = false>
    <cfset rc.username = event.getValue("username","")>
    <cfset rc.password = event.getValue("password","")>
    <cfset rc.fileData = event.getValue("emailattach","")>
    <cfif rc.username eq "" AND rc.password eq "">
      <!--- Railo bug --->
      <cfset rc.doRailo = true>
      <cfset entireRequestData = ToString(GetHTTPRequestData().content) & "--">
      <cfset rc.username = trim(ListGetAt(entireRequestData,4,chr(13)))>
      <cfset rc.password = trim(ListGetAt(entireRequestData,8,chr(13)))>

    </cfif>
    <cfset rc.contact = ContactService.logUserIn(rc.username,rc.password,"",true)>
    <cfif isBoolean(rc.contact)>
      <cfset logger.debug("Couldn't find user :#rc.username# #rc.password#")>
    </cfif>
    <cfset rc.userTicket = bvUserService.getTicket(rc.contact.bvusername,rc.contact.bvpassword)>
    <cfif isBoolean(rc.userTicket)>
      <cfheader statuscode="401" statustext="Username and password were incorrect">
      <cfabort>
    </cfif>
    <cfset serverFileName = createUUID()>
    <cffile action="upload" filefield="emailattach" destination="/tmp/#serverFileName#.eml" />
    <cffile action="read" file="/tmp/#serverFileName#.eml" variable="emailAttach">
    <cfset rc.attachmentData = bvEmailService.parseRaw(fileData=emailAttach)>
    <cfset rc.nodeRef = EmailService.sendToAlf(rc.userTicket,"/tmp/#serverFileName#.eml")>
    <cfset rc.message = EmailService.archive(rc.contact,request.siteID,rc.attachmentData,rc.nodeRef,rc.password)>
    <cfset logger.debug(rc.message)>
	  <cfset logger.debug("seems to be ok?")>

    <cfset event.noRender()>
  </cffunction>

  <cffunction name="history" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.contactID = event.getValue("contactID",0)>
    <cfset rc.companyID = event.getValue("companyID",0)>
    <cfset event.setView("contact/panels/emailHistory")>
  </cffunction>

  <cffunction name="getImage" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.fileName = event.getValue("file","")>
    <cfcontent file="#rc.app.appRoot#cache/#rc.fileName#" type="#getPageContext().getServletContext().getMimeType('#rc.app.appRoot#cache/#rc.fileName#')#">
  </cffunction>

  <cffunction name="detail" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.emailID = event.getValue("id")>
    <cfset rc.email = EmailService.getEmail(rc.emailID)>
    <cfset rc.showExtra = event.getValue("showExtra",true)>
    <cfset rc.node = bvEmailService.getMessage(rc.email.nodeRef)>
    <cfset rc.message = bvEmailService.parseRaw(rc.node.downloadUrl)>

    <cfset rc.contact = ContactService.getContactByEmail(rc.message.from[1],0,request.siteID)>
    <cfset rc.company = company.getCompany(rc.contact.id)>
    <cfset rc.toContacts = ArrayNew(1)>
    <cfloop array="#rc.message.torecipients#" index="e">
      <cfset arrayAppend(rc.toContacts,ContactService.getContactByEmail(e,0,request.siteID))>
    </cfloop>
    <cfset rc.ccContacts = ArrayNew(1)>
    <cfloop array="#rc.message.ccrecipients#" index="e">
      <cfset arrayAppend(rc.ccContacts,ContactService.getContactByEmail(e,0,request.siteID))>
    </cfloop>

    <!---<cfset event.setView("debug")>--->
    <cfset event.setView("contact/panels/emailDetail")>
  </cffunction>

  <cffunction name="body" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.downloadURL = event.getValue("downloadURL")>
    <cfset rc.message = bvEmailService.parseRaw(rc.downloadUrl)>
    <cfset event.setView(view="contact/panels/emailBody",noLayout=true)>
  </cffunction>

  <cffunction cache="true" name="list" returntype="Any" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.startRow = event.getValue("iDisplayStart",0);
      rc.maxRows = event.getValue("iDisplayLength",10);
      rc.contactID = event.getValue("contactID",0);
      rc.companyID = event.getValue("companyID",0);
      rc.sortColumn = event.getValue("iSortCol_0",0);
      rc.sEcho = event.getValue("sEcho","");
      rc.sortDirection = event.getValue("sSortDir_0","asc");
      rc.searchQuery = event.getValue("sSearch","");
      rc.emailCount = EmailService.cCount(rc.searchQuery,rc.contactID,rc.companyID);
      rc.emailData = EmailService.list(rc.startRow,rc.maxRows,rc.sortColumn,rc.sortDirection,rc.searchQuery,rc.contactID,rc.companyID);
      rc.json = {};
      rc.json["sEcho"] = rc.sEcho;
      rc.json["iTotalRecords"] = rc.emailCount;
      rc.json["iTotalDisplayRecords"] = rc.emailCount;
      rc.json["aaData"] = [];
    </cfscript>
    <cfloop query="rc.emailData">
      <cfset thisRow = [
        "<img rel='#id#' src='https://d25ke41d0c64z1.cloudfront.net/images/icons/mail-open.png'>",
        "#first_name# #surname#",
        "#subject#",
        "#DateFormat(messageDate,'DD/MM/YYYY')# #TimeFormat(messageDate,'HH:MM')#"]>
      <cfset ArrayAppend(rc.json.aaData,thisRow)>
    </cfloop>
    <cfset event.renderData("json",rc.json,"text/html")>
  </cffunction>

  <cffunction name="fileForm" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>

    <cfset event.setView(view="test/emailForm",noLayout=true)>
  </cffunction>

</cfcomponent>
