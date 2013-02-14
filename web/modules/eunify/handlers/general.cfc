<cfcomponent name="general" output="false"  cache="true"  autowire="true">

<cfproperty name="FeedService" inject="id:eGroup.feed" />
<cfproperty name="CompanyService" inject="id:eGroup.company" />
<cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
<cfproperty name="logger" inject="logbox:root">

<!------------------------------------------- PUBLIC EVENTS ------------------------------------------>

	<!--- Default Action --->
	<cffunction name="index" cache="true" returntype="void" output="false" hint="My main event">
		<cfargument name="event">

		<cfscript>
		  var rc = arguments.event.getCollection();
		  setNextEvent(uri="/eunify/dashboard");
		</cfscript>
	</cffunction>

	  	<cffunction name="help" returntype="void" output="false" hint="My main event">
	  				<cfargument name="event">

	  				<cfset var rc = arguments.event.getCollection()>
	  				<cfset var getTopic = "">
	  				<Cfset rc.topic = arguments.event.getValue('topic','')>
	  				<cfquery name="getTopic" datasource="cbagroup">
	  				  select description from help where name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.topic#">
	  				</cfquery>
	  				<cfset rc.description = "">
	  				<cfset rc.description = getTopic.description>
	  				<cfset arguments.event.setLayout('Layout.ajax')>
	  				<cfset arguments.event.setView('admin/help')>
	  			</cffunction>

	<cffunction name="debug" returntype="void" cache="true">
		<cfargument name="event" required="true" />
		<cfscript>
			var rc = arguments.event.getCollection();
		</cfscript>
		<cfset arguments.event.setLayout('Layout.Main')>
	  <cfset arguments.event.setView('admin/debug')>
	</cffunction>
<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>

  <cffunction name="sethomepage" returntype="void" output="false" hint="My main event">
    <cfargument name="event" required="true" type="any">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.homepage = arguments.event.getValue("page","feed")>
    <cfset CookieStorage.setVar("homePage",rc.homepage,365)>
    <cfset rc.sess.eGroup.homepage = rc.homepage>
    <cfset setNextEvent(uri="/#rc.sess.eGroup.homepage#")>
  </cffunction>

  <!--- quick update for easyrec --->
  
  <!--- google maps update --->
  
  <cffunction name="googleMapsUpdate">
  	<cfargument name="event">
	  <cfthread action="run" name="googlise" priority="LOW">
	  <cfquery name="emptyInvoices" datasource="BMNet">
	  	select * from Invoice where order_category = 'D'
		  AND
		  delivery_latitude = 0
	  </cfquery>
	  <cfsetting requesttimeout="9000000">
	  <cfloop query="emptyInvoices">
      <!--- we now have the lat/long of the delivery address --->
      <cfquery name="branchCo" datasource="BMNet">
        SELECT maplat, maplong from branch where branch_ref = <cfqueryparam cfsqltype="cf_sql_integer" value="#branch_id#">
      </cfquery>
      <!--- now we need to work out the distance ...--->
      <cfhttp url="http://maps.googleapis.com/maps/api/directions/json?origin=#branchCo.maplat#,#branchCo.maplong#&destination=#delivery_postcode#&region=gb&sensor=false&unit=imperial" result="directions">
      <cfset jsonDirections = Deserializejson(directions.fileContent)>
      <cfif jsonDirections.status eq "OK">
        <cfset deliveryLatitude = jsonDirections.routes[1].legs[1].end_location.lat>
        <cfset deliveryLongitude = jsonDirections.routes[1].legs[1].end_location.lng>
        <cfset distance = jsonDirections.routes[1].legs[1].distance.text>
		    <cfquery name="updateInvoice" datasource="BMNet">
				  update Invoice set
				  delivery_distance = <cfqueryparam cfsqltype="cf_sql_varchar" value="#distance#">,
				  delivery_latitude = <cfqueryparam cfsqltype="cf_sql_float" value="#deliveryLatitude#">,
				  delivery_longitude = <cfqueryparam cfsqltype="cf_sql_float" value="#deliveryLongitude#">
				  where id = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
			 </cfquery>
      </cfif>          
	  </cfloop>
	  </cfthread>
	  <cfset event.noRender()>
  </cffunction>
  
  <cffunction name="easyRecUpdate">
  	<cfargument name="event">
  	<cfsetting requesttimeout="9000000">
  	<cfthread action="run" name="easyrec" priority="LOW">
  	<cfquery name="invoices" datasource="BMNet">
      select 
			  Invoice.account_number,
			  Invoice.siteID, 
			  Invoice_Header.product_code, 
			  Products.Full_Description, 
			  Invoice.invoice_number, 
			  Invoice.invoice_date 
			FROM
			  Invoice_Header,
			  Invoice,
			  Products
			WHERE
			  Invoice_Header.siteID = 1 
			  AND
			  Invoice.invoice_number = Invoice_Header.invoice_num
			  AND
			  Products.Product_Code = Invoice_Header.product_code	  	
	  </cfquery>
	  <cfloop query="invoices">
	    <cfhttp port="8080" url="http://46.51.188.170/easyrec-web/api/1.0/buy?apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=bmnet_#siteID#&itemid=#product_code#&itemdescription=#Full_Description#&itemurl=#URLEncodedFormat('/mxtra/shop/product?productID=#product_code#')#&userid=#account_number#&sessionid=#invoice_number#_1&actiontime=#DateFormat(invoice_date,"DD_MM_YYYY")#_00_00_00&itemtype=ITEM"></cfhttp> 
	  </cfloop>
	  </cfthread>
	  <cfset event.noRender()>
  </cffunction>
  <cffunction name="test" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
    </cfscript>
    <cfset arguments.event.setLayout('Layout.Temp')>
    <cfset arguments.event.setView('temp')>
  </cffunction>
</cfcomponent>