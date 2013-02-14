 <cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/quote","#request.siteID#/checkout")>
<div class="page-header">
  <h2>Start a new Quotation</h2>	
</div>
<form action="/mxtra/shop/quote/save" class="form form-horizontal">
  <fieldset>
    <legend>Overview</legend>
    <div class="control-group">
      <label class="control-label" for="reference">Your Reference</label>
			<div class="controls">
        <input type="text" name="reference" id="reference" />
			</div>
    </div>
    <div class="control-group">
      <label class="control-label" for="deliverydate">Delivery Date</label>
			<div class="controls">
        <input class="date input-small" type="text" name="deliverydate" id="deliverydate" />
			</div>
    </div>
  </fieldset>
  <cfoutput>
  <fieldset>
    <legend>Delivery Details</legend>
    <div class="control-group">
      <label class="control-label" for="bPC">Delivered?</label>
      <div class="controls">
      	<input type="checkbox" name="delivered" value="Yes" checked>
			</div>
    </div>
    <div class="control-group">
      <label class="control-label" for="Contact">Contact Name<em>*</em></label>
      <div class="controls">
      	<input type="text" name="contact" class="" value="#rc.customer.name#">
			</div>
    </div>
    <div class="control-group">
      <label class="control-label" for="deliveryAddress">Address<em>*</em></label>
      <div class="controls">
      	<textarea class="nice " cols="40" rows="7" name="deliveryAddress">#rc.customer.company_address_1##chr(13)#
	        #rc.customer.company_address_2##chr(13)#
	        #rc.customer.company_address_3##chr(13)#
	        #rc.customer.company_address_4##chr(13)#
	      </textarea>
			</div>
    </div>
    <div class="control-group">
      <label class="control-label" for="postcode">Postcode<em>*</em></label>
      <div class="controls">
      	<input type="text" name="postcode" size="10" class="nice " value="#rc.customer.company_postCode#">
			</div>
    </div>
    <div class="control-group">
      <label class="control-label"  for="phone">Phone number<em>*</em></label>
      <div class="controls">
      	<input type="text" name="phone" size="20" class="nice " value="#rc.customer.company_phone#">
			</div>
  </div>
  </fieldset>
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Start Quotation &raquo;" />
  </div>
  </cfoutput>
</form>
