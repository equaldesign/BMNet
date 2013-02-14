<cfcomponent name="figuresHandler" cache="true" cacheTimeout="30" output="false">


  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="logger" inject="logbox:root">

  <cffunction name="index" returntype="void">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.layout = contact.getDashboardLayout()>
    <cfset rc.showMenu = false>
    <cfset event.setView("contact/dashboard/custom")>
  </cffunction>



<cffunction name="rebate" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfset var rc = event.getCollection()>
    <cfset rc.psa = psa>
    <cfset rc.logger = logger>
    <cfset rc.periodFrom = LSDateFormat(event.getValue("periodFrom",CreateDate(YEAR(now()),1,1)))>
    <cfset rc.periodTo = LSDateFormat(event.getValue("periodTo",now()))>
    <cfset rc.rType = event.getValue("rType","false")>
    <cfset rc.yearrebatePayments = figures.payable(paid="#rc.rType#",memberID=rc.cID,period_from=rc.periodFrom,period_to=rc.periodTo)>
    <cfset event.setView('contact/dashboard/#rc.dashtype#/earnings/#rc.rType#')>
  </cffunction>
  <cffunction name="turnoverdata" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfset var rc = event.getCollection()>
    <cfset event.setLayout('Layout.ajax')>
    <cfif rc.sess.eGroup.isMemberContact>
      <cfset rc.rebatePayments = figures.getMemberTurnover(periodFrom=DateAdd("yyyy",-2,now()),periodTo=now(),members=rc.sess.eGroup.companyID)>
      <cfset rc.groupPayments = figures.getMemberTurnover(periodFrom=DateAdd("yyyy",-2,now()),periodTo=now(),members=rc.sess.eGroup.companyID,allbut=true)>
      <cfset event.setView('charts/memberTurnover')>
    </cfif>
  </cffunction>


  <cffunction name="newWidget" returntype="void">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("contact/dashboard/customwidget")>

  </cffunction>

  <cffunction name="intro" returntype="void">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("contact/dashboard/widgetintro")>

  </cffunction>
  <!------------------------------------------- PRIVATE EVENTS ------------------------------------------>
</cfcomponent>

