<cfset getMyPlugin(plugin="jQuery").getDepends("form","#request.siteID#/checkout","#request.siteID#/checkout")>
<div id="checkout">
<div class="page-header">
  <h1>Checkout</h1>
</div>
<div id="checkOutStage">
  <ul class="breadcrumb">
    <li class="active"><a href="/mxtra/shop/checkout">1. Login or guest</a><span class="divider">/</span></li>
    <li class="active"><a href="/mxtra/shop/checkout?stage=1">2. Billing</a><span class="divider">/</span></li>
    <li class="active"><a href="/mxtra/shop/checkout?stage=2">3. Delivery</a><span class="divider">/</span></li>
    <li>4. Payment Information<span class="divider">/</span></li>
    <li>5. Confirmation</li>
  </ul>
</div>
<div class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <strong>Required fields</strong> are denoted by <em>*</em>.
</div>
	<form class="form-horizontal" id="checkout" action="/mxtra/shop/checkout" method="post">
	   <fieldset>
	   <legend>Delivery Information</legend>
		<cfif isDefined('rc.error') and ArrayLen(rc.error.message) neq 0>
    <div class="alert alert-error">     
      <strong>Sorry. There was a problem with some of the information you submitted:</strong>
      <ul>
      <cfoutput>
      <cfloop array="#rc.error.message#" index="i">
        <li>#i#</li>
      </cfloop>
      </cfoutput>
      </ul>
    </div>
    </cfif>
    <cfoutput>
		<div class="control-group #isErrorField('dN')#">
		  <label class="control-label" for="dN">Contact Name<em>*</em></label>
		  <div class="controls">
			  <input type="text" name="dN" size="20" class="nice #isErrorField('dN')#" value="#rc.order.delivery.name#">
			</div>
		</div>
		<div class="control-group #isErrorField('bA')#">
		  <label class="control-label" for="bA">Address<em>*</em></label>
		  <div class="controls">
			  <textarea class="nice #isErrorField('dA')#" cols="20" rows="5" name="dA">#rc.order.delivery.address#</textarea>
			</div>
		</div>
		<div class="control-group #isErrorField('bPC')#">
		  <label class="control-label" for="bPC">Postcode<em>*</em></label>
		  <div class="controls">
		  	<input type="text" name="dPC" size="10" class="nice #isErrorField('dPC')#" value="#rc.order.delivery.postCode#">
			</div>
		</div>
		<div class="control-group #isErrorField('dP')#">
		  <label class="control-label" for="dP">Phone number<em>*</em></label>
		  <div class="controls">
		  	<input type="text" name="bP" size="20" class="nice #isErrorField('dP')#" value="#rc.order.delivery.phone#">
			</div>
		</div>
		<div class="control-group">
		  <label class="control-label" for="dM">Mobile number</label>
		  <div class="controls">
		  	<input type="text" name="bM" size="20" class="nice" value="#rc.order.delivery.mobile#">
		  </div>
		</div>
		<div class="control-group #isErrorField('dE')#">
		  <label class="control-label" for="dE">Email Address</label>
		  <div class="controls">
		  	<input type="text" name="bE" size="20" class="nice #isErrorField('dE')#" value="#rc.order.delivery.email#">
			</div>
		</div>
		<div class="form-actions">
      <button type="submit" class="btn btn-primary">Continue</button>      
    </div>
		</fieldset>
    </cfoutput>		
	</form>
</div>