
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <cfproperty name="productService" inject="id:bv.ProductService">
  <cfproperty name="stockistService" inject="id:bv.StockistService">
  <cfproperty name="amazonService" inject="id:bv.aws.shopping">
  <cfproperty name="documentService" inject="id:bv.DocumentService">
  <cfproperty name="wikiService" inject="id:bv.WikiService">
  <cfproperty name="searchService" inject="id:bv.SearchService">
  <cfproperty name="siteService" inject="id:bv.SiteService"> 
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">

  <!--- preHandler --->
 
  <!--- index --->
  <cffunction name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.query = event.getValue("query","test");      
      rc.boundaries = rc.paging.getBoundaries();
      rc.products = productService.productSearch(rc.query,rc.siteID,rc.boundaries.startRow,rc.boundaries.maxrow);
      rc.resultCount = rc.products.resultCount;
      if (isDefined("rc.format")) {
        if (rc.format eq "json") {
          if (rc.resultCount eq 0) {
            rc.products = amazonService.amazonSearch(rc.query,rc.page);
            event.renderData(data=xmlToJson(rc.products.ItemSearchResponse.items),type="PLAIN");
          } else {
            event.renderData(data=rc.products,type="JSON");
          }

        }
      } else {
        if (rc.resultCount eq 0) {
          setNextEvent(uri="/search/az?query=#rc.query#");
        }
        event.setView("web/search/results");
      }

    </cfscript>
  </cffunction>

  <cffunction name="stockist" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();      
      rc.postcode = event.getValue("postcode","");
      rc.stockists = stockistService.search(request.bvsiteID,rc.postcode);
      event.setView("web/search/stockists");      
    </cfscript>
  </cffunction>

  <cffunction name="az" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.query = event.getValue("query","test");
      rc.boundaries = rc.paging.getBoundaries();
      rc.products = amazonService.amazonSearch(rc.query,rc.page);
      rc.resultCount = rc.products.ItemSearchResponse.Items.TotalResults.xmlText;
      event.setView("web/search/amazon");

    </cfscript>
  </cffunction>

  <cffunction name="products" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      UserStorage.setVar("defaultSearch","products");
      CookieStorage.setVar("defaultSearch","products",365);      
      rc.query = event.getValue("query","test");
      rc.boundaries = rc.paging.getBoundaries();
      rc.products = productService.productSearch(rc.query,"",rc.boundaries.startRow,rc.boundaries.maxrow);
      rc.resultCount = rc.products.resultCount;
      event.setView("web/search/results");

    </cfscript>
  </cffunction>

  <cffunction name="wiki" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.query = event.getValue("query","test");
      rc.pages = wikiService.search(rc.query);

      event.setView("web/search/wiki");

    </cfscript>
  </cffunction>
<cffunction name="documents" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      UserStorage.setVar("defaultSearch","documents");
      CookieStorage.setVar("defaultSearch","documents",365);
      rc.query = event.getValue("query","test");
      rc.boundaries = rc.paging.getBoundaries();
      rc.documents = documentService.search(rc.query);
      rc.resultCount = rc.documents.resultCount;
      event.setView("web/search/documents");

    </cfscript>
  </cffunction>
<cffunction name="company" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.query = event.getValue("query","test");
      UserStorage.setVar("defaultSearch","company");
      CookieStorage.setVar("defaultSearch","company",365);
      rc.boundaries = getMyPlugin(plugin="Paging").getBoundaries();
      rc.companies = searchService.company(rc.query,rc.siteID);
      rc.resultCount = rc.companies.resultCount;
      event.setView("web/search/companies");

    </cfscript>
  </cffunction>

  <cffunction name="people" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.query = event.getValue("query","test");
      UserStorage.setVar("defaultSearch","people");
      CookieStorage.setVar("defaultSearch","people",365);
      rc.boundaries = getMyPlugin(plugin="Paging").getBoundaries();
      rc.contacts = searchService.contact(rc.query,rc.siteID);
      rc.resultCount = rc.contacts.resultCount;
      event.setView("web/search/contacts");

    </cfscript>
  </cffunction>
</cfcomponent>