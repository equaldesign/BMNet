
<cfcomponent output="false" autowire="true" cache="true">

	<!--- dependencies --->
	<cfproperty name="userService" inject="id:bv.userService">
	<cfproperty name="productService" inject="id:bv.ProductService">
  <cfproperty name="shoppingService" inject="id:bv.aws.shopping">
  <cfproperty name="documentService" inject="id:bv.DocumentService">
  <cfproperty name="RecommendationService" inject="id:bv.RecommendationService">
  <cfproperty name="ratingService" inject="id:bv.RatingService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="commentService" inject="id:bv.CommentService">
  <cfproperty name="AuditService" inject="id:bv.AuditService">
  <cfproperty name="paging" inject="coldbox:myPlugin:Paging">
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">
	<!--- preHandler --->

	<!--- index --->
	<cffunction cache="true" name="index" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.nodeRef = event.getValue("nodeRef","0");
			rc.paging = paging;
			rc.maxRows = event.getValue("maxrows","");
			rc.layout = event.getValue("layout","");
			if (NOT isDefined("request.buildingVine.maxRows")) {
				request.buildingVine.maxRows = 10;
        UserStorage.setVar("buildingVine",request.buildingVine);
			}
			if (NOT isDefined("request.buildingVine.layout")) {
        request.buildingVine.layout = "grid";
        UserStorage.setVar("buildingVine",request.buildingVine);
      }
			if ((rc.layout neq "" AND rc.layout neq request.buildingVine.layout)) {
        request.buildingVine.layout = rc.layout;
        UserStorage.setVar("buildingVine",request.buildingVine);
      }
      if ((rc.maxRows neq "" AND rc.maxRows neq request.buildingVine.maxRows)) {
        request.buildingVine.maxRows = rc.maxRows;
        UserStorage.setVar("buildingVine",request.buildingVine);
      }
      paging.setPagingMaxRows(request.buildingVine.maxRows);
      rc.boundaries = paging.getBoundaries();
      rc.products = productService.listProducts(nodeRef=rc.nodeRef,siteID=request.bvsiteID,startRow=rc.boundaries.startRow,maxrow=rc.boundaries.maxRow);
		  event.setView("web/products/grid");

		</cfscript>
	</cffunction>
  <cffunction cache="true" name="count" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
        rc.products = productService.productCount(request.bvsiteID);
        event.setView("products/count");

    </cfscript>
  </cffunction>
	<cffunction cache="true" name="productDetail" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.nodeRef = event.getValue("nodeRef","");
			rc.product = productService.productDetail(rc.nodeRef,request.bvsiteID);
      if (isUserInRole("admin_#request.bvsiteID#")) {
        rc.reach = RecommendationService.getViews(rc.nodeRef);
      }
			rc.parents = [];
			var index = ArrayLen(rc.product.detail.parents);
			while (index>0) {
				ArrayAppend(rc.parents,"###rc.product.detail.parents[index]#");
				index--;
			}
			//if (rc.buildingVine.latitude neq "") {
      //    rc.nearestStockists = siteService.getLocaStockists(request.bvsiteID,rc.buildingVine.latitude,rc.buildingVine.longitude);
      //}
			//rc.images = productService.image(rc.product.detail.eancode,paramValue("rc.product.detail.attributes.manufacturerproductcode",""),rc.product.detail.title);
			rc.amazonExists = false;
			if (isDefined("rc.product.amazon.mainProduct.ItemSearchResponse.Items.item")) {
			  if (ArrayLen(rc.product.amazon.mainProduct.ItemSearchResponse.Items.item) gte 1) {
			  	 rc.amazonExists = true;
			  	 rc.amazon = rc.product.amazon.mainProduct.ItemSearchResponse.Items.item[1];
			  	 rc.amazonRelated = rc.product.amazon.relatedProducts;
			  }
			}
			rc.rating = ratingService.getRating(rc.nodeRef);
			request.bvsiteID = rc.product.detail.site;
			rc.siteDB = siteService.siteDB(request.bvsiteID);
			rc.buildingVine.siteID = request.bvsiteID;
			event.setView("#rc.viewPath#/products/detail");
		</cfscript>
	</cffunction>
  <cffunction name="edit" returntype="void" output="false" cache="true">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.product = productService.productDetail(rc.nodeRef,request.bvsiteID)>
    <cfset event.setView("web/products/edit")>
  </cffunction>
  <cffunction name="importProducts" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset var ticket = request.user_ticket>
	  <cfset rc.documentRef = event.getValue("documentRef","")>
    <cfthread rc="#rc#" ticket="#ticket#" productService="#productService#" action="run" name="product#createUUID()#" priority="HIGH">
      <cfset attributes.productService.importProducts(attributes.ticket,attributes.rc,"supplier")>
     </cfthread>
    <!---<cfset rc.d = productService.importProducts(ticket,rc,"supplier")>--->
    <cfset event.setLayout('Layout.ajax')>
    <cfset event.setView('web/products/importDone')>
  </cffunction>

  <cffunction name="editlinks" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.productNode = event.getValue("nodeRef")>
    <cfset rc.links = productService.getLinks(rc.productNode)>
    <cfset event.setView("web/products/links")>
  </cffunction>

  <cffunction name="importCategories" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset var ticket = request.user_ticket>
    <cfset rc.targetSiteID = event.getValue("targetSiteID",request.bvsiteID)>
    <cfset rc.file = event.getValue("file","")>
    <cfif rc.file neq "">
      <cffile action="upload" filefield="file" destination="/tmp/#createUUID()#.xls" result="uploadedFile">
      <cfset rc.file = "/tmp/#uploadedFile.ServerFile#">
    </cfif>

    <cfthread rc="#rc#" ticket="#ticket#" productService="#productService#" action="run" name="product#createUUID()#" priority="HIGH">
      <cfset attributes.productService.importCategories(attributes.ticket,attributes.request.bvsiteID,attributes.rc.file)>
    </cfthread>


    <cfset event.setView('secure/products/importDone')>
  </cffunction>

  <cffunction name="recent" returntype="void" output="false" cache="true">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.boundaries = Paging.getBoundaries()>
	  <cfset rc.leftMenu = "site">
    <cfset rc.filterSite = event.getValue("filterSite","")>
    <cfset rc.products = productService.recentlyUpdated(startRow=rc.boundaries.startRow,maxrow=rc.boundaries.maxrow,siteID=rc.filterSite)>
    <cfif rc.filterSite neq "">
      <cfset event.setView("web/products/recentlyUpdatedSite")>
    <cfelse>
      <cfset event.setView("web/products/recentlyUpdated")>
    </cfif>
  </cffunction>

  <cffunction name="uploadSpreadsheet" returntype="void">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.file = event.getValue("file","")>
    <cfif rc.file neq "">
      <cffile action="upload" filefield="file" destination="#rc.app.appRoot#/cache/upload/#createUUID()#.xls" result="uploadedFile">
      <cfset rc.file = "#rc.app.appRoot#/cache/upload/#uploadedFile.ServerFile#">
      <cfspreadsheet action="read" src="#rc.file#" sheet="1" headerrow="1" query="sheet"></cfspreadsheet>
      <cfset rc.sheet = sheet>
      <cfset rc.pService = productService>
      <cfset event.setLayout("Layout.ajax")>
      <cfset event.setView("web/products/import/mapfields")>
    </cfif>
  </cffunction>

  <cffunction name="uploadPriceSpreadsheet" returntype="void">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.file = event.getValue("file","")>
    <cfif rc.file neq "">
      <cffile action="upload" filefield="file" destination="#rc.app.appRoot#/cache/upload/#createUUID()#.xls" result="uploadedFile">
      <cfset rc.file = "#rc.app.appRoot#/cache/upload/#uploadedFile.ServerFile#">
      <cfspreadsheet action="read" src="#rc.file#" sheet="1" headerrow="1" query="sheet"></cfspreadsheet>
      <cfset rc.sheet = sheet>
      <cfset rc.pService = productService>
      <cfset event.setLayout("Layout.ajax")>
      <cfset event.setView("web/products/price/mapfields")>
    </cfif>
  </cffunction>

  <cffunction name="importPrices" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("web/products/price/import")>
  </cffunction>

	<cffunction cache="true" name="search" returntype="void" output="false">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
			rc.query = event.getValue("query","");
			rc.boundaries = getMyPlugin(plugin="Paging").getBoundaries();
			rc.products = productService.productSearch(rc.query,request.bvsiteID,rc.boundaries.startRow,rc.boundaries.maxrow);
  		event.setView("web/products/searchResults");

		</cfscript>
	</cffunction>
  <cffunction name="review" access="public" returntype="void" output="false">
     <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.productID = event.getValue("productID","ewrw")>
    <cfset rc.jsoncallback = event.getValue("callback","")>
    <cfset rc.ticket = event.getValue("ticket","")>
    <cfset event.setLayout("Layout.ajax")>
    <cfset rc.retVar = {}>
    <cfset rc.error = false>
    <cfif getAuthUser() neq "" OR (rc.ticket neq "" AND rc.ticket neq "undefined")>
      <cfset event.setView("secure/products/review")>
    <cfelse>
      <cfset rc.retVar["loggedin"] = false>
      <cfset rc.target = "/products/writeReview?productID=#rc.productID#">
      <cfset event.setView("api/ratingLogin")>
    </cfif>
  </cffunction>
  <cffunction name="writeReview" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.productID = event.getValue("productID","ewrw")>
     <cfset event.setLayout("Layout.ajax")>
      <cfset event.setView("secure/products/writeReview")>
  </cffunction>
  <cffunction name="createReview" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.productID = event.getValue("productID","ewrw")>
    <cfset rc.title = event.getValue("title","")>
    <cfset rc.comment = event.getValue("comment","")>
    <cfset commentService.addComment("/node/#rc.productID#/comments",rc.title,rc.comment)>
    <cfset event.setLayout("Layout.ajax")>
    <cfset event.setView("secure/products/reviewComplete")>
  </cffunction>

  <cffunction name="imageupload" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset event.setView('secure/products/uploadImages')>
  </cffunction>

  <cffunction name="addprice" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.siteMembers = siteService.getMembership(request.bvsiteID)>
    <cfset event.setView("web/products/price/edit")>
  </cffunction>

  <cffunction name="doImageupload" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset var ticket = request.user_ticket>
    <cfif rc.file neq "">
      <cffile action="upload" filefield="file" destination="/tmp/#createUUID()#.xls" result="uploadedFile">
      <cfset rc.file = "/tmp/#uploadedFile.ServerFile#">
    </cfif>
    <cfset rc.targetSiteID = event.getValue("targetSiteID",request.bvsiteID)>
    <cfset rc.d = productService.importProductImages(ticket,rc.targetSiteID,rc.file)>
    <cfset event.setView('secure/products/importDone')>
  </cffunction>

  <cffunction name="upload" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.importStatus = SiteService.getImportStatus(request.bvsiteID)>

    <cfset event.setView("web/products/upload")>
  </cffunction>

  <cffunction name="az" cache="true" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.ASIN = event.getValue("id","")>
    <cfset rc.product = shoppingService.getItem(rc.ASIN,true)>
    <cfset request.bvsiteID = "buildingVine">
    <cfset rc.siteDB = siteService.siteDB(request.bvsiteID)>
    <cfset event.setView("#rc.viewPath#/products/amazon")>
  </cffunction>


  <cffunction name="categoriesUpload" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("secure/products/uploadCategories")>
  </cffunction>

  <cffunction name="addProduct" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.productImages = documentService.documentList(bc="Sites/#request.bvsiteID#/documentLibrary/Product Information/Product Images")>
    <cfset event.setView("secure/products/addProduct")>
  </cffunction>

  <cffunction name="editImage" returntype="void" output="false">
	  <cfargument name="event" required="true">
	  <cfset var rc = event.getCollection()>
	  <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.product = productService.productDetail(rc.nodeRef)>
    <cfset event.setView("web/products/images/edit")>
  </cffunction>
  <cffunction name="editDocuments" returntype="void" output="false" cache="true">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.product = productService.productDetail(rc.nodeRef)>
    <cfset event.setView("web/products/documents/edit")>
  </cffunction>

  <cffunction name="createLink" returntype="void" output="false" cache="true">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfset rc.documentNodeRef = event.getValue("nodeRef","")>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.type = event.getValue("type","")>
    <cfset rc.document = documentService.getAssociations("#rc.nodeRef#")>
    <cfset event.setView("web/products/#rc.type#/associate")>
  </cffunction>
  <cffunction name="importPrices2" returntype="void" output="false">
  	<cfargument name="event" required="true">
	  <cfset var rc = event.getCollection()>
    <cfset rc.sourceSiteID = event.getValue("sourceSiteID",request.bvsiteID)>
    <cfset rc.targetSiteID = event.getValue("targetSiteID",request.bvsiteID)>
    <cfset rc.columnRow = event.getValue("columnRow",1)>
    <cfset rc.sheetNumber = event.getValue("sheetNumber",1)>
    <cfset rc.file = event.getValue("file","")>
    <cfif rc.file neq "">
      <cffile action="upload" filefield="file" destination="/tmp/#createUUID()#.xls" result="uploadedFile">
      <cfset rc.file = "/tmp/#uploadedFile.ServerFile#">
      <cfspreadsheet src="/tmp/#uploadedFile.ServerFile#" action="read" headerrow="#rc.columnRow#" sheet="#rc.sheetNumber#" query="tmp"></cfspreadsheet>
      <cfset rc.sheet = tmp>
    </cfif>
    <cfset event.setView('secure/tools/priceImport2')>
  </cffunction>

  <cffunction name="setLayout" returntype="void" output="false">
	<cfargument name="event" required="true">
	<cfset var rc = event.getCollection()>
	<cfset layout = event.getValue("layout","standard")>
  <cfset CookieStorage.setVar("productLayout",layout,365)>
  <cfset UserStorage.setVar("productLayout",layout)>
  <cfif layout eq "standard">
    <cfset rc.buildingVine.paging.setPagingMaxRows(10)>
  <cfelseif layout eq "grid">
    <cfset rc.buildingVine.paging.setPagingMaxRows(20)>
  <cfelse>
    <cfset rc.buildingVine.paging.setPagingMaxRows(50)>
  </cfif>
  <cfset event.setView("blank")>
