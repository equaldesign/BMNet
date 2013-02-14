<cfset getMyPlugin(plugin="jQuery").getDepends("form,validate","shop/checkout","#request.siteID#/checkout")>
<div id="checkout">
<cfoutput>#renderView("shop/checkout/stages")#</cfoutput>
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
		<div class="control-group #isErrorField('mxtra.order.delivery.name')#">
		  <label class="control-label" for="mxtra.order.delivery.name">Contact Name<em>*</em></label>
		  <div class="controls">
			  <input type="text" name="mxtra.order.delivery.name" size="20" class="nice #isErrorField('mxtra.order.delivery.name')#" value="#request.mxtra.order.delivery.name#">
			</div>
		</div>
		<div class="control-group #isErrorField('mxtra.order.delivery.address1')#">
      <label class="control-label" for="mxtra.order.delivery.address1">Address Line 1<em>*</em></label>
      <div class="controls">
       <input type="text" name="mxtra.order.delivery.address1" size="20" class="nice #isErrorField('mxtra.order.delivery.address1')# required" value="#request.mxtra.order.delivery.address1#">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="mxtra.order.delivery.address2">Address Line 2</label>
      <div class="controls">
       <input type="text" name="mxtra.order.delivery.address2" size="20" class="nice" value="#request.mxtra.order.delivery.address2#">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="mxtra.order.delivery.address3">Address Line 3</label>
      <div class="controls">
       <input type="text" name="mxtra.order.delivery.address3" size="20" class="nice" value="#request.mxtra.order.delivery.address3#">
      </div>
    </div>
    <div class="control-group #isErrorField('mxtra.order.delivery.town')#">
      <label class="control-label" for="mxtra.order.invoice.town">Town <em>*</em></label>
      <div class="controls">
       <input id="mxtra.order.invoice.town" type="text" name="mxtra.order.delivery.town" size="20" class="nice #isErrorField('mxtra.order.delivery.town')# required" value="#request.mxtra.order.delivery.town#">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="mxtra.order.delivery.county">County</label>
      <div class="controls">
       <input id="mxtra.order.invoice.county" type="text" name="mxtra.order.delivery.county" size="20" class="nice" value="#request.mxtra.order.delivery.county#">
      </div>
    </div>
    <div class="control-group #isErrorField('mxtra.order.delivery.postcode')#">
      <label class="control-label" for="mxtra.order.delivery.postcode">Postcode<em>*</em></label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-postcode"></i></span>
          <input type="text" name="mxtra.order.delivery.postcode" size="10" class="input-small #isErrorField('mxtra.order.delivery.postcode')# required" value="#request.mxtra.order.delivery.postcode#">
        </div>
      </div>
    </div>
    <div class="control-group #isErrorField('mxtra.order.delivery.phone')#">
      <label class="control-label" for="mxtra.order.delivery.phone">Phone number<em>*</em></label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-phone"></i></span>
          <input type="text" name="mxtra.order.delivery.phone" size="20" class="input-medium #isErrorField('mxtra.order.delivery.phone')# required" value="#request.mxtra.order.delivery.phone#">
        </div>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="mxtra.order.delivery.mobile">Mobile number</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-mobile"></i></span>
          <input type="text" name="mxtra.order.delivery.mobile" size="20" class="input-medium" value="#request.mxtra.order.delivery.mobile#">
        </div>
      </div>
    </div>
		<div class="form-actions">
      <a class="btn btn-danger" href="/mxtra/shop/checkout?stage=1">Back</a>&nbsp;<button type="submit" class="btn btn-success">Continue</button>
    </div>
		</fieldset>
    </cfoutput>
    <input type="hidden" name="stage" value="3" />
	</form>
</div>