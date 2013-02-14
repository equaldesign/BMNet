
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="wikiParser" inject="coldbox:plugin:WikiText">
  <cfproperty name="SiteService" inject="id:bv.SiteService">
  <cfproperty name="shoppingService" inject="id:bv.aws.shopping" />
  <cfproperty name="templateCache" inject="cachebox:template" />

  <cffunction name="updateNotifications" returntype="void" output="false">
    <cfargument name="event">
    <cfsetting requesttimeout="180">
    <cfset var rc = arguments.event.getCollection()>
    <cfset allPeople = userService.allPeople()>
    <cfset services = "site,comments,discussion,calendar,documentlibrary,wiki,links,datalists,subscriptions,profile">
    <cfloop array="#allPeople.people#" index="person">
      <!--- unset them from the following services: site, comments, discussion, calendar, documentlibrary, wiki, links, datalists, subscriptions, profile --->      
      <cfloop list="#services#" index="service">
        <cfquery name="a" datasource="alfresco">
          insert into alf_activity_feed_control
            (feed_user_id,app_tool,last_modified)
            VALUES
            (
              <cfqueryparam value="#person.email#" cfsqltype="cf_sql_varchar">,
              <cfqueryparam value="#service#" cfsqltype="cf_sql_varchar">,
              now()
            )
        </cfquery>
      </cfloop>
    </cfloop>    
    <cfabort>
    <cfset arguments.event.noRender()>
  </cffunction>

  <cffunction name="bbUpdate" returntype="void" output="false">
    <cfargument name="event">
    <cfsetting requesttimeout="980">
    <cfset var rc = arguments.event.getCollection()>
    <cfquery name="b" datasource="bvine">
      select * from brochureDownload;
    </cfquery>
    <cfloop query="b">
        <cfhttp port="80" resolveurl="true" getasbinary="auto" url="#uri#" result="doc"></cfhttp>        
        <cfif doc.statusCode eq "200 OK">
          <cfset localFileName = ListLast(uri,"/")>                
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
          <cfhttp port="8080" result="docUp" url="http://46.51.188.170/alfresco/service/bvine/docs/files/upload.json?alf_ticket=#request.buildingVine.admin_ticket#&title=#fileName#&niceFolder=Sites/#shortname#/documentLibrary/#folder#" method="post">
            <cfhttpparam type="file" name="file" file="#localFileName#">            
          </cfhttp>
        </cfif>
    </cfloop>      
    <cfabort>
    <cfset arguments.event.noRender()>
  </cffunction>

  <cffunction name="clearCacheKey">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.cacheKey = event.getValue("cacheKey","")>
    <cfif templateCache.lookup(rc.cacheKey)>
      <cfset templateCache.clear(rc.cacheKey)>
    </cfif>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="tbImport" returntype="void" output="false">
    <cfargument name="event">
    <cfif isDefined("cfthread_tbimport")>
      <cfthread action="terminate" name="tbimport">
        
      </cfthread>
    </cfif>
    <cfthread action="run" priority="LOW" name="tbimport" shoppingService="#shoppingService#" wikiParser="#wikiParser#" logger="#logger#">
      <Cfloop from="1" to="30000" index="l" step="1000">
        <cfsetting requesttimeout="199999">
        <cfquery name="tbdata" datasource="bvine">
          select 
            tbtemp.eancode, 
            CASE WHEN tbtemp.eancode is NULL THEN tbtemp2.suppliercode ELSE tbtemp.suppliercode END as suppliercode,
            REPLACE((CASE WHEN tbtemp.eancode is NULL THEN tbtemp2.productname ELSE tbtemp.description END),'  ','') as description,
            CASE WHEN tbtemp.eancode is NULL THEN tbtemp2.priceunit ELSE tbtemp.priceunit END as priceunit,
            CASE WHEN tbtemp.eancode is NULL THEN tbtemp2.poum ELSE tbtemp.pricequnt END as pricequnt,
            CASE WHEN tbtemp.eancode is NULL THEN CONCAT('http://images.toolbank.com/images/extralarge/',RTRIM(REPLACE(tbtemp2.suppliercode,'/','-')),'.jpg') ELSE tbtemp.imgurl END  as imgurl
          from 
            tbtemp2 
          LEFT JOIN tbtemp on tbtemp.suppliercode = tbtemp2.suppliercode
          limit #l#,1000
        </cfquery>
        <cfset logger.debug("Starting.... #tbdata.recordCount# rows to process...")>
        <cfset productArray = []>
        <cfloop query="tbdata">
          <cfset logger.debug("Processing row #l# #tbdata.currentRow#")>
          <cftry>
          <cfset product = {}>
          <cfset imageDir = UCASE(Left(suppliercode,1))>
          <cfset product["imageSearchNames"] = []>
          <cfset product["documentSearchNames"] = []>
          <cfset product["imageNodeRefs"] = []>
          <cfset product["documentNodeRefs"] = []>
          <cfset product["productData"] = {}>
          <cfset product["customData"] = {}>
          <cfset product["productData"]["eancode"] = ToString(eancode)>
          <cfset product["category"] = "Uncategorised/#UCASE(Left(description,1))#">
              
          <cfset product["productData"]["supplierproductcode"] = trim(ToString(suppliercode))>
          
          <!--- we need to download the image, upload it, and then get the nodeRef --->
          <cfhttp port="80" resolveurl="true" getasbinary="auto" url="#imgurl#" result="im" useragent="Googlebot/2.1 (+http://www.google.com/bot.html)"></cfhttp>
          <cfif im.statusCode eq "200 OK">          
            <cfset localFIleName = ListLast(imgurl,'/')>          
            <cffile action="write" file="/tmp/#localFileName#" output="#im.fileContent#">
            <cfif listLast(localFileName,".") eq "tmp">
              <cfset mime = getPageContext().getServletContext().getMimeType("/tmp/#localFileName#")>
              <cfset mimExt = getMimeTypeExtension(mime)>
              <cffile action="move" source="/tmp/#localFileName#" destination="/tmp/#ListFirst(localFileName,'.')##mimExt#">
              <cfset localFileName = "/tmp/#ListFirst(localFileName,'.')##mimExt#">          
            <cfelse>
              <cfset localFileName = "/tmp/#localFileName#">          
            </cfif>
            <cfset myImage = ImageRead(localFileName)>
            <cfset ImageCrop(myImage,3,3,myImage.width-6,myImage.height-6)>
            <cfset ImageWrite(myImage,localFileName)>
            <cfhttp username="admin" password="bugg3rm33" port="8080" result="imageUp" url="http://46.51.188.170/alfresco/service/bvine/docs/files/upload.json?niceFolder=Sites/curtisholt/documentLibrary/Product%20Information/Product%20Images/#imageDir#" method="post">
              <cfhttpparam type="file" name="file" file="#localFileName#">
            </cfhttp>
            <cfset ImgRes = DeSerializejson(imageUp.fileContent)>              
            <cfset ArrayAppend(product["imageNodeRefs"],ImgRes.nodeRef)>
          </cfif>
          <!--- lets try to get amazon data, as it's much better --->
          <cfset product["productData"]["productname"] = trim(ToString(description))>  
          <cfif eancode neq "">
            <cfset lookupKey = eancode>
          <cfelse>
            <cfset lookupKey = suppliercode>
          </cfif>
          <cfset amazon = shoppingService.amazonResults(lookupKey)>        
          <cfif amazon.mainproduct.ItemSearchResponse.items.TotalResults.xmlText neq "0">                 
            <cfset item = amazon.mainproduct.ItemSearchResponse.items.item>
            <cfif isDefined("item.ItemAttributes.Title.xmlText")>
              <cfset product["productData"]["productname"] = item.ItemAttributes.Title.xmlText>  
            </cfif>
            <cfif isDefined("item.ItemAttributes.Binding.xmlText")>

              <cfset product["category"] = "#xmlFormat(item.ItemAttributes.ProductGroup.xmlText)#/#xmlFormat(item.ItemAttributes.ProductTypeName.xmlText)#/#xmlFormat(item.ItemAttributes.Brand.xmlText)#">
            </cfif>
            <cfif isDefined("item.ItemAttributes.Brand.xmlText")>
              <cfset product["productData"]["manufacturerbrandname"] = item.ItemAttributes.Brand.xmlText>
            </cfif>
            <cfif isDefined("item.ItemAttributes.Brand.xmlText")>
              <cfset product["productData"]["manufacturerbrandname"] = item.ItemAttributes.Brand.xmlText>
            </cfif>
            <cfif isDefined("item.ItemAttributes.ListPrice.Amount.xmlText")>
              <cfif item.ItemAttributes.ListPrice.Amount.xmlText gt 0>
                <cfset product["productData"]["RRP"] = item.ItemAttributes.ListPrice.Amount.xmlText/100>  
              </cfif>            
            </cfif>
            <cfif isDefined("item.ItemAttributes.EAN.xmlText") AND item.ItemAttributes.EAN.xmlText neq "">
              <cfset product["productData"]["eancode"] = item.ItemAttributes.EAN.xmlText>
            </cfif>
            <cfif isDefined("item.ItemAttributes.ItemDimensions.Weight.xmlText")>
              <cfset product["productData"]["unitweight"] = item.ItemAttributes.ItemDimensions.Weight.xmlText>
              <cfif item.ItemAttributes.ItemDimensions.Weight.XMLAttributes.Units eq "hundredths-pounds">
                <!--- a gram is 4.53 --->
                <cfif item.ItemAttributes.ItemDimensions.Weight.xmlText neq "0">
                  <cfset grams = item.ItemAttributes.ItemDimensions.Weight.xmlText*4.53592>
                  <cfset grams = DecimalFormat(grams/1000)> 
                  <cfset product["productData"]["unitweight"] = grams>
                </cfif>
              </cfif>
            </cfif>
            <cfif isDefined("item.EditorialReviews.EditorialReview.Content.xmlText")>            
              <cfset product["productData"]["productdescription"] = wikiParser.toWiki("WIKIPEDIA",item.EditorialReviews.EditorialReview.Content.xmlText)>
            </cfif>
          </cfif>  
          <cfif product["productData"]["eancode"] neq "">
            <cfset product["fileName"] = "#hash(product['productData']['eancode'])#.json">
          </cfif>  
          <cfif NOT StructKeyExists(product,"filename")>
            <cfset product["fileName"] = "#hash(product['productData']['supplierproductcode'])#.json">
          </cfif>    
          <cfset arrayAppend(productArray,product)>
          
          <cfcatch type="any">
            <cfset logger.debug("#cfcatch.message# #cfcatch.detail#")>
          </cfcatch>
          </cftry>  
        </cfloop>
        <cfset jsonObject = {}>
        <cfset jsonObject["products"] = productArray>
        <!--- now serialize the json object and send it to alfresco --->
        <cfset js = SerializeJSON(jsonObject)>
        <cffile action="write" file="/tmp/test" output="#js#">
        <cfhttp username="admin" password="bugg3rm33" timeout="9000" result="importImages" port="8080" method="post" url="http://46.51.188.170/alfresco/service/bv/product?siteID=curtisholt">
          <cfhttpparam type="header" name="content-type" value="application/json">
          <cfhttpparam type="body" name="json" value="#js#">
        </cfhttp>    
        <cfthread action="sleep" duration="50000" />    
      </Cfloop>
    </cfthread>
    <cfset arguments.event.noRender()>
  </cffunction>

  <cffunction name="doStockists">
    <cfargument name="event">
    <Cfsetting requesttimeout="9000">
    <cfset SiteService.getAllLocaStockists()>
    <cfabort>
  </cffunction>

  <cffunction name="suggest" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset event.setView("web/suggest/index")>
  </cffunction>

  <cffunction name="eGroupUserCreation" returntype="void">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.id = arguments.event.getValue("id",0)>
    <cfset userService.setUpIntranetUser(rc.id)>
    <cfset arguments.event.setView(name="web/signup/complete")>
  </cffunction>
</cfcomponent>