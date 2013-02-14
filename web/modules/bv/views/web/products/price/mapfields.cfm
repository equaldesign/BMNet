<cfoutput>
<fieldset>
	<legend>Search Lookup</legend>
	<br />
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>   
    Select the column in your spreadsheet that unquely indentifies your product.    
  </div>
  
  <div class="control-group">
    <label class="control-label" for="eanCode">Search On</label>
		<div class="controls">
	    <select name="searchOn" id="searchOn">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"searchOn").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
	  </div>
  </div>
</fieldset>

<fieldset>
	<legend>Price Fields</legend>
	<br />
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>   
    Select the columns in your spreadsheet that match our pre-defined columns. Any columns you don't match with ours will be added as "meta data" to your products.    
  </div>
	
  <div class="control-group">
    <label class="control-label" for="supplierslistprice">List Price</label>
    <div class="controls">
			<select name="supplierslistprice" id="supplierslistprice">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getColumnNames()#" index="col">
	        <option #vm(col,rc.pService.getFields(rc.siteID,"supplierslistprice").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
		</div>
  </div>
  
	<div class="control-group">
    <label class="control-label" for="merchantinvoiceprice">Invoice Price #rc.pService.getFields(rc.siteID,"merchantinvoiceprice").mapsTo#</label>
    <div class="controls">
      <select name="merchantinvoiceprice" id="merchantinvoiceprice">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getColumnNames()#" index="col">
          <option #vm(col,rc.pService.getFields(rc.siteID,"merchantinvoiceprice").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
	
	<div class="control-group">
    <label class="control-label" for="packquantity">Pack Quantity</label>
    <div class="controls">
      <select name="packquantity" id="packquantity">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getColumnNames()#" index="col">
          <option #vm(col,rc.pService.getFields(rc.siteID,"packquantity").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
	
	<div class="control-group">
    <label class="control-label" for="priceeffectivefromdate">Price Effective From</label>
    <div class="controls">
      <select name="priceeffectivefromdate" id="priceeffectivefromdate">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getColumnNames()#" index="col">
          <option #vm(col,rc.pService.getFields(rc.siteID,"priceeffectivefromdate").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
	
	<div class="control-group">
    <label class="control-label" for="priceeffectivetodate">Price Effective To</label>
    <div class="controls">
      <select name="priceeffectivetodate" id="priceeffectivetodate">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getColumnNames()#" index="col">
          <option #vm(col,rc.pService.getFields(rc.siteID,"priceeffectivetodate").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
	
	<div class="control-group">
    <label class="control-label" for="priceunitofmeasuredescription">Unit of Measure Name (i.e EACH)</label>
    <div class="controls">
      <select name="priceunitofmeasuredescription" id="priceunitofmeasuredescription">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getColumnNames()#" index="col">
          <option #vm(col,rc.pService.getFields(rc.siteID,"priceunitofmeasuredescription").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
	
	<div class="control-group">
    <label class="control-label" for="priceunitofmeasurequantity">Unit of Measure Quantity</label>
    <div class="controls">
      <select name="priceunitofmeasurequantity" id="priceunitofmeasurequantity">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getColumnNames()#" index="col">
          <option #vm(col,rc.pService.getFields(rc.siteID,"priceunitofmeasurequantity").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
	
	<div class="control-group">
    <label class="control-label" for="discountgroup">Discount Group</label>
    <div class="controls">
      <select name="discountgroup" id="discountgroup">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getColumnNames()#" index="col">
          <option #vm(col,rc.pService.getFields(rc.siteID,"discountgroup").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
	
</fieldset>
<div class="form-actions">
  <button type="submit" class="btn btn-primary">Import Spreadsheet</button>  
</div>
<input type="hidden" name="fileName" value="#rc.file#" />
</cfoutput>