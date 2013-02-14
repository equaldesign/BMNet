<cfset getMyPlugin(plugin="jQuery").getDepends("validate","login","form",false,"eunify")>
<cfheader name="Expires" value="#getHttpTimeString(now())#"> 
<cfoutput>
  <div class="page-header">
    <h1>Login to Building Vine</h1>
  </div>  
  <form class="form-horizontal" method="post" action="/login/doLogin" id="loginForm">       
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
        <label class="control-label" for="username">Email</label>
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