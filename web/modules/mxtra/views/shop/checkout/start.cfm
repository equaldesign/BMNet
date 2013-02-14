<cfset getMyPlugin(plugin="jQuery").getDepends("validate","shop/checkout","#request.siteID#/checkout")>
<div id="checkout">
<cfoutput>#renderView("shop/checkout/stages")#</cfoutput>
<form id="loginForm" class="form-horizontal" method="post" action="/mxtra/shop/checkout/switch">
  <fieldset>
    <legend>Sign In</legend><br />
    <div class="control-group">
    	<label class="control-label" for="username">Email Address</label>
			<div class="controls">
			  <input type="text" class="input-large required" placeholder="you@yourdomain.com" size="15" name="mxtra.order.email" />
			</div>
		</div>
    <div class="control-group">
      <div class="controls">
        <label class="radio">
          <input class="userType" type="radio" checked="checked" name="userType" value="newCustomer">
          I am a new customer<br />
          <small>(You'll create a password later)</small>
        </label>
        <label class="radio">
          <input type="radio" name="userType" value="existingCustomer">
          I'm a returning customer, and my password is:
        </label>
      </div>
    </div>
    <div class="control-group">
      <div class="controls">
        <input id="password" disabled="disabled" class="input-large uneditable-input" type="password" name="password" />
      </div>
    </div>
    <div class="form-actions">
      <button type="submit" class="btn btn-success"><i class="icon-tick-circle-frame"></i>Continue Securely</button>
    </div>
  </fieldset>
</form>
</div>