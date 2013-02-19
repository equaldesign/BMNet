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
        <cfset local.imageMagickArguments = '"#local.fileName#" -resize "#arguments.width#x#arguments.height#^" -gravity #arguments.cropx# -crop #arguments.width#x#arguments.height#+0+0 +repage -quality 90 "#local.outputfileName#"'>
        
         <cfexecute name="/usr/local/bin/convert" arguments='#local.imageMagickArguments#' timeout="4"  />
      </cfif>
    <cfelse>
       <cfset local.imageMagickArguments = '"#local.fileName#" -resize "#arguments.width#" -quality 90 +repage "#local.outputfileName#"'>
       <cfexecute name="/usr/local/bin/convert" arguments='#local.imageMagickArguments#' timeout="4"/>      
    </cfif> 
    <cfcatch type="any">      
      <cfdump var="#cfcatch#">
    </cfcatch>
    </cftry>
    <cfreturn local.outputfileName>
</cffunction>
<cfscript>
  function getValue(name,def){
   requireNumeric = false;
   if (ArrayLen(Arguments) GTE 3){   
      if (Arguments[3]){
         requireNumeric = true;
      }
   }
   requireValue = false;
   if (ArrayLen(Arguments) GTE 4){
      if (Arguments[4]){
         requireValue = true;
      }
   }
      
   if (isDefined('Form.#name#')){
      value = Form[name];
   } else if (isDefined('URL.#name#')){
      value = URL[name];
   } else {
      value = def;
   }
   
   if (requireNumeric){
      if (isNumeric(value)){
         return value;
      } else {
         return 0;
      }
   } else {
      return value;
   }
}
</cfscript>
<cfsetting requesttimeout="20">
<cfset rc = {}>
<cfset prc = {}>
<cfset objImage = {}>
<cfset productImages = {}>
<cfset prc.ticketCount = getTickCount()>
<cfset prc.instance = createUUID()>    
<cfset prc.id = getValue("id","")><!--- the image ID - for backwards compatability --->
<cfset prc.size = getValue("size","medium")><!--- the size of the image, default to medium --->
<cfset prc.crop = getValue("crop",false)>
<cfset prc.cropAspect = getValue("aspect","4:3")>
<cfset prc.fullFileName = getValue("fn","")>
<cfset prc.cropx = getValue("cropx","center")>
<cfset prc.cropy = getValue("cropy","center")>
<cfset prc.blur = getValue("blur",0)>
<cfset prc.bvsite = getValue("siteID","")><!--- the site for the image, to avoid grabbing anything incorrectly --->
<cfset prc.force = getValue("f",true)><!--- force new image? --->
<cfset prc.imageplaceholder = getValue("imageplaceholder","http://www.buildingvine.com/modules/bv/includes/images/api/errormedium.jpg")><!--- force new image? --->
<cfset prc.quality = getValue("quality","highestQuality")>
<cfset prc.key = getValue("key","")><!--- the API key --->
<cfset prc.nodeRef = getValue("nodeRef","")><!--- we have a nodeRef? awsome! --->
<cfset prc.categoryNodeRef = getValue("categoryNodeRef","")><!--- a category noderef; used for BV only, no external API support --->
<cfset prc.alf_ticket = getValue("ticket","")> <!--- an passed in alf ticket --->
<!--- some defaults --->
<cfset prc.hasImage = false>
<cfset prc.title = "speng">
<cfset prc.searchAmazon = true>
<cfset prc.watermark = false>
<cfset prc.error = false>
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

<cfset prc.debugu = getValue("debugu",false)><!--- are we debuggin'? --->
<cfset prc.eanCode = getValue("eancode","")><!--- the passed in EAN code --->
<cfif prc.id eq "" and prc.eanCode neq ""><!--- we used to use ID as the EAN, this is for backwards compatability --->
  <cfset prc.id = prc.eanCode>
