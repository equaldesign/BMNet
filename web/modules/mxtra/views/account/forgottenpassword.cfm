 <cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy,validate.min,form","sites/#rc.sess.siteID#/turnbull,sites/#rc.sess.siteID#/checkout","sites/#rc.sess.siteID#/checkout,sites/#rc.sess.siteID#/style,sites/#rc.sess.siteID#/shop,sites/#rc.sess.siteID#/screenShotPreview")>
 <div class="form-signUp">
      <cfoutput>
      <form method="post" action="/login/passwordReminder" id="loginForm">
        <fieldset>
          <legend>Forgotten password</legend>
          <div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
            <p><span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-alert"></span>
            <strong>Email address</strong></p>
            <p>Please enter the email address registered against your user account</p>
          </div>
          <div>
            <label class="o" for="email">email address<em>*</em></label>
            <input type="text" id="email" name="email" value="#rc.username#" />
          </div>
          <div class="buttonrow">
            <input class="doIt" type="submit" value="Email my password &raquo;" />
            <br clear="all" />
          </div>
          <br clear="all" />
        </fieldset>
      </form>
      </cfoutput>
</div>