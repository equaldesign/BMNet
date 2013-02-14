<cfcomponent output="false" cache="true">

<!------------------------------------------- GLOBAL IMPLICIT EVENTS ONLY ------------------------------------------>
<!--- In order for these events to fire, you must declare them in the coldbox.xml.cfm --->
  <cfproperty name="category" inject="model:bmnet.modules.mxtra.model.category" scope="instance" />
  <cfproperty name="product" inject="id:eunify.ProductService" scope="instance" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:cookiestorage" />
  <cfproperty name="Paging" inject="coldbox:myPlugin:Paging">

  <cffunction name="index" returntype="any" output="true">
  	<cfargument name="event" required="true">
    <cfargument name="inlineRender" required="false" default="false">
  	<cfset var rc = event.getCollection()>

    <cfswitch expression="#rc.viewMode#">
      <cfcase value="list">
        <cfset rc.maxRows = 5>
      </cfcase>
      <cfcase value="grid">
        <cfset rc.maxRows = 25>
      </cfcase>
      <cfcase value="table">
        <cfset rc.maxRows = 50>
      </cfcase>
    </cfswitch>

  	<cfset rc.pageID = 0>
  	<cfset rc.pageName = "Shop Online">
  	<cfset rc.showLinks=  false>
    <cfif rc.slug neq "">
		  <cfset rc.categoryID = instance.product.getCategoryBySlug(rc.slug)>
	  </cfif>
	  <cfset rc.filterOptions = instance.product.getProductRanges(ArrayToList(instance.product.categoryTraverse(rc.categoryID)))>
  	<cfset rc.categoryName = instance.category.getCategoryName(rc.categoryID,request.siteID)>
  	<cfset rc.paging = Paging>
  	<cfset rc.metaData = instance.product.getProductMeta(rc.categoryID,"category","tabData")>
    <cfset rc.landingData = instance.product.getProductMeta(rc.categoryID,"category","landing")>
    <cfset rc.boundaries = Paging.getBoundaries(rc.itemsPerPage)>
    <cfset rc.category = instance.product>
    <cfset rc.categoryDetails = instance.product.getCategory(rc.categoryID,request.siteID)>
  	<cfset rc.parentID = instance.category.getParentCategory(rc.categoryID,request.siteID).id>
	  <cfset rc.categories = instance.product.categoryList(rc.categoryID)>
    <cfif rc.categories.recordCount eq 0>
     <cfset rc.leftCategories = instance.product.categoryList(rc.categoryDetails.parentID)>
    <cfelse>
      <cfset rc.leftCategories = rc.categories>
    </cfif>
  	<cfset rc.products = instance.product.getProducts(rc.categoryID,rc.boundaries.startRow,rc.boundaries.maxrow-rc.boundaries.startRow,request.siteID,false)>
  	<cfset rc.productCount = instance.product.getProductCount(rc.categoryID,request.siteID)>
  	<cfset rc.product = instance.product>
  	<cfif arguments.inlineRender>
    	<cfreturn renderView(view="shop/product/styles/grid",module="mxtra")>
  	<cfelse>
    	<cfset event.setView("shop/product/index")>
  	</cfif>
  </cffunction>

  <cffunction name="landing">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfhttp port="8080" url="http://46.51.188.170:8080/alfresco/service/slingshot/doclib/doclist/files/site/#request.bvsiteID#/web/media/landingimages/#rc.categoryID#?alf_ticket=#request.buildingVine.admin_ticket#" result="documentList"></cfhttp>
    <cfreturn documentList.fileContent>
  </cffunction>
	</cfcomponent>