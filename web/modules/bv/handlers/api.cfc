<cfcomponent name="api" cache="true">
  <cfproperty name="logger" inject="logbox:root">
  <cfproperty name="shoppingService" inject="id:bv.aws.shopping" />
  <cfproperty name="ProductService" inject="id:bv.ProductService" />
  <cfproperty name="templateCache" inject="cachebox:template" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage">
  <cfproperty name="userService" inject="id:bv.UserService">

  <cfscript>
    this.name = "s3test";
    this.s3.accessKeyid = "AKIAJ7KY7OTQMJ4QN24Q";
    this.s3.awsSecretKey = "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";
    this.s3.defaultLocation="bvcache";
  </cfscript>

  <cffunction name="gt" returntype="any">
    <cfargument name="event">
    <cfset rc = event.getCollection()>
    <cfhttp url="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.e)))#?size=#rc.size#&d=#urlEncodedFormat(rc.d)#" getasbinary="yes" result="gravatar"></cfhttp>    
    <cfcontent variable="#gravatar.fileContent#" type="image/jpeg">
    <cfset event.norender()>
  </cffunction>

  <cffunction name="resizeBVImage" returntype="any">
    <cfargument name="imageObject" required="true" type="any"> 
    <cfargument name="width" required="true">
    <cfargument name="height" required="true">
    <cfargument name="quality" required="true">
    <cfargument name="crop" required="true">
    <cfargument name="cropAspect" required="true">
    <cfargument name="cropx" required="true" default="center">
    <cfargument name="cropy" required="true" default="center">
    <cfset var local = {}>
    <cfset local.fileName = "/tmp/#createUUID()#.jpg" />
    <cfset local.outputfileName = "/tmp/#createUUID()#.jpg" />
    <cfset local.objectImage = arguments.imageObject>
    <cffile action="write" file="#local.fileName#" output="#local.objectImage#">
    
    <cftry>
    <cfif arguments.crop>
      <cfset local.aspect = ListLast(arguments.cropAspect,":")/ListFirst(arguments.cropAspect,":")>
      
        <cfset arguments.height = arguments.width*local.aspect>
  
      <cfif isNumeric(arguments.cropx) AND isNumeric(arguments.cropy)>
         <cfset local.imageMagickArguments = '"#local.fileName#" -resize "#arguments.width#x#arguments.height#^" -quality 90 -crop #arguments.width#x#arguments.height#+#arguments.cropx#+#arguments.cropy# +repage "#local.outputfileName#"'>         
         <cfexecute name="/usr/local/bin/convert" arguments='#local.imageMagickArguments#' timeout="4" />
      <cfelse> 
        <cfset local.imageMagickArguments = '"#local.fileName#" -resize "#arguments.width#x#arguments.height#^" -gravity center -crop #arguments.width#x#arguments.height#+0+0 +repage -quality 90 "#local.outputfileName#"'>
        
         <cfexecute name="/usr/local/bin/convert" arguments='#local.imageMagickArguments#' timeout="4"  />
      </cfif>
    <cfelse>
       <cfset local.imageMagickArguments = '"#local.fileName#" -resize "#arguments.width#" -quality 90 +repage "#local.outputfileName#"'>
       <cfexecute name="/usr/local/bin/convert" arguments='#local.imageMagickArguments#' timeout="4"/>      
    </cfif> 
    <cfcatch type="any">      
      
    </cfcatch>
    </cftry>
    <cfreturn local.outputfileName>
  </cffunction>


  <cffunction name="viewItem" returntype="void">
    <cfargument name="event" required="true"> 
    <cfset var rc = event.getCollection()>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.returnType = event.getValue("returnType","image")>
    <cfset rc.itemURL = event.getValue("/","")>
    <cfset rc.itemType = event.getValue("itemType","PRODUCT")>
    <cfset rc.itemName = event.getValue("itemName","")>
    <cfset rc.shortName = event.getValue("shortName","")>
    <cftry>
      <cfset remoteAdd = GetHttpRequestData().headers['X-Forwarded-For']>
      <cfcatch type="any">
        <cfset remoteAdd = cgi.REMOTE_ADDR>
      </cfcatch>
    </cftry>
    <cfif ListLen(remoteAdd,",") gt 1>
      <cfset remoteAdd = ListFirst(remoteAdd)>
    </cfif>
    <cfhttp url="http://46.51.188.170/easyrec-web/api/1.0/view?itemurl=#rc.itemURL#&itemdescription=#rc.itemName#&apikey=efcfbd174579c7a25ca3e276f01f8529&tenantid=buildingvine&itemid=#rc.nodeRef#&itemtype=#rc.itemType#&sessionid=#cookie.cfid#" port="8080"></cfhttp>
    <cfquery name="bv" datasource="bvine">
      insert into visitorLog
        (siteID,nodeRef,itemType,ipAddress,referrer)
      VALUES
        (
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.shortName#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.nodeRef#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.itemType#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#remoteAdd#">,
          <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.HTTP_REFERER#">
        )
    </cfquery>
    <cfif rc.returnType eq "image">
      <cfcontent type="image/gif" file="/fs/sites/ebiz/resources/shim.gif">
      <cfset event.noRender()>
    <cfelse>
      <cfset event.renderData(data="",type="JSONP")>  
    </cfif>
  </cffunction>

  <cffunction name="logo" returntype="void">
  	<cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
	  <cfset rc.site = event.getValue("site","buildingVine")>
	  <cfif FileExists("#rc.app.appRoot#/includes/images/companies/#rc.site#/small.jpg")>
	    <cfcontent type="image/jpeg" file="#rc.app.appRoot#/includes/images/companies/#rc.site#/small.jpg">
		<cfelse>
			<cfcontent type="image/jpeg" file="#rc.app.appRoot#/includes/images/companies/buildersmerchant/small.jpg">
	  </cfif>
	  <cfset event.noRender()>
  </cffunction>

  <cffunction name="productImage" cache="true" access="public" returntype="void" output="true">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfsetting requesttimeout="20">
    <cfset var rc = event.getCollection()>
    <cfset var prc = event.getCollection(true)>
    <cfset var objImage = {}>
    <cfset var productImages = {}>
    <cfset prc.ticketCount = getTickCount()>
    <cfset prc.instance = createUUID()>
    <cfset logger.debug("API: Started #prc.instance#: #(getTickCount()-prc.tickCount)/1000#")>
    <cfset prc.id = event.getValue("id","")><!--- the image ID - for backwards compatability --->
    <cfset prc.size = event.getValue("size","medium")><!--- the size of the image, default to medium --->
    <cfset prc.crop = event.getValue("crop",false)>
    <cfset prc.cropAspect = event.getValue("aspect","4:3")>
    <cfset prc.cropx = event.getValue("cropx","center")>
    <cfset prc.cropy = event.getValue("cropy","center")>
    <cfset prc.blur = event.getValue("blur",0)>
    <cfset prc.bvsite = event.getValue("siteID","")><!--- the site for the image, to avoid grabbing anything incorrectly --->
    <cfset prc.force = event.getValue("f",true)><!--- force new image? --->
    <cfset prc.imageplaceholder = event.getValue("imageplaceholder","http://www.buildingvine.com/includes/images/api/errormedium.jpg")><!--- force new image? --->
    <cfset prc.quality = event.getValue("quality","highestQuality")>
    <cfset prc.key = event.getValue("key","")><!--- the API key --->
    <cfset prc.nodeRef = event.getValue("nodeRef","")><!--- we have a nodeRef? awsome! --->
    <cfset prc.categoryNodeRef = event.getValue("categoryNodeRef","")><!--- a category noderef; used for BV only, no external API support --->
    <cfset prc.alf_ticket = event.getValue("ticket","")> <!--- an passed in alf ticket --->
    <!--- some defaults --->
    <cfset prc.hasImage = false>
    <cfset prc.title = "speng">
	  <cfset prc.searchAmazon = true>
    <cfset prc.watermark = false>
    <cfset prc.error = false>
    
    <cfset logger.debug("API: Starting Try #prc.instance# : #(getTickCount()-prc.tickCount)/1000#")>
    
	  <!--- let's start the logic --->
    <cfif prc.alf_ticket eq ""><!--- if they haven't passed in an alf ticket --->
      <cfif prc.key eq ""><!--- if they haven't passed in a key TODO: remove this as everyone should pass in a key --->
        <cfset prc.alf_ticket = request.buildingVine.admin_ticket><!--- get the standard alf ticket --->
      <cfelse>
        <cfset userStruct = DeSerializeJSON(urlDecrypt(prc.key))><!--- deconstruct the key which is an encrypted username/password in JSON --->
        <cfset prc.alf_ticket = userService.getTicket(userStruct.username,userStruct.password)><!--- grab a ticket from this struct --->
      </cfif>
    </cfif>
    <cfif NOT isNumeric(prc.size)><!--- image is one of three sizes --->
      <cfswitch expression="#prc.size#">
        <cfcase value="small"><!--- they want a small image, which is 100 wide or 100 tall maximum --->
          <cfset prc.width = 100>
          <cfset prc.height = 100>
        </cfcase>
        <cfcase value="medium"><!--- they want a medium image, which is 100 wide or 100 tall maximum --->
          <cfset prc.width = 300>
          <cfset prc.height = 300>
        </cfcase>
        <cfcase value="large"><!--- they want a large image, which is 800 wide or 800 tall maximum --->
          <cfset prc.width = 800>
          <cfset prc.height = 800>
        </cfcase>
        <cfdefaultcase><!--- they passed in a size which we don't support; RTFM! --->
          <cfset prc.width = 100>
          <cfset prc.height = 100>
        </cfdefaultcase>
      </cfswitch>
    <cfelse><!--- they've passed in a numerical size --->
      <cfif prc.size gt 2000><!--- 1000 is the max, if they want bigger than that, tough! --->
        <cfset prc.size = 2000>
      </cfif>
      <cfif prc.size lt 10><!--- they want an image smaller than 10 pixels? get real! --->
        <cfset prc.size = 10>
      </cfif>
      <cfset prc.width = prc.size> <!--- set the width to be the pixel size --->
	    <cfset prc.height = prc.size><!--- set the height to be the pixel size --->
      <cfif prc.size LT 100><!--- if the size is less than 100, then get the alf thumbnail which is "small", no point getting anything bigger --->
        <cfset prc.size = "medium">
      <cfelseif prc.size GT 500><!--- if the size is bigger than 500 pixels, get the alf thumbnail which is "large" --->
        <cfset prc.size = "large">
        <cfset prc.imageSize = "large">
      <cfelse><!--- it's in between 100 and 500, so use the "medium" thumbnail --->
        <cfset prc.size = "medium">
        <cfset prc.imageSize = "medium">
      </cfif>
    </cfif>
    <cfset prc.debugu = event.getValue("debugu",false)><!--- are we debuggin'? --->
		<cfset prc.eanCode = event.getValue("eancode","")><!--- the passed in EAN code --->
		<cfif prc.id eq "" and prc.eanCode neq ""><!--- we used to use ID as the EAN, this is for backwards compatability --->
  		<cfset prc.id = prc.eanCode>
		</cfif>
    <cfset prc.productCode = URLEncodedFormat(event.getValue("productCode",""))><!--- the product code. Drop support for this eventually --->
    <cfset prc.merchantCode = URLEncodedFormat(event.getValue("merchantCode",""))><!--- the merchant code - for merchant specific images. Drop support for this eventually --->
    <cfset prc.supplierproductcode = URLEncodedFormat(event.getValue("supplierproductcode",""))><!--- the supplier product code --->
    <cfset prc.manufacturerproductcode = URLEncodedFormat(event.getValue("manufacturerproductcode",""))><!--- the manufacturer product code --->
	  <cfset prc.productName = URLEncodedFormat(event.getValue("productName",""))><!--- the product name, loose matching, use with caution! --->
    <cfset ref = Replace(cgi.HTTP_REFERER,"http://","","ALL")><!--- the referring URL/domain. Hit and miss here, but we have no choice --->
    <cfset ref = Replace(cgi.HTTP_REFERER,"https://","","ALL")><!--- strip the http/https --->
    <cfset refL = ListToArray(ref,"/")><!--- the url as an array --->
    <cftry>
	    <cfset prc.referrer = refL[1]><!--- this should be the TLD --->
      <cfcatch type="any"><!--- if something goes wrong, fall back to buildingvine.com as the referrer --->
        <cfset prc.referrer = "www.buildingvine.com">
        <cfset logger.debug("referrer error: #cgi.HTTP_REFERER# #prc.referrer# #cfcatch.message#")>
      </cfcatch>
    </cftry>
    <cfif cgi.server_port_secure && cgi.server_port_secure><!--- we want to ensure we redirect to the correct cloudfront type (otherwise we'd server non-secure content to a secure site. HTTPS has extra overhead, so we don't want to use this unless we really need to. --->
      <cfset prc.rootType = "https">
    <cfelse>
      <cfset prc.rootType = "http">
    </cfif>
    <cfif prc.referrer eq "www.buildingvine.com"><!--- if it's a building vine referrer - watermark the image --->
        <cfset prc.watermark = true>
    </cfif>
		<cfset prc.mimeType = "image/jpeg"><!--- set the mime/type - we always export as jpeg regardless of the input format of the image --->
	  <cfif prc.nodeRef eq ""><!--- we don't have a nodeRef, so we need to do a search --->
		  <cfset prc.imURL = "http://10.50.14.61/alfresco/service/buildingvine/api/productSearch.json?categoryNodeRef=#prc.categoryNodeRef#&size=#prc.size#&eanCode=#prc.id#&supplierProductCode=#prc.supplierProductCode#&manufacturerCode=#prc.manufacturerProductCode#&merchantCode=#prc.merchantCode#&mimetype=#URLEncodedFormat(prc.mimeType)#&productName=#prc.productName#">
	  <cfelse><!--- we have a nodeRef, just grab the thumbail --->
      <cfset prc.imURL = "http://10.50.14.61/alfresco/service/api/node/workspace/SpacesStore/#prc.nodeRef#/content/thumbnails/#prc.size#?ph=true&c=force">
    </cfif>
    <cfset prc.imagekey = hash(toString(serializeJSON(prc)))>
    <!--- now do the search or grab the thumbnail --->      
    <cfset logger.debug("API: Getting from Alfresco #prc.instance# : #(getTickCount()-prc.tickCount)/1000#")>
    <cfhttp username="admin" password="bugg3rm33" port="8080" getasbinary="auto" redirect="true" url="#prc.imURL#" result="productImages" timeout="20"></cfhttp>
    <cfset logger.debug("API: Download from Alfresco #prc.instance# : #(getTickCount()-prc.tickCount)/1000#")>
    
    <cfif isBinary(productImages.fileContent)><!--- we have a binary result - which means an image --->
      <!--- create a UUID fileName --->
      <cfset sFileName = "#createUUID()#">

        <cftry>
		    <cfheader name="expires" value="#GetHttpTimeString(dateAdd('m',1,now()))#"><!--- set a nice cache expiry header for well behaved caches --->
        <cfheader name="cache-control" value="public"><!--- add some cache control headers for good measure --->
        <cfset objImage = productImages.fileContent>            
        <cfset objImage = resizebvimage(objImage,prc.width,prc.height,prc.quality,prc.crop,prc.cropAspect,prc.cropx,prc.cropy)>
        <cfset logger.debug("API: Resized Image #prc.instance#: #(getTickCount()-prc.tickCount)/1000#")>
        <cfif prc.blur neq 0>
          <cfset ImageBlur(objImage,prc.blur)>
        </cfif>          
        
        <cfcontent type="image/jpeg" file="#objImage#">
        <cfabort>            
        <cffile action="copy" source="#objImage#" destination ="/bvcache/#prc.imageKey#.jpg" nameconflict="overwrite"><!--- save the image to S3 --->
        <cfset logger.debug("API: Copied Image #prc.instance#: #(getTickCount()-prc.tickCount)/1000#")>
        <cfif NOT prc.debugu>
          <cfcontent type="image/jpeg" file="/bvcache/#prc.imageKey#.jpg">            
        </cfif>
        <cfcatch type="any">
        <cfset logger.debug("API: Error: #prc.instance#: #cfcatch.message#")>
        </cfcatch>
        </cftry>
	    </cfif>
      <!--- no BV image, but what about amazon? Let's try them --->
      <cfif prc.eanCode neq "" AND prc.searchAmazon><!--- only do this for products with an EAN, anything else is too unreliable. Also, we want the ability to disable this feature easily. --->
        <cfset amazonResults = shoppingService.amazonResults(prc.eanCode)>
        <cfif isDefined("amazonResults.ItemSearchResponse.Items.item")>
          <cfif arrayLen(amazonResults.ItemSearchResponse.Items.item) gte 1>
            <cfset amazonItem = amazonResults.ItemSearchResponse.Items.item[1]>
            <cfif isDefined("amazonItem.LargeImage.URL") AND isValid("URL",amazonItem.LargeImage.URL.xmlText)>
               <cfhttp getasbinary="auto" redirect="true" url="#amazonItem.LargeImage.URL.xmlText#" result="productImages"></cfhttp>
               <cfset sFileName = "#createUUID()#">
               <cfset objImage = productImages.fileContent>

              <cfset perm = structnew()>
              <cfset perm.group = "all">
              <cfset perm.permission = "read">
              <cfset perm1 = structnew()>
              <cfset perm1.email = "tom.miller@ebiz.co.uk">
              <cfset perm1.permission = "FULL_CONTROL">
              <cfset myarrray = arrayNew(1)>
              <cfset myarrray = [perm,perm1]>
              <cfheader name="expires" value="#GetHttpTimeString(dateAdd('m',1,now()))#">
              <cfheader name="cache-control" value="public">
               <cfif fileExists("/bvcache/#prc.imageKey#.jpg")>
                 <cfset fileInfo = GetFileInfo("/bvcache/#prc.imageKey#.jpg")>
                 <cfif DateCompare(DateAdd("d",now(),-1),fileInfo.Lastmodified,"d") lte 0>
                  <cfif NOT prc.debugu>
                    <cflocation url="#prc.roottype#://http://drw4snv3q2fw8.cloudfront.net/#prc.imageKey#.jpg" />
                  </cfif>
                 <cfelse>
                   <cffile action="delete" file="/bvcache/#prc.imageKey#.jpg">
                 </cfif>
               </cfif>
               <cffile action="write" output="#objImage#" file="/bvcache/#prc.imageKey#.jpg" nameconflict="overwrite">                 
               <cfif NOT prc.debugu>
                <cfcontent type="image/jpeg" file="/bvcache/#prc.imageKey#.jpg"><!--- output this via cfcontent --->
                <!--- <cflocation url="#prc.roottype#://drw4snv3q2fw8.cloudfront.net/#prc.imageKey#.jpg" addtoken="false" /> --->
               </cfif>
               
            </cfif>
          </cfif>
        </cfif>
      </cfif>
      <cfif NOT prc.debugu><!--- if we get here, we haven't found anything. However if we're debugging, we want to skip this to see the debug view --->
        <cfheader name="expires" value="#GetHttpTimeString(DateAdd('d',1,now()))#"><!--- set the cache for 15 mins --->
        <cfheader name="cache-control" value="public">
        <cfheader statuscode="307" statustext="Moved Temp"><!--- set a temporary HTTP code - we want spiders to come back --->
        <cfhttp url="#prc.imageplaceholder#" result="holdingImage" getasbinary="auto"></cfhttp>
        <cfset objImage = holdingImage.fileContent>          
        <cfset objImage = resizebvimage(objImage,prc.width,prc.height,prc.quality,prc.crop,prc.cropAspect,prc.cropx,prc.cropy)>
        <cfset logger.debug("API: Resized Holding #prc.instance#: #(getTickCount()-prc.tickCount)/1000#")>
        <cfset perm = structnew()>
        <cfset perm.group = "all">
        <cfset perm.permission = "read">
        <cfset perm1 = structnew()>
        <cfset perm1.email = "tom.miller@ebiz.co.uk">
        <cfset perm1.permission = "FULL_CONTROL">
        <cfset myarrray = arrayNew(1)>
        <cfset myarrray = [perm,perm1]>
        <cfif NOT fileExists("/bvcache/error#prc.size#_#URLEncodedFormat(prc.imageplaceholder)#.jpg")><!--- this image already exists in S3 --->
           <cffile action="copy" source="#objImage#" destination="/bvcache/error#prc.size#_#URLEncodedFormat(prc.imageplaceholder)#.jpg" nameconflict="overwrite"><!--- save the image to S3 --->
        </cfif>
        
        <cfif NOT prc.debugu>
          <cfcontent type="image/jpeg" file="/bvcache/#prc.imageKey#.jpg">            
        </cfif>
        
      </cfif>      
    <cfset event.setView('api/image',true)>
  </cffunction>

  <cffunction name="getProductMeta" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
	  <cfset var returnJSON = {}>
    <cfset rc.key = event.getValue("key","ewrw")>
    <cfset rc.eanCode = event.getValue("eancode","")>
    <cfset rc.jsoncallback = event.getValue("callback","")>
    <cfset rc.productCode = URLEncodedFormat(event.getValue("productCode",""))>
    <cfset rc.merchantCode = URLEncodedFormat(event.getValue("merchantCode",""))>
    <cfset rc.supplierproductcode = URLEncodedFormat(event.getValue("supplierproductcode",""))>
    <cfset rc.manufacturerproductcode = URLEncodedFormat(event.getValue("manufacturerproductcode",""))>
    <cfset rc.productName = URLEncodedFormat(event.getValue("productName",""))>
	  <cfset rc.nodeID = event.getValue("nodeRef","")>
    <cfset event.setLayout("Layout.ajax")>
    <cfset rc.error = false>
	  <cfif rc.nodeID eq "">
      <cfset nodeSearchURL = "http://www.buildingvine.com/alfresco/service/bvine/products/nodeSearch?eancode=#rc.eancode#&supplierProductCode=#rc.supplierProductCode#&manufacturerProductCode=#rc.manufacturerproductcode#&productName=#rc.productName#">
      <cfhttp username="admin" password="bugg3rm33" getasbinary="never" url="#nodeSearchURL#" result="products"></cfhttp>
      <cfset productList = DeSerializeJSON(products.fileContent)>
	  </cfif>
    <cfif rc.nodeID neq "" OR (isArray(productList.items) AND arrayLen(productList.items) gte 1)>
	    <cfif rc.nodeID eq "">
	      <cfset rc.productID = Replace(productList.items[1],":/","","ALL")>
	      <cfset rc.nodeID = ListLast(rc.productID,"/")>
		  <cfelse>
		    <cfset rc.productID = "workspace://spacesStore/#rc.nodeID#">
		  </cfif>
      <cfset returnJSON["output"] = ProductService.productDetail(rc.nodeID)>
	    <cfhttp username="admin" password="bugg3rm33" getasbinary="never" url="http://www.buildingvine.com/alfresco/service/api/node/#rc.productID#/ratings" result="ratings"></cfhttp>
	    <cfhttp username="admin" password="bugg3rm33" getasbinary="never" url="http://www.buildingvine.com/alfresco/service/api/node/#rc.productID#/comments" result="comments"></cfhttp>
	    <cfset returnJSON["nodeRef"] = rc.nodeID>
	    <cfset rc.ratings = DeSerializeJSON(ratings.fileContent)>
	    <cfset rc.comments = DeSerializeJSON(comments.fileContent)>
		  <cfset returnJSON["ratings"] = rc.ratings>
	    <cfset event.renderData(data=returnJSON,type="JSONP",jsonCallback=rc.jsoncallback)>
    <cfelse>
      <cfset event.renderData(data={},type="JSONP",jsonCallback=rc.jsoncallback)>
    </cfif>
  </cffunction>

  <cffunction name="productList" cache="true" access="public" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.key = event.getValue("key","")>
    <cfset request.user_ticket = event.getValue("ticket","")>
    <cfif request.user_ticket eq "">
      <cfif rc.key eq "">
        <cfset request.user_ticket = UserStorage.getVar("guest_ticket","")>
      <cfelse>
        <cfset userStruct = DeSerializeJSON(urlDecrypt(rc.key))>
        <cfset request.user_ticket = userService.getTicket(userStruct.username,userStruct.password)>
      </cfif>
    </cfif>
    <cfset rc.siteID = event.getValue("siteID","")>
    <cfset rc.maxResults = event.getValue("maxResults","")>
    <cfset rc.startRow = event.getValue("startRow","")>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfset rc.sortOrder = event.getValue("sortOrder","")>
    <cfset rc.stylesheet = event.getValue("stylesheet","https://www.buildingvine.com/includes/style/products.css")>
    <cfset rc.javascript = event.getValue("javascript","https://www.buildingvine.com/includes/javascript/api/js.js")>
    <cfhttp url="http://www.buildingvine.com/alfresco/service/bv/products.#rc.format#?siteid=#rc.siteID#&maxrows=#rc.maxResults#&startRow=#rc.startRow#&nodeRef=#rc.nodeRef#&sortOrder=#rc.sortOrder#&alf_ticket=#request.user_ticket#" method="get" result="p"></cfhttp>
    <cfif rc.format eq "html">
      <cfsavecontent variable="headerInfo">
        <cfoutput>
        <html>
        <head>
        <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
        <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.3/jquery-ui.js"></script>
        <script src="#rc.javascript#" type="text/javascript" language="javascript"></script>
        <link href="#rc.stylesheet#" rel="stylesheet">
        </head>
        <body>
        #p.fileContent#
        </body>
        </html>
        </cfoutput>
      </cfsavecontent>
      <cfset rc.data = headerInfo>
    <cfelse>
      <cfset rc.data = p.fileContent>
    </cfif>
    <cfset event.renderData(data=rc.data,contentType="text/#rc.format#")>
  </cffunction>

  <cffunction name="detail" cache="true" access="public" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.key = event.getValue("key","")>
    <cfset request.user_ticket = event.getValue("ticket","")>
    <cfset rc.stylesheet = event.getValue("stylesheet","https://www.buildingvine.com/includes/style/products.css")>
    <cfset rc.javascript = event.getValue("javascript","https://www.buildingvine.com/includes/javascript/api/js.js")>
    <cfif request.user_ticket eq "">
      <cfif rc.key eq "">
        <cfset request.user_ticket = UserStorage.getVar("guest_ticket","")>
      <cfelse>
        <cfset userStruct = DeSerializeJSON(urlDecrypt(rc.key))>
        <cfset request.user_ticket = userService.getTicket(userStruct.username,userStruct.password)>
      </cfif>
    </cfif>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfhttp url="http://www.buildingvine.com/alfresco/service/bvine/product.#rc.format#?nodeRef=#rc.nodeRef#&alf_ticket=#request.user_ticket#" method="get" result="p"></cfhttp>
    <cfif rc.format eq "html">
      <cfsavecontent variable="headerInfo">
        <cfoutput>
        <html>
        <head>
        <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.5.2/jquery.min.js"></script>
        <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.7.3/jquery-ui.js"></script>
        <script src="#rc.javascript#" type="text/javascript" language="javascript"></script>
        <link href="#rc.stylesheet#" rel="stylesheet">

        </head>
        <body>
        #p.fileContent#
        </body>
        </html>
        </cfoutput>
      </cfsavecontent>
      <cfset rc.data = headerInfo>
    <cfelse>
      <cfset rc.data = p.fileContent>
    </cfif>
    <cfset event.renderData(data=rc.data,contentType="text/#rc.format#")>
  </cffunction>

  <cffunction name="product" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id","")>
    <cfset rc.size = event.getValue("size","medium")>
    <cfset rc.bvsite = event.getValue("siteID","")>
    <cfset rc.force = event.getValue("f",true)>
    <cfset rc.key = event.getValue("key","ewrw")>
    <cfset rc.hasImage = false>
    <cfset rc.title = "speng">
    <cfset rc.watermark = false>
    <cfif NOT isNumeric(rc.size)>
      <!--- set size to be default sizes --->
      <cfswitch expression="#rc.size#">
        <cfcase value="small">
          <cfset rc.width = 100>
        </cfcase>
        <cfcase value="medium">
          <cfset rc.width = 300>
        </cfcase>
        <cfcase value="large">
          <cfset rc.width = 800>
        </cfcase>
      </cfswitch>
    <cfelse>
      <cfif rc.size gt 1000>
        <cfset rc.size = 1000>
      </cfif>
      <cfif rc.size lt 10>
        <cfset rc.size = 10>
      </cfif>
      <cfset rc.width = rc.size>
    </cfif>
    <cfset rc.debugu = event.getValue("debugu",false)>
    <cfset rc.eanCode = event.getValue("eancode","")>
    <cfif rc.id eq "" and rc.eanCode neq "">
      <cfset rc.id = rc.eanCode>
    </cfif>
    <cfset rc.productCode = URLEncodedFormat(event.getValue("productCode",""))>
    <cfset rc.merchantCode = URLEncodedFormat(event.getValue("merchantCode",""))>
    <cfset rc.supplierproductcode = URLEncodedFormat(event.getValue("supplierproductcode",""))>
    <cfset rc.manufacturerproductcode = URLEncodedFormat(event.getValue("manufacturerproductcode",""))>
    <cfset rc.productName = URLEncodedFormat(event.getValue("productName",""))>
    <cfset ref = Replace(cgi.HTTP_REFERER,"http://","","ALL")>
    <cfset ref = Replace(cgi.HTTP_REFERER,"https://","","ALL")>
    <cfset refL = ListToArray(ref,"/")>
    <cftry>
      <cfset rc.referrer = refL[1]>
      <cfcatch type="any">
        <cfset rc.referrer = "www.buildingvine.com">
      </cfcatch>
    </cftry>
    <cfquery name="keyLookup" datasource="bvine" cachedWithin="#CreateTimeSpan(1,0,0,0)#">
      select apiKey from site where host RLIKE "(^|,)#rc.referrer#($|,)"
    </cfquery>
    <cfif rc.key eq keyLookup.apiKey>
      <cfset rc.error = false>
    <cfelse>
      <cfset rc.watermark = true>
      <cfif rc.referrer eq "www.buildingvine.com">
        <cfset rc.error = false>
      <cfelse>
        <cfset rc.error = true>
      </cfif>
    </cfif>
    <cfif rc.referrer eq "www.buildingvine.com">
        <cfset rc.watermark = true>
    </cfif>
    <cfswitch expression="#rc.format#">
      <cfcase value="jpg,jpeg,gif,png,bmp">
        <cfif rc.id neq "">
          <cfset rc.imageKey = "#rc.id#.#rc.format#">
        <cfelse>
          <cfset rc.imageKey = urlEncrypt("#rc.productCode##rc.merchantCode##rc.productName##rc.supplierproductcode##rc.manufacturerProductCode##rc.bvsite#.#rc.format#")>
        </cfif>
        <cfif rc.watermark>
          <cfset rc.imageKey = "#rc.imageKey#_water">
        </cfif>
        <cfif rc.width gt 300>
          <cfset rc.imageSize = "large">
        <cfelseif rc.width gt 100>
          <cfset rc.imageSize = "medium">
        <cfelse>
          <cfset rc.imageSize = "small">
        </cfif>
        <cfset rc.mimeType = "image/jpeg">
            <cfset imURL = "http://www.buildingvine.com/alfresco/service/buildingvine/api/productSearch.json?eanCode=#rc.id#&supplierProductCode=#rc.supplierProductCode#&manufacturerCode=#rc.manufacturerProductCode#&merchantCode=#rc.merchantCode#&mimetype=#URLEncodedFormat(rc.mimeType)#&productName=#rc.productName#">
            <cfset rc.imageURLD = imURL>
            <cfhttp url="#imURL#" result="productImages" username="admin" password="bugg3rm33" timeout="10"></cfhttp>
            <cfif rc.debugu>
              <cfset event.setLayout('www.buildingvine.com/Layout.ajax.debug')>
              <cfset event.setView('/api/image')>
            </cfif>
            <cfset images = DeserializeJSON(productImages.fileContent)>
            <cfset rc.images = images>
            <cfif isArray(images) AND arrayLen(images) gte 1>
               <!--- there's an image.
               We resize it, stick it in Amazon S3, then redirect to cloudfront.
               nginx will cache this page, so it shouldn't get accessed again for a week...
               --->
               <cfhttp username="admin" password="bugg3rm33" getasbinary="auto" url="http://www.buildingvine.com/alfresco/service/#images[1].thumbnailUrl##rc.imageSize#?ph=true&c=force" result="image"></cfhttp>
               <cftry>
               <cfset ImageScaleToFit(image.fileContent,"#rc.width#","","highestQuality ")>
               <cfset objImage = image.fileContent>
               <cfcatch type="any">
                <cfset objImage = image.fileContent>
                <cfset logger.debug("Error resizing image: #cfcatch.Detail#")>
               </cfcatch>
               </cftry>

               <cftry>
               <cfif rc.watermark>
                 <cfset objWatermark = ImageNew("#rc.app.appRoot#includes/images/secure/water_large.png") />
                 <cfset ImageScaleToFit(objWatermark,rc.width,"","highestQuality") />
                 <cfset ImageSetAntialiasing(objImage,"on") />
                 <cfset ImageSetDrawingTransparency(objImage,50) />
                 <cfset ImagePaste(objImage,objWatermark,((objImage.GetWidth()/2) - (objWatermark.GetWidth()/2)),((objImage.GetHeight()/2) - (objWatermark.GetHeight()/2))) />
               </cfif>
               <cfimage action="write" source="#objImage#" destination="/s3/#rc.imageKey#_#rc.width#.#rc.format#" overwrite="true">
               <cfcatch type="any">
                <cfset logger.debug("Error watermarking image: #cfcatch.Detail#")>
                  <cffile action="write" output="#objImage#" file="/s3/#rc.imageKey#_#rc.width#.#rc.format#">
                </cfcatch>
               </cftry>
               <cfset setNextEvent(uri="https://drw4snv3q2fw8.cloudfront.net/#rc.imageKey#_#rc.width#.#rc.format#")>
            </cfif>
        <cfset event.setView('/api/image',true)>
      </cfcase>
      <cfcase value="json,xml,csv">

      </cfcase>
    </cfswitch>

  </cffunction>

<cffunction name="productDetail" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id","")>
    <cfset rc.key = event.getValue("key","")>
    <cfset rc.callback = event.getValue("jsoncallback","")>
	  <cfset rc.nodeRef = event.getValue("nodeRef","")>
	  <cfset rc.alf_ticket = event.getValue("alf_ticket","")>
    <cfset rc.productCode = event.getValue("productCode","")>
    <cfset rc.merchantCode = URLEncodedFormat(event.getValue("merchantCode",""))>
    <cfset ref = Replace(cgi.HTTP_REFERER,"http://","","ALL")>
    <cfset refL = ListToArray(ref,"/")>
	 <cfif rc.alf_ticket eq ""><!--- if they haven't passed in an alf ticket --->
      <cfif rc.key eq ""><!--- if they haven't passed in a key TODO: remove this as everyone should pass in a key --->
        <cfset rc.alf_ticket = request.admin_ticket><!--- get the standard alf ticket --->
      <cfelse>
        <cfset userStruct = DeSerializeJSON(urlDecrypt(rc.key))><!--- deconstruct the key which is an encrypted username/password in JSON --->
        <cfset rc.alf_ticket = userService.getTicket(userStruct.username,userStruct.password)><!--- grab a ticket from this struct --->
      </cfif>
    </cfif>
    <cfif rc.nodeRef eq ""><!--- we don't have a nodeRef, so we need to do a search --->
      <cfset rc.imURL = "http://www.buildingvine.com/alfresco/service/buildingvine/api/productSearchDetail.json?productCode=#rc.id#&supplierCode=#rc.productCode#*&merchantcode=#rc.merchantCode#*&mimetype=#URLEncodedFormat(rc.mimeType)#&alf_ticket=#rc.alf_ticket#">
    <cfelse><!--- we have a nodeRef, just grab the thumbail --->
      <cfset rc.imURL = "http://46.51.188.170/alfresco/service/bvine/product?nodeRef=#rc.nodeRef#&alf_ticket=#rc.alf_ticket#">
    </cfif>
    <cftry>
      <cfset rc.referrer = refL[1]>
      <cfcatch type="any">
        <cfset rc.referrer = "www.buildingvine.com">
      </cfcatch>
    </cftry>
    <cfquery name="keyLookup" datasource="bvine">
      select apiKey from site where host RLIKE "(^|,)#rc.referrer#($|,)"
    </cfquery>
    <cfif rc.key eq keyLookup.apiKey>
      <cfset rc.error = false>
    <cfelse>
      <cfif rc.referrer eq "www.buildingvine.com">
        <cfset rc.error = false>
      <cfelse>
        <cfset rc.error = true>
      </cfif>
    </cfif>
    <cfset rc.mimeType = "text/javascript">
    <cfhttp url="#rc.imUrl#" result="productDetail"></cfhttp>

    <cfset rc.product = DeserializeJSON(productDetail.fileContent)>
    <cfif isArray(rc.product) AND ArrayLen(rc.product) gte 1>
	    <cfset json = StructNew()>
	    <cfset json["html"] = renderLayout(rc.product[1].parent,rc.product[1].content)>
	    <cfset rc.json = serializeJSON(json)>
    <cfelse>
      <cfset rc.json = productDetail.fileContent>
    </cfif>
    <cfset event.setLayout('www.buildingvine.com/Layout.ajax.pure')>
    <cfset event.setView('api/jscript')>

  </cffunction>

  <cffunction name="rateProduct" access="public" returntype="void" output="false">
     <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.productID = event.getValue("productID","ewrw")>
    <cfset rc.rating = event.getValue("rating","")>
    <cfset rc.jsoncallback = event.getValue("callback","")>
    <cfset rc.ticket = event.getValue("ticket","")>
    <cfset event.setLayout("Layout.ajax")>
    <cfset rc.retVar = {}>
    <cfset rc.error = false>
    <cfif getAuthUser() neq "" OR (rc.ticket neq "" AND rc.ticket neq "undefined")>
      <cfset rc.retVar["loggedin"] = true>
      <cfset js = {}>
      <cfset js["rating"] = rc.rating>
      <cfset js["ratingScheme"] = "fiveStarRatingScheme">
      <cfhttp method="post" getasbinary="auto" url="http://www.buildingvine.com/alfresco/service/api/node/#rc.productID#/ratings?alf_ticket=#request.user_ticket#" result="ratings">
        <cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
      </cfhttp>
      <cfset event.setView("blank",true)>
    <cfelse>
      <cfset rc.retVar["loggedin"] = false>
      <cfset rc.target = "/login/externalThanks">
      <cfset event.setView("api/ratingLogin")>
    </cfif>
  </cffunction>

  <cffunction name="getProductRating" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.key = event.getValue("key","ewrw")>
    <cfset rc.eanCode = event.getValue("eancode","")>
    <cfset rc.jsoncallback = event.getValue("callback","")>
    <cfset rc.productCode = URLEncodedFormat(event.getValue("productCode",""))>
    <cfset rc.merchantCode = URLEncodedFormat(event.getValue("merchantCode",""))>
    <cfset rc.supplierproductcode = URLEncodedFormat(event.getValue("supplierproductcode",""))>
    <cfset rc.manufacturerproductcode = URLEncodedFormat(event.getValue("manufacturerproductcode",""))>
    <cfset rc.productName = URLEncodedFormat(event.getValue("productName",""))>
    <cfset event.setLayout("Layout.ajax")>
    <cfset rc.error = false>
    <cfset nodeSearchURL = "http://www.buildingvine.com/alfresco/service/bvine/products/nodeSearch?eancode=#rc.eancode#&supplierProductCode=#rc.supplierProductCode#&manufacturerProductCode=#rc.manufacturerproductcode#&productName=#rc.productName#">
    <cfhttp username="admin" password="bugg3rm33" getasbinary="never" url="#nodeSearchURL#" result="products"></cfhttp>
    <cfset productList = DeSerializeJSON(products.fileContent)>
    <cfif isArray(productList.items) AND arrayLen(productList.items) gte 1>
    <cfset rc.productID = Replace(productList.items[1],":/","","ALL")>
    <cfset rc.nodeID = ListLast(rc.productID,"/")>
    <cfhttp username="admin" password="bugg3rm33" getasbinary="never" url="http://www.buildingvine.com/alfresco/service/api/node/#rc.productID#/ratings" result="ratings"></cfhttp>
    <cfhttp username="admin" password="bugg3rm33" getasbinary="never" url="http://www.buildingvine.com/alfresco/service/api/node/#rc.productID#/comments" result="comments"></cfhttp>
    <cfset rc.ratings = DeSerializeJSON(ratings.fileContent)>
    <cfset rc.comments = DeSerializeJSON(comments.fileContent)>
    <cfset event.setView("api/rating")>
    <cfelse>
    <cfset event.setView("blank")>
    </cfif>
  </cffunction>


  <cffunction name="getAssociatedDocuments" access="public" returntype="void" output="false">
     <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset rc.key = event.getValue("key","ewrw")>
    <cfset rc.eanCode = event.getValue("eancode","")>
    <cfset rc.jsoncallback = event.getValue("callback","")>
    <cfset rc.productCode = URLEncodedFormat(event.getValue("productCode",""))>
    <cfset rc.merchantCode = URLEncodedFormat(event.getValue("merchantCode",""))>
    <cfset rc.siteID = URLEncodedFormat(event.getValue("siteID",""))>
    <cfset rc.supplierproductcode = URLEncodedFormat(event.getValue("supplierproductcode",""))>
    <cfset rc.manufacturerproductcode = URLEncodedFormat(event.getValue("manufacturerproductcode",""))>
    <cfset rc.productName = URLEncodedFormat(event.getValue("productName",""))>
    <cfset event.setLayout("Layout.ajax")>
    <cfset rc.error = false>
	  <cfset rc.nodeID = event.getValue("nodeRef","")>
    <cfif rc.nodeID eq "">
      <cfset nodeSearchURL = "http://www.buildingvine.com/alfresco/service/bvine/products/nodeSearch?eancode=#rc.eancode#&supplierProductCode=#rc.supplierProductCode#&manufacturerProductCode=#rc.manufacturerproductcode#&productName=#rc.productName#">
      <cfhttp username="admin" password="bugg3rm33" getasbinary="never" url="#nodeSearchURL#" result="products"></cfhttp>
      <cfset productList = DeSerializeJSON(products.fileContent)>
    </cfif>

      <cfif rc.nodeID neq "" OR (isArray(productList.items) AND arrayLen(productList.items) gte 1)>
        <cfif rc.nodeID eq "">
          <cfset rc.productID = Replace(productList.items[1],":/","","ALL")>
          <cfset rc.nodeID = ListLast(rc.productID,"/")>
        <cfelse>
          <cfset rc.productID = "workspace://spacesStore/#rc.nodeID#">
        </cfif>
        <cfhttp username="admin" password="bugg3rm33" url="http://www.buildingvine.com/alfresco/service/bvine/product?nodeRef=#rc.nodeId#" result="product"></cfhttp>
        <cfset rc.product = DeSerializeJSON(product.fileContent)>
        <cfset event.setView("api/docs")>
      <cfelse>
	  	  <cfset event.norender()>
	    </cfif>

  </cffunction>

  <cffunction name="documentList" access="public" returntype="void" output="false">
    <cfargument name="Event" type="any">
    <!--- RC Reference --->
    <cfset var rc = event.getCollection()>
    <cfset sess = getPlugin(plugin="UserStorage")>
    <cfset rc.file = event.getValue("file","")>
    <cfset rc.id = event.getValue("id","")>
    <cfif NOT isDefined('rc.folder') OR rc.folder eq "">
      <cfset rc.folder = event.getValue("dir","")>
    </cfif>
    <cfset rc.bc = event.getValue("bc","")>
    <cfhttp url="http://#cgi.http_host#/alfresco/service/bvine/docs/list/document/site/ebiz/documentLibrary?folder=#rc.folder#&userID=#rc.userID#&folderName=#rc.bc#&guest=true" result="documentList"></cfhttp>
    <cfset rc.documents = DeserializeJSON(documentList.fileContent)>
    <cfset rc.document_layout = "largeicons">
    <cfset event.setLayout('www.buildingvine.com/Layout.api')>
    <cfset event.setView('/documents/api/documentList')>
  </cffunction>
<!------------------------------------------- PRIVATE EVENTS ------------------------------------------>

<cffunction name="renderLayout" returntype="String" access="public" output="true">
  <cfargument name="siteID">
  <cfargument name="productXML">
  <cfquery name="productLayout" datasource="bvine">
    select siteLayout from siteProductLayout
    where
    shortName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#siteID#">
  </cfquery>
  <cfif productLayout.recordCount eq 0>
    <cfset productXML = xmlParse(productXML)>
    <cfsavecontent variable="newoutput">
      <cfoutput>
        <table>
        <cfloop array="#productXML.product.XmlChildren#" index="x">
        <cfif x.xmlText neq "NULL" AND x.xmlText neq "">
          <tr>
            <td class="bold right">#x.xmlName#</td>
            <td>#x.xmlText#</td>
          </tr>
        </cfif>
        </cfloop>
        </table>
      </cfoutput>
    </cfsavecontent>
  <cfelse>
    <cfsavecontent variable="output">
      <cfoutput>
      #productLayout.siteLayout#
      </cfoutput>
    </cfsavecontent>
    <cfset output = populate_fields(output,ToString(productXML))>
    <cfsavecontent variable="newoutput">
      <cfoutput>
      #output#
      </cfoutput>
    </cfsavecontent>
  </cfif>
  <cfreturn newoutput>
</cffunction>

<cffunction name="ttest">
  <cfargument name="event">
  <cfset var rc = event.getCollection()>
  <cfthread action="run" name="test">
        <cfset something = "anything">
  </cfthread>
  <cfset rc.thread = cfthread>
  <cfset event.setView("debug",true)>
</cffunction>

</cfcomponent>