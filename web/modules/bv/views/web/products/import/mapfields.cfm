<cfoutput>
<fieldset>
<legend>Spreadsheet field mappings</legend>
  <br />
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>		
    Select the columns in your spreadsheet that match our pre-defined columns. Any columns you don't match with ours will be added as "meta data" to your products.    
  </div>
  <div class="control-group">
    <label class="control-label" for="eanCode">EAN/GTIN</label>
		<div class="controls">
	    <select name="eanCode" id="eanCode">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"eanCode").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
	  </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="productname">Product Name<em>*</em></label>
    <div class="controls">
			<select name="productname" id="productname">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"productname").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
		</div>
  </div>
  <div class="control-group">
    <label class="control-label" for="productdescription">Product Description</label>
    <div class="controls">
    	<select name="productdescription" id="productdescription">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"productdescription").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="manufacturerproductcode">Manufacturer Product Code</label>
    <div class="controls">
    	<select name="manufacturerproductcode" id="manufacturerproductcode">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"manufacturerproductcode").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>		
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="supplierproductcode">Supplier Product Code</label>
    <div class="controls">
    	<select name="supplierproductcode" id="supplierproductcode">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"supplierproductcode").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="rrp">RRP</label>
    <div class="controls">
    	<select name="rrp" id="rrp">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"rrp").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Weight in Kg</label>
    <div class="controls">
    	<select name="unitweight" id="unitweight">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"unitweight").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>			
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Document/Image relationships</legend>
  <br />
	<div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>   
      Choose the columns in your spreadsheet with filenames or partial files names to match images and document up with products.</p>
      <p>For example, if your product images are named [eancode].jpg - then you can select the column in your spreadsheet with your EAN codes.</p>
      <p>You should ensure you have already uploaded all your images and documents into your document library.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="imageRef">Image Name</label>
    <div class="controls">
    	<select multiple="multiple" name="imageRef" id="imageRef">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"imageRef").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="documentRef">Document Name</label>
    <div class="controls">
    	<select multiple="multiple" name="documentRef" id="documentRef">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"documentRef").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Category Tree</legend>
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>   
      One column in your spreadsheet should contain a "tree", seperated by slashes. For example: Clothing/Boots/Steel Toecaps.
      <p>This enables our system to categorize your products. If you do not include a category, all your products will go into a default category, called "all products".</p>
    </div>
  </div>
  <div>
    <label class="control-label" for="categoryColumn">Category Column <em>*</em></label>
    <div class="controls">
    	<select multiple="multiple" name="categoryColumn" id="categoryColumn">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"categoryColumn").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Spreadsheet type</legend>
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>   
      If this spreadsheet only contains new products, the import will not perform a search and just import all products as new products.
      <p>If the spreadsheet contains all your products, the system will search for existing products - thereby updating all your products, adding any new products, and marking missing products as discontinued.</p>
    </div>
  </div>
  <div>
    <label class="control-label" for="sstype">Import type</label>
    <div class="controls">
    	<select name="sstype" id="sstype">
	      <option value="update">Update existing prdoducts</option>
	      <option value="new">New products only</option>
	    </select>
    </div>
  </div>
</fieldset>
<div class="form-actions">
  <button type="submit" class="btn btn-primary">Import Spreadsheet</button>  
</div>
<input type="hidden" name="fileName" value="#rc.file#" />
</cfoutput>