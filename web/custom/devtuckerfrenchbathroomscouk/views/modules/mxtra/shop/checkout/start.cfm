<cfset getMyPlugin(plugin="jQuery").getDepends("","#request.siteID#/checkout","#request.siteID#/checkout")>
<div id="checkout">
<h1>Checkout</h1>
<h3>Your Progress</h3>
<div  id="checkOutStage">
	<cfif rc.delivered>
  <ul class="breadcrumb">  	
    <li><a class="active" href="/mxtra/shop/checkout">1. Login or guest</a><span class="divider"></span></li>
    <li><a href="/mxtra/shop/checkout?stage=1">2. Billing</a><span class="divider"></span></li>
    <li><a href="/mxtra/shop/checkout?stage=2">3. Delivery</a><span class="divider"></span></li>
    <li><a href="/mxtra/shop/checkout?stage=3">4. Payment Information</a><span class="divider"></span></li>
    <li><a href="/mxtra/shop/checkout?stage=4">5. Confirmation</a><span class="divider"></span></li>
  </ul>
	</cfif>
</div>
<div class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <strong>Required fields</strong>  are denoted by <em>*</em>.
</div>
<form class="form-horizontal" method="post" action="/mxtra/shop/checkout/confirmGuest">
  <fieldset>
    <legend>Continue as guest</legend><br />
    <div class="alert alert-success">
      <a class="close" data-dismiss="alert">&times;</a>         
      If you do not want to create an account at this time, you can continue as a guest
    </div>        
    <div class="form-actions">
      <button type="submit" class="btn btn-success">Continue as a guest</button>        
  </div>
  </fieldset>
</form>   
<form class="form-horizontal" method="post" action="/mxtra/invoicing/account/login">
  <fieldset>
    <legend>Returning Customers</legend><br />
    <p>Returning user can login below</p>
    <div class="control-group">
    	<label class="control-label" for="username">Username <em>*</em></label>
			<div class="controls">
			  <input class="" id="username" size="15" name="username" /> 
			</div>
		</div> 
    <div class="control-group">
    	<label class="control-label" for="password">Password <em>*</em></label> 
			<div class="controls">
			  <input class="" id="password" size="15" name="password" /> 
			</div>
		</div>
    <div class="form-actions">
      <button type="submit" class="btn btn-primary">Login</button>        
    </div>			
  </fieldset> 
</form>
<form class="form-horizontal" id="register" method="post" action="/mxtra/account/register">
<fieldset>
  <legend>Register</legend>
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>         
    You can register with us to save you entering your details in the future
  </div>				
  <div class="control-group">
    <label class="control-label" for="bN">Contact Name<em>*</em></label>
    <div class="controls">
		 <input type="text" id="bN" name="bN" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="bA">Address<em>*</em></label>
    <div class="controls">
    	<textarea class="" cols="20"id="bA" rows="5" name="bA"></textarea>
		</div>
  </div>
  <div class="control-group">
    <label class="control-label" for="bPC">Postcode<em>*</em></label>
    <div class="controls">
    	<input type="text" id="bPC" name="bPC" size="10" class="">
		</div>
  </div>
  <div class="control-group">
    <label class="control-label" for="bP">Phone number<em>*</em></label>
    <div class="controls">
    	<input type="text" id="bP" name="bP" size="20" class="">
		</div>
  </div>
  <div class="control-group">
    <label class="control-label" for="bM">Mobile number</label>
    <div class="controls">
    	<input type="text" name="bM" size="20" class="" value="">
		</div>
  </div>
  <div class="control-group">
    <label class="control-label" for="bE">Email Address<em>*</em></label>
    <div class="controls">
    	<input type="text" id="bE" name="bE" size="20" class=""">
		</div>
  </div>
  <div class="control-group">
    <label class="control-label" for="password">Password <em>*</em></label>
		<div class="controls">
			<input id="password" type="password" size="15" class="" name="password" />
		</div>
	</div>
	<div class="control-group">
    <label class="control-label" for="password">Confirm Password <em>*</em></label>
    <div class="controls">
    	<input id="password2" type="password" size="15"class="" name="password2" />
		</div>
  </div>
  <div class="form-actions">
    <button type="submit" class="btn btn-info">Register</button> 
  </div>
</fieldset>
</form>  
