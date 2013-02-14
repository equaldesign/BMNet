<div class="Logo floatleft"><img src="https://d25ke41d0c64z1.cloudfront.net/includes/images/toplogo.png" alt="Building Vine"/></div>
<div id="topright" class="floatright">
	<cfset r = getPlugin("cookiestorage").getVar(name="rememberMe",default="checked")>
    <div class="login">
      <form action="https://www.buildingvine.com/bv/login/doLogin" method="post">
	      <label for="username">LOGIN</label><input type="text" id="username" name="username" class="logininput login_username" />
	      <input type="password" name="password" id="password" class="logininput login_password" />
	      <input type="image" src="https://d25ke41d0c64z1.cloudfront.net/includes/images/login.png" id="login_button" />
				<div id="remember">
				  <label class="remember" for="rememberMe">Keep me signed in</label>
				  <cfoutput><input class="rememberCheck" type="checkbox" id="rememberMe" name="rememberMe" value="y" checked="#r#" /></cfoutput>
          <span id="passwordLost"><a href="/profile/resetPassword">forgotten your password?</a></span>
			  </div>
      </form>
    </div>
    <div id="menubar">
      <ul>
        <li><a class="n-home" href="/">home</a></li>
        <li><a class="n-faqs" href="/bvblog">news and examples</a></li>
        <li><a class="n-faqs" href="/pages/faqs">what is it?</a></li>
      </ul>
    </div>
  </div>
<br class="clear" />