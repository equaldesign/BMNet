<cfset getMyPlugin(plugin="jQuery").getDepends("form,swfobject,upload","secure/products/image/editImage","secure/documents/uploadify,secure/products/editimage")>
<cfoutput>
  <cftry>
  <input type="hidden" id="alf_ticket" value="#request.buildingVine.user_ticket#">
  <input type="hidden" id="productNodeRef" value="#rc.product.detail.nodeRef#">
<div class="span7">
  <div class="row">
    <div class="span2">
    <cfif ArrayLen(rc.product.detail.productImage) gte 1>
      <img id="productImagePreview" src="https://www.buildingvine.com/api/productImage?nodeRef=#rc.product.detail.productImage[1].nodeRef#&size=250" title="#rc.product.detail.title#" class="glow smallImage">
    <cfelse>
      <img
         id="productImagePreview"
				src="https://www.buildingvine.com/api/productImage?eancode=#rc.product.detail.eancode#&size=250&supplierproductcode=#paramValue('rc.product.detail.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('rc.product.detail.attributes.manufacturerproductcode','')#&productName=#rc.product.detail.title#"
        title="#rc.product.detail.title#"
        class="glow smallImage">
    </cfif>
      <ul id="mainProductImage" class="thumbnails">
       <li>        
        <cfset found = false>
        <cfloop array="#rc.product.detail.productImage#" index="img">     
			   <div class="chooseImage thumbnail">     
            <img id="#img.nodeRef#" src="https://www.buildingvine.com/api/productImage?nodeRef=#img.nodeRef#&size=50" />            
            	<h5>Main Image</h5>
              <a target="_blank" class="icon magnify" href="/alfresco#img.downloadUrl#?alf_ticket=#request.user_ticket#"></a>
              <a class="unchoose" href="##"><i class="icon-cross"></i></a>
            </div>          
        </cfloop>
       </li>
			</ul>
      <ul id="productImage" class="thumbnails">        
        <cfloop array="#rc.product.detail.images#" index="imgs">
			  <li class="productImage">
          <div class="chooseImage left thumbnail">
            <img id="#imgs.nodeRef#" src="https://www.buildingvine.com/api/productImage?nodeRef=#imgs.nodeRef#&size=50" />           
            <a target="_blank" class="icon magnify" href="/alfresco#imgs.downloadUrl#?alf_ticket=#request.user_ticket#"></a>
            <a class="unchoose" href="##"><i class="icon-tick"></i></a>
          </div>          
        </li>
				</cfloop>        
       </ul>            
    </div>
    <div class="span5">
      <cftry><div class="page-header"><h2>#rc.product.detail.attributes.title#</h2></div><cfcatch type="any"></cfcatch></cftry>
      <cfif StructKeyExists(rc.product.detail.attributes,"description")><p>#rc.product.detail.attributes.description#</p></cfif>
      <cfif ArrayLen(rc.product.detail.productImage) gte 1>
        <div class="alert alert-info">
          <a class="close" data-dismiss="alert">&times;</a>
          <strong>Official Image</strong> This product has an "official" image. You can remove this image, and then <!---either --->search for a new image to "attach" to this product<!---, or upload a new image--->.
        </div>
      <cfelse>
        <div class="alert alert-info">
          <a class="close" data-dismiss="alert">&times;</a>
          <strong>Unofficial Image</strong> This product does not have an "official image". Building Vine has tried to "find" an image in the repository, or on Amazon&reg;, which is based on the product code(s) and name.
          If either an image could not be found, the image that was found was incorrect, or if you'd like to replace the image
              with one more suitable, you can <!---upload a new image or---> search Building Vine for a replacement.</p>
              <p>If you don't want Building Vine to automatically search for an "unoffical image" (if, for example, an incorrect image is appearing), you can disable this functionality for this product by editing the product, and ticking the "NO AutoSeach" checkbox.</p>
        </div>          
      </cfif>
      <div>
        <div class="page-header"><h3>Search for a replacement</h3></div>        
        <div rel="#rc.product.detail.nodeRef#" class="rel" id="imageSearch">
          <form class="form-inline" action="/alfresco/service/buildingvine/api/productSearch.json?alf_ticket=#request.buildingVine.user_ticket#" method="post" id="searchImage">   
            <div class="input-append">      
              <input id="eanCode" class="input-medium" placeholder="Search for an image..." type="text" name="eanCode">
              <input type="submit" class="btn btn-primary" value="Search" />
            </div>
            <select name="mime" id="mime">
              <option value="image/jpeg">JPEG</option>
              <option value="image/tiff">TIF</option>
              <option value="image/bmp">BMP</option>
            </select>
          </form>          
        </div>
        <div id="uploadQueue"></div>
        <div id="imageResults" class="thumbnails"></div>
      </div>
    </div>
  </div>
</div>
<cfcatch type="any">
  <cfdump var="#rc.product#">
</cfcatch>
  </cftry>
</cfoutput>
