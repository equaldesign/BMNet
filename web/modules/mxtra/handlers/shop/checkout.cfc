<cfcomponent output="false"  cache="true">
  <cfproperty name="basket" inject="id:mxtra.basket" scope="instance" />
  <cfproperty name="orders" inject="id:mxtra.orders" scope="instance" />
  <cfproperty name="checkout" inject="id:mxtra.checkout" scope="instance" />
  <cfproperty name="account" inject="id:mxtra.account" scope="instance" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="Renderer" inject="coldbox:plugin:Renderer">
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">
<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->

<cffunction name="add" returntype="void" output="false">
	<cfargument name="event" required="true">
	<cfset var rc = event.getCollection()>
  <cfset quantity = event.getValue('quantity',1)>
  <cfset productID = event.getValue('productID',0)>
  <cfset currentQuantity = 0>
  <cfset rc.refURL = event.getValue('refURL','')>
	<!--- see if the product is already in the basket --->
	<cfquery name="getprod" datasource="mxtra_#rc.sess.siteID#">
	  select quantity from basket where productCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#">
	   and
	   cookie_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.cookieID#">;
	</cfquery>
	<cfif getprod.recordCount neq 0>
	  <cfset currentQuantity = getprod.quantity>
	  <cfset q = quantity + currentQuantity>
	  <cfquery name="updateQuant" datasource="mxtra_#rc.sess.siteID#">
	    update basket set quantity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#q#"> where cookie_id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.cookieID#">
	     and productCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#">;
	  </cfquery>
	<cfelse>
	  <cfset q = quantity>
	  <!--- add the product to the basket --->
	  <cfquery name="addprod" datasource="mxtra_#rc.sess.siteID#">
	    insert into basket (productCode,quantity,cookie_id) VALUES
	    (<cfqueryparam cfsqltype="cf_sql_varchar" value="#productID#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#q#">,<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.cookieID#">);
	  </cfquery>
	</cfif>
  <cfset setNextRoute("/mxtra/shop/basket","refURL")>
</cffunction>

<cffunction name="index" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.pageID = 0>
  <cfset rc.categoryID = 0>
  <cfset rc.productID = 0>
  <cfset rc.basket = instance.basket.getBasket()>
  <cfset rc.step = event.getValue("stage",request.mxtra.order.stage)>
  <cfset rc.delivered = instance.basket.isDelivered()>
  <cfset rc.basketTotal = instance.basket.getTotalPrice()>
  <cfif NOT isDefined("rc.mxtra")>
    <cfset rc.mxtra = request.mxtra>
  </cfif>
  <cfswitch expression="#rc.step#">
    <cfcase value="0">
      <!--- they want to go back to the beginning --->
      <cfset request.mxtra.order = ApplicationStorage.getVar("mxtra").order>
      <cfset UserStorage.setVar("mxtra",request.mxtra)>
      <cfset event.setView("shop/checkout/start")>
    </cfcase>
    <cfcase value="1">
      <!--- stage one - either login or confirm they're a guest --->
      <cfif NOT isUserInRole("trade") AND NOT request.mxtra.order.guest><!--- they are not logged in, and are not a confirmed guest --->
        <cfset event.setView("shop/checkout/start")>
      <cfelse>
        <cfif isUserInRole("trade")>
          <cfif request.mxtra.order.invoice.address eq "">
            <cfset instance.account.PopulateAccountAddresses(rc.sess.mxtra.account.number)>
          </cfif>
        </cfif>
        <cfset rc.error = StructNew()>
        <cfset rc.error.message = ArrayNew(1)>
        <cfset rc.error.fields = ArrayNew(1)>
        <cfset request.mxtra.order.stage = 2>
        <cfset UserStorage.setVar("mxtra",request.mxtra)>
        <cfif rc.delivered>
          <cfset event.setView("shop/checkout/invoiceAddress")>
		    <cfelse>
				  <cfset event.setView("shop/checkout/getName")>
		    </cfif>
      </cfif>
    </cfcase>
    <cfcase value="2"><!--- stage 2, confirm invoice details --->
		    <cfif rc.delivered>
	        <cfset rc.useForDel = event.getValue("useForDelivery",false)>
          <cfset rc.error = StructNew()>
	        <cfset rc.error.message = ArrayNew(1)>
	        <cfset rc.error.fields = ArrayNew(1)>

          <cfloop collection="#rc.mxtra.order.invoice#" item="i">
            <cfset request.mxtra.order.invoice[i] = rc.mxtra.order.invoice[i]>
          </cfloop>
	        <cfif request.mxtra.order.invoice.name eq "">
	          <cfset ArrayAppend(rc.error.message,"A Contact Name is required for the invoice")>
	          <cfset ArrayAppend(rc.error.fields,"mxtra.order.invoice.name")>
	        </cfif>
	        <cfif request.mxtra.order.invoice.address1 eq "">
	          <cfset ArrayAppend(rc.error.message,"The first line of your billing address is required")>
	          <cfset ArrayAppend(rc.error.fields,".mxtra.order.invoice.address1")>
	        </cfif>
	        <cfif NOT instance.checkout.checkPostcode(request.mxtra.order.invoice.postCode)>
	          <cfset ArrayAppend(rc.error.message,"Your postcode does not seem to be valid")>
	          <cfset ArrayAppend(rc.error.fields,"mxtra.order.invoice.postCode")>
	        </cfif>
	        <cfif ArrayLen(rc.error.message) gte 1>
	           <cfset event.setView("shop/checkout/invoiceAddress")>
	        <cfelse>
            <cfif rc.useForDel>
              <cfset request.mxtra.order.delivery = request.mxtra.order.invoice>
              <cfset request.mxtra.order.stage = 4>
              <cfset UserStorage.setVar("mxtra",request.mxtra)>
           <cfset event.setView("shop/checkout/paymentInformation")>
            <cfelse>
              <cfset request.mxtra.order.stage = 3>
               <cfset UserStorage.setVar("mxtra",request.mxtra)>
           <cfset event.setView("shop/checkout/deliveryAddress")>
            </cfif>


	        </cfif>
        <cfelse>
			    <cfset rc.error = StructNew()>
          <cfset rc.error.message = ArrayNew(1)>
          <cfset rc.error.fields = ArrayNew(1)>
          <cfloop collection="#rc.mxtra.order.invoice#" item="i">
            <cfset request.mxtra.order.invoice[i] = rc.mxtra.order.invoice[i]>
          </cfloop>
		      <cfif request.mxtra.order.invoice.name eq "">
            <cfset ArrayAppend(rc.error.message,"A Contact Name is required for collection")>
            <cfset ArrayAppend(rc.error.fields,"mxtra.order.invoice.name")>
          </cfif>
			    <cfif request.mxtra.order.invoice.phone eq "">
            <cfset ArrayAppend(rc.error.message,"A phone number is required")>
            <cfset ArrayAppend(rc.error.fields,"mxtra.order.invoice.phone")>
          </cfif>
          <cfif request.mxtra.order.invoice.address1 eq "">
            <cfset ArrayAppend(rc.error.message,"An Invoice Address is required")>
            <cfset ArrayAppend(rc.error.fields,"mxtra.order.invoice.address1")>
          </cfif>
          <cfif NOT instance.checkout.checkPostcode(request.mxtra.order.invoice.postCode)>
            <cfset ArrayAppend(rc.error.message,"Your postcode does not seem to be valid")>
            <cfset ArrayAppend(rc.error.fields,"mxtra.order.invoice.postCode")>
          </cfif>
			    <cfif ArrayLen(rc.error.message) gte 1>
             <cfset event.setView("shop/checkout/getName")>
          <cfelse>
			      <cfset request.mxtra.order.stage = 5>
            <cfset UserStorage.setVar("mxtra",request.mxtra)>
            <cfset event.setView("shop/checkout/confirmation")>
				  </cfif>
			  </cfif>
    </cfcase>
    <cfcase value="3">
        <cfset rc.error = StructNew()>
        <cfset rc.error.message = ArrayNew(1)>
        <cfset rc.error.fields = ArrayNew(1)>
        <cfloop collection="#rc.mxtra.order.delivery#" item="i">
          <cfset request.mxtra.order.delivery[i] = rc.mxtra.order.delivery[i]>
        </cfloop>
        <cfif request.mxtra.order.delivery.name eq "">
          <cfset ArrayAppend(rc.error.message,"A Contact Name is required for Delivery")>
          <cfset ArrayAppend(rc.error.fields,"mxtra.order.delivery")>
        </cfif>
        <cfif request.mxtra.order.delivery.address1 eq "">
          <cfset ArrayAppend(rc.error.message,"An Invoice Address is required")>
          <cfset ArrayAppend(rc.error.fields,"mxtra.order.delivery.address1")>
        </cfif>
        <cfif NOT instance.checkout.checkPostcode(request.mxtra.order.delivery.postCode)>
          <cfset ArrayAppend(rc.error.message,"Your postcode does not seem to be valid")>
          <cfset ArrayAppend(rc.error.fields,"mxtra.order.delivery")>
        </cfif>
        <cfif ArrayLen(rc.error.message) gte 1>
           <cfset event.setView("shop/checkout/deliveryAddress")>
        <cfelse>
           <cfset request.mxtra.order.stage = 4>
           <cfset UserStorage.setVar("mxtra",request.mxtra)>
           <cfset event.setView("shop/checkout/paymentInformation")>
        </cfif>
    </cfcase>
    <cfcase value="4">
      <cfset rc.error = StructNew()>
      <cfset rc.error.message = ArrayNew(1)>
      <cfset rc.error.fields = ArrayNew(1)>
      <cfset pSY = event.getValue("pSY","")>
      <cfset pSM = event.getValue("pSM","")>
      <cfif pSY neq "">
        <cfset request.mxtra.order.card.validFrom = createDate(pSY,pSM,1)>
      </cfif>
      <cfset mxtra.order.card.validTo = createDate(event.getValue("pEY",Year(request.mxtra.order.card.validTo)),event.getValue("pEM",DateFormat(request.mxtra.order.card.validTo,"MM")),1)>
      <cfloop collection="#rc.mxtra.order.card#" item="i">
        <cfset request.mxtra.order.card[i] = rc.mxtra.order.card[i]>
      </cfloop>
      <cfif request.mxtra.order.card.name eq "">
        <cfset ArrayAppend(rc.error.message,"A Cardholder Name is required")>
        <cfset ArrayAppend(rc.error.fields,"mxtra.order.card.name")>
      </cfif>
      <cfif ListContains("Switch,Mastercard,Visa",request.mxtra.order.card.cardType) eq 0>
        <cfset ArrayAppend(rc.error.message,"You need to choose a card type")>
        <cfset ArrayAppend(rc.error.fields,"mxtra.order.card.cardType")>
      </cfif>
      <cfif NOT instance.checkout.checkCard(request.mxtra.order.card.cardNumber,request.mxtra.order.card.cardType)>
        <cfset ArrayAppend(rc.error.message,"Your Card Number was not valid")>
        <cfset ArrayAppend(rc.error.fields,"mxtra.order.card.cardNumber")>
      </cfif>
      <cfif request.mxtra.order.card.cardType eq "Switch" AND (request.mxtra.order.card.validFrom eq "" OR DateCompare(request.mxtra.order.card.validFrom,now(),"m") gt 0)>
          <cfset ArrayAppend(rc.error.message,"Start date is incorrect")>
          <cfset ArrayAppend(rc.error.fields,"mxtra.order.card.validFrom")>
      </cfif>
      <cfif request.mxtra.order.card.cardType eq "Switch" AND NOT isNumeric(request.mxtra.order.card.issueNumber)>
        <cfset ArrayAppend(rc.error.message,"IssueNumber is invalid")>
        <cfset ArrayAppend(rc.error.fields,"mxtra.order.card.issueNumber")>
      </cfif>
      <cfif DateCompare(request.mxtra.order.card.validTo,now(),'m') lt 0>
        <cfset ArrayAppend(rc.error.message,"Your Payment Card seems to have expired : #DateCompare(request.mxtra.order.card.validTo,now())#")>
        <cfset ArrayAppend(rc.error.fields,"request.mxtra.order.card.validTo")>
      </cfif>
      <cfif request.mxtra.order.card.securityCode eq "">
        <cfset ArrayAppend(rc.error.message,"You did not enter a security code")>
        <cfset ArrayAppend(rc.error.fields,"mxtra.order.card.securityCode")>
      </cfif>
      <cfif ArrayLen(rc.error.message) gte 1 AND request.mxtra.order.quote eq false>
        <cfset event.setView("shop/checkout/paymentInformation")>
      <cfelseif ArrayLen(rc.error.message) lt 1 AND request.mxtra.order.quote eq true>
        <cfset request.mxtra.order.stage = 5>
        <cfset request.mxtra.order.quote = false>
        <cfset instance.basket.setVar("order",request.mxtra.order)>
        <cfset event.setView("shop/checkout/confirmation")>
      <cfelse>
        <cfset request.mxtra.order.stage = 5>
        <cfset UserStorage.setVar("mxtra",request.mxtra)>
        <cfset event.setView("shop/checkout/confirmation")>
      </cfif>
    </cfcase>
    <cfcase value="5">

      <cfset event.setView("shop/checkout/confirmation")>
    </cfcase>
  </cfswitch>
</cffunction>

<cffunction name="quote" returntype="void" output="false">
<cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset request.mxtra.order.stage = 5>
  <cfset request.mxtra.order.quote = true>
  <cfset event.setLayout('sites/#rc.sess.siteID#/Layout.#rc.sess.pageFormat#')>
           <cfset rc.basketItems = instance.basket.getItems()>
          <cfset event.setView("shop/checkout/confirmation")>
</cffunction>
<cffunction name="finish" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset request.mxtra.order = instance.orders.getBasketOrder()>
  <cfset rc.basket = instance.basket.getBasket()>
  <cfset rc.isDelivered = instance.basket.isDelivered()>
  <cfset request.mxtra.orderID = instance.checkout.do(rc.basket,request.mxtra.order,rc.isDelivered)>
  <!--- send an email to Turnbull --->
  <cfif rc.isDelivered>
    <cfset rc.emailView = "email/ecommerce/customer/order">
    <cfset rc.subject = "Order Confirmation: order #request.mxtra.orderID#">
  <cfelse>
    <cfset rc.emailView = "email/ecommerce/customer/reservation">
    <cfset rc.subject = "Click and Collect Confirmation: #request.mxtra.orderID#">
  </cfif>
  <cfset local.CustomerEmail = MailService.newMail().config(from="Turnbull 24-7 <weborders@turnbullsonline.co.uk>",to="#request.mxtra.order.invoice.email#",subject = "#rc.subject#")>
  <cfset local.CustomerEmail.addMailPart(charset='utf-8',type='text/html',body=Renderer.renderLayout(layout="email/ecommerce/Layout.email.html",args=rc))>
  <cfset local.CustomerEmail.addMailPart(charset='utf-8',type='text/plain',body=Renderer.renderLayout(layout="email/ecommerce/Layout.email.plain",args=rc))>
  <cfset local.CustomerEmailResult = MailService.send(local.CustomerEmail)>
  <cfif rc.isDelivered>
    <cfset rc.emailView = "email/ecommerce/staff/order">
    <cfset rc.subject = "New Web Order: #request.mxtra.orderID#">
  <cfelse>
    <cfset rc.emailView = "email/ecommerce/staff/reservation">
    <cfset rc.subject = "New Click and Collect Reservation: #request.mxtra.orderID#">
  </cfif>
  <cfset local.StaffEmail = MailService.newMail().config(from="Web Orders <no-reply@buildersmerchant.net>",to="hannah.prangnell@turnbullsonline.co.uk,andrew.copeland@turnbullsonline.co.uk",subject = "#rc.subject#")>
  <cfset local.StaffEmail.addMailPart(charset='utf-8',type='text/html',body=Renderer.renderLayout(layout="email/ecommerce/Layout.email.html",args=rc))>
  <cfset local.StaffEmail.addMailPart(charset='utf-8',type='text/plain',body=Renderer.renderLayout(layout="email/ecommerce/Layout.email.plain",args=rc))>
  <cfset local.StaffEmailResult = MailService.send(local.StaffEmail)>

  <cfset instance.basket.empty()>
  <!--- now redirect to thankyou page --->
  <cfset event.setView("shop/checkout/thankyou")>
</cffunction>


<cffunction name="switch" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.userType = event.getValue("userType","newCustomer")>
  <cfif rc.userType eq "newCustomer">
    <cfset request.mxtra.order.guest = true>
  <cfelse>

  </cfif>
  <cfset request.mxtra.order.email = event.getValue("username","")>
  <cfset UserStorage.setVar("mxtra",request.mxtra)>
  <cfset setNextevent(uri="/mxtra/shop/checkout")>
</cffunction>

	</cfcomponent>