<cfset getMyPlugin(plugin="jQuery").getDepends("validate","login/login")>
<cfoutput>

<div id="login-content" class="clearfix">
    <form method="post" action="/login/doLogin" id="loginForm" class="form-horizontal">
        <cfif isDefined('rc._securedURL')>
            <input type="hidden" name="target" value="#rc._securedURL#" />
        </cfif>
        <div id="errorMessage" style="padding: 0pt 0.7em;" class="#IIf(rc.error eq "","'hidden'","''")# alert">
            <a href=="##" class="close" data-dismiss="alert">&times;</a>
            #rc.error#
        </div>
        <fieldset>
            <legend>Please Login</legend>
            <div class="control-group">
                <label class="control-label" for="username">Username</label>
                <div class="controls">
                    <input type="text" id="j_username" name="j_username" value="#rc.username#" />
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="password">Password</label>
                <div class="controls">
                    <input type="password" id="j_password" name="j_password" value="#rc.password#" />
                </div>
            </div>
            <div id="remember-me" class="control-group">
                <div class="controls">
                    <label class="checkbox" id="remember-label" for="remember">
                        Remember Me
                        <input type="checkbox" value="y" name="rememberme"  #IIf(rc.rem,"'checked=checked'","''")# />
                    </label>
                </div>
            </div>
        </fieldset>
        <div class="pull-right">
            <button type="submit" class="btn btn-large">
                Login
            </button>
        </div>
    </form>
</div>
</cfoutput>