</cffunction>

  <cffunction name="doImportPrices" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
     <cfset var ticket = request.user_ticket>
    <cfset rc.prices = populateModel("PriceService")>
	  <cfthread rc="#rc#" ticket="#ticket#" action="run" name="product#createUUID()#" priority="HIGH" email="#getAuthUser()#">
      <cfset attributes.rc.prices.importPrices(attributes.ticket,attributes.email)>
    </cfthread>
    <cfset event.setLayout("Layout.ajax")>
    <cfset event.setView('web/products/price/done')>
  </cffunction>

  <cffunction name="tree" returntype="void" output="false">
    <cfargument name="event">
    <cfscript>
      var rc = event.getCollection();
      rc.nodeRef = event.getValue("nodeRef","");
      rc.categories = productService.categoryList(rc.nodeRef,request.bvsiteID);
    </cfscript>
    <cfset listItems = ArrayNew(1)>
    <cfloop array="#rc.categories#" index="item">
      <cfset x = StructNew()>
        <cfset x["data"]["title"] = "#left(item.name,30)#">
        <cfset x["attr"]["id"] = "#item.nodeRef#">
        <cfset x["data"]["attr"]["id"] = "#item.nodeRef#">
        <cfset x["data"]["attr"]["class"] = "ajax">
        <cfif item.children eq 0>
          <cfset x["data"]["attr"]["href"] = "/products?nodeRef=#item.nodeRef#">
          <cfset x["data"]["icon"] = "product">
        <cfelse>
          <cfset x["state"] = "closed">
          <cfset x["attr"]["class"] = "jstree-drop">
          <cfset x["data"]["attr"]["href"] = "/products?nodeRef=#item.nodeRef#">
        </cfif>
        <cfset arrayAppend(listItems,x)>
    </cfloop>
    <cfset rc.json = SerializeJSON(listItems)>
    <cfset event.setView("renderJSON")>
  </cffunction>

  <cffunction name="brochurebuilder"  returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("#rc.viewpath#products/brochure/start")>
  </cffunction>
  <cffunction name="brochureDo"  returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.title = event.getValue("title","Funky Brochure!")>
    <cfset rc.style = event.getValue("style","standard")>
    <cfset rc.introduction = event.getValue("introduction","Lorem ipsum!")>
    <cfset rc.name = event.getValue("name","Tom Miller")>
    <cfset rc.email = event.getValue("email","tom.miller@ebiz.co.uk")>
    <cfset rc.subject = event.getValue("subject","check out me massive piece!")>

    <!--- now lets build it! --->
    <cfset rc.products = productService>
    <cfset rc.documents = DocumentService>
    <cfset rc.categoryList = rc.products.listAllCategories(request.bvsiteID)>
    <cfset event.setView(view="#rc.viewpath#products/brochure/build",noLayout=true)>
  </cffunction>


  <cffunction name="download" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.dateFrom = event.getValue("dateFrom","")>
    <cfset productService.download(rc.dateFrom)>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="feed" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.recent = event.getValue("recent","")>
    <cfset rc.format = event.getValue("format","JSON")>
    <cfset products = productService.getFeed(rc.recent,rc.format)>
    <cfset event.renderData(data=products,type="#rc.format#")>
  </cffunction>
</cfcomponent>