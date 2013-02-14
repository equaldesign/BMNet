<cfset getMyPlugin(plugin="jQuery").getDepends("validate,form","sites/#request.siteID#/checkout","#request.siteID#/checkout")>
<div id="checkout">

<cfoutput>#renderView("shop/checkout/stages")#</cfoutput>

	<form id="delivery" class="form-horizontal" action="/mxtra/shop/checkout" method="post">
	   <fieldset>
	     <legend>Billing Information</legend>
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
		<div class="control-group #isErrorField('bN')#">
		  <label class="control-label" for="mxtra.order.invoice.name">Contact Name<em>*</em></label>
		  <div class="controls">
			 <input type="text" name="mxtra.order.invoice.name" size="20" class="nice #isErrorField('mxtra.order.invoice.name')# required" value="#request.mxtra.order.invoice.name#">
			</div>
		</div>
    <div class="control-group #isErrorField('mxtra.order.invoice.address1')#">
      <label class="control-label" for="mxtra.order.invoice.address1">Address Line 1<em>*</em></label>
      <div class="controls">
       <input type="text" name="mxtra.order.invoice.address1" size="20" class="nice #isErrorField('mxtra.order.invoice.address1')# required" value="#request.mxtra.order.invoice.address1#">
      </div>
    </div>
		<div class="control-group">
      <label class="control-label" for="mxtra.order.invoice.address2">Address Line 2</label>
      <div class="controls">
       <input type="text" name="mxtra.order.invoice.address2" size="20" class="nice" value="#request.mxtra.order.invoice.address2#">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="mxtra.order.invoice.address3">Address Line 3</label>
      <div class="controls">
       <input type="text" name="mxtra.order.invoice.address3" size="20" class="nice" value="#request.mxtra.order.invoice.address3#">
      </div>
    </div>
    <div class="control-group #isErrorField('mxtra.order.invoice.town')#">
      <label class="control-label" for="mxtra.order.invoice.town">Town <em>*</em></label>
      <div class="controls">
       <input id="mxtra.order.invoice.town" type="text" name="mxtra.order.invoice.town" size="20" class="nice #isErrorField('mxtra.order.invoice.town')# required" value="#request.mxtra.order.invoice.town#">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="mxtra.order.invoice.county">County</label>
      <div class="controls">
       <input id="mxtra.order.invoice.county" type="text" name="mxtra.order.invoice.county" size="20" class="nice" value="#request.mxtra.order.invoice.county#">
      </div>
    </div>
		<div class="control-group #isErrorField('mxtra.order.invoice.postcode')#">
		  <label class="control-label" for="mxtra.order.invoice.postcode">Postcode<em>*</em></label>
			<div class="controls">
		    <div class="input-prepend">
		    	<span class="add-on"><i class="icon-postcode"></i></span>
				  <input type="text" name="mxtra.order.invoice.postcode" size="10" class="input-small #isErrorField('mxtra.order.invoice.postcode')# required" value="#request.mxtra.order.invoice.postcode#">
				</div>
			</div>
		</div>
		<div class="control-group #isErrorField('mxtra.order.invoice.phone')#">
		  <label class="control-label" for="mxtra.order.invoice.phone">Phone number<em>*</em></label>
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-phone"></i></span>
		      <input type="text" name="mxtra.order.invoice.phone" size="20" class="input-medium #isErrorField('mxtra.order.invoice.phone')# required" value="#request.mxtra.order.invoice.phone#">
				</div>
			</div>
		</div>
		<div class="control-group">
		  <label class="control-label" for="mxtra.order.invoice.mobile">Mobile number</label>
			<div class="controls">
				<div class="input-prepend">
					<span class="add-on"><i class="icon-mobile"></i></span>
		      <input type="text" name="mxtra.order.invoice.mobile" size="20" class="input-medium" value="#request.mxtra.order.invoice.mobile#">
				</div>
			</div>
		</div>
		<div class="control-group">
			<div class="controls">
		    <label class="checkbox">
				<input type="checkbox" checked="true" name="useForDelivery" size="40" class="nice" value="true">
          Use this address for delivery?
        </label>
			</div>
		</div>
		<div class="form-actions">
      <button type="submit" class="btn btn-success">Continue</button>
    </div>
		</fieldset>
    </cfoutput>
    <input type="hidden" name="stage" value="2" />
	</form>
</div>