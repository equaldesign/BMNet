<cfcomponent accessors="true" output="true" hint="The bvine module service layer" cache="true">

  <cfproperty name="eancode">
  <cfproperty name="productactive">
  <cfproperty name="productcode">
  <cfproperty name="manufacturerproductcode">
  <cfproperty name="supplierproductcode">
  <cfproperty name="productdescription">
  <cfproperty name="rrp">
  <cfproperty name="unitweight">
  <cfproperty name="manufacturerbrandname">
  <cfproperty name="packagingpaper">
  <cfproperty name="packagingwood">
  <cfproperty name="packagingglass">
  <cfproperty name="packagingsteel">
  <cfproperty name="packagingplastic">
  <cfproperty name="imageurl">
  <cfproperty name="thumbnailurl">
  <cfproperty name="coshhurl">
  <cfproperty name="specificationurl">
  <cfproperty name="autosearch">
  <cfproperty name="official">

	<!--- Dependencies --->

  <cfproperty name="userService" inject="model:UserService"  scope="instance" />
  <cfproperty name="shoppingService" inject="model:aws.shopping" />
  <cfproperty name="templateCache" inject="cachebox:template" />
  <cfproperty name="beanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="jsonChecker" inject="coldbox:myPlugin:jsonChecker" /> 
  <!---<cfproperty name="simpleDB" inject="model:aws.db"  scope="instance" /> --->
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" scope="instance" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" scope="instance" />
  <cfproperty name="logger" inject="logbox:root">
	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>

  <cffunction name="getFeed" returntype="any">
    <cfargument name="recent" required="true" default="">
    <cfargument name="format" required="true" default="json">
    <cfif arguments.recent eq "">
      <cfreturn getFullList(arguments.format).products>
    <cfelse>
      <cfreturn recentlyUpdated(siteID=request.bvSiteID,format=arguments.format).results>      
    </cfif>
  </cffunction>

  <cffunction name="download" returntype="void">
    <cfargument name="dateFrom" required="true" default="">
    <cfif arguments.dateFrom eq "">
      <cfset var products = getFullList().products>
    <cfelse>
      <cfset var products = recentlyUpdated(siteID=request.bvSiteID).results>      
    </cfif>
    <cfset var appRoot = instance.ApplicationStorage.getVar("appRoot")>
    <cfspreadsheet action="read" src="#appRoot#web/includes/ssheets/Master.xls" name="master"></cfspreadsheet>
    <cfset i = 2>
    <cfloop array="#products#" index="product">
      <cfif isDefined('product.eancode')>
        <cfset SpreadsheetSetCellValue(master,replaceWhiteSpace(product.eancode),i,2)>
      </cfif>
      <cfif isDefined('product.attributes.supplierproductcode')>
        <cfset SpreadsheetSetCellValue(master,trim(product.attributes.supplierproductcode),i,3)>
      </cfif>
      <cfif isDefined('product.attributes.manufacturerproductcode')>
        <cfset SpreadsheetSetCellValue(master,trim(product.attributes.manufacturerproductcode),i,4)>
      </cfif>
      <cfif isDefined('product.attributes.productdescription') AND product.attributes.productdescription neq "">
        <cfset SpreadsheetSetCellValue(master,trim(product.attributes.productdescription),i,6)>
      </cfif>
      <cfif isDefined("product.title")>
        <cfset SpreadsheetSetCellValue(master,trim(product.title),i,5)>
      </cfif>
      <cfif isDefined('product.attributes.rrp')>
        <cfset SpreadsheetSetCellValue(master,trim(product.attributes.rrp),i,8)>
      </cfif>
      <cfif isDefined('product.attributes.unitweight')>
        <cfset SpreadsheetSetCellValue(master,trim(product.attributes.unitweight),i,9)>
      </cfif>
      <cfif isDefined('product.attributes.manufacturerbrandname')>
        <cfset SpreadsheetSetCellValue(master,trim(product.attributes.manufacturerbrandname),i,10)>
      </cfif>
      <cfif arrayLen(product.productImage) gte 1>
        <cfset SpreadsheetSetCellValue(master,"https://46.51.188.170/alfresco#product.productImage[1].downloadUrl#",i,11)>
      </cfif>
      <cfif arrayLen(product.productImage) gte 1>
        <cfset SpreadsheetSetCellValue(master,"https://46.51.188.170/alfresco/service/#product.productImage[1].thumbnailUrl#",i,12)>
      </cfif>

      <cfif arrayLen(product.productDocuments) gte 1>
        <cftry>
        <cfset SpreadsheetSetCellValue(master,"https://46.51.188.170/alfresco#product.productDocuments[1].downloadUrl#",i,13)>
        <cfcatch type="any"></cfcatch>
        </cftry>
      </cfif>

      <!--- now lets add the prices :) --->
      <cfif ArrayLen(product.prices) gte 1>
        <!--- <cfset priceArray = arrayOfStructsSort(product.prices,"merchantinvoiceprice","desc","numeric","~")> --->
        <cfset priceArray = product.prices>
        <cfset found = false>
        <cfloop array="#priceArray#" index="price">
          <cfif NOT isDefined('price.priceeffectivefromdate')>
            <cfset found = true>
          <cfelse>
            <cfif DateCompare(price.priceeffectivefromdate,now(),"d") lte 0>
              <cfset found = true>
            </cfif>
          </cfif>
          <cfif found>
            <cfif isDefined("price.priceunitofmeasuredescription")>
              <cfset SpreadsheetSetCellValue(master,price.priceunitofmeasuredescription,i,14)>
            </cfif>
            <cfif isDefined("price.priceunitofmeasurequantity")>
              <cfset SpreadsheetSetCellValue(master,price.priceunitofmeasurequantity,i,15)>
            </cfif>
            <cfif isDefined("price.packquantity")>
              <cfset SpreadsheetSetCellValue(master,price.packquantity,i,16)>
            </cfif>
            <cfif isDefined("price.vatcode")>
              <cfset SpreadsheetSetCellValue(master,price.vatcode,i,17)>
            </cfif>
            <cfif isDefined("price.vatcode")>
              <cfset SpreadsheetSetCellValue(master,price.vatcode,i,17)>
            </cfif>
            <cfif isDefined("price.priceeffectivefromdate")>
              <cfset SpreadsheetSetCellValue(master,price.priceeffectivefromdate,i,18)>
            </cfif>
            <cfif isDefined("price.discountgroup")>
              <cfset SpreadsheetSetCellValue(master,price.discountgroup,i,20)>
            </cfif>
            <cfif isDefined("price.rebategroup")>
              <cfset SpreadsheetSetCellValue(master,price.rebategroup,i,21)>
            </cfif>
            <cfif isDefined("price.rebategroup")>
              <cfset SpreadsheetSetCellValue(master,price.rebategroup,i,21)>
            </cfif>
            <cfif isDefined("price.nmbsproductgroup")>
              <cfset SpreadsheetSetCellValue(master,price.nmbsproductgroup,i,22)>
            </cfif>
            <cfif isDefined("price.supplierslistprice")>
              <cfset SpreadsheetSetCellValue(master,price.supplierslistprice,i,23)>
            </cfif>
            <cfif isDefined("price.merchantinvoiceprice")>
              <cfset SpreadsheetSetCellValue(master,price.merchantinvoiceprice,i,24)>
            </cfif>
          </cfif>
        </cfloop>
      </cfif>
      <cfset i++>
    </cfloop>
    <cfset spreadsheetFileName = "/tmp/#siteID#_#createUUID()#.xls">
    <cfspreadsheet action="write" filename="#spreadsheetFileName#" name="master"></cfspreadsheet>
    <cfheader name="Content-Disposition" value="attachment;filename=#ListLast(spreadsheetFileName,"/")#">
    <cfcontent type="application/msexcel" file="#spreadsheetFileName#">    
  </cffunction> 

  <cffunction name="recentlyUpdated" returntype="struct">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="siteID" required="true" default="">
    <cfargument name="format" required="true" default="json">
    <cfset var cacheKey = "recentlyUpdatedProducts_#arguments.siteID#">
    <cfset var ticket = request.buildingVine.user_ticket>
    <cfset logger.debug("cacheKeyExists: " & templateCache.lookup(cacheKey))>
    <cfif templateCache.lookup(cacheKey)>
      <cfreturn templateCache.get(cacheKey)>
    <cfelse>
      <cfhttp port="8080" timeout="999999" url="http://46.51.188.170/alfresco/service/bv/recent/products.#arguments.format#?startRow=#startRow#&maxrows=#maxrow#&siteID=#arguments.siteID#&alf_ticket=#ticket#" result="productList"></cfhttp>
      <cfif arguments.format eq "JSON">
        <cfset returnO = deserializeJSON(productList.fileContent)>
        <cfset isSet = templateCache.set(cacheKey,returnO,180,180)>        
        <cfreturn returnO>  
      <cfelse>
        <cfset returnO = {results=productList.fileContent}>
        <cfset templateCache.set(cacheKey,returnO,180,180)>
        <cfreturn returnO>    
      </cfif>
    </cfif>
  </cffunction>

  <cffunction name="recentlyUpdatedCount" returntype="struct">
    <cfargument name="siteID" required="true" default="">    
    <cfset var cacheKey = "recentlyUpdatedProductCount_#arguments.siteID#">
    <cfset var ticket = request.buildingVine.user_ticket>
    <cfset logger.debug("cacheKeyExists: " & templateCache.lookup(cacheKey))>
    <cfif templateCache.lookup(cacheKey)>
      <cfreturn templateCache.get(cacheKey)>
    <cfelse>
      <cfhttp port="8080" timeout="999999" url="http://46.51.188.170/alfresco/service/bv/recent/products/count?siteID=#arguments.siteID#&alf_ticket=#ticket#&withinDays=30" result="productList"></cfhttp>      
      <cfset returnO = deserializeJSON(productList.fileContent)>
      <cfset isSet = templateCache.set(cacheKey,returnO,180,180)>        
      <cfreturn returnO>        
    </cfif>
  </cffunction>

  <cffunction name="getFullList" returntype="struct">
    <cfargument name="format" required="true" default="json">
    <cfset var ticket = request.buildingVine.user_ticket>
    <cfset var appRoot = instance.ApplicationStorage.getVar("appRoot")>
    <cfset var siteID = request.BVsiteID>
    <cfhttp timeout="999999" url="http://46.51.188.170/alfresco/service/bv/product/fullList.#arguments.format#?siteID=#siteID#&alf_ticket=#ticket#" result="productList"></cfhttp>
    <cfif arguments.format eq "json">
      <cfreturn DeSerializejson(productList.fileContent)>  
    <cfelse>
      <cfreturn results={productList.fileContent}>
    </cfif>
    
  </cffunction>

  <cffunction name="getLinks" returntype="array">
    <cfargument name="nodeRef">
    <cfset var ticket = request.user_ticket>
    <cfhttp charset="utf-8" port="8080" url="http://46.51.188.170/alfresco/service/bvine/product/links.json?productNode=#arguments.nodeRef#&alf_ticket=#ticket#" result="productLinks"></cfhttp>
    <cfreturn DeSerializejson(productLinks.fileContent)>
  </cffunction>

  <cffunction name="listAllProducts" output="false" access="public" returntype="any">
    <cfargument name="siteID" required="true" type="string">
    <cfset var ticket = request.user_ticket>
    <cflock timeout="90000">
    <cfhttp timeout="90000" port="8080" username="website@buildingvine.com" password="f4ck5t41n" url="http://46.51.188.170/alfresco/service/bv/product/fullList.json?siteID=#siteID#" result="productList"></cfhttp>
    </cflock>
    <cfreturn DeSerializeJSON(productList.fileContent)>
  </cffunction>

  <cffunction name="listAllCategories" output="false" access="public" returntype="any">
    <cfargument name="siteID" required="true" type="string">
    <cfset var ticket = request.user_ticket>
      <cflock timeout="90000">
      <cfhttp timeout="90000" port="8080" url="http://46.51.188.170/alfresco/service/bv/product/fullTree?siteID=#siteID#&alf_ticket=#request.user_ticket#" result="productList"></cfhttp>
      </cflock>
      <cfreturn DeSerializeJSON(productList.fileContent)>
  </cffunction>

  <cffunction name="listFlatCategories" output="false" access="public" returntype="any">
    <cfargument name="siteID" required="true" type="string">
    <cfset var ticket = request.user_ticket>
      <cflock timeout="90000">
      <cfhttp timeout="90000" port="8080" url="http://46.51.188.170/alfresco/service/bv/product/categories/flat?siteID=#siteID#&alf_ticket=#request.user_ticket#" result="productList"></cfhttp>
      </cflock>
      <cfreturn DeSerializeJSON(productList.fileContent)>
  </cffunction>

	<!--- getParentListing --->
	<cffunction name="listProducts" output="false" access="public" returntype="any">
		<cfargument name="siteID" required="true" type="string">
		<cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfargument name="nodeRef" required="true" type="string" default="A">
		<cfset var ticket = request.buildingVine.user_ticket>

    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bv/products?nodeRef=#nodeRef#&siteid=#siteID#&startRow=#startRow#&maxrows=#maxrow#&alf_ticket=#ticket#" result="productList"></cfhttp>
 		<cfreturn jsonChecker.check(productList)>
	</cffunction>
  <cffunction name="productCount" output="false" access="public" returntype="any">
    <cfargument name="siteID" required="true" type="string">
    <cfset var ticket = request.user_ticket>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/buildingvine/api/productCount.json?siteID=#siteID#&alf_ticket=#ticket#" result="c"></cfhttp>
      <cfreturn DeserializeJSON(c.fileContent)>
  </cffunction>

  <cffunction name="listProductsDemo" output="false" access="public" returntype="any">
    <cfargument name="siteID" required="true" type="string">
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfset var ticket = instance.userService.getUserTicket(true)>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/products/list?siteid=#siteID#&startRow=#startRow#&maxrows=#maxrow#" username="admin" password="bugg3rm33" result="productList"></cfhttp>
      <cfreturn DeserializeJSON(productList.fileContent)>
  </cffunction>

	<cffunction name="productDetail" access="public" returntype="struct" output="false">
    <cfargument name="nodeRef" required="true" type="string" >
    <cfargument name="siteID" required="true" type="string" default="" >
    <cfset var returnStruct = StructNew()>
    <!--- RC Reference --->
    <cfset var ticket = request.buildingVine.admin_ticket>
    <cfhttp charset="utf-8" port="8080" url="http://46.51.188.170/alfresco/service/bvine/product?nodeRef=#nodeRef#&alf_ticket=#ticket#" result="productDetail"></cfhttp>
    <cfset returnStruct = StructNew()>
    <cftry>
      <cfset returnStruct.detail = DeSerializeJSON(productDetail.fileContent).product>
      <cfif returnStruct.detail.eancode neq "" >
        <cfparam name="cookie.CFTOKEN" default="#createUUID()#">
        <cfset cID = cookie.CFToken>
        <!--- <cfthread name="easyRec_#createUUID()#" action="run" priority="LOW" returnStruct="#returnStruct#" cID="#cID#">
        <cfhttp timeout="290"
          url="http://50.16.234.76/easyrec-web/api/1.0/buy?itemurl=/products/productDetail?nodeRef=#attributes.returnStruct.detail.nodeRef#&itemdescription=#URLEncodedFormat(attributes.returnStruct.detail.title)#&apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=buildingvine&itemid=#attributes.returnStruct.detail.nodeRef#&itemtype=ITEM&sessionid=#attributes.CID#" port="8080"></cfhttp>
        </cfthread> --->
        <cfset returnStruct.amazon = shoppingService.amazonResults(returnStruct.detail.eancode)>
      </cfif>
      <cfset returnStruct.output = renderLayout(siteID,returnStruct.detail.attributes.customProperties)>
      <cfcatch type="any">
        <cfset returnStruct.output = "#cfcatch.Message#">
      </cfcatch>
    </cftry>
    <cfreturn returnStruct>
  </cffunction>

	<cffunction name="productSearch" access="public" returntype="Any" output="false">
    <cfargument name="query" required="true" type="string" >
    <cfargument name="siteID" required="true" type="string" default="" >
    <cfargument name="startRow" required="true" type="numeric" default="1">
    <cfargument name="maxrow" required="true" type="numeric" default="10">
    <cfif siteID eq "buildingvine" OR siteID eq "buildingVine">
      <cfset siteID = "">
    </cfif>
    <!--- RC Reference --->
    <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/bvine/search/products?q=#query#&siteid=#siteID#&maxrows=#maxRow#&startRow=#startRow#&alf_ticket=#ticket#" result="productDetail"></cfhttp>    
    <cfreturn jsonChecker.check(productDetail.fileContent)>    
  </cffunction>

  <cffunction name="importPrices" returntype="any">
    <cfargument name="ticket">
    <cfargument name="sourceSiteID">
    <cfargument name="targetSiteID">
    <cfargument name="file">
    <cfsetting requesttimeout="9000">
    <cfspreadsheet action="read" src="#file#" headerrow="1" query="priceSpreadsheet" sheet="2" />
    <cfloop query="priceSpreadsheet" startrow="2">
      <!--- we need to set a fileName --->
      <cfset supplierproductcode = "">
      <cfset eancode = "">
      <cfset manufacturerproductcode = "">
      <cfset productcode = "">
      <cfset productName = "">
      <cfif ListFindNoCase(priceSpreadsheet.ColumnList,"EAN Code") AND priceSpreadsheet["EAN Code"][currentRow] neq "" AND priceSpreadsheet["EAN Code"][currentRow] neq " ">
        <cfset fileName = priceSpreadsheet["EAN Code"][currentRow]>
        <cfset eancode = priceSpreadsheet["EAN Code"][currentRow]>
      <cfelseif ListFindNoCase(priceSpreadsheet.ColumnList,"productcode") AND priceSpreadsheet["productcode"][currentRow] neq "" AND priceSpreadsheet["productcode"][currentRow] neq " ">
        <cfset fileName = priceSpreadsheet["productcode"][currentRow]>
      <cfelseif ListFindNoCase(productSpreadsheet.ColumnList,"Manufacturer Product Code") AND  priceSpreadsheet["Manufacturer Product Code"][currentRow] neq "">
        <cfset fileName = priceSpreadsheet["Manufacturer Product Code"][currentRow]>
      <cfelseif ListFindNoCase(priceSpreadsheet.ColumnList,"Supplier Product Code") AND priceSpreadsheet["Supplier Product Code"][currentRow] neq "">
        <cfset fileName = priceSpreadsheet["Supplier Product Code"][currentRow]>
      <cfelse>
        <cfset fileName = priceSpreadsheet["Product Description 1"][currentRow]>
      </cfif>
      <cfif ListFindNoCase(priceSpreadsheet.ColumnList,"Manufacturer Product Code") AND  priceSpreadsheet["Manufacturer Product Code"][currentRow] neq "">
        <cfset manufacturerproductcode = priceSpreadsheet["Manufacturer Product Code"][currentRow]>
      </cfif>
      <cfif ListFindNoCase(priceSpreadsheet.ColumnList,"Supplier Product Code") AND priceSpreadsheet["Supplier Product Code"][currentRow] neq "">
        <cfset supplierproductcode = priceSpreadsheet["Supplier Product Code"][currentRow]>
      </cfif>
      <cfif ListFindNoCase(priceSpreadsheet.ColumnList,"Product Description 1") AND  priceSpreadsheet["Product Description 1"][currentRow] neq ""><cfset productName = "#productName# #priceSpreadsheet['Product Description 1'][currentRow]#"> </cfif>
      <cfif ListFindNoCase(priceSpreadsheet.ColumnList,"Product Description 2") AND  priceSpreadsheet["Product Description 2"][currentRow] neq ""><cfset productName = "#productName# #priceSpreadsheet['Product Description 2'][currentRow]#"> </cfif>
      <cfif ListFindNoCase(priceSpreadsheet.ColumnList,"Product Description 3") AND  priceSpreadsheet["Product Description 3"][currentRow] neq ""><cfset productName = "#productName# #priceSpreadsheet['Product Description 3'][currentRow]#"> </cfif>
      <cfset priceFile = StructNew()>
      <cfloop list="#priceSpreadsheet.columnList#" index="col">
        <cfset colName = LCase(Replace(col," ","","ALL"))>
        <!--- add a new tag pair --->
        <cfswitch expression="#colName#">
          <cfcase value="eancode,productdescription1,productdescription2,productdescription3,productcode,manufacturerproductcode,supplierproductcode,priceeffectivefromdate,discountgroup,rebategroup,supplierslistprice,merchantinvoiceprice,priceunitofmeasuredescription,priceunitofmeasurequantity,packquantity,vatcode,price,nmbsproductgroup,weightperunitofmeasure,rrp,unitweight,manufacturerbandname,packagingpaper,nmbssuppliercode,packagingwood,packagingglass,packagingsteel,packagingplastic,manufacturerbrandname,packagingaluminium,imageurl,thumbnailurl,coshhurl,specificationurl">
            <!--- don't add this to the meta --->
          </cfcase>
          <cfdefaultcase>
              <!--- to the meta data description --->
              <cfset priceFile["#colName#"] = "#priceSpreadsheet['#col#'][currentRow]#">
          </cfdefaultcase>
        </cfswitch>
      </cfloop>
      <cfset productName = trim(productName)>
      <cfset fileName = "#friendlyUrl(fileName)#.json">
      <cflog application="true" text="#fileName#">
      <cfhttp result="pric" port="8080" url="http://46.51.188.170/alfresco/service/bv/price" method="post">
        <cfhttpparam type="formfield" name="alf_ticket" value="#ticket#">
        <cfhttpparam type="formfield" value="#SerializeJSON(priceFile)#" name="xml">
        <cfhttpparam type="formfield" name="sourceSiteID" value="#sourceSiteID#">
        <cfhttpparam type="formfield" name="targetSiteID" value="#targetSiteID#">
        <cfhttpparam type="formfield" name="eancode" value="#eancode#">
        <cfhttpparam type="formfield" name="supplierproductcode" value="#supplierproductcode#">
        <cfhttpparam type="formfield" name="manufacturerproductcode" value="#manufacturerproductcode#">
        <cfhttpparam type="formfield" name="productDescription" value="#trim(productName)#">
        <cfhttpparam type="formfield" name="fileName" value="#fileName#">
        <cfif isNumeric(left(trim(productName),1))>
          <cfhttpparam type="formfield" name="directory" value="0">
        <cfelse>
          <cfhttpparam type="formfield" name="directory" value="#UCASE(left(trim(productName),1))#">
        </cfif>

        <cfloop list="#priceSpreadsheet.columnList#" index="col">
          <cfset colName = LCase(Replace(col," ","","ALL"))>
          <cfswitch expression="#colName#">
            <cfcase value="priceeffectivefromdate">
              <cfhttpparam type="formfield" name="price_#colName#" value="#dateformat(priceSpreadsheet['#col#'][currentRow], 'yyyy-mm-dd')#T#TimeFormat(priceSpreadsheet['#col#'][currentRow], 'HH:mm:ss.000Z')#">
            </cfcase>
            <cfcase value="nmbsproductgroup,nmbssuppliercode,price,vatcode,packquantity,discountgroup,rebategroup,supplierslistprice,merchantinvoiceprice,priceunitofmeasuredescription,priceunitofmeasurequantity">
              <!--- these are model attributes --->
              <cfhttpparam type="formfield" name="price_#colName#" value="#priceSpreadsheet['#col#'][currentRow]#">
            </cfcase>
          </cfswitch>
        </cfloop>
      </cfhttp>
      <cflog application="true" text="#pric.FileContent#">
    </cfloop>
    <!--- then read in the second sheet - which are deletions --->
    <cfreturn local>
  </cffunction>

  <cffunction name="importProducts" returntype="Any">
    <cfargument name="ticket" required="true">
    <cfargument name="requestCollection" required="true">
    <cfset var rc = arguments.requestCollection>
    <cfsetting requesttimeout="9000">
    <cfquery name="doImportStatus" datasource="bvine">
      update site set productImportStatus = <cfqueryparam cfsqltype="cf_sql_float" value="1">, importStatusLastTime = now() where shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">
    </cfquery>
    <cfset productArray = []>
    <!--- remove mappings --->
    <cfquery name="d" datasource="bvine">
      delete from fieldDefinitions where site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">
    </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="eanCode">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.eanCode#">
        )
    </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="manufacturerproductcode">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.manufacturerproductcode#">
        )
    </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="supplierproductcodeode">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.supplierproductcode#">
        )
    </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="productname">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.productname#">
        )
     </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="productdescription">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.productdescription#">
        )
     </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="rrp">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.rrp#">
        )
    </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="unitweight">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.unitweight#">
        )
    </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="imageRef">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.imageRef#">
        )
    </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="documentRef">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.documentRef#">
        )
     </cfquery>
    <cfquery name="addThis" datasource="bvine">
      insert into fieldDefinitions (object,fieldName,site,mapsTo)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="product">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="categoryColumn">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.siteID#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.categoryColumn#">
        )

    </cfquery>
    <cfspreadsheet action="read" src="#rc.fileName#" headerrow="1" query="productSpreadsheet" sheet="1" />
    <cfloop query="productSpreadsheet" startrow="2">
      <cfset product = {}>
      <cfset product["imageSearchNames"] = []>
      <cfset product["documentSearchNames"] = []>
      <cfset product["imageNodeRefs"] = []>
      <cfset product["documentNodeRefs"] = []>
      <cfset product["productData"] = {}>
      <cfset product["customData"] = {}>
      <cfset ignoreColumns = arrayNew(1)>
      <cfset isEmptyRow = true>
      <!--- we need to set a fileName --->

      <cfif fileExists("/fs/sites/ebiz/46.51.188.170/web/model/customImport/#rc.siteID#.cfc")>
        <cfset product = beanFactory.getModel("customImport.#rc.siteID#").runIt(productSpreadsheet,currentRow,product,rc,ticket)>
      </cfif>

      <cfif rc.categoryColumn neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.categoryColumn#")>
        <cfset product["category"] = trim(ToString(productSpreadsheet["#rc.categoryColumn#"][currentRow]))>
      <cfelse>
        <cfset product["category"] = "All Products">
      </cfif>
      <cfif rc.eanCode neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.eanCode#")>
        <cfset product["productData"]["eancode"] = replaceWhiteSpace(ToString(productSpreadsheet["#rc.eanCode#"][currentRow]))>
        <cfif product["productData"]["eancode"] neq "">
          <cfset product["fileName"] = "#hash(product['productData']['eancode'])#.json">
		    </cfif>
      </cfif>
      <cfif rc.manufacturerproductcode neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.manufacturerproductcode#")>
        <cfset product["productData"]["manufacturerproductcode"] = trim(ToString(productSpreadsheet["#rc.manufacturerproductcode#"][currentRow]))>
        <cfif NOT StructKeyExists(product,"filename")>
          <cfset product["fileName"] = "#hash(product['productData']['manufacturerproductcode'])#.json">
        </cfif>
      </cfif>
      <cfif rc.supplierproductcode neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.supplierproductcode#")>
        <cfset product["productData"]["supplierproductcode"] = trim(ToString(productSpreadsheet["#rc.supplierproductcode#"][currentRow]))>
        <cfif NOT StructKeyExists(product,"filename")>
          <cfset product["fileName"] = "#hash(product['productData']['supplierproductcode'])#.json">
        </cfif>
      </cfif>
      <cfif rc.productname neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.productname#")>
        <cfset product["productData"]["productname"] = trim(ToString(productSpreadsheet["#rc.productname#"][currentRow]))>
      </cfif>
      <cfif rc.productdescription neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.productdescription#")>
        <cfset product["productData"]["productdescription"] = trim(ToString(productSpreadsheet["#rc.productdescription#"][currentRow]))>
      </cfif>
      <cfif rc.rrp neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.rrp#")>
        <cfset product["productData"]["rrp"] = trim(ToString(productSpreadsheet["#rc.rrp#"][currentRow]))>
      </cfif>
      <cfif rc.unitweight neq "">
        <cfset ArrayAppend(ignoreColumns,"#rc.unitweight#")>
        <cfset product["productData"]["unitweight"] = trim(ToString(productSpreadsheet["#rc.unitweight#"][currentRow]))>
      </cfif>
      <cfif rc.imageRef neq "">

        <cfloop list="#rc.imageRef#" index="i">
          <cfset ArrayAppend(ignoreColumns,"#i#")>
          <cfif left(productSpreadsheet["#i#"][currentRow],4) eq "http">
            <!--- we need to download the image, upload it, and then get the nodeRef --->
            <cfhttp port="80" resolveurl="true" getasbinary="auto" url="#productSpreadsheet['#i#'][currentRow]#" result="im"></cfhttp>
            <cfif im.statusCode eq "200 OK">
              <cfset localFileName = "#createUUID()#.jpg">
              <cfif Len(ListLast(productSpreadsheet['#i#'][currentRow],'/')) lt 30>
                <cfset localFIleName = ListLast(productSpreadsheet['#i#'][currentRow],'/')>
              </cfif>
              <cffile action="write" file="/tmp/#localFileName#" output="#im.fileContent#">
              <cfif listLast(localFileName,".") eq "tmp">
                <cfset mime = getPageContext().getServletContext().getMimeType("/tmp/#localFileName#")>
                <cfset mimExt = getMimeTypeExtension(mime)>
                <cffile action="move" source="/tmp/#localFileName#" destination="/tmp/#ListFirst(localFileName,'.')##mimExt#">
                <cfset localFileName = "/tmp/#ListFirst(localFileName,'.')##mimExt#">
              </cfif>
              <cfhttp port="8080" result="imageUp" url="http://46.51.188.170/alfresco/service/bvine/docs/files/upload.json?alf_ticket=#ticket#&niceFolder=Sites/#rc.siteID#/documentLibrary/Product%20Information/Product%20Images" method="post">
                <cfhttpparam type="file" name="file" file="/tmp/#localFileName#">
              </cfhttp>
              <cfset ImgRes = DeSerializejson(imageUp.fileContent)>
              <cfset ArrayAppend(product["imageNodeRefs"],ImgRes.nodeRef)>
            </cfif>
          <cfelse>
            <cfset ArrayAppend(product["imageSearchNames"],productSpreadsheet['#i#'][currentRow])>
          </cfif>
        </cfloop>
      </cfif>
      <cfif rc.documentRef neq "">

        <cfloop list="#rc.documentRef#" index="i">
          <cfset ArrayAppend(ignoreColumns,"#i#")>
          <cfif left(productSpreadsheet["#i#"][currentRow],4) eq "http">
            <!--- we need to download the image, upload it, and then get the nodeRef --->
            <cfhttp port="80" resolveurl="true" getasbinary="auto" url="#productSpreadsheet['#i#'][currentRow]#" result="doc"></cfhttp>
            <cfif doc.statusCode eq "200 OK">
              <cfset localFileName = friendlyUrl(ListLast(productSpreadsheet['#i#'][currentRow],'/'))>
              <cffile action="write" file="/tmp/#localFileName#" output="#doc.fileContent#">
              <cfif listLast(localFileName,".") eq "tmp" OR len(listLast(localFileName,".")) gte 5>
                <cftry>
                <cfset mimExt = getMimeTypeExtension(mimetype=getPageContext().getServletContext().getMimeType("/tmp/#localFileName#"))>
                <cfcatch type="any">
                  <cfset mimExt = "pdf">
                </cfcatch>
                </cftry>
                <cffile action="move" source="/tmp/#localFileName#" destination="/tmp/#ListFirst(localFileName,'.')#.#mimExt#">
                <cfset localFileName = "/tmp/#ListFirst(localFileName,'.')#.#mimExt#">
              <cfelse>
                <cffile action="move" source="/tmp/#localFileName#" destination="/tmp/#ListFirst(localFileName,'.')#.#ListLast(localFileName,'.')#">
                <cfset localFileName = "/tmp/#ListFirst(localFileName,'.')#.#ListLast(localFileName,'.')#">
              </cfif>
              <cfhttp port="8080" result="docUp" url="http://46.51.188.170/alfresco/service/bvine/docs/files/upload.json?alf_ticket=#ticket#&niceFolder=Sites/#rc.siteID#/documentLibrary/Product%20Information/Product%20Brochures" method="post">
                <cfhttpparam type="file" name="file" file="#localFileName#">
              </cfhttp>
              <cfset DocRes = DeSerializejson(docUp.fileContent)>
              <cfset ArrayAppend(product["documentNodeRefs"],DocRes.nodeRef)>
            </cfif>
          <cfelse>
            <cfset ArrayAppend(product["documentSearchNames"],productSpreadsheet['#i#'][currentRow])>
          </cfif>
        </cfloop>
      </cfif>

      <cfloop list="#productSpreadsheet.columnList#" index="col">
	      <cfset colName = LCase(Replace(col," ","","ALL"))>
	      <cfif NOT StructKeyExists(product,col) AND LEFT(col,3) neq "COL">
          <!--- to the meta data description --->
          <cfif NOT ArrayFindNoCase(ignoreColumns,"#col#")>
            <cfset product["customData"]["#col#"] = "#productSpreadsheet['#col#'][currentRow]#">
          </cfif>
          <cfif col neq "">
            <cfset isEmptyRow = false>
          </cfif>
        </cfif>
      </cfloop>
      <cfif NOT isEmptyRow>
        <cfset arrayAppend(productArray,product)>
      </cfif>
    </cfloop>
    <cfset jsonObject = {}>
    <cfset jsonObject["products"] = productArray>
    <cfset jsonObject["importType"] = rc.sstype>
    <!--- now serialize the json object and send it to alfresco --->
    <cfset js = SerializeJSON(jsonObject)>
    <cffile action="write" file="/tmp/test" output="#js#">

    <cfhttp timeout="9000" result="importImages" port="8080" method="post" url="http://46.51.188.170/alfresco/service/bv/product?siteID=#rc.siteID#&alf_ticket=#ticket#">
      <cfhttpparam type="header" name="content-type" value="application/json">
      <cfhttpparam type="body" name="json" value="#js#">
    </cfhttp>
    <cfreturn local>
  </cffunction>
  <cffunction name="importProductImages" returntype="Any">
    <cfargument name="ticket">
    <cfargument name="siteID">
    <cfargument name="file">
    <cfspreadsheet action="read" src="#file#" headerrow="1" query="imageSheet" sheet="1" />
    <cfset imageArray = []>
    <cfoutput query="imageSheet" group="supplierproductcode">
      <cfset prod = {}>
      <cfset prod["supplierProductCode"] = supplierproductcode>
      <cfset prod["img"] = []>
      <cfoutput>
        <cfset arrayAppend(prod.img,imgurl)>
      </cfoutput>
      <cfset arrayAppend(imageArray,prod)>
    </cfoutput>
    <cfset jsonObject = {}>
    <cfset jsonObject["products"] = imageArray>
    <cfset js = SerializeJSON(jsonObject)>
    <cfhttp port="8080" result="importImages" method="put" url="http://46.51.188.170/alfresco/service/bv/product/image?siteID=#siteID#&alf_ticket=#ticket#">
      <cfhttpparam type="header" name="content-type" value="application/json">
      <cfhttpparam type="body" name="json" value="#js#">
    </cfhttp>
  </cffunction>


  <cffunction name="importCategories" returntype="Any">
    <cfargument name="ticket">
    <cfargument name="siteID" required="true">
    <cfargument name="localURL" required="true" default="">
    <cfsetting requesttimeout="9000">
    <cfspreadsheet action="read" src="#localURL#" headerrow="1" query="categoryTree" sheet="2" />
    <cfloop query="categoryTree" startrow="2">
      <!--- we need to set a fileName --->
      <cfhttp port="8080" timeout="5" throwonerror="false" result="doProducts" url="http://46.51.188.170/alfresco/service/bv/product/category" method="post">
        <cfhttpparam type="formfield" name="alf_ticket" value="#ticket#">
        <cfhttpparam type="formfield" name="siteID" value="#siteID#">
        <cfhttpparam type="formfield" name="categoryID" value="#categoryID#">
        <cfhttpparam type="formfield" name="categoryName" value="#categoryName#">
        <cfhttpparam type="formfield" name="categoryParent" value="#categoryParent#">
      </cfhttp>
    </cfloop>
    <!--- then read in the second sheet - which are deletions --->
    <cfreturn local>
  </cffunction>

  <cffunction name="categoryList" access="public" returntype="any" output="false">
      <cfargument name="id" required="true" default="">
      <cfargument name="siteID" required="true" default="">
      <cfset var ticket = request.user_ticket>
      <cfhttp port="8080" url="http://46.51.188.170:8080/alfresco/service/bv/product/categories?nodeRef=#id#&siteID=#siteID#&alf_ticket=#ticket#" result="documentList"></cfhttp>
        <cfreturn DeserializeJSON(documentList.fileContent)>
    </cffunction>


  <cffunction name="image" returntype="Any">
    <cfargument name="eanCode">
    <cfargument name="supplierCode">
    <cfargument name="productName">
    <cfset var ticket = request.user_ticket>
    <cfset imURL = "http://46.51.188.170/alfresco/service/buildingvine/api/productSearch.json?productCode=#eanCode#&supplierCode=#supplierCode#&mimetype=image/jpeg&productName=#productName#&alf_ticket=#ticket#">
    <cfhttp port="8080" url="#imURL#" result="productImages" username="admin" password="bugg3rm33"></cfhttp>
    <cfreturn DeSerializeJSON(productImages.fileContent)>
  </cffunction>

