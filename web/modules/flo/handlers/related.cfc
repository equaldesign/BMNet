<cfcomponent output="false"  cache="true">

  <cfproperty name="tasks" inject="id:flo.TaskService">
  <cfproperty name="relationship" inject="id:flo.RelationshipService">
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="psa" inject="id:eunify.PSAService" />
  <cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="products" inject="id:eunify.ProductService" />

  <cffunction name="index" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.system = event.getValue("system","BMNet")>
    <cfset event.setView(view="index")>
  </cffunction>

  <cffunction name="search" cache="true" returntype="void" output="false" hint="My main event">
      <cfargument name="event">

      <cfscript>
        var rc = arguments.event.getCollection();
        var resultA = ArrayNew(1);
        var resultJ = StructNew();
        rc.q = arguments.event.getValue('term',now());
        rc.customers = company.list(searchQuery=rc.q,typeID=1,siteID=request.siteID);
        rc.contacts = contact.list(searchQuery=rc.q,siteID=request.siteID);
        rc.suppliers = company.list(searchQuery=rc.q,typeID=2,siteID=request.siteID);
        rc.products = products.list(searchQuery=rc.q,siteID=request.siteID);
      </cfscript>
      <cfloop query="rc.customers">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#name#">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "/eunify/company/detail/id/#id#">
        <cfset resultJ["category"] = "customer">
        <cfset resultJ["iconclass"] = "customer">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.contacts">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#first_name# #surname#">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "/eunify/contact/index/id/#id#">
        <cfset resultJ["category"] = "contact">
        <cfset resultJ["iconclass"] = "contact">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.suppliers">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#name#">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "/eunify/company/detail/id/#id#">
        <cfset resultJ["category"] = "supplier">
        <cfset resultJ["iconclass"] = "supplier">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.products">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#full_description#">
        <cfset resultJ["id"] = "#product_code#">
        <cfset resultJ["url"] = "/eunify/products/detail/id/#product_code#">
        <cfset resultJ["category"] = "product">
        <cfset resultJ["iconclass"] = "product">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
    <cfset arguments.event.renderData(data=resultA,type="json")>
    </cffunction>

</cfcomponent>