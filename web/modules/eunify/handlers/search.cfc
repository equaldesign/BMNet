<cfcomponent name="searchHandler" cache="false" cacheTimeout="30" output="false">
	<!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
	<!--- Default Action --->
	<cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="tag" inject="id:eunify.TagService" />
	<cfproperty name="psa" inject="id:eunify.PSAService" />
	<cfproperty name="contact" inject="id:eunify.ContactService" />
  <cfproperty name="products" inject="id:eunify.ProductService" />
  <cfproperty name="ecompany" inject="id:eGroup.company" />
  <cfproperty name="epsa" inject="id:eGroup.psa" />
  <cfproperty name="etag" inject="id:eGroup.tag" />
  <cfproperty name="econtact" inject="id:eGroup.contact" />
  <cfproperty name="eblog" inject="id:eGroup.blog" />


			<cffunction name="index" cache="true" returntype="void" output="false" hint="My main event">
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
        // rc.edeals = epsa.search(rc.q);
        // rc.econtacts = econtact.search(rc.q);
        // rc.eblog = eblog.search(rc.q);
        // rc.ecompanies = ecompany.search(rc.q);
			</cfscript>
      <cfloop query="rc.customers">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#name#">
        <cfset resultJ["system"]= "BMNet">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "/eunify/company/detail/id/#id#">
        <cfset resultJ["category"] = "customer">
        <cfset resultJ["iconclass"] = "customer">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.contacts">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#first_name# #surname#">
        <cfset resultJ["system"]= "BMNet">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "/eunify/contact/index/id/#id#">
        <cfset resultJ["category"] = "contact">
        <cfset resultJ["iconclass"] = "contact">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.suppliers">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#name#">
        <cfset resultJ["system"]= "BMNet">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "/eunify/company/detail/id/#id#">
        <cfset resultJ["category"] = "supplier">
        <cfset resultJ["iconclass"] = "supplier">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.products">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#full_description#">
        <cfset resultJ["system"]= "BMNet">
        <cfset resultJ["id"] = "#product_code#">
        <cfset resultJ["url"] = "/eunify/products/detail/id/#product_code#">
        <cfset resultJ["category"] = "product">
        <cfset resultJ["iconclass"] = "product">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <!---
      <cfloop query="rc.edeals">
        <cfset resultJ = StructNew()>
        <cfif internalReference neq "">
          <cfset resultJ["label"]= "#DateFormat(period_from,'YYYY')#-#internalReference# #name# (#known_as#)">
          <cfelse>
          <cfset resultJ["label"]= "#DateFormat(period_from,'YYYY')#-#id# #name# (#known_as#)">
        </cfif>
        <cfset resultJ["system"]= "eGroup">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "#arguments.event.buildLink(linkTo='eGroup.psa.index',queryString='psaid=#id#')#">
        <cfset resultJ["category"] = "agreements">
        <cfif DateCompare(period_to,now(),"d") lt 0 OR DateCompare(period_from,now(),"d") gt 0>
          <cfset resultJ["iconclass"] = "expiredagreements">
          <cfelse>
          <cfset resultJ["iconclass"] = "agreements">
        </cfif>
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.ecompanies">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#known_as#">
        <cfset resultJ["system"]= "eGroup">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["url"] = "#arguments.event.buildLink(linkTo='eGroup.company.index',queryString='id=#id#')#">
        <cfset resultJ["category"] = "company">
        <cfset resultJ["iconclass"] = "company">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.econtacts">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#first_name# #surname# (#known_as#)">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["system"]= "eGroup">
        <cfset resultJ["url"] = "#arguments.event.buildLink(linkTo='eGroup.contact.index',queryString='id=#id#')#">
        <cfset resultJ["category"] = "contact">
        <cfset resultJ["iconclass"] = "contact">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      <cfloop query="rc.eblog">
        <cfset resultJ = StructNew()>
        <cfset resultJ["label"]= "#dateFormat(date,'DD MMM YY')# #title#">
        <cfset resultJ["id"] = "#id#">
        <cfset resultJ["system"]= "eGroup">
        <cfset resultJ["url"] = "#arguments.event.buildLink(linkTo='eGroup.blog.view',queryString='id/#id#')#">
        <cfset resultJ["category"] = "blog">
        <cfset resultJ["iconclass"] = "news">
        <cfset ArrayAppend(resultA,resultJ)>
      </cfloop>
      --->
			<cfset arguments.event.renderData(data=resultA,type="json")>
		</cffunction>



  <cffunction name="advanced" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset arguments.event.setLayout('Layout.Main')>
    <cfset arguments.event.setView('search/advanced')>

  </cffunction>

  <cffunction name="agreements" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfscript>
      rc.searchArguments = {};
      rc.searchArguments.keywords = arguments.event.getValue("keywords","");
      rc.searchArguments.period_from = arguments.event.getValue("period_from","");
      rc.searchArguments.period_from_operator = arguments.event.getValue("period_from_operator","");
      rc.searchArguments.period_to = arguments.event.getValue("period_to","");
      rc.searchArguments.period_to_operator = arguments.event.getValue("period_to_operator","");
      rc.searchArguments.dealType = arguments.event.getValue("dealType","");
      rc.searchArguments.status = arguments.event.getValue("status","");
      rc.searchArguments.negotiator = arguments.event.getValue("negotiator","");
      rc.searchArguments.negotiatorCompany = arguments.event.getValue("negotiatorCompany","");
      rc.searchArguments.figuresStatus = arguments.event.getValue("figuresStatus","");
      if (rc.searchArguments.figuresStatus neq "") {
        rc.searchArguments.figuresStatus = DateAdd("m",rc.searchArguments.figuresStatus,now());
        rc.searchArguments.figuresStatus = createDate(year(rc.searchArguments.figuresStatus),month(rc.searchArguments.figuresStatus),1);
      }
      rc.searchArguments.figuresType = arguments.event.getValue("figuresType","");
      rc.results = psa.advancedSearch(rc.searchArguments);
    </cfscript>
    <cfset arguments.event.setLayout('Layout.Main')>
      <cfset arguments.event.setView('search/results/agreements')>
  </cffunction>
	<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>

  <cffunction name="tags" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset var resultA = ArrayNew(1)>
    <cfset rc.q = arguments.event.getValue('term',now())>
    <cfset rc.tags = tag.search(rc.q)>
    <cfloop query="rc.tags">
      <cfset resultJ = StructNew()>
      <cfset resultJ["id"]= "#tag#">
      <cfset resultJ["label"]= "#tag#">
      <cfset ArrayAppend(resultA,resultJ)>
    </cfloop>
    <cfset event.renderData(data=resultA,type="JSON")>
  </cffunction>
</cfcomponent>

