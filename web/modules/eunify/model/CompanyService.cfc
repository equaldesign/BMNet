<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">

  <!--- static properties --->
  <cfproperty name="id" default=" " required="true">
  <cfproperty name="account_number" default=" " required="true">
  <cfproperty name="contact_id" default=" " required="true">
  <cfproperty name="name" default=" " required="true">
  <cfproperty name="known_as" default=" " required="true">
  <cfproperty name="company_address_1" default=" " required="true">
  <cfproperty name="company_address_2" default=" " required="true">
  <cfproperty name="company_address_3" default=" " required="true">
  <cfproperty name="company_address_4" default=" " required="true">
  <cfproperty name="company_address_5" default=" " required="true">
  <cfproperty name="company_postcode" default=" " required="true">
  <cfproperty name="company_phone" default=" " required="true">
  <cfproperty name="company_fax" default=" " required="true">
  <cfproperty name="company_mobile" default="  " required="true">
  <cfproperty name="company_email" default="" required="true">
  <cfproperty name="default_contact_firstname" />
  <cfproperty name="default_contact_surname" />
  <cfproperty name="default_contact_email" />
  <cfproperty name="default_contact_mobile" />
  <cfproperty name="password" />
  <cfproperty name="sendLogin" default="false" elementtype="boolean" />
  <cfproperty name="company_website" default=" " required="true">
  <cfproperty name="company_phone_2" default=" " required="true">
  <cfproperty name="type_id" default= " " required="true">
  <cfproperty name="eGroup_id" default="" required="true">
  <cfproperty name="inBuildingVine" default=" " required="true">
  <cfproperty name="bvsiteid" default=" " required="true">
  <cfproperty name="twitter_username" default=" " required="true">

  <!--- injected properties --->
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="ContactService" inject="id:eunify.ContactService">
  <!--- methods --->

  <cffunction name="list" returntype="query" output="false">
    <cfargument name="startRow" required="true" type="numeric" default="0">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfargument name="typeID" required="true">
    <cfargument name="siteID" required="true">
    <cfset var columnArray = ["account_number","name","company_address_1","company_postcode","trade","creditLimit","balance"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfquery name="l" datasource="#dsn.getName()#">
      select
        id,
        account_number,
        name,
        company_address_1,
        company_postcode,
        trade,
        creditLimit,
        balance
      from
        company
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.typeID#">
        <cfif arguments.searchQuery neq "">
        AND
        (
        name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        company_address_1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        account_number like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        company_postcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
        </cfif>
        order by #sortColName# #arguments.sortDir#
        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>
    <cfreturn l>
  </cffunction>
  <cffunction name="cCount" returntype="Numeric">
    <cfargument name="searchQuery" required="true" default="">
    <cfargument name="typeID" required="true">
    <cfargument name="siteID" required="true">
    <cfquery name="s" datasource="#dsn.getName()#">
      select count(account_number) as records
      from
      company
      WHERE
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
      type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.typeID#">
      <cfif arguments.searchQuery neq "">
        AND
        (
        name like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        company_address_1 like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        account_number like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        company_postcode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
      </cfif>
    </cfquery>
    <cfreturn s.records>
  </cffunction>
  <cffunction name="getcompany" returntype="query">
    <cfargument name="id" required="true" default="">
    <cfargument name="siteID" required="true" default="#request.siteID#">
	  <cfargument name="account_number" required="true" default="0">
    <cfquery name="s" datasource="#dsn.getName()#">
      select company.*, companyType.name as typeName
      from
      company,
      companyType
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        <cfif id neq "">
        id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
		    <cfelse>
		    account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_number#">
		    </cfif>
        AND
        companyType.type_id = company.type_id
    </cfquery>
    <cfreturn s>
  </cffunction>

  <cffunction name="getcompanyByName" returntype="query">
    <cfargument name="companyName" required="true" default="">
    <cfquery name="s" datasource="#dsn.getName()#">
      select company.*, companyType.name as typeName
      from
      company,
      companyType
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        AND
        account_number = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.companyName#">
        AND
        companyType.type_id = company.type_id
    </cfquery>
    <cfreturn s>
  </cffunction>

  <cffunction name="getcompanyByEgroup" returntype="query">
    <cfargument name="id" required="true" default="">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfquery name="s" datasource="#dsn.getName()#">
      select company.*, companyType.name as typeName
      from
      company,
      companyType
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
        AND
        eGroup_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
        AND
        companyType.type_id = company.type_id
    </cfquery>
    <cfreturn s>
  </cffunction>

  <cffunction name="getcompanyByAccountNumber" returntype="query">
    <cfargument name="account_number" required="true" default="">
	   <cfargument name="siteID" required="true" default="">
    <cfquery name="s" datasource="#dsn.getName()#">
      select company.*
      from
      company
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_number#">

    </cfquery>
    <cfreturn s>
  </cffunction>

  <cffunction name="getcompanyByTLD" returntype="query">
    <cfargument name="emailAddress" required="true" default="">     
    <cfquery name="s" datasource="#dsn.getName()#">
      select 
        company.*
      from
        company
      WHERE
        company.company_email LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ListLast(arguments.emailAddress,"@")#">         
        AND
        company.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">        
    </cfquery>
    <cfreturn s>
  </cffunction>

    <cffunction name="getCompanyContacts" returntype="query" output="false">
    <cfargument name="companyID" required="yes">
    <cfset var userData = "">
    <cfquery name="userData" datasource="#dsn.getName()#">
                select * from contact where company_id = '#arguments.companyID#' order by first_name;
              </cfquery>
    <cfreturn userData>
  </cffunction>

  <cffunction name="save" returntype="Any">
    <cfargument name="datasource" default="">
    <cfset var BMNet = UserStorage.getVar('BMNet')>
    <cfset var contact = "">
    <cfset var c = "">
    <cfset var n = "">
    <cfset var result = "">
    <cfif this.getid() neq 0 AND this.getid() neq "">
      <!--- we are updated an existing company --->
      <cfquery name="c" datasource="#dsn.getName()#">
            update company
            set account_number = <cfqueryparam value="#this.getaccount_number()#" cfsqltype="cf_sql_varchar">,
            contact_id = <cfqueryparam value="#this.getcontact_id()#" cfsqltype="cf_sql_integer">,
            name = <cfqueryparam value="#this.getname()#" cfsqltype="cf_sql_varchar">,
            company_address_1 = <cfqueryparam value="#this.getcompany_address_1()#" cfsqltype="cf_sql_varchar">,
            company_address_2 = <cfqueryparam value="#this.getcompany_address_2()#" cfsqltype="cf_sql_varchar">,
            company_address_3 = <cfqueryparam value="#this.getcompany_address_3()#" cfsqltype="cf_sql_varchar">,
            company_address_4 = <cfqueryparam value="#this.getcompany_address_4()#" cfsqltype="cf_sql_varchar">,
            company_address_5 = <cfqueryparam value="#this.getcompany_address_5()#" cfsqltype="cf_sql_varchar">,
            company_postcode = <cfqueryparam value="#this.getcompany_postcode()#" cfsqltype="cf_sql_varchar">,
            company_phone = <cfqueryparam value="#this.getcompany_phone()#" cfsqltype="cf_sql_varchar">,
            company_fax = <cfqueryparam value="#this.getcompany_fax()#" cfsqltype="cf_sql_varchar">,
            company_mobile = <cfqueryparam value="#this.getcompany_mobile()#" cfsqltype="cf_sql_varchar">,
            company_email = <cfqueryparam value="#this.getcompany_email()#" cfsqltype="cf_sql_varchar">,
            company_website = <cfqueryparam value="#this.getcompany_website()#" cfsqltype="cf_sql_varchar">,
            company_phone_2 = <cfqueryparam value="#this.getcompany_phone_2()#" cfsqltype="cf_sql_varchar">,
            type_id = <cfqueryparam value="#this.gettype_id()#" cfsqltype="cf_sql_integer">,
            <cfif this.geteGroup_id() neq "">
            eGroup_id = <cfqueryparam value="#this.geteGroup_id()#" cfsqltype="cf_sql_integer">,
            </cfif>
            buildingVine = <cfqueryparam value="#this.getinBuildingVine()#" cfsqltype="cf_sql_varchar">,
            bvsiteid = <cfqueryparam value="#this.getbvsiteid()#" cfsqltype="cf_sql_varchar">,
            twitter_username = <cfqueryparam value="#this.gettwitter_username()#" cfsqltype="cf_sql_varchar">
            where
            id = <cfqueryparam value="#this.getid()#" cfsqltype="cf_sql_integer">
          </cfquery>
      <cfelse>
      <!--- we are creating a new company --->
      <cfset contactQ = ContactService.getContactByEmail(this.getdefault_contact_email(),2,request.siteID)>
      <cfif contactQ.recordCount neq 0>
        <cfset this.contact = beanFactory.populateFromQuery(target="eunify.ContactService",qry=contactQ,exclude="SessStruct")>
        <cfset newcontactID = this.contact.getid()>
      <cfelse>
        <cfset this.contact = beanFactory.populateModel("eunify.ContactService")>
              <cfscript>
            // we need to setup some contact permissions
            this.contact.setfirst_name(this.getdefault_contact_firstname());
            this.contact.setpassword(this.getpassword());
            this.contact.setsurname(this.getdefault_contact_surname());
            this.contact.setemail(this.getdefault_contact_email());
            this.contact.setmobile(this.getdefault_contact_mobile());
            this.contact.setemailLogin(this.getsendLogin());
            this.contact.save();
            newcontactID = this.contact.getid();

        </cfscript>

      </cfif>
      <cfset this.setcontact_id(newcontactID)>
      <!--- first up, let's create a contact --->

      <!--- create create the company information --->
      <cfquery name="c" datasource="#dsn.getName()#">
            insert into company (
              contact_id,
              account_number,
              name,
              company_address_1,
              company_address_2,
              company_address_3,
              company_address_4,
              company_address_5,
              company_postcode,
              company_fax,
              company_mobile,
              company_email,
              company_website,
              company_phone_2,
              type_id,
              eGroup_id,
              buildingVine,
              bvsiteid,
              twitter_username,
              company_phone,
              siteID)
            VALUES (
              <cfqueryparam value="#newcontactID#" cfsqltype="cf_sql_integer">,
              <cfqueryparam value="#this.getaccount_number()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getname()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_address_1()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_address_2()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_address_3()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_address_4()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_address_5()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_postcode()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_fax()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_mobile()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_email()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_website()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_phone_2()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.gettype_id()#" cfsqltype="cf_sql_integer">,
              <cfqueryparam value="#this.geteGroup_id()#" cfsqltype="cf_sql_integer">,
              <cfqueryparam value="#this.getinBuildingVine()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getbvsiteid()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.gettwitter_username()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getcompany_phone()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#request.siteID#" cfsqltype="cf_sql_integer">
            )
          </cfquery>
      <cfquery name="n" datasource="#dsn.getName()#">
            select LAST_INSERT_ID() as id from company; 
          </cfquery>
      <cfset this.setid(n.id)>
      <cfset this.contact.setcompany_id(this.getid())>
      <cfset this.contact.save()>
    </cfif>
      </cffunction>



</cfcomponent>