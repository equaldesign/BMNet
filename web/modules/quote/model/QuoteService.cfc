<cfcomponent name="quoteService" cache="true">
	<cfproperty name="BranchService" inject="id:eunify.BranchService" />
	<cfproperty name="CompanyService" inject="id:eunify.CompanyService" />
	<cfproperty name="ContactService" inject="id:eunify.ContactService" />
	<cfproperty name="ProductService" inject="id:eunify.ProductService" />


	<cffunction name="getPendingQuotations" returntype="query" hint="Returns Quotations for Merchants that they have not responded to">
    <cfquery name="pendingQuotations" datasource="BMNet">
		  SELECT
			  qrq.*,
			  qr.id as responseID,
			  qs.id as sentID
			FROM
			  quoteRequest as qrq,
			  quoteSent as qs LEFT JOIN quoteResponse as qr
			  ON
			  qr.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.companyID#">
			  AND
			  qr.requestID = qs.requestID
			WHERE
			  qs.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.companyID#">
			  AND
			  qrq.id = qs.requestID
			  AND
			  qr.id is null
	  </cfquery>
	  <cfreturn pendingQuotations>
	</cffunction>

  <cffunction name="getOpenQuotations" returntype="query" hint="Returns Quotations for Merchants that they have not responded to">
    <cfquery name="pendingQuotations" datasource="BMNet">
      SELECT
        qrq.*,
        qr.id as responseID,
        qs.id as sentID
      FROM
        quoteRequest as qrq,
        quoteSent as qs,
        quoteResponse as qr
      WHERE
        (
        qr.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.companyID#">
        AND
        qs.requestID = qr.requestID
        AND
        qrq.id = qs.requestID
        )
        OR
        (
          qrq.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.contactID#">
          AND
          qr.requestID = qrq.id
          AND
          qs.requestID = qrq.id
        )
        AND
        qr.interested = <cfqueryparam cfsqltype="cf_sql_varchar" value="notviewed">
    </cfquery>
    <cfreturn pendingQuotations>
  </cffunction>

  <cffunction name="getRejectedQuotations" returntype="query" hint="Returns Quotations for Merchants that they have not responded to">
    <cfquery name="pendingQuotations" datasource="BMNet">
      SELECT
        qrq.*,
        qr.id as responseID,
        qs.id as sentID
      FROM
        quoteRequest as qrq,
        quoteSent as qs,
        quoteResponse as qr
      WHERE
        (
        qr.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.companyID#">
        AND
        qs.requestID = qr.requestID
        AND
        qrq.id = qs.requestID
        )
        OR
        (
          qrq.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.contactID#">
          AND
          qr.requestID = qrq.id
          AND
          qs.requestID = qrq.id
        )
        AND
        qr.interested = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">
    </cfquery>
    <cfreturn pendingQuotations>
  </cffunction>

  <cffunction name="getsuccessfulQuotations" returntype="query" hint="Returns Quotations for Merchants that they have not responded to">
    <cfquery name="pendingQuotations" datasource="BMNet">
      SELECT
        qrq.*,
        qr.id as responseID,
        qs.id as sentID
      FROM
        quoteRequest as qrq,
        quoteSent as qs,
        quoteResponse as qr
      WHERE
        (
        qr.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.companyID#">
        AND
        qs.requestID = qr.requestID
        AND
        qrq.id = qs.requestID
        )
        OR
        (
          qrq.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.contactID#">
          AND
          qr.requestID = qrq.id
          AND
          qs.requestID = qrq.id
        )
        AND
        qr.interested = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
    </cfquery>
    <cfreturn pendingQuotations>
  </cffunction>

	<cffunction name="getActiveQuotations" returntype="query" hint="Returns Quotations for Merchants that they have not responded to">
    <cfquery name="pendingQuotations" datasource="BMNet">
      SELECT
        qrq.*
      FROM
        quoteRequest as qrq
      WHERE
        qrq.contactID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.contactID#">
		    AND
			  qrq.deadline > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
    </cfquery>
    <cfreturn pendingQuotations>
  </cffunction>

	<cffunction name="getQuoteResponse" returntype="">
		<cfargument name="responseID" required="true">
		<cfset var returnStruct = {}>
		<cfquery name="r" datasource="BMNet">
			SELECT
			  quoteResponse.*,
        quoteResponse.deliveryDate as responseDeliveryDate,
			  quoteResponseLine.*,
			  quoteRequest.*
			FROM
			 quoteResponse,
			 quoteResponseLine,
			 quoteRequest
			WHERE
			 quoteResponse.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responseID#">
			AND
			 quoteResponseLine.responseID = quoteResponse.id
			AND
			 quoteRequest.id = quoteResponse.requestID
		</cfquery>
		<cfset returnStruct.response = r>
		<cfset returnStruct.seller = CompanyService.getCompany(r.companyID,request.siteID)>
		<cfset returnStruct.contact = ContactService.getContact(r.contactID)>
		<cfset returnStruct.buyer = CompanyService.getCompany(returnStruct.contact.company_id,request.siteID)>
		<cfreturn returnStruct>
	</cffunction>

  <cffunction name="rejectResponse" returntype="void">
    <cfargument name="responseID" required="true">
    <cfargument name="comment" required="true">
    <cfquery name="r" datasource="BMNet">
      UPDATE
        quoteResponse
      SET
       interested = <cfqueryparam cfsqltype="cf_sql_varchar" value="false">,
       comment = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.comment#">
      WHERE
       quoteResponse.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responseID#">
    </cfquery>
  </cffunction>

  <cffunction name="acceptResponse" returntype="void">
    <cfargument name="responseID" required="true">
    <cfquery name="r" datasource="BMNet">
      UPDATE
        quoteResponse
      SET
       interested = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">
      WHERE
       quoteResponse.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.responseID#">
    </cfquery>
  </cffunction>

	<cffunction name="getQuoteRequest" returntype="struct">
		<cfargument name="quoteID" required="true" default="">
		<cfset var returnStructure = {}>
		<cfquery name="quoteDetail" datasource="BMNet">
			SELECT
			 *
			FROM
			 quoteRequest as qr,
			 quoteRequestLine qrl
			WHERE
			  qr.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quoteID#">
		  AND
		    qrl.requestID = qr.id
		</cfquery>

		<cfset returnStructure.quoteRequest = quoteDetail>
	  <cfset returnStructure.contact = ContactService.getContact(quoteDetail.contactID)>
	  <cfset returnStructure.company = CompanyService.getCompany(returnStructure.contact.company_id,request.siteID)>
	  <!--- get remaining slots --->
	  <cfquery name="slots" datasource="BMNet">
      SELECT
       5-count(id) as remaining
      FROM
       quoteResponse as qs
      WHERE
        qs.requestID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quoteID#">
    </cfquery>
    <cfset returnStructure.slotsRemaining = slots.remaining>
	  <!--- get responses --->
		<cfquery name="quoteResponses" datasource="BMNet">
			SELECT
			  *
			FROM
			 quoteResponse as qr,

			 quoteResponseLine as qrl,
			 company as c
			WHERE
			  qr.requestID = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.quoteID#">
			AND
			  qrl.responseID = qr.id
			<cfif quoteDetail.contactID neq request.bmnet.contactID>
				AND
				qr.companyID = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.bmnet.companyID#">
			</cfif>
			AND
			c.id = qr.companyID
		</cfquery>
		<cfset returnStructure.quoteResponses = quoteResponses>
    <cfif quoteDetail.contactID eq request.bmnet.contactID>
      <cfquery name="responSummaries" dbtype="query">
        SELECT
          SUM(price) as totalItems,
          COUNT(*) as lines,
          max(responseID) as responseID,
          max(name) as companyName,
          max(deliveryCharge) as deliveryCharge,
          max(validUntil) as validUntil,
          max(paymentMethod) as paymentMethod,
          max(interested) as interested
        FROM
          quoteResponses
        GROUP BY companyID
      </cfquery>
      <cfset returnStructure.responseSummaries = responSummaries>
    </cfif>
		<cfreturn returnStructure>
	</cffunction>
	<cffunction name="createRequest" returntype="numeric">
		<cfargument name="reference" type="string">
		<cfargument name="delivered" type="boolean">
		<cfargument name="deliveryDate" type="date">
		<cfargument name="deliveryAddress" type="string">
		<cfargument name="deliveryPostcode" type="string">
		<cfargument name="pickupRadius" type="numeric">
		<cfargument name="deadline" type="date">
		<cfargument name="bestQuote" type="string">
		<cfargument name="productLines" type="array">
		<cfargument name="contactID" type="numeric">
		<cfquery name="doI" datasource="BMNet">
			INSERT INTO quoteRequest
			 (
			   contactID,
			   internalReference,
			   delivered,
			   deliveryDate,
			   deliveryAddress,
			   deliveryPostcode,
			   pickupRadius,
			   deadline,
			   bestQuote,
			   siteID,
			   ticket
			 )
			 VALUES (
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.contactID#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.reference#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.delivered#">,
			   <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.deliveryDate#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deliveryAddress#" >,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.deliveryPostcode#" >,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.pickupRadius#" >,
			   <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.deadline#" >,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.bestQuote#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#request.siteID#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#">
			 )
		</cfquery>
		<cfquery name="n" datasource="BMNet">
			SELECT LAST_INSERT_ID() as id
			FROM
			quoteRequest
		</cfquery>
		<cfset requestID = n.id>
		<cfloop array="#productLines#" index="p">
			<cfif p.product_code neq "void">
				<cfset var product = ProductService.getProduct(p.product_code,request.siteID)>
			<cfelse>
				<cfset var product = {}>
				<cfset product.eancode = "">
				<cfset product.Full_Description = p.product_name>
				<cfset product.Manufacturers_Product_Code = "">
			</cfif>
			<cfquery name="insertLine" datasource="BMNet">
				INSERT INTO quoteRequestLine
				(
				  requestID,
				  quantity,
				  unit,
				  productName,
				  eancode,
				  manufacturerProductCode
				)
				VALUES
				(
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#requestID#">,
				  <cfqueryparam cfsqltype="cf_sql_integer" value="#p.quantity#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.unit#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#product.Full_Description#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#product.eancode#">,
				  <cfqueryparam cfsqltype="cf_sql_varchar" value="#product.Manufacturers_Product_Code#">
				)
			</cfquery>
		</cfloop>
		<cfreturn requestID>
	</cffunction>

	<cffunction name="commitResponse" rreturntype="numeric">
		<cfargument name="id" required="true">
		<cfargument name="sentID" required="true">
		<cfargument name="product" required="true">
	  <cfargument name="paymentMethod" required="true">
		<cfargument name="paypalEmail" required="true">
		<cfargument name="deliveryCharge" required="true">
		<cfargument name="deliveryDate" required="true">
    <cfargument name="deadline" required="true">
    <cfargument name="validUntil" required="true">
		<cfquery name="d" datasource="BMNet">
			insert into quoteResponse
			 (requestID,sentID,companyID,deliveryDate,deliveryCharge,paymentMethod,paypalEmail,deadline,validUntil)
			 VALUES
			 (
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.id#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.sentID#">,
			   <cfqueryparam cfsqltype="cf_sql_integer" value="#request.BMNet.companyID#">,
			   <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.deliveryDate)#">,
			   <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.deliveryCharge#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paymentMethod#">,
			   <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.paypalEmail#">,
         <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.deadline)#">,
         <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(arguments.validUntil)#">
			 )
		</cfquery>
		<cfquery name="r" datasource="BMNet">
			SELECT
			 LAST_INSERT_ID() as id FROM quoteResponse
		</cfquery>
		<cfset newID = r.id>
		<cfloop array="#arguments.product#" index="p">
			<cfquery name="i" datasource="BMNet">
				insert into quoteResponseLine
				  (responseID,quantity,unit,product_name,price)
				VALUES
				  (
				    <cfqueryparam cfsqltype="cf_sql_integer" value="#newID#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#p.quantity#">,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.unit#">,
					  <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.productname#">,
					  <cfqueryparam cfsqltype="cf_sql_float" value="#p.amount#">
				  )
			</cfquery>
		</cfloop>

		<!--- get the quote detail --->
		<cfset quote = getQuoteRequest(arguments.id)>
		<cfquery name="uB" datasource="BMNet">
			update company set balance = balance-#quote.quoteRequest.credits# where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#request.BMNet.companyID#">
		</cfquery>
		<cfreturn newID>
	</cffunction>
</cfcomponent>