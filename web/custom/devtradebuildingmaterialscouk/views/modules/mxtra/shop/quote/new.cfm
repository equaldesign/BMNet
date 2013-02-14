 <cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/search","")>
<div class="row">
	<div class="span8">
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
		      <label class="control-label" for="bPC">Delivered?</label>
		      <div class="controls">
		        <label class="checkbox">
						  <input type="checkbox" name="delivered" value="Yes" checked>
							If you do not choose delivery, you'll need to collect your order. Don't worry, we'll only put your quote for tender to merchants in your area!
						</label>
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
		      	<input type="text" name="postcode" size="10" class="input-small" value="#rc.customer.company_postCode#">
					</div>
		    </div>
		    <div class="control-group">
		      <label class="control-label"  for="email">Email Address<em>*</em></label>
		      <div class="controls">
		        <input type="text" name="email" size="20" class="nice " value="#rc.customer.company_email#">
		      </div>
		    </div>
				<div class="control-group">
		      <label class="control-label"  for="phone">Phone number<em>*</em></label>
		      <div class="controls">
		      	<input type="text" name="phone" size="20" class="nice " value="#rc.customer.company_phone#">
					</div>
		    </div>
		  </fieldset>
			<fieldset>
				<legend>Products Required</legend>
				<div class="control-group">
					<label class="control-label">Quantity Required</label>
					<div class="controls">
						<input id="quantity" type="text" class="input-mini" name="quantity" value="1" />
					</div>
				</div>
				<div class="control-group">
		      <label class="control-label">Unit</label>
		      <div class="controls">
		      	<select id="unit" name="unit">
		      		<cfset uTypes = getModel('modules.eunify.model.ProductService').getUnitTypes()> 
		          <cfloop query="uTypes">
				  	   <option value="#type#">#display#</option>
		          </cfloop>		
		      	</select>
					</div>			  
		    </div>
				<div class="control-group">
					<label class="control-label">Product Name</label>
					<div class="controls">
						<div class="input-prepend">
							<span class="add-on">
								<i class="icon-search"></i>
							</span>
						  <input type="text" name="sname" id="searchQuery" />			
							<p class="help-block">Start typing a product name, and we'll search as you type. If the correct product appears, select it from the list. If we can't find it - don't worry, just press return!</p>		
						</div>
					</div>		
				</div>
			</fieldset>
			<fieldset>
				<legend>Your Product List</legend>
				<br />
				<table id="shoppingList" class="table table-striped table-bordered">
					<thead>
						<tr>
							<th>Quantity</th>
							<th>Unit</th>
							<th>Name</th>
							<th>Remove</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</fieldset>
		  <div class="form-actions">
		    <input type="submit" class="btn btn-success" value="Finish and confirm &raquo;" />
		  </div>
		  </cfoutput>
		</form>		
	</div>
	<div class="span4">
		<div class="alert alert-success">      
      <h3 class="alert-heading">How it works...</h3>
      <p>You enter your details, where your want your goods delivered, and build up your list of required products.</p>
      <p>We then submit this to independent merchants close to your location.</p>
			<p>Within 24 hours, you'll get your quotes delivered via email.</p>
			<p>It couldn't be any simpler!</p>
    </div>
		<div class="alert alert-info">		  
		  <h3 class="alert-heading">What you need to know...</h3>
		  <p>In order to get you the best possible price for your job, please try and fill in the following form as comprehensively as you can.</p>
		  <p>We know it looks a little tedious, but we assure you it will be worth it!</p>
		</div>
	</div>
</div>