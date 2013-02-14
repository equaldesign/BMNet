<cfcomponent outut="false" accessors="true" hint="The bvine module service layer" cache="true">
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />

  <!--- methods --->

  <cffunction name="list" returntype="query" output="false">
    <cfargument name="filterBy" required="true" type="string" default="">
    <cfargument name="filterID" required="true" type="string" default="">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="sortCol" required="true" type="numeric" default="0">
    <cfargument name="sortDir" required="true" type="string" default="asc">
    <cfargument name="searchQuery" required="true" type="string" default="">
	  <cfargument name="quote" required="true" type="boolean" default="false">
    <cfset var columnArray = ["id","billingContact","billingAddress","billingPostCode","totalPrice","status","date","delivered"]>
    <cfset var sortColName = columnArray[arguments.sortCol+1]>
    <cfquery name="l" datasource="#dsn.getName()#">
      select
        *
      from
        shopOrder
        WHERE
        siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
		    AND
			  quote = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.quote#">
        <cfif arguments.filterBy neq "">
        AND
        #filterBy# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterID#">
        </cfif>
        <cfif arguments.searchQuery neq "">
        AND
        (
        status like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        billingContact like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        billingPostCode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
        </cfif>
        order by #sortColName# #arguments.sortDir#
        limit #arguments.startRow#,#arguments.maxRow#
    </cfquery>
    <cfreturn l>
  </cffunction>

  <cffunction name="getOrder" returntype="query" output="false">
    <cfargument name="id" required="true" type="string" default="">
    <cfquery name="l" datasource="#dsn.getName()#">
      select
        *
      from
        shopOrder,
        shopOrderLine,
        Products
        WHERE
        shopOrder.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
		    AND
			  shopOrder.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">
			  AND
			  shopOrderLine.shopOrderId = shopOrder.id
			  AND
			  Products.Product_Code = shopOrderLine.itemNo
			  AND
			  Products.siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
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
      shopOrder
      WHERE
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
        <cfif arguments.filterBy neq "">
          AND
          #filterBy# = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.filterID#">

        </cfif>
        <cfif arguments.searchQuery neq "">
         AND
        (
        status like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        billingContact like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        OR
        billingPostCode like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.searchQuery#%">
        )
        </cfif>
    </cfquery>
    <cfreturn s.records>
  </cffunction>

<cffunction name="changeStatus" returntype="query">
    <cfargument name="id">
    <cfargument name="status">
    <cfquery name="order" datasource="BMNet">
      update
        shopOrder
      set status = <cfqueryparam cfsqltype="cf_sql_varchar" value="#status#">
      where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
            AND
      siteID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">
    </cfquery>
    <cfset order = getOrder(id)>
    <cfswitch expression="#status#">
      <cfcase value="confirmed">
<cfmail from="no-reply@turnbull24-7.co.uk" to="#order.billingContact# <#order.billingEmail#>" subject="Your Turnbull 24-7 Order">
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND OR REPLY TO THIS EMAIL

===============================

Dear #order.billingContact#,

Thank you for your recent order with Turnbull 24-7.

We are writing to inform you that your payment has been processed.

You will receive a further email once your order has been shipped.

Thank you.

-------------------------------
Turnbull 24-7

http://www.turnbull24-7.co.uk

</cfmail>
      </cfcase>
      <cfcase value="shipped">
<cfmail from="no-reply@turnbull24-7.co.uk" to="#order.billingContact# <#order.billingEmail#>" subject="Your Turnbull 24-7 Order">
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND OR REPLY TO THIS EMAIL

===============================

Dear #order.billingContact#,

Thank you for your recent order with Turnbull 24-7.

We are writing to inform you that your order has now been shipped.

You should receive your item shortly.

Thank you.

-------------------------------
Turnbull 24-7

http://www.turnbull24-7.co.uk

</cfmail>
      </cfcase>
      <cfcase value="cancelled">
<cfmail from="no-reply@turnbull24-7.co.uk" to="#order.billingContact# <#order.billingEmail#>" subject="Your Turnbull 24-7 Order">
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND OR REPLY TO THIS EMAIL

===============================

Dear #order.billingContact#,

Thank you for your recent order with Turnbull 24-7.

Your order status has been changed to "cancelled."

Thank you.

-------------------------------
Turnbull 24-7

http://www.turnbull24-7.co.uk

</cfmail>
      </cfcase>
      <cfcase value="declined">
<cfmail from="no-reply@turnbull24-7.co.uk" to="#order.billingContact# <#order.billingEmail#>" subject="Your Turnbull 24-7 Order">
THIS IS AN AUTOMATED MESSAGE - PLEASE DO NOT RESPOND OR REPLY TO THIS EMAIL

===============================

Dear #order.billingContact#,

You recently placed an order with us. Ref: WEB#NumberFormat(order.id,"000000")#

Regrettably, we have not been able to obtain the necessary authorisation from your payment card issuing company.

This may be down to one of the following reasons:
  * Incorrect account number
  * Incorrect expiry date
  * Incorrect name for account card
To confirm or correct your payment details for the above order, please call us on 01529 303025. If we do not hear from you within 5 working days, we will cancel your order.

We apologise for any inconvenience this may cause and we look forward to hearing from you.

Customer Services

Turnbulls

-------------------------------
Turnbull 24-7

http://www.turnbull24-7.co.uk

</cfmail>
      </cfcase>
    </cfswitch>
    <cfreturn order>
  </cffunction>

</cfcomponent>