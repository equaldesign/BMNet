<cfoutput>
<div class="pforms">
  <div class="tabbable">
    <ul class="nav nav-tabs">
      <li class="active"><a href="##public_delivery" data-toggle="tab">Public</a></li>
      <li><a href="##trade_delivery" data-toggle="tab">Trade</a></li>  </ul>
    <div class="tab-content">
      <div class="tab-pane active" id="public_delivery">
        <div class="row-fluid">
          <label for="delivery_time" class="span3">Delivery Time</label>
          <div class="span9">
            <div class="input-prepend input-append">
              <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/calendar.png"></span><input class="input-mini" type="text" size="5" id="delivery_time" name="delivery_time" value="#rc.product.delivery_time#" /><span class="add-on">days</span>
            </div>
          </div>
        </div>
        <div class="row-fluid">
          <label for="minimum_delivery_quantity" class="span3">Minimum Delivery Quant.</label>
          <div class="span9">
            <input class="input-mini" type="text" size="5" id="minimum_delivery_quantity" name="minimum_delivery_quantity" value="#rc.product.minimum_delivery_quantity#" />
          </div>
        </div>
        <div class="row-fluid">
          <label for="minimum_delivery_quantity" class="span3">Minimum Delivery Quant. Unit</label>
          <div class="span9">
            #renderUnits(rc.product.minimum_delivery_quantity_unit,rc.product.product_code,"minimum_delivery_quantity_unit")#
          </div>
        </div>
        <div class="row-fluid">
          <label for="tel" class="span3">Delivery Areas</label>
          <div class="span9">
            <label class="radio">
              <input class="delivery_area" type="radio" name="delivery_locations" value="collectonly" #vm("collectonly","#rc.product.delivery_locations#","checkbox")# />
              Collection Only
            </label>
           <label class="radio">
             <input class="delivery_area" type="radio" name="delivery_locations" value="nationwide" #vm("nationwide","#rc.product.delivery_locations#","checkbox")# />
             Nationwide delivery
           </label>
           <label class="radio">
             <input class="delivery_area" type="radio" name="delivery_locations" value="radius" #vm("radius","#rc.product.delivery_locations#","checkbox")# />
             Radius in miles
           </label>
           <label class="radio">
             <input class="delivery_area" type="radio" name="delivery_locations" value="postcode" #vm("postcode","#rc.product.delivery_locations#","checkbox")# />
             Postcode areas
           </label>
           <label class="radio">
             <div class="input-prepend input-append">
               <span class="add-on"><i class="icon-truck"></i></span>
               <input type="text" class="input-mini" size="5" name="delivery_location_value" value="#rc.product.delivery_location_value#" >
               <span class="add-on delivery_extra hidden"></span>
             </div>
           </label>
          </div>
        </div>
        <div class="row-fluid">
          <label class="span3">Carrier</label>
          <div class="span9">
            <select name="carrier_web">
              <option value="0">--none--</option>
              <cfloop query="rc.carriers">
                <option value="#id#" #vm(rc.product.carrier_web,id)#>#name#</option>
              </cfloop>
            </select>
          </div>
        </div>
        <div class="row-fluid">
          <label for="tel" class="span3">Cost</label>
          <div class="span9">
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
      </div>
      <div class="tab-pane" id="trade_delivery">
        <div class="row-fluid">
          <label for="delivery_time_trade" class="span3">Delivery Time</label>
          <div class="span9">
            <div class="input-prepend input-append">
              <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/calendar.png"></span><input class="input-mini" type="text" size="5" id="delivery_time_trade" name="delivery_time_trade" value="#rc.product.delivery_time_trade#" /><span class="add-on">days</span>
            </div>
          </div>
        </div>
        <div class="row-fluid">
          <label for="minimum_delivery_quantity_trade" class="span3">Minimum Delivery Quant.</label>
          <div class="span9">
            <input class="input-mini" type="text" size="5" id="minimum_delivery_quantity_trade" name="minimum_delivery_quantity_trade" value="#rc.product.minimum_delivery_quantity_trade#" />
          </div>
        </div>
        <div class="row-fluid">
          <label for="minimum_delivery_quantity_trade" class="span3">Minimum Delivery Quant Unit.</label>
          <div class="span9">
            <input class="input-mini" type="text" size="5" id="minimum_delivery_quantity_trade_unit" name="minimum_delivery_quantity_trade_unit" value="#rc.product.minimum_delivery_quantity_trade_unit#" />
          </div>
        </div>
        <div class="row-fluid">
          <label for="tel" class="span3">Delivery Areas</label>
          <div class="span9">
            <label class="radio">
              <input class="delivery_area" type="radio" name="delivery_locations_trade" value="collectonly" #vm("collectonly","#rc.product.delivery_locations_trade#","checkbox")# />
              Collection Only
            </label>
            <label class="radio">
              <input class="delivery_area" type="radio" name="delivery_locations_trade" value="nationwide" #vm("nationwide","#rc.product.delivery_locations_trade#","checkbox")# />
              Nationwide delivery
            </label>
            <label class="radio">
              <input class="delivery_area" type="radio" name="delivery_locations_trade" value="radius" #vm("radius","#rc.product.delivery_locations_trade#","checkbox")# />
              Radius in miles
            </label>
            <label class="radio">
              <input class="delivery_area" type="radio" name="delivery_locations_trade" value="postcode" #vm("postcode","#rc.product.delivery_locations_trade#","checkbox")# />
              Postcode areas
            </label>
            <label class="radio">
             <div class="input-prepend input-append">
               <span class="add-on"><i class="icon-truck"></i></span>
               <input type="text" class="input-mini" size="5" name="delivery_location_value_trade" value="#rc.product.delivery_location_value_trade#" >
               <span class="add-on delivery_extra hidden"></span>
             </div>
            </label>
          </div>
        </div>
        <div class="row-fluid">
          <label class="span3">Carrier</label>
          <div class="span9">
            <select name="carrier_trade">
              <option value="0">--none--</option>
              <cfloop query="rc.carriers">
                <option value="#id#" #vm(rc.product.carrier_trade,id)#>#name#</option>
              </cfloop>
            </select>
          </div>
        </div>
        <div class="row-fluid">
          <label for="tel" class="span3">Cost</label>
          <div class="span9">
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
                <span class="add-on">&pound;</span><input class="input-mini" type="text" size="5" name="delivery_charge_value_trade" value="#rc.product.delivery_charge_value_trade#" ><span class="add-on">Inc VAT</span>
              </div>
            </label>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>
</cfoutput>