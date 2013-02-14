<cfcomponent name="account" hint="Creates a template code" cache="false" cachetimeout="90">

  <cfproperty name="UserStorage" inject="coldbox:myplugin:UserStorage" />

  <cffunction name="getCustomer" returntype="query">
      <cfargument name="siteID" required="true">
      <cfargument name="account_number" required="true">
      <cfquery name="customerDetails" datasource="BMNet" >
      SELECT
        *
      FROM
        company
      WHERE
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_number#">
      AND
        type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
    </cfquery>
    <cfreturn customerDetails>
  </cffunction>

  <cffunction name="getInvoices" returntype="query">
    <cfargument name="dateFrom" required="true" default="#createDate(2000,01,01)#">
    <cfargument name="dateTo" required="true" default="#now()#">
    <cfargument name="siteID" required="true">
    <cfargument name="account_number" required="true">
    <cfquery name="invoices" datasource="BMNet">
      SELECT
	      Invoice.id,
        invoice_number as invoice_num,
        order_number,
        line_total,
        vat_total line_vat,
        invoice_date,
        quantity as items,
        order_number,
        PODFile,
        name
      FROM
        Invoice,
        branch
      WHERE
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_number#">
      AND
        Invoice.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
        branch.branch_ref = Invoice.branch_id
      AND
        invoice_date
          BETWEEN
            <cfqueryparam cfsqltype="cf_sql_date" value="#dateFrom#">
          AND
            <cfqueryparam cfsqltype="cf_sql_date" value="#dateTo#">
      GROUP BY invoice_number
	  order by invoice_date asc
    </cfquery>
    <cfreturn invoices>
  </cffunction>

  <cffunction name="getRecentInvoices" returntype="query">
    <cfargument name="siteID" required="true">
    <cfargument name="account_number" required="true">
    <cfquery name="invoices" datasource="BMNet">
      SELECT
        invoice_number as invoice_num,
        order_number,
        line_total,
        vat_total as line_vat,
        invoice_date as inv_date
      FROM
        Invoice
      WHERE
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_number#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      GROUP BY invoice_number
      ORDER BY invoice_date desc limit 0,5
    </cfquery>
    <cfreturn invoices>
  </cffunction>

  <cffunction name="getRecentPODs" returntype="query">
    <cfargument name="siteID" required="true">
    <cfargument name="account_number" required="true">
    <cfquery name="invoices" datasource="BMNet">
      SELECT
        invoice_number as invoice_num,
        order_number,
        line_total,
        invoice_date as inv_date,
        PODFile
      FROM
        Invoice
      WHERE
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_number#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
        PODFile != 0
      GROUP BY invoice_number
      order by invoice_date desc limit 0,5
    </cfquery>
    <cfreturn invoices>
  </cffunction>

  <cffunction name="getInvoiceCount" returntype="query">
    <cfargument name="dateFrom" required="true" default="#createDate(2000,01,01)#">
    <cfargument name="dateTo" required="true" default="#now()#">
    <cfargument name="siteID" required="true">
    <cfargument name="account_number" required="true">

    <cfquery name="invoices" datasource="BMNet">
      select
        count(*) as total
      from
        Invoice
      where
        account_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.account_number#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
        month(invoice_date) = month(now())
    </cfquery>
    <cfreturn invoices>
  </cffunction>

  <cffunction name="PopulateAccountAddresses" returntype="void">
    <cfargument name="siteID" required="true">
    <cfargument name="account_number" required="true">
    <cfset var BMNet = UserStorage.getVar("BMNet")>
    <cfset customerDetails = getCustomer(arguments.siteID,arguments.account_number)>
    <cfset BMNet.order.delivery = {
                name = customerDetails.company_contact,
                postCode = customerDetails.company_postcode,
                address = customerDetails.company_address_1,
                town = customerDetails.company_address_2,
                county = customerDetails.company_address_3,
                phone = customerDetails.company_phone,
                mobile = customerDetails.company_mobile,
                email = customerDetails.company_email
              }>

     <cfset BMNet.order.invoice = {
                name = customerDetails.company_contact,
                postCode = customerDetails.company_postcode,
                address = customerDetails.company_address_1,
                town = customerDetails.company_address_2,
                county = customerDetails.company_address_3,
                phone = customerDetails.company_phone,
                mobile = customerDetails.company_mobile,
                email = customerDetails.company_email
              }>
  </cffunction>

  <cffunction name="getInvoice" returntype="query">
    <cfargument name="invoiceID" required="true" default="0">
    <cfargument name="orderID" required="true" default="0">
    <cfargument name="siteID" required="true">
    <cfargument name="account_number" required="true">
    <cfquery name="invoice" datasource="BMNet">
      SELECT
        Invoice.*,
        Invoice_Header.*,
        Invoice_Header.quantity as lineQuantity,
        Invoice_Header.line_total as linePrice,
        branch.name,
        company.*,
        Products.*
      from
        Invoice,
        branch,
        company,
        Invoice_Header
        LEFT OUTER JOIN Products on (Products.Product_Code = Invoice_Header.product_code)

      where
        Invoice.invoice_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoiceID#">
      AND
        Invoice_Header.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      AND
        Invoice_Header.invoice_num = Invoice.invoice_number
      AND
        branch.branch_ref = Invoice.branch_id
      AND
        company.type_id = <cfqueryparam cfsqltype="cf_sql_integer" value="1">
        AND
        company.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
        AND
        company.account_number = Invoice.account_number;
    </cfquery>
    <cfreturn invoice>
  </cffunction>
  <cffunction name="getInvoiceTotal" returntype="query">
    <cfargument name="invoiceID" required="true" default="0">
    <cfargument name="orderID" required="true" default="0">
    <cfargument name="siteID" required="true">
    <cfargument name="account_number" required="true">
    <cfquery name="invoice" datasource="BMNet" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
      select
        line_total,
        vat_total
      from
        Invoice
      where
        invoice_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#invoiceID#">
      AND
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.siteID#">
      <cfif orderID neq 0 AND orderID neq "">
      AND
      order_number = <cfqueryparam cfsqltype="cf_sql_integer" value="#orderID#">
      </cfif>
      group by invoice_number;
    </cfquery>
    <cfreturn invoice>
  </cffunction>
</cfcomponent>