<cfoutput>
  <legend>Spreadsheet field mappings</legend>
  <br />
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>
    Select the columns in your spreadsheet that match our pre-defined columns.
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Product Code<em>*</em></label>
    <div class="controls">
      <select name="object.Product_Code" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Product_Code","product").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Your Product Code.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">EAN/GTIN</label>
		<div class="controls">
	    <select name="object.eanCode" id="p_EANCode">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
	        <option #vm(col,rc.iService.getFields("EANCode","product").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
      <p class="help-inline">Bar code for this product</p>
	  </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="Full_Description">Product Name<em>*</em></label>
    <div class="controls">
			<select name="object.Full_Description" id="p_Full_Description">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
	        <option #vm(col,rc.iService.getFields("Full_Description").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
      <p class="help-inline"><span class="label label-important">Required</span> Product name (this is likely called product description in your back-office system)</p>
		</div>
  </div>
  <div class="control-group">
    <label class="control-label" for="productdescription">Product Description</label>
    <div class="controls">
    	<select name="object.Description2" id="p_Description2">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
	        <option #vm(col,rc.iService.getFields("Description2").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
      <p class="help-inline">A product description</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="Manufacturers_Product_Code">Manufacturer Product Code</label>
    <div class="controls">
    	<select name="object.Manufacturers_Product_Code" id="p_Manufacturers_Product_Code">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
	        <option #vm(col,rc.iService.getFields("Manufacturers_Product_Code").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
      <p class="help-inline">The Manufacturer or suppliers product code</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="rrp">RRP</label>
    <div class="controls">
    	<select name="object.Retail_Price" id="Retail_Price">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
	        <option #vm(col,rc.iService.getFields("Retail_Price").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
     <p class="help-inline">The retail price. This is the default price that will be shown alongside your products to the public</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Trade Price</label>
    <div class="controls">
    	<select name="object.Trade" id="Trade">
	      <option value="">--no value--</option>
	      <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
	        <option #vm(col,rc.iService.getFields("Trade").mapsTo)# value="#col#">#col#</option>
	      </cfloop>
	    </select>
      <p class="help-inline">The standard trade price. This is the price that will be shown to logged in trade customers.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Cost Price</label>
    <div class="controls">
      <select name="object.Cost_Price" id="Cost_Price">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Cost_Price").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Your cost price. This isn't shown on the website, but is stored in the back office for reporting purposes</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Category ID</label>
    <div class="controls">
      <select name="object.categoryID" id="categoryID">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("categoryID").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The Category ID for the object. These should match the ids in your product tree.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Weight in Kg</label>
    <div class="controls">
      <select name="object.Weight" id="Weight">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Weight").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The weight in Kilograms of this product</p>
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Product Unit information</legend>
  <div class="control-group">
    <label class="control-label" for="unitweight">Unit of Sale</label>
    <div class="controls">
      <select name="object.Unit_of_Sale" id="Unit_of_Sale">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Unit_of_Sale").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The unit of sale (i.e PACK, EACH etc.)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Unit of Price</label>
    <div class="controls">
      <select name="object.Unit_of_Price" id="Unit_of_Price">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Unit_of_Price").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
      <p class="help-inline">The unit of price (i.e PACK, EACH etc.)</p>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Unit of Buy</label>
    <div class="controls">
      <select name="object.Unit_of_Buy" id="Unit_of_Buy">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Unit_of_Buy").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Unit of Cost</label>
    <div class="controls">
      <select name="object.Unit_of_Cost" id="Unit_of_Cost">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Unit_of_Cost").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The unit of cost price (i.e PACK, EACH etc.)</p>
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Custom web product information</legend>
  <br />
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>
    Any custom information to override default product information. This can be edited in the system if you do not have this information.
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Name</label>
    <div class="controls">
      <select name="object.Web_Name" id="Web_Name">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Web_Name").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The web-friendly product name</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Name</label>
    <div class="controls">
      <select name="object.Web_Name" id="Web_Name">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Web_Name").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The web-friendly product name</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Description</label>
    <div class="controls">
      <select name="object.web_description" id="web_description">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("web_description").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The web-friendly product description</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Enabled (Public)</label>
    <div class="controls">
      <select name="object.publicwebEnabled" id="publicwebEnabled">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("publicwebEnabled").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Can this product be purchased by the public online? (yes/no,true/false,1/0)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Enabled (Trade)</label>
    <div class="controls">
      <select name="object.webEnabled" id="webEnabled">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("webEnabled").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Can this product be purchased by trade customers? (yes/no,true/false,1/0)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Price</label>
    <div class="controls">
      <select name="object.web_price" id="web_price">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("web_price").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The web price for public web visitors</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Trade Price</label>
    <div class="controls">
      <select name="object.web_trade_price" id="web_trade_price">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("web_trade_price").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The web price for trade customers</p>
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Delivery information</legend>
  <div class="control-group">
    <label class="control-label" for="unitweight">Minimum Delivery Quantity (Public)</label>
    <div class="controls">
      <select name="object.minimum_delivery_quantity" id="minimum_delivery_quantity">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("minimum_delivery_quantity").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The minimum delivery quantity for public web customers</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Delivery Quantity Unit (Public)</label>
    <div class="controls">
      <select name="object.minimum_delivery_quantity_unit" id="minimum_delivery_quantity_unit">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("minimum_delivery_quantity_unit").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The minimum delivery quantity unit (PACKS,PALLET etc.)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Minimum Delivery Quantity (Trade)</label>
    <div class="controls">
      <select name="object.minimum_delivery_quantity_trade" id="minimum_delivery_quantity_trade">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("minimum_delivery_quantity_trade").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The minimum delivery quantity for trade customers</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Web Delivery Quantity Unit (Trade)</label>
    <div class="controls">
      <select name="object.minimum_delivery_quantity_trade_unit" id="minimum_delivery_quantity_trade_unit">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("minimum_delivery_quantity_trade_unit").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The minimum delivery quantity unit for trade customers (PACKS,PALLET etc.)</p>
    </div>
  </div>

  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Charge Type</label>
    <div class="controls">
      <select name="object.delivery_charge" id="delivery_charge">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_charge").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The delivery charge type (free,weight,fixed) Free: no delivery charge. Weight: based per kilo. Fixed: A fixed delivery charge</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Charge Type (Trade)</label>
    <div class="controls">
      <select name="object.delivery_charge_trade" id="delivery_charge_trade">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_charge_trade").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The delivery charge type for trade customers (free,weight,fixed) Free: no delivery charge. Weight: based per kilo. Fixed: A fixed delivery charge</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Charge Value</label>
    <div class="controls">
      <select name="object.delivery_charge_value" id="delivery_charge_value">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_charge_value").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The value (cost) of the delivery charge</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Charge Value (Trade)</label>
    <div class="controls">
      <select name="object.delivery_charge_value_trade" id="delivery_charge_value_trade">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_charge_value_trade").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">The value (cost) of the delivery charge for trade customers</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Time (delivered within x days)</label>
    <div class="controls">
      <select name="object.delivery_time" id="delivery_time">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_time").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">How many days can a customer expect delivery within</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Time Trade (delivered within x days)</label>
    <div class="controls">
      <select name="object.delivery_time_trade" id="delivery_time_trade">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_time_trade").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">How many days can a trade customer expect delivery within</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Locations</label>
    <div class="controls">
      <select name="object.delivery_locations" id="delivery_locations">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_locations").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Where can this product be delivered (nationwide,radius,postcode,collectonly)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Locations for Trade</label>
    <div class="controls">
      <select name="object.delivery_locations_trade" id="delivery_locations_trade">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_locations_trade").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Where can this product be delivered for trade customers (nationwide,radius,postcode,collectonly)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Locations (value)</label>
    <div class="controls">
      <select name="object.delivery_location_value" id="delivery_location_value">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_location_value").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Where value for the above delivery options. i.e (5 for radius, BN14,BN13,BN12 for postcodes)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Delivery Locations for trade (value)</label>
    <div class="controls">
      <select name="object.delivery_location_value_trade" id="delivery_location_value_trade">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_location_value_trade").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Where value for the above delivery options. i.e (5 for radius, BN14,BN13,BN12 for postcodes)</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="unitweight">Collectable</label>
    <div class="controls">
      <select name="object.collectable" id="collectable">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("collectable").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Collectable. Can this product be collected. (yes/no,true/false,0/1)</p>
    </div>
  </div>
<div class="form-actions">
  <button type="submit" class="btn btn-primary">Import Spreadsheet</button>
</div>
<input type="hidden" name="fileName" value="#rc.file#" />
</cfoutput>