
<cfset getMyPlugin(plugin="jQuery").getDepends("validate","login","form",false,"eunify")>
<cfoutput>
  <div class="page-header">
    <h1>Your Account</h1>
  </div>
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>
    <h3 class="alert-heading">About the Your Account section of the Turnbull 24-7 website.</h3>
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
  <form class="form-horizontal" method="post" action="/eunify/login/doLogin" id="loginForm">
    <fieldset>
      <cfif rc.error neq "">
      <div class="control-group">
        <div class="alert alert-error">
          <a class="close" data-dismiss="alert">&times;</a>
          #rc.error#
        </div>
      </div>
      </cfif>
      <div class="control-group">
        <label class="control-label" for="username">Email or account number</label>
        <div class="controls">
          <input size="16" type="text" id="j_username" name="j_username" value="#rc.username#" />
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="password">Password</label>
        <div class="controls">
          <input size="16" type="password" id="j_password" name="j_password" value="#rc.password#" />
        </div>
      </div>
			<div class="controls">
				<label class="checkbox" for="rememberme">
					<input #IIf(rc.rem,"'checked=checked'","''")# type="checkbox" value="y" name="rememberme"  />
					remember me?
				</label>
			</div>
      <div class="controls">
         <a href="/mxtra/account/main/forgottenpassword" class="forgottenPassword">Forgotten your password?</a>
      </div>
      <div class="form-actions">
        <input type="submit" class="btn btn-info" value="login &raquo;" />
      </div>
    </fieldset>
    <cfif isDefined('rc._securedURL')>
     <input type="hidden" name="target" value="#rc._securedURL#" />
    </cfif>
  </form>
</cfoutput>