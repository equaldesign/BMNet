<cfcomponent output="false"  cache="true">
  
  <cfproperty name="UserStorage" inject="coldbox:myplugin:UserStorage" />
  <cfproperty name="account" inject="id:mxtra.account" scope="instance" />
  <cfproperty name="CompanyService" inject="id:eunify.CompanyService" />
  <cfproperty name="admin" inject="id:mxtra.orders" scope="instance" />


<cffunction name="getOrders" returntype ="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.status = event.getValue("status","")>
  <cfset rc.orders = instance.admin.getOrders("false",rc.status)>
  <cfset rc.title = "#rc.status# Orders">
  <cfset event.setView("admin/orderlist")>
</cffunction>

<cffunction name="getQuotes" returntype ="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.status = event.getValue("status","")>
  <cfset rc.orders = instance.admin.getOrders("true",rc.status)>
  <cfset rc.title = "#rc.status# Quotations">
  <cfset event.setView("admin/orderlist")>
</cffunction>



<cffunction name="orderDetail" returntype ="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.layout = event.getValue("format","")>
  <cfif rc.layout neq "">
    <cfset event.setLayout('sites/#rc.sess.siteID#/Layout.account.#rc.layout#')>
  </cfif>
  <cfset rc.orderID = event.getValue("id","")>
  <cfset rc.order = instance.admin.getOrder(rc.orderID)>
  <cfset event.setView("admin/orderDetail")>
</cffunction>

<cffunction name="doQuote" returntype ="void" output="true">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.sendEmail = event.getValue("sendEmail",false)>
  <cfset rc.orderID = event.getValue("orderID",0)>
  <cfset rc.delivery = event.getValue("delivery",0)>
  <cfset rc.overage = 0>
  <cfset rc.order = instance.admin.doQuote(rc.orderID,rc.delivery,form)>
  <cfif rc.sendEmail>
    <cfoutput>#renderView("admin/quotePDF")#</cfoutput>
    <cfoutput>
    <cfmail to="#rc.order.billingEmail#" from="Turnbull 24-7<no-reply@turnbull24-7.co.uk>" subject="Your Turnbull 24-7 Quotation">
Dear #rc.order.billingContact#,

Please find attached your quotation recently prepared by Turnbull 24-7

<cfmailparam file="#rc.app.appRoot#/sites/#rc.sess.siteID#/mxtra/quotations/#rc.orderID#.pdf" disposition="attachment">
    </cfmail>
    </cfoutput>
  </cfif>
  <cfset setNextEvent(uri="/mxtra/admin/orders/orderDetail/id/#rc.orderID#")>
</cffunction>

<cffunction name="changeStatus" returntype="void" output="false">
  <cfargument name="event">
  <cfset var rc = event.getCollection()>
  <cfset rc.id = event.getValue("id",0)>
  <cfset rc.status = event.getValue("status","")>
  <cfset instance.admin.changeStatus(rc.id,rc.status)>
  <cfset event.setLayout("Layout.ajax")>
  <cfset event.setView("blank")>
</cffunction>
<cffunction name="becomeAccount" returntype="void" output="false">
  <cfargument name="event">
  <cfset var rc = event.getCollection()>
  <cfset var BMNet = UserStorage.getVar("BMNet")>
  <cfset rc.id = event.getValue("aNum",0)>
  <cfset company = CompanyService.getcompanyByAccountNumber(rc.id,request.siteID)>
  <cfset BMNet.companyID = company.id>
  <cfset BMNet.account_number = company.account_number>  
  <cfset UserStorage.setVar("BMNet",BMNet)>
  <cfset setNextEvent(uri="/mxtra/account")>
</cffunction>

<cffunction name="downloadCustomers" returntype="void" output="true">
  <cfargument name="event">
  <cfset var rc = event.getCollection()>
  <cfset rc.customers = instance.admin.getCustomers()>
  <cfset rc.fileName = createUUID()>
  <cfspreadsheet action="write" query="rc.customers" filename="/tmp/#rc.fileName#.xls" sheetname="Customers"></cfspreadsheet>
  <cfheader name="Content-Disposition" value="attachment;filename=Customers.xls">
  <cfcontent deletefile="true" reset="true" file="/tmp/#rc.filename#.xls" type="#getPageContext().getServletContext().getMimeType('/tmp/#rc.filename#.xls')#">>
  <cfset event.noRender()>
</cffunction>
<cffunction name="downloadProducts" returntype="void" output="true">
  <cfargument name="event">
  <cfset var rc = event.getCollection()>
  <Cfquery name="prods" datasource="mxtra_#rc.sess.siteid#">
    select * from Products;
  </Cfquery>
  <cfset rc.fileName = createUUID()>
  <cfspreadsheet action="write" query="prods" filename="/tmp/#rc.fileName#.xls" sheetname="Products"></cfspreadsheet>
  <cfheader name="Content-Disposition" value="attachment;filename=Products.xls">
  <cfcontent deletefile="true" reset="true" file="/tmp/#rc.filename#.xls" type="#getPageContext().getServletContext().getMimeType('/tmp/#rc.filename#.xls')#">>
  <cfset event.noRender()>
</cffunction>
</cfcomponent>

