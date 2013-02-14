
<cfif rc.error>
  <cfif rc.debugu>
    <cfdump var="#rc#"><cfabort>
  <cfelse>
  <cfheader name="expires" value="#now()#">
   <cfheader name="pragma" value="no-cache">
   <cfheader name="cache-control" value="no-cache, no-store, must-revalidate">   
  <cfoutput>http://#cgi.http_host#/alfresco/service/buildingvine/api/productSearch.json?productCode=#rc.id#&supplierCode=#rc.productCode#&merchantcode=#rc.merchantCode#&mimetype=#URLEncodedFormat(rc.mimeType)#</cfoutput>
  
  </cfif>
<cfelse>
  <cfif rc.debugu>
  <cfdump var="#rc#"><cfabort>
    <cfoutput><h1>test</h1>
      <cfdump var="http://#cgi.http_host#/alfresco/service/#rc.images[1].thumbnailUrl##rc.imageSize#?ph=true&c=force&alf_ticket=#rc.buildingVine.admin_ticket#">
    </cfoutput>
 <cfelse>
  <cftry>
	 <cfheader name="expires" value="#now()#">
   <cfheader name="pragma" value="no-cache">
   <cfheader name="cache-control" value="no-cache, no-store, must-revalidate">   
	 <cfcontent type="#rc.MimeType#" variable="#rc.fileContent#">
	 <cfcatch type="any">
    <cflog application="true" text="#cfcatch.message#">
	  <cfif fileExists("/fs/sites/ebiz/www.buildingvine.com/web/includes/images/api/#rc.referrer#/error#rc.imageSize#.jpg")>
	     <cfcontent type="image/jpeg"  file="/fs/sites/ebiz/www.buildingvine.com/web/includes/images/api/#rc.referrer#/error#rc.imageSize#.jpg">
	   <cfelse>
	     <cfcontent type="image/jpeg"  file="/fs/sites/ebiz/www.buildingvine.com/web/includes/images/api/error#rc.imageSize#.jpg">
	   </cfif>
	 </cfcatch>
  </cftry>
   </cfif>
</cfif>

