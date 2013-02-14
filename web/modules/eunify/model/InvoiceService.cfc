<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />

  <!--- methods --->

  <cffunction name="getInvoice" returntype="query">
    <cfargument name="id" required="true">
    <cfquery name="i" datasource="#dsn.getName()#">
      select
	       Invoice.*,
	       Invoice_Header.quantity as lineQuantity,
	       Invoice_Header.goods_total as lineGoodsTotal,
	       Invoice_Header.line_total as lineTotal,
         Invoice.invoice_total,
         Invoice.vat_total,
	       Invoice_Header.line_vat as lineVAT,
	       Invoice_Header.full_description,
	       Invoice_Header.Product_Code,
	       Products.Unit_of_Sale,
	       company.* from
      Invoice,
      Invoice_Header LEFT JOIN Products on (Products.Product_Code = Invoice_Header.Product_Code),
      company
      where Invoice.id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#">
      AND
      company.account_number = Invoice.account_number
      AND
      Invoice_Header.invoice_num = Invoice.invoice_number
      AND
      company.account_number = Invoice.account_number
      AND
      Invoice.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">

      group by Invoice_Header.id
    </cfquery>
    <cfreturn i>
  </cffunction>


  <cffunction name="list" returntype="query" output="false">
    <cfargument name="filterBy" required="true" type="string" default="">
    <cfargument name="filterID" required="true" type="string" default="">
    <cfargument name="startRow" required="true" type="numeric" default="0">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
    <cfset var columnArray = ["id","branch_id","account_number","account_name","order_number","invoice_number","invoice_date","invoice_total","salesman","PODFile"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfset var useAnd = false>
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="l" datasource="#dsn.getName()#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
      select
	      id,
        branch_id,
        account_number,
        account_name,
        order_number,
        invoice_number,
        invoice_date,
        order_category,
        invoice_total,
        quantity,
        salesman,
        PODFile
      from
        Invoice
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        <cfif arguments.filterBy neq "" AND arguments.filterBy neq 0>
        AND
        #filterBy# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterID#">

        </cfif>
        <cfif arguments.searchQuery neq "">
        AND
        (
        account_number like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        invoice_num like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        product_code like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        salesman like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
        </cfif>
        <cfif arguments.sortCol neq "">
        order by #sortColName# #arguments.sortDir#
        </cfif>
        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="fullList" returntype="query" output="false">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="l" datasource="#dsn.getName()#">
      select
        Invoice_Header.*,
        Products.*
      from
        Invoice_Header,
        Products
      where
        Invoice_Header.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#BMNet.companyID#">
        AND
        Products.product_code = Invoice_Header.product_code

    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="cCount" returntype="Numeric">
    <cfargument name="filterBy" required="true" type="string" default="">
    <cfargument name="filterID" required="true" type="string" default="">
    <cfargument name="searchQuery" required="true" default="">
    <cfset var BMNet = instance.UserStorage.getVar("BMNet")>
    <cfquery name="s" datasource="#dsn.getName()#">
      select count(account_number) as records
      from
      Invoice
      WHERE
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        <cfif arguments.filterBy neq "">
          AND
          #filterBy# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterID#">

        </cfif>
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

  <cffunction name="getCustomer" returntype="query">
    <cfargument name="id" required="true" default="">
    <cfquery name="s" datasource="#dsn.getName()#">
      select *
      from
      Customer
        WHERE
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
    </cfquery>
    <cfreturn s>
  </cffunction>


  <cffunction name="search" access="public" returntype="Any" output="false">
    <cfargument name="query" required="true" type="string" >
    <cfargument name="siteID" required="true" type="string" default="" >
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <!--- RC Reference --->
    <cfset var ticket = instance.userService.getUserTicket()>
    <cfhttp url="http://46.51.188.170/alfresco/service/bv/search/company?q=#query#&siteid=#siteID#&maxrows=#maxRow#&startRow=#startRow#&alf_ticket=#ticket#" result="companies"></cfhttp>
    <cftry>
    <cfreturn DeserializeJSON(companies.fileContent)>
    <cfcatch type="any">
    <cfreturn companies.fileContent>
    </cfcatch>
    </cftry>
  </cffunction>
</cfcomponent>