<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
  <cfproperty name="nodeRef" default=" " required="true">
  <cfproperty name="companyID" default=" " required="true">
  <cfproperty name="name" default=" " required="true">
  <cfproperty name="description" default=" " required="true">
  <cfproperty name="industry" default=" " required="true">
  <cfproperty name="annualRevenue" default=" " required="true">
  <cfproperty name="fax" default=" " required="true">
  <cfproperty name="phone" default=" " required="true">
  <cfproperty name="phoneAlternate" default=" " required="true">
  <cfproperty name="billingName" default=" " required="true">
  <cfproperty name="billingAddress1" default=" " required="true">
  <cfproperty name="billingAddress2" default="  " required="true">
  <cfproperty name="billingAddress3" default="" required="true">
  <cfproperty name="billingTown" default=" " required="true">
  <cfproperty name="billingCounty" default=" " required="true">
  <cfproperty name="billingPostCode" default= " " required="true">
  <cfproperty name="billingCountry" default="" required="true">
  <cfproperty name="website" default=" " required="true">
  <cfproperty name="companyEmail" default=" " required="true">
  <cfproperty name="employees" default=" " required="true">
  <cfproperty name="deliveryName" default=" " required="true">
  <cfproperty name="deliveryAddress1" default=" " required="true">
  <cfproperty name="deliveryAddress2" default="  " required="true">
  <cfproperty name="deliveryAddress3" default="" required="true">
  <cfproperty name="deliveryAddressTown" default="  " required="true">
  <cfproperty name="deliveryAddressCounty" default=" " required="true">
  <cfproperty name="deliveryAddressPostCode" default=" " required="true">
  <cfproperty name="deliveryAddressCountry" default=" " required="true">
  <cfproperty name="qualified" default="true" required="true">
  <cfproperty name="siteID" default=" " required="true">
  <cfproperty name="contacts" default=" " required="true">

  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
  <cfproperty name="bvAddress" inject="coldbox:setting:bvAddress">

  <!--- methods --->
  <cffunction name="getCompany" returntype="struct" output="false">
    <cfargument name="nodeRef">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/company?nodeRef=#nodeRef#&alf_ticket=#ticket#" method="get" result="co"></cfhttp>
    <cfset company = DeSerializeJSON(co.fileContent)>
    <cfset instance.beanFactory.populateFromStruct(this,company.attributes)>
    <cfset this.setname(company.name)>
    <cfset this.setsiteID(company.bvSiteID)>

    <cfreturn this>
  </cffunction>

  <cffunction name="save" returntype="boolean" output="false">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfif this.getnodeRef() eq "">
      <cfset method="post">
    <cfelse>
      <cfset method="put">
    </cfif>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/company?alf_ticket=#ticket#" method="#method#" result="co">
      <cfhttpparam type="formfield" name="siteID" value="#this.getsiteID()#">
      <cfhttpparam type="formfield" name="nodeRef" value="#this.getnodeRef()#">
      <cfhttpparam type="formfield" name="bvCo_companyID" value="#this.getcompanyID()#">
      <cfhttpparam type="formfield" name="bvCo_name" value="#this.getname()#">
      <cfhttpparam type="formfield" name="bvCo_description" value="#this.getdescription()#">
      <cfhttpparam type="formfield" name="bvCo_industry" value="#this.getindustry()#">
      <cfhttpparam type="formfield" name="bvCo_annualRevenue" value="#this.getannualRevenue()#">
      <cfhttpparam type="formfield" name="bvCo_fax" value="#this.getfax()#">
      <cfhttpparam type="formfield" name="bvCo_phone" value="#this.getphone()#">
      <cfhttpparam type="formfield" name="bvCo_phoneAlternate" value="#this.getphoneAlternate()#">
      <cfhttpparam type="formfield" name="bvCo_billingName" value="#this.getbillingName()#">
      <cfhttpparam type="formfield" name="bvCo_billingAddress1" value="#this.getbillingAddress1()#">
      <cfhttpparam type="formfield" name="bvCo_billingAddress2" value="#this.getbillingAddress2()#">
      <cfhttpparam type="formfield" name="bvCo_billingAddress3" value="#this.getbillingAddress3()#">
      <cfhttpparam type="formfield" name="bvCo_billingTown" value="#this.getbillingTown()#">
      <cfhttpparam type="formfield" name="bvCo_billingCounty" value="#this.getbillingCounty()#">
      <cfhttpparam type="formfield" name="bvCo_billingPostCode" value="#this.getbillingPostCode()#">
      <cfhttpparam type="formfield" name="bvCo_billingCountry" value="#this.getbillingCountry()#">
      <cfhttpparam type="formfield" name="bvCo_website" value="#this.getwebsite()#">
      <cfhttpparam type="formfield" name="bvCo_companyEmail" value="#this.getcompanyEmail()#">
      <cfhttpparam type="formfield" name="bvCo_employees" value="#this.getemployees()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryName" value="#this.getdeliveryName()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddress1" value="#this.getdeliveryAddress1()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddress2" value="#this.getdeliveryAddress2()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddress3" value="#this.getdeliveryAddress3()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressTown" value="#this.getdeliveryAddressTown()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressCounty" value="#this.getdeliveryAddressCounty()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressPostCode" value="#this.getdeliveryAddressPostCode()#">
      <cfhttpparam type="formfield" name="bvCo_deliveryAddressCountry" value="#this.getdeliveryAddressCountry()#">

    </cfhttp>
    <cfreturn true>
  </cffunction>

  <cffunction name="getList" returntype="struct" output="false">
    <cfargument name="siteID" required="true" type="string">
    <cfargument name="letter" required="true" type="string">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfhttp port="8080" result="companies" url="http://46.51.188.170/alfresco/service/bv/company/list?siteID=#siteID#&dir=#letter#&startRow=#startRow#&maxRows=#maxrow#&alf_ticket=#ticket#"></cfhttp>
    <cfreturn DeSerializeJSON(companies.fileContent)>
  </cffunction>

  <cffunction name="doImport" returntype="any">
    <cfargument name="fileName">
    <cfargument name="siteID">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfset var x = 1>
    <cfquery name="fieldMappings" datasource="bvine">
      select fieldName, mapsTo from fieldDefinitions where site = <cfqueryparam  cfsqltype="cf_sql_varchar" value="#siteID#"> and object = <cfqueryparam  cfsqltype="cf_sql_varchar" value="company">
    </cfquery>
    <cfspreadsheet action="read" query="company" src="/tmp/#fileName#" headerrow="1" excludeHeaderRow="true"></cfspreadsheet>

    <cfloop query="company">
      <cfhttp result="newCompany" method="post" port="8080" url="http://46.51.188.170/alfresco/service/bv/company?siteID=#siteID#&alf_ticket=#ticket#">
        <cfloop query="fieldMappings">
          <cfhttpparam name="bvCo_#fieldName#" value="#company['#mapsTo#'][x]#" type="formfield">
          <cflog application="true" text="#company['#mapsTo#'][x]#">
        </cfloop>
      </cfhttp>
      <cfset x++>
    </cfloop>
  </cffunction>

  <cffunction name="emailHistory" returntype="array">
    <cfargument name="nodeRef" required="true" type="string">
    <cfset var ticket = instance.UserStorage.getVar("alf_ticket","")>
    <cfhttp port="8080" result="contacts" url="http://46.51.188.170/alfresco/service/bv/email/company?nodeRef=#nodeRef#&alf_ticket=#ticket#"></cfhttp>
    <cfreturn DeSerializeJSON(contacts.fileContent)>
  </cffunction>

  <cffunction name="search" access="public" returntype="Any" output="false">
    <cfargument name="query" required="true" type="string" >
    <cfargument name="siteID" required="true" type="string" default="" >
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <!--- RC Reference --->
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/search/company?q=#query#&siteid=#siteID#&maxrows=#maxRow#&startRow=#startRow#&alf_ticket=#ticket#" result="companies"></cfhttp>
    <cftry>
    <cfreturn DeserializeJSON(companies.fileContent)>
    <cfcatch type="any">
    <cfreturn companies.fileContent>
    </cfcatch>
    </cftry>
  </cffunction>
</cfcomponent>