<cffunction name="renderLayout" returntype="String" access="public" output="true">
  <cfargument name="siteID">
  <cfargument name="productStruct">
  <cfquery name="productLayout" datasource="bvine">
    select productLayoutCode from siteProductLayout
    where
    shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#siteID#">
  </cfquery>
  <cfif productLayout.recordCount eq 0>
	  <cfsavecontent variable="newoutput">
	    <cfoutput>
	      <div class="t">
	      <cfloop collection="#productStruct#" item="x">
	      <cfif productStruct[x] neq "NULL" AND productStruct[x] neq "">
	        <cfif x neq "fake">
          <div class="trow">
	          <div class="tcell">#x#</div>
	          <div class="tcell">
	          	<cfif isValid("URL",#productStruct[x]#)>
				  	   <a href="#productStruct[x]#" target="_blank"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/globe-network.png" border="0" class="ttip" title="View #x#"></a>
				  	  <cfelse>
	          	#productStruct[x]#
	            </cfif>
						</div>
	        </div>
          </cfif>
	      </cfif>
	      </cfloop>
	      </div>
	    </cfoutput>
	  </cfsavecontent>
  <cfelse>
	  <cfsavecontent variable="output">
	    <cfoutput>
	    #productLayout.productLayoutCode#
	    </cfoutput>
	  </cfsavecontent>
	  <cfset output = populate_fields(output,productStruct)>
	  <cfsavecontent variable="newoutput">
	    <cfoutput>
	    #output#
	    </cfoutput>
	  </cfsavecontent>
  </cfif>
  <cfreturn newoutput>

</cffunction>

  <cffunction name="getFields" returntype="query">
    <cfargument name="site">
    <cfargument name="fieldName">
    <cfquery name="fields" datasource="bvine">
      select * from fieldDefinitions where site IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#arguments.site#">)
      AND
      fieldName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.fieldName#">
    </cfquery>
    <cfreturn fields>
  </cffunction>

  <cffunction name="runSync" returntype="boolean">
    <cfset var syncOptions = instance.UserStorage.getVar("syncOptions")>
    <cfset var ticket = request.user_ticket>
    <cfscript>
    updatedFormat = {};
    updatedFormat.fgcolor = "dark_blue";
    updatedFormat.color = "pale_blue";
    </cfscript> >

    <cfspreadsheet action="read" src="/tmp/#syncOptions.filename#" headerrow="1" query="spreadsheet" />
    <cfspreadsheet action="read" src="/tmp/#syncOptions.filename#" headerrow="1" name="spreadsheetCopy" />
    <cfset newQ = QueryNew( spreadsheet.ColumnList ) />
    <cfquery name="mappings" datasource="bvine">
	    select
			  fieldDefinitions.fieldName as merchantField,
			  fieldDefinitionsMerchant.fieldName
			from
			  fieldMappings as fieldMappings,
			  fieldDefinitions as fieldDefinitions,
			  fieldDefinitions as fieldDefinitionsMerchant
			where
        fieldDefinitions.site = <cfqueryparam cfsqltype="cf_sql_varchar" value="#syncOptions.siteID#">
			AND
        fieldDefinitions.id = fieldMappings.fieldID
			AND
			  fieldDefinitionsMerchant.id = fieldMappings.foreignID
    </cfquery>
    <cfloop query="spreadsheet">
      <cfif syncOptions.search_eancode neq "">
        <cfset s_eancode = spreadsheet["#syncOptions.search_eancode#"][spreadsheet.CurrentRow]>
      <cfelse>
        <cfset s_eancode = "">
      </cfif>
      <cfif syncOptions.search_supplierproductcode neq "">
        <cfset s_supplierproductcode = spreadsheet["#syncOptions.search_supplierproductcode#"][spreadsheet.CurrentRow]>
      <cfelse>
        <cfset s_supplierproductcode = "">
      </cfif>
      <cfif syncOptions.search_manufacturerproductcode neq "">
        <cfset s_manufacturerproductcode = spreadsheet["#syncOptions.search_manufacturerproductcode#"][spreadsheet.CurrentRow]>
      <cfelse>
        <cfset s_manufacturerproductcode = "">
      </cfif>
      <cfif syncOptions.search_description neq "">
        <cfset s_description = spreadsheet["#syncOptions.search_description#"][spreadsheet.CurrentRow]>
      <cfelse>
        <cfset s_description = "">
      </cfif>
      <cfif syncOptions.BVsiteID neq "">
        <cfset s_siteID = spreadsheet["#syncOptions.BVsiteID#"][spreadsheet.CurrentRow]>
      <cfelse>
        <cfset s_siteID = "">
      </cfif>
			<cfset QueryAddRow(newQ)>
			<cfloop index="strColumn" list="#spreadsheet.ColumnList#">
  			<cfset newQ[strColumn][newQ.RecordCount] = spreadsheet[strColumn][spreadsheet.CurrentRow] />
			</cfloop>
      <cfhttp url="http://46.51.188.170/alfresco/service/bvine/productsync?eanCode=#s_eancode#&sCode=#s_supplierproductcode#&mCode=#s_manufacturerproductcode#&desc=#s_description#&siteID=#s_SiteID#&alf_ticket=#ticket#" result="productDetail"></cfhttp>
      <cfif productDetail.statusCode eq "200 OK">
        <cfset prod = DeSerializeJSON(productDetail.fileContent)>
        <cfif ArrayLen(prod.items) gte 1>
	        <cfset product = prod.items[1]>
	        <cfloop query="mappings">
	          <cfif StructKeyExists(product.attributes, "#fieldName#")>
              <!--- <cfset colNum = ListFind(spreadsheet.ColumnList,merchantField)>
              <cfset SpreadsheetSetCellValue(spreadsheetCopy,product.attributes["#fieldName#"],spreadsheet.CurrentRow,colNum)>
              <cfset spreadsheetFormatRow(spreadsheetCopy,updatedFormat,spreadsheet.CurrentRow)>--->
	            <cfset newQ["#merchantField#"][newQ.RecordCount] = product.attributes["#fieldName#"]>
	          </cfif>
	        </cfloop>
	        <cfif ArrayLen(product.prices) gte 1>
            <cflog application="true" text="prices array exists">
	          <cfloop query="mappings">
	            <cfif StructKeyExists(product.prices[1], "#fieldName#")>
              <!---<cfset colNum = ListFind(spreadsheet.ColumnList,merchantField)>
              <cfset SpreadsheetSetCellValue(spreadsheetCopy,product.prices[1]["#fieldName#"],spreadsheet.CurrentRow,colNum)>
              <cfset spreadsheetFormatRow(spreadsheetCopy,updatedFormat,spreadsheet.CurrentRow)>--->
	             <cfset newQ["#merchantField#"][newQ.RecordCount] = product.prices[1]["#fieldName#"]>
              </cfif>
	          </cfloop>
          </cfif>
        </cfif>
      </cfif>
    </cfloop>
    <cfspreadsheet action="write" filename="/tmp/new_#syncOptions.filename#" query="#newQ#" />
    <cfreturn true>
  </cffunction>

	<cfscript>
	  function populate_fields(str,productStruct){
    l = Len(str);
    i = 1;
    output = '';

    while (i LT l){

        f = REFindNoCase("\{([a-z,0-9,_])+\}",str,i,"TRUE");
        if (f.pos[1] IS 0){
            output = output & Mid(str,i,l-i+1);
            i = l;
        } else {
            output = output & Mid(str,i,f.pos[1]-i);
            name = Mid(str,f.pos[1]+1,f.len[1] - 2);
            output = output & productStruct["#name#"];
            i = f.pos[1] + f.len[1];
        }

    }

    return output;

}
function getMimeTypeExtension(mimetype) {
    var mimeStruct=structNew();
    var fileExtension ="";
    mimeStruct['application/postscript'] = ".ai";
    mimeStruct['audio/x-aiff'] = ".aif";
    mimeStruct['audio/x-aiff'] = ".aifc";
    mimeStruct['audio/x-aiff'] = ".aiff";
    mimeStruct['text/plain'] = ".asc";
    mimeStruct['audio/basic'] = ".au";
    mimeStruct['video/x-msvideo'] = ".avi";
    mimeStruct['application/x-bcpio'] = ".bcpio";
    mimeStruct['application/octet-stream'] = ".bin";
    mimeStruct['text/plain'] = ".c";
    mimeStruct['text/plain'] = ".cc";
    mimeStruct['application/clariscad'] = ".ccad";
    mimeStruct['application/x-netcdf'] = ".cdf";
    mimeStruct['application/octet-stream'] = ".class";
    mimeStruct['application/x-cpio'] = ".cpio";
    mimeStruct['application/mac-compactpro'] = ".cpt";
    mimeStruct['application/x-csh'] = ".csh";
    mimeStruct['text/css'] = ".css";
    mimeStruct['application/x-director'] = ".dcr";
    mimeStruct['application/x-director'] = ".dir";
    mimeStruct['application/octet-stream'] = ".dms";
    mimeStruct['application/msword'] = ".doc";
    mimeStruct['application/drafting'] = ".drw";
    mimeStruct['application/x-dvi'] = ".dvi";
    mimeStruct['application/acad'] = ".dwg";
    mimeStruct['application/dxf'] = ".dxf";
    mimeStruct['application/x-director'] = ".dxr";
    mimeStruct['application/postscript'] = ".eps";
    mimeStruct['text/x-setext'] = ".etx";
    mimeStruct['application/octet-stream'] = ".exe";
    mimeStruct['application/andrew-inset'] = ".ez";
    mimeStruct['text/plain'] = ".f";
    mimeStruct['text/plain'] = ".f90";
    mimeStruct['video/x-fli'] = ".fli";
    mimeStruct['image/gif'] = ".gif";
    mimeStruct['application/x-gtar'] = ".gtar";
    mimeStruct['application/x-gzip'] = ".gz";
    mimeStruct['text/plain'] = ".h";
    mimeStruct['application/x-hdf'] = ".hdf";
    mimeStruct['text/plain'] = ".hh";
    mimeStruct['application/mac-binhex40'] = ".hqx";
    mimeStruct['text/html'] = ".htm";
    mimeStruct['text/html'] = ".html";
    mimeStruct['x-conference/x-cooltalk'] = ".ice";
    mimeStruct['image/ief'] = ".ief";
    mimeStruct['model/iges'] = ".iges";
    mimeStruct['model/iges'] = ".igs";
    mimeStruct['application/x-ipscript'] = ".ips";
    mimeStruct['application/x-ipix'] = ".ipx";
    mimeStruct['image/jpeg'] = ".jpe";
    mimeStruct['image/jpeg'] = ".jpeg";
    mimeStruct['image/jpeg'] = ".jpg";
    mimeStruct['application/x-javascript'] = ".js";
    mimeStruct['audio/midi'] = ".kar";
    mimeStruct['application/x-latex'] = ".latex";
    mimeStruct['application/octet-stream'] = ".lha";
    mimeStruct['application/x-lisp'] = ".lsp";
    mimeStruct['application/octet-stream'] = ".lzh";
    mimeStruct['text/plain'] = ".m";
    mimeStruct['application/x-troff-man'] = ".man";
    mimeStruct['application/x-troff-me'] = ".me";
    mimeStruct['model/mesh'] = ".mesh";
    mimeStruct['audio/midi'] = ".mid";
    mimeStruct['audio/midi'] = ".midi";
    mimeStruct['application/vnd.mif'] = ".mif";
    mimeStruct['www/mime'] = ".mime";
    mimeStruct['video/quicktime'] = ".mov";
    mimeStruct['video/x-sgi-movie'] = ".movie";
    mimeStruct['audio/mpeg'] = ".mp2";
    mimeStruct['audio/mpeg'] = ".mp3";
    mimeStruct['video/mpeg'] = ".mpe";
    mimeStruct['video/mpeg'] = ".mpeg";
    mimeStruct['video/mpeg'] = ".mpg";
    mimeStruct['audio/mpeg'] = ".mpga";
    mimeStruct['application/x-troff-ms'] = ".ms";
    mimeStruct['model/mesh'] = ".msh";
    mimeStruct['application/x-netcdf'] = ".nc";
    mimeStruct['application/oda'] = ".oda";
    mimeStruct['image/x-portable-bitmap'] = ".pbm";
    mimeStruct['chemical/x-pdb'] = ".pdb";
    mimeStruct['application/pdf'] = ".pdf";
    mimeStruct['image/x-portable-graymap'] = ".pgm";
    mimeStruct['application/x-chess-pgn'] = ".pgn";
    mimeStruct['image/png'] = ".png";
    mimeStruct['image/x-portable-anymap'] = ".pnm";
    mimeStruct['application/mspowerpoint'] = ".pot";
    mimeStruct['image/x-portable-pixmap'] = ".ppm";
    mimeStruct['application/mspowerpoint'] = ".pps";
    mimeStruct['application/mspowerpoint'] = ".ppt";
    mimeStruct['application/mspowerpoint'] = ".ppz";
    mimeStruct['application/x-freelance'] = ".pre";
    mimeStruct['application/pro_eng'] = ".prt";
    mimeStruct['application/postscript'] = ".ps";
    mimeStruct['video/quicktime'] = ".qt";
    mimeStruct['audio/x-realaudio'] = ".ra";
    mimeStruct['audio/x-pn-realaudio'] = ".ram";
    mimeStruct['image/cmu-raster'] = ".ras";
    mimeStruct['image/x-rgb'] = ".rgb";
    mimeStruct['audio/x-pn-realaudio'] = ".rm";
    mimeStruct['application/x-troff'] = ".roff";
    mimeStruct['audio/x-pn-realaudio-plugin'] = ".rpm";
    mimeStruct['text/rtf'] = ".rtf";
    mimeStruct['text/richtext'] = ".rtx";
    mimeStruct['application/x-lotusscreencam'] = ".scm";
    mimeStruct['application/set'] = ".set";
    mimeStruct['text/sgml'] = ".sgm";
    mimeStruct['text/sgml'] = ".sgml";
    mimeStruct['application/x-sh'] = ".sh";
    mimeStruct['application/x-shar'] = ".shar";
    mimeStruct['model/mesh'] = ".silo";
    mimeStruct['application/x-stuffit'] = ".sit";
    mimeStruct['application/x-koan'] = ".skd";
    mimeStruct['application/x-koan'] = ".skm";
    mimeStruct['application/x-koan'] = ".skp";
    mimeStruct['application/x-koan'] = ".skt";
    mimeStruct['application/smil'] = ".smi";
    mimeStruct['application/smil'] = ".smil";
    mimeStruct['audio/basic'] = ".snd";
    mimeStruct['application/solids'] = ".sol";
    mimeStruct['application/x-futuresplash'] = ".spl";
    mimeStruct['application/x-wais-source'] = ".src";
    mimeStruct['application/STEP'] = ".step";
    mimeStruct['application/SLA'] = ".stl";
    mimeStruct['application/STEP'] = ".stp";
    mimeStruct['application/x-sv4cpio'] = ".sv4cpio";
    mimeStruct['application/x-sv4crc'] = ".sv4crc";
    mimeStruct['application/x-shockwave-flash'] = ".swf";
    mimeStruct['application/x-troff'] = ".t";
    mimeStruct['application/x-tar'] = ".tar";
    mimeStruct['application/x-tcl'] = ".tcl";
    mimeStruct['application/x-tex'] = ".tex";
    mimeStruct['application/x-texinfo'] = ".texi";
    mimeStruct['application/x-texinfo'] = ".texinfo";
    mimeStruct['image/tiff'] = ".tif";
    mimeStruct['image/tiff'] = ".tiff";
    mimeStruct['application/x-troff'] = ".tr";
    mimeStruct['audio/TSP-audio'] = ".tsi";
    mimeStruct['application/dsptype'] = ".tsp";
    mimeStruct['text/tab-separated-values'] = ".tsv";
    mimeStruct['text/plain'] = ".txt";
    mimeStruct['application/i-deas'] = ".unv";
    mimeStruct['application/x-ustar'] = ".ustar";
    mimeStruct['application/x-cdlink'] = ".vcd";
    mimeStruct['application/vda'] = ".vda";
    mimeStruct['video/vnd.vivo'] = ".viv";
    mimeStruct['video/vnd.vivo'] = ".vivo";
    mimeStruct['model/vrml'] = ".vrml";
    mimeStruct['audio/x-wav'] = ".wav";
    mimeStruct['model/vrml'] = ".wrl";
    mimeStruct['image/x-xbitmap'] = ".xbm";
    mimeStruct['application/vnd.ms-excel'] = ".xlc";
    mimeStruct['application/vnd.ms-excel'] = ".xll";
    mimeStruct['application/vnd.ms-excel'] = ".xlm";
    mimeStruct['application/vnd.ms-excel'] = ".xls";
    mimeStruct['application/vnd.ms-excel'] = ".xlw";
    mimeStruct['text/xml'] = ".xml";
    mimeStruct['image/x-xpixmap'] = ".xpm";
    mimeStruct['image/x-xwindowdump'] = ".xwd";
    mimeStruct['chemical/x-pdb'] = ".xyz";
    mimeStruct['application/zip'] = ".zip";
    if(structKeyExists(mimeStruct,arguments.mimetype)) {
      return mimeStruct[arguments.mimetype];
    } else {
      return ".tmp";
    }
}
function friendlyUrl(title) {
    title = trim(title);
    title = replaceNoCase(title,"&amp;","and","all"); //replace &amp;
    title = replaceNoCase(title,"&","and","all"); //replace &
    title = replaceNoCase(title,"'","","all"); //remove apostrophe
    title = reReplaceNoCase(trim(title),"[^a-zA-Z0-9]","","ALL");
    return lcase(title);
}
function replaceWhiteSpace (str) {
	return ReplaceNoCase(str," ","","ALL");
}
</cfscript>
</cfcomponent>