</cfif>
<cfset prc.productCode = URLEncodedFormat(getValue("productCode",""))><!--- the product code. Drop support for this eventually --->
<cfset prc.merchantCode = URLEncodedFormat(getValue("merchantCode",""))><!--- the merchant code - for merchant specific images. Drop support for this eventually --->
<cfset prc.supplierproductcode = URLEncodedFormat(getValue("supplierproductcode",""))><!--- the supplier product code --->
<cfset prc.manufacturerproductcode = URLEncodedFormat(getValue("manufacturerproductcode",""))><!--- the manufacturer product code --->
<cfset prc.productName = URLEncodedFormat(getValue("productName",""))><!--- the product name, loose matching, use with caution! --->
<cfset ref = Replace(cgi.HTTP_REFERER,"http://","","ALL")><!--- the referring URL/domain. Hit and miss here, but we have no choice --->
<cfset ref = Replace(cgi.HTTP_REFERER,"https://","","ALL")><!--- strip the http/https --->
<cfset refL = ListToArray(ref,"/")><!--- the url as an array --->
<cftry>
  <cfset prc.referrer = refL[1]><!--- this should be the TLD --->
  <cfcatch type="any"><!--- if something goes wrong, fall back to buildingvine.com as the referrer --->
    <cfset prc.referrer = "www.buildingvine.com">        
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
<cfif prc.fullFileName neq "">
  <cfset objImage = fileRead(prc.fullFileName)>
  <cfset objImage = resizebvimage(objImage,prc.width,prc.height,prc.quality,prc.crop,prc.cropAspect,prc.cropx,prc.cropy)>    
  <cfif prc.blur neq 0>
    <cfset ImageBlur(objImage,prc.blur)>
  </cfif>          
  
  <cfcontent type="image/jpeg" file="#objImage#">
  <cfabort>            
</cfif>
<cfset prc.imagekey = hash(toString(serializeJSON(prc)))>
<!--- now do the search or grab the thumbnail --->          
<cfhttp username="admin" password="bugg3rm33" port="8080" getasbinary="auto" redirect="true" url="#prc.imURL#" result="productImages" timeout="20"></cfhttp>    
    
<cfif isBinary(productImages.fileContent)><!--- we have a binary result - which means an image --->
  <!--- create a UUID fileName --->
  <cfset sFileName = "#createUUID()#">
  <cftry>
    <cfheader name="expires" value="#GetHttpTimeString(dateAdd('m',1,now()))#"><!--- set a nice cache expiry header for well behaved caches --->
    <cfheader name="cache-control" value="public"><!--- add some cache control headers for good measure --->
    <cfset objImage = productImages.fileContent>            
    <cfset objImage = resizebvimage(objImage,prc.width,prc.height,prc.quality,prc.crop,prc.cropAspect,prc.cropx,prc.cropy)>    
    <cfif prc.blur neq 0>
      <cfset ImageBlur(objImage,prc.blur)>
    </cfif>          
    
    <cfcontent type="image/jpeg" file="#objImage#">
    <cfabort>            
    <cffile action="copy" source="#objImage#" destination ="/bvcache/#prc.imageKey#.jpg" nameconflict="overwrite"><!--- save the image to S3 --->    
    <cfif NOT prc.debugu>
      <cfcontent type="image/jpeg" file="/bvcache/#prc.imageKey#.jpg">            
    </cfif>
    <cfcatch type="any">
      <cfdump var="#cfcatch#">
    </cfcatch>
  </cftry>
</cfif>      
<cfif NOT prc.debugu><!--- if we get here, we haven't found anything. However if we're debugging, we want to skip this to see the debug view --->
  <cfheader name="expires" value="#GetHttpTimeString(DateAdd('d',1,now()))#"><!--- set the cache for 15 mins --->
  <cfheader name="cache-control" value="public">
  <cfheader statuscode="307" statustext="Moved Temp"><!--- set a temporary HTTP code - we want spiders to come back --->
  <cfhttp url="#prc.imageplaceholder#" result="holdingImage" getasbinary="auto"></cfhttp>
  <cfset objImage = holdingImage.fileContent>          
  <cfset objImage = resizebvimage(objImage,prc.width,prc.height,prc.quality,prc.crop,prc.cropAspect,prc.cropx,prc.cropy)>        
  <cfset perm = structnew()>
  <cfset perm.group = "all">
  <cfset perm.permission = "read">
  <cfset perm1 = structnew()>
  <cfset perm1.email = "tom.miller@ebiz.co.uk">
  <cfset perm1.permission = "FULL_CONTROL">
  <cfset myarrray = arrayNew(1)>
  <cfset myarrray = [perm,perm1]>
  <cfcontent type="image/jpeg" file="#objImage#">
  <cfabort>
  <cfif NOT fileExists("/bvcache/error#prc.size#_#URLEncodedFormat(prc.imageplaceholder)#.jpg")><!--- this image already exists in S3 --->
     <cffile action="copy" source="#objImage#" destination="/bvcache/error#prc.size#_#URLEncodedFormat(prc.imageplaceholder)#.jpg" nameconflict="overwrite"><!--- save the image to S3 --->
  </cfif>
  
  <cfif NOT prc.debugu>
    <cfcontent type="image/jpeg" file="/bvcache/#prc.imageKey#.jpg">            
  </cfif>
</cfif>
