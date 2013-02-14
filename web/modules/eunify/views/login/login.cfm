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
  <form class="form-horizontal" method="post" action="/eunify/login/doLogin" id="loginForm">       
    <fieldset title="Please Login">
      <legend>Please Login</legend>
      <cfif rc.error neq "">
	    <div class="control-group">
	    	<div class="alert alert-error">
          <a class="close" data-dismiss="alert">&times;</a>
					#rc.error#
        </div>
			</div>
	    </cfif>
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
		<cfif isDefined('rc._securedURL')>
     <input type="hidden" name="target" value="#rc._securedURL#" />
    </cfif>
  </form>
</div>
<cfset getMyPlugin(plugin="jQuery").getDepends("validate","login/login")>

			<cfoutput>
			<form method="post" action="/eunify/login/doLogin" id="loginForm">
			 <cfif isDefined('rc._securedURL')>
			   <input type="hidden" name="target" value="#rc._securedURL#" />
			 </cfif>
				<fieldset>
					<legend>Please login</legend>
					<div id="errorMessage" style="padding: 0pt 0.7em;" class="#IIf(rc.error eq "","'hidden'","''")# Aristo ui-state-error ui-corner-all">
						<span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-alert"></span>
						#rc.error#
					</div>
					<div>
						<label class="l" for="j_username">email address<em>*</em></label>
						<input size="16" type="text" id="j_username" name="j_username" value="#rc.username#" />
					</div>
					<div>
						<label class="l" for="j_password">password<em>*</em></label>
						<input size="16" type="password" id="j_password" name="j_password" value="#rc.password#" />
					</div>
					<div>
						<label class="l" for="rememberme">remember me</label>
						<input #IIf(rc.rem,"'checked=checked'","''")# type="checkbox" value="y" name="rememberme"  />
					</div>
			    <div>
				    <input class="doIt" type="submit" value="Login &raquo;" />
			    </div>
					<br clear="all" />
					<div>
				    <a href="#bl('login.index','do=resetpassword')#" class="forgottenPassword">Forgotten your password?</a>
			    </div>
				</fieldset>
			</form>
			</cfoutput>


