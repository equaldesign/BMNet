<cfcomponent output="false">
	<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>

	<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
  <cfproperty name="account" inject="id:mxtra.account" scope="instance" />
  <cfproperty name="InvoiceService" inject="id:eunify.InvoiceService">
  <cfproperty name="QuoteService" inject="id:quote.QuoteService">
  <cfproperty name="EcommerceService" inject="id:eunify.EcommerceService">
  <cfproperty name="admin" inject="id:mxtra.orders" scope="instance" />
  <cffunction name="preHandler" returntype="void" output="false">
    <cfargument name="Event">
    <cfset var rc = event.getCollection()>

    <cfset rc.fromDate = LSDateFormat(event.getValue("fromDate",createDate(year(now()),month(now()),1)))>
    <cfset rc.toDate = LSDateFormat(event.getValue("toDate",now()))>
  </cffunction>

	<cffunction name="index" returntype="void" output="false">
	  <cfargument name="event" required="true">
	  <cfset var rc = event.getCollection()>
    <cfset rc.invoices = InvoiceService.list(filterBy="account_number",filterID=rc.sess.BMNet.account_number,maxrow=5,sortCol=6,sortDir="desc")>
	  <cfset rc.quotations = QuoteService.getActiveQuotations()>
	  <cfset event.setView("account/index")>
	</cffunction>

  <cffunction name="quotes" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.status = event.getValue("status","")>
    <cfset rc.orders = instance.admin.getOrders("true",rc.status,request.siteID)>
    <cfset rc.title = "#rc.status# Quotations">
    <cfset event.setView("admin/orderlist")>
  </cffunction>

	<cffunction name="invoiceList" returntype="void" output="false">
	  <cfargument name="event" required="true">
	  <cfset var rc = event.getCollection()>
    <cfset rc.invoice_number = event.getValue("invoice_number","")>
    <cfif rc.invoice_number neq "">
      <cfset rc.invoice = InvoiceService.getInvoice(rc.invoice_number,request.siteID)>
      <cfif rc.invoice.recordCount neq 0>
        <cfset setNextEvent(uri="/mxtra/account/invoiceDetail?id=#rc.invoice_number#")>
      </cfif>
    </cfif>
    <cfset rc.fromDate = event.getValue("fromDate",createDate(2000,01,01))>
    <cfset rc.toDate = event.getValue("toDate",now())>
    <cfset rc.invoices = instance.account.getInvoices(rc.fromDate,rc.toDate,request.siteID,rc.sess.BMNet.account_number)>
	  <cfset event.setView("invoicing/thisMonth")>
	</cffunction>

  <cffunction name="allInvoices" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("invoicing/thisMonth")>
  </cffunction>

	<cffunction name="invoiceDetail" returntype="void" output="false">
	  <cfargument name="event" required="true">
	  <cfset var rc = event.getCollection()>
	  <cfset rc.invoiceID = event.getValue("id",0)>
	  <cfset rc.output = event.getValue("output","html")>
	  <cfset rc.invoice = InvoiceService.getInvoice(rc.invoiceID,request.siteID)>

	  <cfset event.setView("invoicing/invoiceDetail.#rc.output#")>
	</cffunction>
<cffunction name="orderDetail" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.orderID = event.getValue("id",0)>
    <cfset rc.order = instance.admin.getOrder(rc.orderID)>
     <cfset rc.output = event.getValue("output",rc.sess.pageFormat)>
    <cfset event.setLayout('sites/#rc.sess.siteID#/Layout.account.#rc.output#')>
    <cfset event.setView("invoicing/quote.#rc.output#")>
  </cffunction>
  <cffunction name="getPOD" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.POD = event.getValue("PODFile","")>
    <cfset event.setView("invoicing/viewPOD",true)>
  </cffunction>

  <cffunction name="emailinvoices">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
	  <cfset rc.invoiceNumbers = event.getValue("invoiceNumber","")>
    <cfset event.setView("invoicing/emailinvoices")>
  </cffunction>

  <cffunction name="indexPODs" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfsetting requesttimeout="9900">
    <cfindex language="english" collection="turnbullpods" recurse="true" action="update" key="/fs/homes/turnbull/turnbullftp/PODs" extensions=".pdf" type="path" />
    <cfquery name="invoices" datasource="mxtra_#rc.sess.siteID#">
      select id, order_number, product_code from Invoice_Header where PODFile is null AND inv_date > <cfqueryparam cfsqltype="cf_sql_date" value="#DateAdd('m',-1,now())#">;
    </cfquery>
    <cfloop query="invoices">
      <cfsearch name="PODs" collection="turnbullpods" criteria="#order_number# AND '#product_code#'" type="simple" />
      <cfset rc.PODs = PODs>
      <cfif PODs.recordCount neq 0>
        <cfquery name="updateHeader" datasource="mxtra_#rc.sess.siteID#">
          update Invoice_Header set PODFile = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PODs.url#"> where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
        </cfquery>
      </cfif>
    </cfloop>
   <cfset rc.invoices = invoices>
   <cfset event.setLayout('sites/#rc.sess.siteID#/Layout.account.#rc.sess.pageFormat#')>
    <cfset event.setView("debug")>
  </cffunction>
</cfcomponent>