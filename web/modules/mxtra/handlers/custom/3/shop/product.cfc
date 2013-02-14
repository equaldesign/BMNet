<cfcomponent output="false"  cache="true">

<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
  <cfproperty name="category" inject="id:mxtra.category" scope="instance" />
  <cfproperty name="product" inject="id:eunify.ProductService" scope="instance" />
  <cfproperty name="recommendationService" inject="id:eunify.RecommendationService" scope="instance" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />
  <cfproperty name="Paging" inject="coldbox:myPlugin:Paging">
    
<cffunction name="index" returntype="void" output="true">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.pageID = 0>
  <cfset rc.pageName = "Shop Online">  
  <cfset rc.product = instance.product.getProduct(rc.productID,request.siteID)>
  <cfdump var="#rc.product#">
  <cfset rc.recommendations = instance.recommendationService.getProductRecommendations(rc.productID,request.siteID)>
  <cfset rc.categoryID = rc.product.categoryID>
  <cfset event.setView("shop/product/detail")>
</cffunction>

<cffunction name="search" returntype="void" output="true">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.q = event.getValue("q","")>
  
  <cfset rc.paging = Paging>
  <cfset rc.maxRows = 10>  
  <cfset rc.boundaries = Paging.getBoundaries(rc.itemsPerPage)>
  <cfset rc.productCount = instance.product.list(1,50000,3,"asc",rc.q).recordCount>
  <cfset rc.products = instance.product.list(rc.boundaries.startRow,rc.boundaries.maxrow-rc.boundaries.startRow,3,"asc",rc.q)>    
  <cfset event.setView("shop/product/searchResults")>
</cffunction>

<cffunction name="specials" returntype="void" output="false">
  <cfargument name="event" required="true">

  <cfset var rc = event.getCollection()>
  <cfset rc.viewMode = event.getValue("viewMode",CookieStorage.getVar("viewMode","list"))>
  <cfset rc.pageID = 0>
  <cfset rc.maxRows = 5>
  <cfset rc.categoryID = event.getValue('categoryID',0)>
  <cfset rc.type = event.getValue("type","S")>
  <cfset rc.sPage = event.getValue('sPage',1)>
  <cfset rc.Query = event.getValue('query',"")>
  <cfset rc.fPage = event.getValue('fPage',1)>
  <cfset rc.sRow = rc.sPage*rc.maxRows-(rc.maxRows-1)>
  <cfset rc.currentPage = rc.sPage>
<cfset rc.parentID = 0>
  <cfset rc.pageName = "Shop Online">
  <cfset rc.product = instance.product>
  <cfset rc.products = instance.product.getSpecials()>
  <cfset rc.productCount = rc.products.recordCount>
  <cfset rc.orderDir = event.getValue('orderDir',CookieStorage.getVar("mxtra_orderDir","asc"))>
    <cfif rc.orderDir neq CookieStorage.getVar("mxtra_orderDir","asc")>
     <cfset CookieStorage.setVar("mxtra_orderDir",rc.orderDir)>
    </cfif>
  <cfset rc.pages = ceiling(rc.productCount/rc.maxRows)>
  <cfset rc.categoryName = "Special Offers">
  <cfset event.setView("shop/product/index")>
</cffunction>
<cffunction name="clearance" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfset rc.viewMode = event.getValue("viewMode",CookieStorage.getVar("viewMode","list"))>
  <cfset rc.pageID = 0>
  <cfset rc.maxRows = 50>
  <cfset rc.categoryID = event.getValue('categoryID',0)>
  <cfset rc.sPage = event.getValue('sPage',1)>
  <cfset rc.Query = event.getValue('query',"")>
  <cfset rc.fPage = event.getValue('fPage',1)>
  <cfset rc.sRow = rc.sPage*rc.maxRows-(rc.maxRows-1)>
  <cfset rc.currentPage = rc.sPage>
  <cfset rc.pageName = "Shop Online">
  <cfset rc.product = instance.product>
  <cfset rc.parentID = 0>
  <cfset rc.orderDir = event.getValue('orderDir',CookieStorage.getVar("mxtra_orderDir","asc"))>
    <cfif rc.orderDir neq CookieStorage.getVar("mxtra_orderDir","asc")>
     <cfset CookieStorage.setVar("mxtra_orderDir",rc.orderDir)>
    </cfif>
  <cfset rc.products = instance.product.getClearance()>
  <cfset rc.productCount = rc.products.recordCount>
  <cfset rc.pages = ceiling(rc.productCount/rc.maxRows)>
  <cfset rc.categoryName = "Clearance">
  <cfset event.setView("shop/product/index")>
</cffunction>
<cffunction name="dataDump" returntype="void" output="false">
  <cfargument name="event" required="true">
  <cfset var rc = event.getCollection()>
  <cfsetting requesttimeout="9000">
  <cfset event.setLayout('Layout.ajax')>
  <cfset event.setView('importScripts/#rc.sess.siteID#/import')>
</cffunction>

<cfscript>
function getAWord(list) {
  var maxLen = ArrayLen(list);
  var word = list[RandRange(1,maxLen)];
  if (len(word) lte 8) {
    return word;
  } else {
    return getAWord(list);
  }
}
function MakeNicePassword(list) {
  var firstWord = getAWord(list);
  var secondWord = getAWord(list);
  firstWord = ReReplace(firstWord,"[^a-zA-Z]","","ALL");
  secondWord = ReReplace(secondWord,"[^a-zA-Z]","","ALL");
  return "#LCASE(firstWord)##LCASE(secondWord)#";
}
function MakePassword()
{
var valid_password = 0;
var loopindex = 0;
var this_char = "";
var seed = "";
var new_password = "";
var new_password_seed = "";
while (valid_password eq 0){
new_password = "";
new_password_seed = CreateUUID();
for(loopindex=20; loopindex LT 35; loopindex = loopindex + 2){
this_char = inputbasen(mid(new_password_seed, loopindex,2),16);
seed = int(inputbasen(mid(new_password_seed,loopindex/2-9,1),16) mod 3)+1;
switch(seed){
case "1": {
new_password = new_password & chr(int((this_char mod 9) + 48));
break;
}
    case "2": {
new_password = new_password & chr(int((this_char mod 26) + 65));
break;
}
case "3": {
new_password = new_password & chr(int((this_char mod 26) + 97));
break;
}
} //end switch
}
valid_password = iif(refind("(O|o|0|i|l|1|I|5|S)",new_password) gt 0,0,1);
}
return new_password;
}
</cfscript>

	</cfcomponent>