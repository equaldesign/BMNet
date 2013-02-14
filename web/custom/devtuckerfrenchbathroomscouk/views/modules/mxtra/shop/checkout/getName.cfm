<cfset getMyPlugin(plugin="jQuery").getDepends("validate,form","sites/#request.siteID#/checkout","#request.siteID#/checkout")>
<div id="checkout">
<div class="page-header">
  <h1>Checkout</h1>
</div>

<div class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <strong>Required fields</strong> are denoted by <em>*</em>.
</div>
  <form id="checkout" class="form-horizontal" action="/mxtra/shop/checkout" method="post">
     <fieldset>
       <legend>Your Information</legend>   
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
      <label class="control-label" for="bN">Contact Name<em>*</em></label>
      <div class="controls">
       <input type="text" name="bN" size="20" class="nice #isErrorField('bN')#" value="#rc.order.invoice.name#">
      </div>
    </div>    
    <div class="control-group #isErrorField('bP')#">
      <label class="control-label" for="bP">Phone number<em>*</em></label>
      <div class="controls">
        <input type="text" name="bP" size="20" class="nice #isErrorField('bP')#" value="#rc.order.invoice.phone#">
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="bM">Mobile number</label>
      <div class="controls">
        <input type="text" name="bM" size="20" class="nice" value="#rc.order.invoice.mobile#">
      </div>
    </div>
    <div class="control-group #isErrorField('bE')#">
      <label class="control-label" for="bE">Email Address<em>*</em></label>
      <div class="controls">
        <input type="text" name="bE" size="20" class="nice #isErrorField('bE')#" value="#rc.order.invoice.email#">
      </div>
    </div>    
    <div class="form-actions">
      <button type="submit" class="btn btn-primary">Continue</button>      
    </div>
    </fieldset>
    </cfoutput>   
  </form>
</div>