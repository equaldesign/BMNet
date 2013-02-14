<cfcomponent>
  <cfproperty name="SiteService" inject="id:eunify.SiteService" />
  <cffunction name="index" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("signup")>
  </cffunction>


  <cffunction name="do" returntype="any">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.error.fields = []>
    <cfset rc.error.message = []>
    <cfset rc.first_name = event.getValue("first_name","")>
    <cfset rc.surname = event.getValue("surname","")>
    <cfset rc.email = event.getValue("email","")>
    <cfset rc.password = event.getValue("password","")>
    <cfset rc.password2 = event.getValue("password2","")>
    <cfset rc.business_name = event.getValue("business_name","")>
    <cfset rc.siteName = event.getValue("siteName","")>
    <cfset rc.postcode = event.getValue("postcode","")>
    <cfif rc.first_name eq "">
      <cfset ArrayAppend(rc.error.fields,"first_name")>
      <cfset ArrayAppend(rc.error.message,"We need your first name!")>
    </cfif>
    <cfif rc.surname eq "">
      <cfset ArrayAppend(rc.error.fields,"surname")>
      <cfset ArrayAppend(rc.error.message,"We need your Surname!")>
    </cfif>
    <cfif NOT isValid("email",rc.email)>
      <cfset ArrayAppend(rc.error.fields,"email")>
      <cfset ArrayAppend(rc.error.message,"Your email is required and needs to be correct!")>
    </cfif>
    <cfif rc.password eq "" OR rc.password neq rc.password2>
      <cfset ArrayAppend(rc.error.fields,"password")>
      <cfset ArrayAppend(rc.error.message,"Your passwords didn't match")>
    </cfif>
    <cfif rc.business_name eq "">
      <cfset ArrayAppend(rc.error.fields,"business_name")>
      <cfset ArrayAppend(rc.error.message,"We need your company name!")>
    </cfif>
    <cfif rc.postcode eq "">
      <cfset ArrayAppend(rc.error.fields,"postcode")>
      <cfset ArrayAppend(rc.error.message,"We need your company postcode!")>
    </cfif>
    <cfif rc.siteName eq "">
      <cfset ArrayAppend(rc.error.fields,"siteName")>
      <cfset ArrayAppend(rc.error.message,"We need your site URL")>
    </cfif>
    <cf_recaptcha action="check" privateKey="6LcuftoSAAAAAGgL4xMKrrJATSUOZTPQXQZMdAxb" publicKey="6LcuftoSAAAAAHbm13T0QpzfN8tjgkeeyGbBsN8s">
    <cfif NOT form.recaptcha>
      <cfset ArrayAppend(rc.error.fields,"recaptcha")>
      <cfset ArrayAppend(rc.error.message,"You entered the security question incorrectly!")>
    </cfif>
    <cfif ArrayLen(rc.error.fields) gte 1>
      <cfset event.setView("signup")>
    <cfelse>
      <cfscript>
        var siteID = rc.siteID;
        rc.siteID = rc.siteName;
        site = populateModel("eunify.SiteService");
        site.createSite();
        event.setView("signupComplete");
      </cfscript>
    </cfif>
  </cffunction>
  <cffunction name="eGroupSearch" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.eGroup_datasource = event.getValue("eGroup_datasource","")>
    <cfset rc.eGroup_username = event.getValue("eGroup_username","")>
    <cfset rc.eGroup_password = event.getValue("eGroup_password","")>
    <!--- start with cemco --->
    <cfquery name="info" datasource="#rc.eGroup_datasource#" cachedwithin="#Createtimespan(10,0,0,0)#">
      select
        company.*, contact.first_name, contact.surname FROM contact, company WHERE
      contact.email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.eGroup_username#">
      AND
      contact.password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.eGroup_password#">
      AND
      company.id = contact.company_id
    </cfquery>
    <cfset event.renderData(data=info,type="JSON")>
  </cffunction>
</cfcomponent>