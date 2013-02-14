<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/market/edit","")>
<cfoutput>
<form method="post" class="hidden" action="/alfresco/service/api/upload?alf_ticket=#request.user_ticket#" id="fileUpload" enctype="multipart/form-data">
	<input type="hidden" name="siteid" value="#request.buildingVine.site.shortName#" />
	<input type="hidden" name="containerId" value="DocumentLibrary" />
</form>
<div class="alert alert-info">
	<a href="##" class="close" data-dismiss="alert">&times;</a>
	<h3 class="alert-heading">How to list an item</h3>
	<p>Anyone</p>	
</div>
<form name="itemForm" id="itemForm" class="form form-horizontal" action="/alfresco/service/market/item?alf_ticket=#request.user_ticket#" method="post">
	<fieldset>
		<legend>About your item</legend>
		<div class="control-group">
			<label class="control-label">Name</label>
			<div class="controls">
				<input type="text" name="name" id="name" class="js" />
			</div>
		</div>
		<div class="control-group">
      <label class="control-label">Summary</label>
      <div class="controls">
        <textarea name="summary" class="js" rows="5" id="summary"></textarea>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Full Description</label>
      <div class="controls">
        <textarea name="description" class="ckeditor js" rows="5" id="description"></textarea>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Building Vine Product</label>
      <div class="controls">
      	<div class="input-prepend">
      		<span class="add-on"><i class="icon-search"></i></span>
          <input type="text" name="BVSearch" id="BVSearch" placeholder="search by EAN, SKU or product name..." />
					<div id="bvnodes"></div>
				</div>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Image</label>
      <div class="controls">
        <input type="file" name="filedata" id="image" />
				<input type="hidden" name="image" id="imageNodeRef" class="js" />
        <p class="help-block">If the item is not in Building Vine, we'd recommend adding an image</p>
      </div>
    </div>
	</fieldset>
	<fieldset>
		<legend>Lot detail</legend>
		<div class="control-group">
      <label class="control-label">Lot/Unit size</label>
      <div class="controls">
        <input type="text" name="packsize" class="input-mini js" value="1" id="packsize" />
				<p class="help-block">How many units in each item? (for example, 50 items per box - 50 would be the unit size, box would be the unit description)</p>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Lot/Unit description</label>
      <div class="controls">
        <input type="text" name="packsizedescription" class="input-small js" value="units" id="packsizedescription" />
        <p class="help-block">i.e units, tonnes, widgets</p>
      </div>
    </div>				
	</fieldset>	
	<fieldset>
		<legend>Availability</legend>		
		<div class="control-group">
      <label class="control-label">Available to</label>
      <div class="controls">
        <select name="enduser" class="js" id="enduser">
          <option value="merchants">Other Merchants</option>
          <option value="public">General Public</option>
        </select>      
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Amount available</label>
      <div class="controls">
        <input type="text" name="stockavailable" class="input-small js" value="1" id="stockavailable" />  
        <p class="help-block">How many lots are available?</p>      
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Start Date</label>
      <div class="controls">
        <div class="input-prepend">
        	<span class="add-on"><i class="icon-calendar"></i></span>
					<input type="text" class="date input-small js" name="validFrom" id="validFrom" value="#DateFormat(DateAdd("d",-1,now()),"DD/MM/YYYY")#" />
        </div>				
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">End Date</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-calendar"></i></span>
          <input type="text" class="date input-small js" name="validTo" id="validTo" value="#DateFormat(DateAdd("d",7,now()),"DD/MM/YYYY")#" />
        </div>        
      </div>
    </div>
	</fieldset>
	<fieldset>
		<legend>Delivery</legend>
		<div class="control-group">
      <label class="control-label">Collection Only</label>
      <div class="controls">
        <label class="checkbox">
          <input type="checkbox" class="js" name="collectonly" value="true" id="collectonly" />
          This item must be collected
        </label>             
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Origination Postcode</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-map"></i></span>
          <input type="text" name="originationPostCode" class="input-small js" value="" id="originationPostCode" />
        </div>      
				<p class="help-block">The origination postcode is used to calculate delivery distance, or so people know where to collect the item</p>       
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Delivery Distance</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-map"></i></span>
          <input type="text" name="deliveryDistance" class="input-small js" value="0" id="deliveryDistance" />					
        </div>
				<p class="help-block">How many miles from origination postcode are you willing to ship? Set as zero for nationwide delivery</p>             
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Delivery Charge</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">&pound;</span>
          <input type="text" name="deliveryCharge" class="input-small js" value="0" id="deliveryCharge" />
        </div>        
				<p class="help-block">Set as zero for free delivery</p>
      </div>
    </div>
	</fieldset>
	<fieldset>
		<legend>Price &amp; Payment</legend>
		<div class="control-group">
      <label class="control-label">Price</label>
      <div class="controls">
      	<div class="input-prepend">
          <span class="add-on">&pound;</span>
          <input type="text" name="price" class="input-small js" value="1.00" id="price" />
				</div>        
      </div>
    </div>    
		<div class="control-group">
      <label class="control-label">Deferred Payment</label>
      <div class="controls">
      	<label class="checkbox">
          <input type="checkbox" class="js" name="deferredPayment" value="true" id="deferredPayment" />
					Can the user pay later?
				</label>        
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Paypal Email</label>
      <div class="controls">
        <input type="text" name="paypalEmail" class="js" value="" id="paypalEmail" />
				<p>If you provide your paypail email address, you can get paid instantly via PayPal</p>   
      </div>
    </div>
	</fieldset>
	<fieldset>
		<legend>Item prominence</legend>
		<div class="control-group">
      <label class="control-label">Billboard Placement</label>
      <div class="controls">
      	<label class="checkbox">
          <input type="checkbox" class="js" name="billboard" value="true" id="billboard" />
					Billboard placement is 20 credits per week
				</label>        
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Feature Placement</label>
      <div class="controls">
        <label class="checkbox">
          <input type="checkbox" class="js" name="feature" value="true" id="feature" />
          Feature placement is 10 credits per week
        </label>        
      </div>
    </div>
	</fieldset>
	<fieldset>
    <legend>
      Security
    </legend>
    <div class="control-group">
    	<label class="control-label">Who can see this item?</label>
      <div class="controls">
      	<div class="input-prepend">
      		<span class="add-on"><i class="icon-search"></i></span>
					<input type="text" id="securitySearch" placeholder="search for a group (ie CEMCO)..." />				
					<div id="securityUsers"></div>	
      	</div>
				<br /><br />

				<input class="js" type="hidden" name="credits" value="1" id="credits" />
      </div>
    </div>
  </fieldset>
	<fieldset>
		<legend>
			Total credits used
		</legend>
		<div class="control-group">			
			<label class="control-label">Credits used</label>
			<div class="controls">
				<span class="label label-warning" id="creditsUsed">1</span>
			</div>
		</div>
		<div class="control-group">
		  <label class="control-label">Credits available</label>
      <div class="controls">
        <span class="label label-success" id="creditsAvailable">#rc.creditsAvailable#</span>
      </div>      		
		</div>
		<div class="hidden" id="creditWarning">
			<div class="alert alert-error">
				<h3 class="alert-heading">Insufficient credits</h3>
				<p>You do not have enough credits for this listing.</p>
				<a href="http://www.paypal.com/asdada" class="btn btn-danger">Get more credits.</a>
			</div>
		</div>
	</fieldset>
	<div class="form-actions">
		<input type="submit" class="btn btn-success" value="Confirm your item" />
	</div>
	<input class="js" type="hidden" id="siteID" value="#request.buildingVine.site.shortName#" />
</form>
</cfoutput>