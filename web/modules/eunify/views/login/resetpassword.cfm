<cfset getMyPlugin(plugin="jQuery").getDepends("validate","login/reminder")>

			<cfoutput>
			<form method="post" action="#bl('login.passwordReminder')#" id="loginForm">
				<fieldset>
					<legend>Forgotten password</legend>
					<div id="errorMessage" style="padding: 0pt 0.7em;" class="#IIf(rc.error eq "","'hidden'","''")# Aristo ui-state-error ui-corner-all">
						<p><span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-alert"></span>
						<span id="messagetext"></span>
					</div>
					<div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
						<p><span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-alert"></span>
						<strong>Email address</strong></p>
						<p>Please enter the email address registered against your user account</p>
					</div>
					<div>
						<label class="l" for="email">email address<em>*</em></label>
						<input size="18" type="text" id="email" name="email" value="#rc.username#" />
					</div>
			    <div>
				    <input class="doIt" type="submit" value="Email my password &raquo;" />
						<br clear="all" />
			    </div>
					<br clear="all" />
				</fieldset>
			</form>
			</cfoutput>
