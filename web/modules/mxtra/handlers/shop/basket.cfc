<cfcomponent output="false"  cache="true">

<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
<cfproperty name="basket" inject="id:mxtra.basket" />
<cfproperty name="orders" inject="id:mxtra.orders" scope="instance" />
<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
<cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />

<!---
<cfproperty name="eGroupLookup" inject="id:mxtra.eGroupLookup" scope="instance" />
--->
<cfproperty name="logger" inject="logbox:root" />
<cfproperty name="product" inject="id:eunify.ProductService" />


<cffunction name="add" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.quantity = event.getValue('quantity',1)>
  <cfset rc.delivered = basket.isDelivered()>
  <cfset rc.productID = event.getValue('productID',0)>
  <cfset rc.branchID = event.getValue("collectionBranch",0)>
  <cfset rc.product = product.getProduct(productID,request.siteID)>

  <cfif NOT rc.product.collectable>
  	<!--- they can't collect it, so just shove it in the basket --->
	  <cfset basket.add(rc.productID,rc.quantity,true,0,request.siteID)>
  <cfelse>
		  <cfset basket.add(rc.productID,rc.quantity,false,rc.branchID,request.siteID)>
  </cfif>
  <cfset rc.refURL = event.getValue('refURL','')>
  <cfset event.setView("shop/basket/preAdd")>
</cffunction>

<cffunction name="index" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.refURL = event.getValue('refURL','/mxtra/shop/category?categoryID=0')>
  <cfset rc.basket = basket.getBasket()>
  <cfset rc.basketTotal = basket.getTotalPrice()>
  <cfset event.setView("shop/basket/index")>
</cffunction>
<cffunction name="overview" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.basket = basket.getBasket()>
  <cfset event.setView("shop/basket_overview")>
</cffunction>
<cffunction name="update" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.product_code = event.getValue("product_code","")>
  <cfset rc.quantity = event.getValue("quantity",0)>
  <cfset rc.refURL = event.getValue('refURL','/mxtra/shop/basket')>
  <cfset rc.basket = basket.getBasket()>
  <cfset basket.updateQuantity(rc.basket.id,rc.product_code,rc.quantity)>
  <cfif rc.basket.recordCount eq 0>
    <cfset CookieStorage.deleteVar("basketID")>
  </cfif>
  <cfset setNextEvent(uri="#rc.refURL#")>
</cffunction>


<cffunction name="enterpostcode" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset event.setView("shop/basket/enterpostcode")>
</cffunction>

<cffunction name="setpostcode" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  
  <cfset rc.deliverypostCode = event.getValue("postcode","")>
  <cfset rc.bvsiteID = event.getValue("bvsiteID","")>
  <cfhttp result="pcRequestResult" url="http://maps.google.com/maps/geo?q=#rc.deliverypostCode#&output=csv">
  <cfset coOrds = ListToArray(pcRequestResult.fileContent)>
  <cfif (coOrds[1] eq "200") >
    <cfset request.geoInfo = {}>
    <cfset request.geoInfo.zipcode = rc.deliverypostcode>
    <cfset request.geoInfo.longitude = coOrds[3]>
    <cfset request.geoInfo.latitude = coOrds[4]>
    <cfset UserStorage.setVar("geoInfo",request.geoInfo)>
  </cfif>
  <cfif CookieStorage.getVar("basket","") eq "">
    <cfset request.mxtra.basket.ID = createUUID()>
    <cfset CookieStorage.setVar("basketID",request.mxtra.basket.ID)>
    <cfset UserStorage.setVar("mxtra",request.mxtra)>
  </cfif>
  <!--- <cfset rc.branches = instance.eGroupLookup.getBranches(rc.bvsiteID,thisBasket.deliveryCoOrdinates)> --->
  <cfset setNextEvent(uri="/")>
</cffunction>

	</cfcomponent>