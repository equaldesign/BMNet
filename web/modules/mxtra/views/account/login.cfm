 <cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy,validate.min,form","sites/#rc.sess.siteID#/turnbull,sites/#rc.sess.siteID#/checkout","sites/#rc.sess.siteID#/checkout,sites/#rc.sess.siteID#/style,sites/#rc.sess.siteID#/shop,sites/#rc.sess.siteID#/screenShotPreview")>
  <div class="page-header">
  	<h1>Your Account</h1>
	</div>
	<div class="alert alert-info">
		<a class="close" data-dismiss="alert">&times;</a>
		<p>Your account" section is a dedicated website, allowing you to manage your account whenever it's convenient for you.</p>
    <p>You can create priced quotations for your chosen products and then order online - all from the comfort of your PC (Credit Account holders only).</p>
    <p>You can:</p>
		<ul>
      <li>Check and view outstanding balances</li>
      <li>Check and view statements</li>
      <li>Check and view previous payments</li>
      <li>View invoices and resolve queries</li>
      <li>Obtain copy invoices, credit notes and POD's (Proof of Deliveries)</li>
      <li>Create quotations for you or your customers</li>
      <li>You can login to Your Account.</li>
    </ul>
	</div>
  <form class="form-horiztonal" action="/mxtra/account/doLogin" method="post">
    <fieldset title="Please Login">
      <legend>Please Login</legend>
      <div class="control-group">
        <label class="control-label" for="username">username</label>
        <div class="controls">
				  <input type="text" name="username" id="username" />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="password">password</label>
        <div class="controls">
				  <input type="password" name="password" id="password" />
				</div>
      </div>
      <div class="controls">
         <a href="/mxtra/account/main/forgottenpassword" class="forgottenPassword">Forgotten your password?</a>
      </div>
      <div class="form-actions">
        <input type="submit" class="btn btn-info" value="login &raquo;" />
      </div>
    </fieldset>
  </form>
</div>