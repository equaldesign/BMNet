<cfcomponent name="companyService" accessors="true" output="true" cache="false" cacheTimeout="30" autowire="true">
  <!--- Dependencies --->
  <cfproperty name="id" />
  <cfproperty name="name" />
  <cfproperty name="type_id" default="2" required="true" />
  <cfproperty name="known_as" />
  <cfproperty name="description" />
  <cfproperty name="contact_id" />
  <cfproperty name="address1" />
  <cfproperty name="address2" />
  <cfproperty name="address3" />
  <cfproperty name="town" />
  <cfproperty name="bankName" />
  <cfproperty name="sortCode" />
  <cfproperty name="accountNumber" />
  <cfproperty name="county" />
  <cfproperty name="postcode" />
  <cfproperty name="twitter_username" />
  <cfproperty name="twitter_token" />
  <cfproperty name="twitter_secret" />
  <cfproperty name="switchboard" />
  <cfproperty name="sendLogin" />
  <cfproperty name="default_contact_firstname" />
  <cfproperty name="default_contact_surname" />
  <cfproperty name="default_contact_email" />
  <cfproperty name="default_contact_mobile" />
  <cfproperty name="fax" />
  <cfproperty name="email" />
  <cfproperty name="web" />
  <cfproperty name="buildingVine" />
  <cfproperty name="bvsiteID" />
  <cfproperty name="companylogo" />
  <cfproperty name="status" default="active" required="true"  />
  <cfproperty name="hidden" default="n" required="true"  />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="securitygroups" inject="coldbox:setting:securitygroups" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:beanfactory" />
  <cfproperty name="utils" inject="coldbox:plugin:utilities" />
  <cfproperty name="platform" inject="coldbox:setting:platform" />
  <cfproperty name="dsn" inject="coldbox:datasource:eGroup" />
  <cfproperty name="dsnRead" inject="coldbox:datasource:eGroupRead" />
  <cfproperty name="logger" inject="logbox" />
  <cfproperty name="contact" inject="model" />
  <cfscript>
  	instance = structnew();
  </cfscript>

  <cffunction name="deleteCompany" returntype="Any">
    <cfargument name="companyID">
    <cfset var removeContacts = "">
    <cfset var removeAgreements = "">
    <cfset var removeCompany = "">
    <cfset var removeBranches = "">
    <cfquery name="removeContacts" datasource="#dsn.getName()#">
        delete from contact where company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
      </cfquery>
    <cfquery name="removeAgreements" datasource="#dsn.getName()#">
        delete from arrangement where company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
      </cfquery>
    <cfquery name="removeBranches" datasource="#dsn.getName()#">
        delete from branch where company_id = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
      </cfquery>
    <cfquery name="removeCompany" datasource="#dsn.getName()#">
        delete from company where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#companyID#">
      </cfquery>
  </cffunction>

  <cffunction name="getContactsByCompanyType" returntype="query">
    <cfargument name="typeID" required="yes" default="1">
    <cfset var c = "">
    <cfquery name="c" datasource="#dsnRead.getName()#">
    	select contact.*, company.id, company.known_as from contact, company where company.id = contact.company_id and company.type_id = #arguments.typeID#;
    </cfquery>
    <cfreturn c>
  </cffunction>

  <cffunction name="getCompanyContacts" returntype="query" output="false">
    <cfargument name="companyID" required="yes">
    <cfset var userData = "">
    <cfquery name="userData" datasource="#dsnRead.getName()#">
  							select * from contact where company_id = '#arguments.companyID#' order by first_name;
  						</cfquery>
    <cfreturn userData>
  </cffunction>

  <cffunction name="getCompany" returntype="struct" output="false">
    <cfargument name="id" required="no">
    <cfset var companyData = "">
    <cfquery name="companyData" datasource="#dsnRead.getName()#">
  									select * from company <cfif isDefined('arguments.id')>where id = '#arguments.id#'</cfif> order by name;
  								</cfquery>
    <cfreturn beanFactory.populateFromQuery(this,companyData)>
  </cffunction>

  <cffunction name="getCompanyOfType" returntype="query" output="false">
    <cfargument name="typeid" required="yes">
    <cfargument name="order" required="no" default="known_as" type="string">
    <cfset var companyData = "">
    <cfquery name="companyData" datasource="#dsnRead.getName()#">
  									select * from company where type_id = '#arguments.typeid#' order by #order#;
  								</cfquery>
    <cfreturn companyData>
  </cffunction>

  <cffunction name="getSuppliers" returntype="query" output="false">
    <cfargument name="order" required="no" default="known_as" type="string">
    <cfargument name="activeOnly" required="true" type="boolean" default="false">
    <cfset var supplier = "">
    <cfquery name="supplier" datasource="#dsnRead.getName()#">
  			select * from company where type_id = 2
        <cfif activeOnly>
        AND
        status = <cfqueryparam cfsqltype="cf_sql_varchar" value="active"> AND hidden = <cfqueryparam cfsqltype="cf_sql_varchar" value="n">
        </cfif>
        order by #order# asc;
  		</cfquery>
    <cfreturn supplier>
  </cffunction>

  <cffunction name="getMembers" returntype="query" output="false">
    <cfargument name="order" required="no" default="known_as" type="string">
    <cfset var member = "">
    <cfquery name="member" datasource="#dsnRead.getName()#">
  			select * from company where type_id = 1 and hidden = 'n' AND status = 'active' order by #order# asc;
  		</cfquery>
    <cfreturn member>
  </cffunction>

  <cffunction name="getCompanies" returntype="query" output="false">
    <cfargument name="type" required="yes" default="1" type="numeric">
    <cfargument name="order" required="no" default="known_as" type="string">
    <cfset var member = "">
    <cfquery name="member" datasource="#dsnRead.getName()#">
        select
          company.*,
          contact.id as
          contactID,
          contact.first_name,
          contact.surname
       from
        company LEFT JOIN contact on contact.id = company.contact_id
       where
        company.type_id = <cfqueryparam value="#type#" cfsqltype="cf_sql_integer">
        and
        hidden = 'n'
        order by #order#
      </cfquery>
    <cfreturn member>
  </cffunction>

  <cffunction name="getCompanyIDByKnownAs" returntype="any" output="no">
    <cfargument name="known_as" required="yes">
    <cfset var companyData = "">
    <cfquery name="companyData" datasource="#dsn.getName()#">
        select id from company
            where known_as = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.known_as#">
      </cfquery>
    <cfreturn companyData.id>
  </cffunction>

  <cffunction name="saveCompany" returntype="Any">
    <cfargument name="datasource" default="">
    <cfset var eGroup = UserStorage.getVar('eGroup')>
    <cfset var appRoot = ApplicationStorage.getVar("appRoot")>
    <cfset var siteName = ApplicationStorage.getVar("siteName")>
    <cfset var contact = "">
    <cfset var logo = "">
    <cfset var imgOb = "">
    <cfset var c = "">
    <cfset var n = "">
    <cfset var result = "">
    <cfif arguments.datasource eq "">
      <cfset arguments.datasource = dsn.getName()>
    </cfif>
    <cfif this.getid() neq 0 AND this.getid() neq "">
      <!--- we are updated an existing company --->
      <cfquery name="c" datasource="#arguments.datasource#">
  		    	update company
  					set name = <cfqueryparam value="#this.getname()#" cfsqltype="cf_sql_varchar">,
  					known_as = <cfqueryparam value="#this.getknown_as()#" cfsqltype="cf_sql_varchar">,
  					description = <cfqueryparam value="#this.getdescription()#" cfsqltype="cf_sql_varchar">,
  					contact_id = <cfqueryparam value="#this.getcontact_id()#" cfsqltype="cf_sql_integer">,
  					address1 = <cfqueryparam value="#this.getaddress1()#" cfsqltype="cf_sql_varchar">,
  					address2 = <cfqueryparam value="#this.getaddress2()#" cfsqltype="cf_sql_varchar">,
  					address3 = <cfqueryparam value="#this.getaddress3()#" cfsqltype="cf_sql_varchar">,
  					town = <cfqueryparam value="#this.gettown()#" cfsqltype="cf_sql_varchar">,
  					county = <cfqueryparam value="#this.getcounty()#" cfsqltype="cf_sql_varchar">,
  					postcode = <cfqueryparam value="#this.getpostcode()#" cfsqltype="cf_sql_varchar">,
            <cfif getbankName() neq "">
            bankName = <cfqueryparam value="#this.getbankName()#" cfsqltype="cf_sql_varchar">,
            </cfif>
            <cfif getsortCode() neq "">
            sortCode = <cfqueryparam value="#this.getsortCode()#" cfsqltype="cf_sql_varchar">,
            </cfif>
            <cfif getaccountNumber() neq "">
            accountNumber = <cfqueryparam value="#this.getaccountNumber()#" cfsqltype="cf_sql_varchar">,
            </cfif>
  					switchboard = <cfqueryparam value="#this.getswitchboard()#" cfsqltype="cf_sql_varchar">,
  					fax = <cfqueryparam value="#this.getfax()#" cfsqltype="cf_sql_varchar">,
  					email = <cfqueryparam value="#this.getemail()#" cfsqltype="cf_sql_varchar">,
  					twitter_username = <cfqueryparam value="#this.gettwitter_username()#" cfsqltype="cf_sql_varchar">,
  					<cfif this.gettwitter_token() neq "">
  					twitter_token = <cfqueryparam value="#this.gettwitter_token()#" cfsqltype="cf_sql_varchar">,
  					</cfif>
  					<cfif this.gettwitter_secret() neq "">
            twitter_secret = <cfqueryparam value="#this.gettwitter_secret()#" cfsqltype="cf_sql_varchar">,
            </cfif>
  					web = <cfqueryparam value="#this.getweb()#" cfsqltype="cf_sql_varchar">
  					<cfif this.getstatus() neq "">
  					,status = <cfqueryparam value="#this.getstatus()#" cfsqltype="cf_sql_varchar">
  					</cfif>
  					<cfif this.gethidden() neq "">
  					,hidden = <cfqueryparam value="#this.gethidden()#" cfsqltype="cf_sql_varchar">
  					</cfif>
  					where
  					id = <cfqueryparam value="#this.getid()#" cfsqltype="cf_sql_integer">
  		    </cfquery>
      <cfelse>
      <!--- we are creating a new company --->
      <!--- first up, let's create a contact --->
      <cfif getsendLogin() neq "">
      <cfset this.contact = beanFactory.populateModel("contact")>
      <cfset newcontactID = contact.getid()>
      <cfscript>
  					// we need to setup some contact permissions
  					if (this.gettype_id() eq 1) {
  						contact.setpermissions(securitygroups.group[5].id);
  					} else {
  						contact.setpermissions(securitygroups.suppliers[2].id);
  					}
  					contact.setfirst_name(this.getdefault_contact_firstname());
  					contact.setpassword(this.getdefault_contact_surname());
  					contact.setsurname(this.getdefault_contact_surname());
  					contact.setemail(this.getdefault_contact_email());
  					contact.setmobile(this.getdefault_contact_mobile());
  					contact.save();

  					contact.emailLoginInfo();
				</cfscript>
      <cfelse>
        <cfset newcontactID = 0>
      </cfif>
      <!--- create create the company information --->
      <cfquery name="c" datasource="#arguments.datasource#">
  					insert into company (contact_id,name,type_id,known_as,address1,address2,address3,town,county,postcode,switchboard,fax,email,web,bankName,sortCode,accountNumber)
  					VALUES (
  						<cfqueryparam value="#newcontactID#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getname()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.gettype_id()#" cfsqltype="cf_sql_integer">,
  						<cfqueryparam value="#this.getknown_as()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getaddress1()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getaddress2()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getaddress3()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.gettown()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getcounty()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getpostcode()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getswitchboard()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getfax()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getemail()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getweb()#" cfsqltype="cf_sql_varchar">,
  						<cfqueryparam value="#this.getbankName()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getsortCode()#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#this.getaccountNumber()#" cfsqltype="cf_sql_varchar">
  					)
  				</cfquery>
      <cfquery name="n" datasource="#arguments.datasource#">
  					select LAST_INSERT_ID() as id from company;
  				</cfquery>
      <cfset this.setid(n.id)>
      <cfif this.getsendLogin() neq "">
      <cfset this.contact.setcompany_id(this.getid())>
      <cfset this.contact.save()>
      </cfif>
    </cfif>
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
      <cfimage quality="0.95" source="#imgOb#" action="write" destination="#appRoot#/web/includes/images/sites/#siteName#/company/#this.getid()#_square.jpg" overwrite="yes">
      <cfif logo.height lt logo.width>
        <cfimage action="resize" width="300" height="" overwrite="yes" destination="#appRoot#/web/includes/images/sites/#siteName#/company/#this.getid()#_large.jpg"  source="#logo#">
        <cfimage action="resize" width="150" height="" overwrite="yes" destination="#appRoot#/web/includes/images/sites/#siteName#/company/#this.getid()#.jpg"  source="#logo#">
        <cfimage action="resize" width="50" height="" overwrite="yes" destination="#appRoot#/web/includes/images/sites/#siteName#/company/#this.getid()#_small.jpg"  source="#logo#">
        <cfelse>
        <cfimage action="resize" height="300" width="" overwrite="yes" destination="#appRoot#/web/includes/images/sites/#siteName#/company/#this.getid()#_large.jpg"  source="#logo#">
        <cfimage action="resize" height="150" width="" overwrite="yes" destination="#appRoot#/web/includes/images/sites/#siteName#/company/#this.getid()#.jpg"  source="#logo#">
        <cfimage action="resize" height="50" width="" overwrite="yes" destination="#appRoot#/web/includes/images/sites/#siteName#/company/#this.getid()#_small.jpg"  source="#logo#">
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="search" returnType="Query">
    <cfargument name="query">
    <cfset var results = "">
    <Cfquery name="results" datasource="#dsnRead.getName()#">
    	select
        id, name, known_as,
        MATCH (name,known_as,town,address1) AGAINST ('#query#') as score
        from
        company
        where MATCH (name,known_as,town,address1) AGAINST ('#query#') OR company.name LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#query#%">
        order by score desc limit 0,10;
    </Cfquery>
  <cfreturn results>
</cffunction>

</cfcomponent>