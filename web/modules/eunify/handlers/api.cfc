<cfcomponent>
  <cfproperty name="FeedService" inject="id:eunify.FeedService">
  <cfproperty name="ContactService" inject="id:eunify.ContactService">
  <cfproperty name="CompanyService" inject="id:eunify.CompanyService">
  <cffunction name="activity" returntype="string" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfsetting enablecfoutputonly="true">
    <cfset rc.userID = event.getValue("userID","")>
    <cfset rc.startTime = event.getValue("startTime","")>
    <cfset rc.contact = ContactService.getContactFromHash(rc.userID)>
    <cfif rc.contact.recordCount neq 0>
    <cfset rc.feed = FeedService.getFeed(
      dateFrom=LSDateformat(rc.startTime),
      contactID=rc.contact.id,
      searchOn="contact",
      searchID="#rc.contact.id#",
      secure=false)>
    <cfelse>
    <cfset rc.feed = QueryNew("id")>
    </cfif>
    <cfset event.setLayout("Layout.xml")>
    <cfset event.setView("feed/xml")>
  </cffunction>
  <cffunction name="contact" returntype="string" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfsetting enablecfoutputonly="true">
    <cfset rc.userID = event.getValue("userID","")>
    <cfset rc.startTime = event.getValue("startTime","")>
    <cfset rc.contact = ContactService.getContactFromHash(rc.userID)>
    <cfset rc.company = CompanyService.getCompany(rc.contact.company_id)>
    <cfset event.setLayout("Layout.xml")>
    <cfset event.setView("contact/xml")>
  </cffunction>
  <cffunction name="getUser" returntype="string" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfsetting enablecfoutputonly="true">
    <cfset rc.userID = event.getValue("userID","")>
    <cfset rc.contact = ContactService.getContact(rc.userID)>
    <cfset rc.company = CompanyService.getCompany(rc.contact.company_id)>
    <cfset event.setLayout("Layout.xml")>
    <cfset event.setView("contact/xml")>
  </cffunction>
  <cffunction name="contactList" returntype="string" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfsetting enablecfoutputonly="true">
    <cfset rc.contacts = ContactService.getAllContacts()>
    <cfset event.setLayout("Layout.xml")>
    <cfset event.setView("contact/contactsxml")>
  </cffunction>
</cfcomponent>