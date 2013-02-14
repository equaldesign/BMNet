<cfoutput>
    <fieldset>
      <legend>Extended Information</legend>
      <div class="control-group">
        <label for="surname" class="control-label">Web Page Slug</label>
        <div class="controls">
          <input size="30" type="text" name="pageslug" id="pageslug" value="#rc.product.pageslug#" />
        </div>
      </div>

      <div class="control-group">
        <label for="subunit" class="control-label">Sub Unit</label>
        <div class="controls">
          <input class="input-small" type="text" size="5" id="subunit" name="subunit" value="#rc.product.subunit#" />
        </div>
      </div>
      <div class="control-group">
        <label for="subsperunit" class="control-label">Subs Per Unit</label>
        <div class="controls">
          <input class="input-small" type="text" size="5" id="subsperunit" name="subsperunit" value="#rc.product.subsperunit#" />
        </div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Attributes</label>
        <div class="controls">
          <label class="checkbox">
            <input type="checkbox" id="featured" name="feature" value="true" #vm("#rc.product.feature#","true","checkbox")#>
            Featured?
          </label>
        	<label class="checkbox">
            <input type="checkbox" id="publicWebEnabled" name="publicWebEnabled" value="true" #vm("#rc.product.publicWebEnabled#","true","checkbox")#>
						Public enabled
					</label>
	        <label class="checkbox">
        	 <input type="checkbox" id="webEnabled" name="webEnabled" value="true" #vm("#rc.product.webEnabled#","true","checkbox")#>
					 Trade enabled?
					</label>
					<label class="checkbox">
        	  <input type="checkbox" id="collectable" name="collectable" value="true" #vm("#rc.product.collectable#","true","checkbox")#>
						Collect in store?
					</label>
					<label class="checkbox">
        	  <input type="checkbox" id="special" name="special" value="true" #vm("#rc.product.special#","true","checkbox")#>
						Special offer?
				  </label>
					<label class="checkbox">
        	  <input type="checkbox" id="clearance" name="clearance" value="true" #vm("#rc.product.clearance#","true","checkbox")#>
						Clearance item?
				  </label>
				</div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Images</legend>
      <div class="control-group">
        <label for="search_bv" class="control-label">Use BV autosearch</label>
        <div class="controls">
        	<input type="checkbox" name="search_bv" value="true" checked="checked" />
				</div>
      </div>
      <div class="control-group">
        <label for="site_image" class="control-label">Image Name</label>
        <div class="controls">
        	<input type="text" name="site_image" value="" />
				</div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Social</legend>
      <div class="control-group">
        <label for="site_image" class="control-label">YouTube Snippet</label>
        <div class="controls">
          <textarea name="youTube">#rc.product.youTube#</textarea>
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Delivery Availablity <small>(Public)</small></legend>
      <div class="control-group">
        <label for="delivery_time" class="control-label">Delivery Time</label>
        <div class="controls">
        	<div class="input-prepend input-append">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/calendar.png"></span><input class="input-small" type="text" size="5" id="delivery_time" name="delivery_time" value="#rc.product.delivery_time#" /><span class="add-on">days</span>
          </div>

				</div>
      </div>
			<div class="control-group">
        <label for="minimum_delivery_quantity" class="control-label">Minimum Delivery Quant.</label>
        <div class="controls">
          <input class="input-mini" type="text" size="5" id="minimum_delivery_quantity" name="minimum_delivery_quantity" value="#rc.product.minimum_delivery_quantity#" />
        </div>
      </div>
      <div class="control-group">
        <label for="minimum_delivery_quantity" class="control-label">Minimum Delivery Quant. Unit</label>
        <div class="controls">
          <input class="input-mini" type="text" size="5" id="minimum_delivery_quantity_unit" name="minimum_delivery_quantity_unit" value="#rc.product.minimum_delivery_quantity_unit#" />
        </div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Delivery Areas</label>
        <div class="controls">
          <label class="radio">
            <input type="radio" name="delivery_locations" value="collectonly" #vm("collectonly","#rc.product.delivery_locations#","checkbox")# />
            Collection Only
          </label>
         <label class="radio">
           <input type="radio" name="delivery_locations" value="nationwide" #vm("nationwide","#rc.product.delivery_locations#","checkbox")# />
           Nationwide delivery
         </label>
         <label class="radio">
           <input type="radio" name="delivery_locations" value="radius" #vm("radius","#rc.product.delivery_locations#","checkbox")# />
           Radius in miles
         </label>
				 <label class="radio">
           <input type="radio" name="delivery_locations" value="postcode" #vm("postcode","#rc.product.delivery_locations#","checkbox")# />
           Postcode areas
         </label>
				 <label class="radio">
           <div class="input-prepend input-append">
             <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/pin.png"></span><input class="input-mini" type="text" size="5" name="delivery_location_value" value="#rc.product.delivery_location_value#" >
           </div>
         </label>
        </div>
      </div>
    </fieldset>
		<fieldset>
			<legend>Carrier <small>(public)</small></legend>
			<div class="control-group">
				<label class="control-label">Carrier</label>
				<div class="controls">
					<select name="carrier_web">
						<option value="0">--none--</option>
						<cfloop query="rc.carriers">
							<option value="#id#" #vm(rc.product.carrier_web,id)#>#name#</option>
						</cfloop>
					</select>
				</div>
			</div>
		</fieldset>
    <fieldset>
      <legend>Delivery Charges <small>(Public)</small></legend>
      <div class="control-group">
        <label for="tel" class="control-label">Cost</label>
        <div class="controls">
          <label class="radio">
            <input type="radio" name="delivery_charge" value="none" #vm("none","#rc.product.delivery_charge#","checkbox")# />
            Free Delivery
          </label>
          <label class="radio">
            <input type="radio" name="delivery_charge" value="weight" #vm("weight","#rc.product.delivery_charge#","checkbox")# />
            Based on product weight
          </label>
					<label class="radio">
            <input type="radio" name="delivery_charge" value="fixed" #vm("fixed","#rc.product.delivery_charge#","checkbox")# />
            Fixed Cost:
					</label>
					<label class="radio">
						<div class="input-prepend input-append">
	            <span class="add-on">&pound;</span><input class="input-mini" type="text" size="5" name="delivery_charge_value" value="#rc.product.delivery_charge_value#" ><span class="add-on">Inc VAT</span>
	          </div>
					</label>
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Delivery Availablity <small>(Trade)</small></legend>
      <div class="control-group">
        <label for="delivery_time_trade" class="control-label">Delivery Time</label>
        <div class="controls">
        	<div class="input-prepend input-append">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/calendar.png"></span><input class="input-small" type="text" size="5" id="delivery_time_trade" name="delivery_time_trade" value="#rc.product.delivery_time_trade#" /><span class="add-on">days</span>
          </div>
			  </div>
      </div>
			<div class="control-group">
        <label for="minimum_delivery_quantity_trade" class="control-label">Minimum Delivery Quant.</label>
        <div class="controls">
          <input class="input-mini" type="text" size="5" id="minimum_delivery_quantity_trade" name="minimum_delivery_quantity_trade" value="#rc.product.minimum_delivery_quantity_trade#" />
        </div>
      </div>
      <div class="control-group">
        <label for="minimum_delivery_quantity_trade" class="control-label">Minimum Delivery Quant Unit.</label>
        <div class="controls">
          <input class="input-mini" type="text" size="5" id="minimum_delivery_quantity_trade_unit" name="minimum_delivery_quantity_trade_unit" value="#rc.product.minimum_delivery_quantity_trade_unit#" />
        </div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Delivery Areas</label>
        <div class="controls">
				  <label class="radio">
            <input type="radio" name="delivery_locations_trade" value="collectonly" #vm("collectonly","#rc.product.delivery_locations_trade#","checkbox")# />
            Collection Only
          </label>
          <label class="radio">
            <input type="radio" name="delivery_locations_trade" value="nationwide" #vm("nationwide","#rc.product.delivery_locations_trade#","checkbox")# />
            Nationwide delivery
          </label>
          <label class="radio">
            <input type="radio" name="delivery_locations_trade" value="radius" #vm("radius","#rc.product.delivery_locations_trade#","checkbox")# />
            Radius in miles
          </label>
          <label class="radio">
            <input type="radio" name="delivery_locations_trade" value="postcode" #vm("postcode","#rc.product.delivery_locations_trade#","checkbox")# />
            Postcode areas
          </label>
					<label class="radio">
           <div class="input-prepend input-append">
             <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/pin.png"></span><input type="text" class="input-mini" size="5" name="delivery_location_value_trade" value="#rc.product.delivery_location_value_trade#" >
           </div>
          </label>
        </div>
      </div>
    </fieldset>
		<fieldset>
      <legend>Carrier <small>(Trade)</small></legend>
      <div class="control-group">
        <label class="control-label">Carrier</label>
        <div class="controls">
          <select name="carrier_trade">
            <option value="0">--none--</option>
            <cfloop query="rc.carriers">
              <option value="#id#" #vm(rc.product.carrier_trade,id)#>#name#</option>
            </cfloop>
          </select>
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Delivery Charges <small>(Trade)</small></legend>
      <div class="control-group">
        <label for="tel" class="control-label">Cost</label>
        <div class="controls">
					<label class="radio">
            <input type="radio" name="delivery_charge_trade" value="none" #vm("none","#rc.product.delivery_charge_trade#","checkbox")# />
            Free Delivery
				  </label>
          <label class="radio">
            <input type="radio" name="delivery_charge_trade" value="weight" #vm("weight","#rc.product.delivery_charge_trade#","checkbox")# />
            Based on product weight
          </label>
          <label class="radio">
            <input type="radio" name="delivery_charge_trade" value="fixed" #vm("fixed","#rc.product.delivery_charge_trade#","checkbox")# />
            Fixed Cost:
          </label>
					<label class="radio">
						<div class="input-prepend input-append">
	            <span class="add-on">&pound;</span><input class="input-small" type="text" size="5" name="delivery_charge_value_trade" value="#rc.product.delivery_charge_value_trade#" ><span class="add-on">Inc VAT</span>
	          </div>
					</label>
        </div>
      </div>
    </fieldset>
		<div class="form-actions">
			<button id="applytoothers" type="button" class="btn btn-danger"><i class="exclamation"></i> apply settings to other products within this category</button>
		</div>
</cfoutput>