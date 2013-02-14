<cfset getMyPlugin(plugin="jQuery").getDepends("validate","login","fonts,main,form,medium,login,Aristo/jQueryUI",false,"eunify")>

<div id="distance"></div>
<div id="content">
	<div id="loginBox">
		<img align="left" src="/includes/images/#getSetting("sitename")#logo.png" />
		<div class="form-signUp">
			<cfoutput>
			<form method="post" action="#bl('login.doLogin')#" id="loginForm">
				<fieldset>
					<legend>Please login</legend>
					<div id="errorMessage" style="padding: 0pt 0.7em;" class="Aristo ui-state-error ui-corner-all">
						<p><span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-alert"></span>
						<span id="messagetext"></span>
					</div>
					<div>
						<label class="l" for="j_username">username</label>
						<input type="text" id="username" name="j_username" value="#rc.username#" />
					</div>
					<div>
						<label class="l" for="j_password">password</label>
						<input type="password" id="password" name="j_password" value="#rc.password#" />
					</div>
					<div>
						<label class="l" for="rememberme">rememberssss me</label>
						<input #IIf(rc.rem,"'checked=checked'","''")# type="checkbox" value="y" name="rememberme"  />
					</div>
			    <div>
				    <input class="doIt" type="submit" value="Login &raquo;" />
			    </div>
					<br clear="all" />
					<div>
				    <a href="##" class="forgottenPassword" />Forgotten your password?</a>
			    </div>
				</fieldset>
			</form>
			</cfoutput>
		</div>
	</div>
	<div id="copyRight">
		<p>Copyright 2010 <a target="_blank" href="http://ebizuk.net">eBiz</a></p>
		<p>Licensed under the GNU General Public Licence Version 3 (<a target="_blank" href="http://www.gnu.org/licenses/quick-guide-gplv3.html">GPLv3</a>).</p>
	</div>
	<br clear="all" />
</div>
