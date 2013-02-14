
<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/products/editProduct","")>
<cfoutput>
<form class="form-horizontal" id="editProduct" action="/alfresco/service/bvine/product?alf_ticket=#request.user_ticket#" method="put">
  <input type="hidden" id="nodeRef" value="#rc.nodeRef#" />
  <input type="hidden" id="tagsiteID" value="#rc.product.detail.site#" />
  <input type="hidden" id="tagContainer" value="ProductFiles" />
  <fieldset>
    <legend>Core Information</legend>
    <div class="control-group">
      <label class="control-label" for="title">Name</label>
      <div class="controls">
        <input size="50" type="text" name="title" id="title" value="#paramValue('rc.product.detail.title','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="eancode">EAN/GTIN Code</label>
      <div class="controls">
        <input type="text" name="eancode" id="eancode" value="#paramValue('rc.product.detail.attributes.eancode','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="productactive">Active?</label>
      <div class="controls">
        <label class="checkbox">
          <input type="checkbox" name="productactive" id="productactive" value="true" #vm(paramValue('rc.product.detail.attributes.productactive','false'),'true','checkbox')# />
          Is this product still active and not discontinued?
        </label>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="autosearch">NO AutoSearch?</label>
      <div class="controls">
        <label class="checkbox">
          <input type="checkbox" name="autosearch" id="autosearch" value="true" #vm(paramValue('rc.product.detail.attributes.autosearch','false'),'true','checkbox')# />
          Do not try to automatically find an image for this product
        </label>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="manufacturerproductcode">Manufacturer Product Code</label>
      <div class="controls">
        <input type="text" name="manufacturerproductcode" id="manufacturerproductcode" value="#paramValue('rc.product.detail.attributes.manufacturerproductcode','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="supplierproductcode">Supplier Product Code</label>
      <div class="controls">
        <input type="text" name="supplierproductcode" id="supplierproductcode" value="#paramValue('rc.product.detail.attributes.supplierproductcode','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="productdescription">Description</label>
      <div class="controls">
        <textarea class="simpleeditor" name="productdescription" id="productdescription">#paramValue('rc.product.detail.attributes.productdescription','')#</textarea>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="rrp">RRP</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">&pound;</span>
          <input class="input-mini" size="4" type="text" name="rrp" id="rrp" value="#paramValue('rc.product.detail.attributes.rrp','')#" />
        </div>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="unitweight">Weight</label>
      <div class="controls">
        <input class="input-mini" size="8" type="text" name="unitweight" id="unitweight" value="#paramValue('rc.product.detail.attributes.unitweight','')#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="manufacturerbrandname">Brand Name</label>
      <div class="controls">
        <input type="text" name="manufacturerbrandname" id="manufacturerbrandname" value="#paramValue('rc.product.detail.attributes.manufacturerbrandname','')#" />
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Custom Information</legend>
		<br />
    <cfloop collection="#rc.product.detail.attributes.customProperties#" item="key">
    <div class="control-group">
      <label class="control-label" for="custom_#key#">#key#</label>
      <div class="controls">
        <input type="text" class="customKeyPair" name="custom_#key#" id="custom_#key#" value="#rc.product.detail.attributes.customProperties['#key#']#" />
        <a href="##" class="removeAttribute"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/cross-button.png" border="0" /></a>
      </div>
    </div>
    </cfloop>
    <div id="customKeyPairs">
	    <div class="control-group">
	      <label class="control-label" for="add">Add key/value</label>
	      <div class="controls">
	        <input type="text" name="key" id="key" value="" />
	        <input type="text" name="value" id="value" value="" />
	        <a href="##" class="addAttribute"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/tick-button.png" border="0" /></a>
	      </div>
	    </div>
		</div>
		<div id="cloneKey" class="hidden control-group">
      <label class="control-label" for=""></label>
      <div class="controls">
        <input class="" type="text" name="" id="" value="" />
        <a href="##" class="removeAttribute"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/cross-button.png" border="0" /></a>
      </div>
    </div>
  </fieldset>
  <cfoutput>#renderView(view="web/tags/create",args={nodeRef=rc.nodeRef,tags=rc.product.detail.tags,type="ProductFiles",siteID=rc.product.detail.site})#</cfoutput>
</form>
</div>
</cfoutput>