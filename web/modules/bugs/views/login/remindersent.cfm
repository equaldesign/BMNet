<cfset getMyPlugin(plugin="jQuery").getDepends("validate","login")>
	
			<cfoutput>
			<form method="post" id="loginForm">
				<fieldset>
					<legend>Sent</legend>
					<div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
						<p><span style="float: left; margin-right: 0.3em;" class="Aristo ui-icon ui-icon-alert"></span>	
						<strong>Reminder Sent</strong></p>
						<p>A password reminder has been sent to you email address, which you should receive within the next 10 minutes.</p>
						<p>If you do not receive the email, it may be because it has been blocked by spam filters.</p>
						<p>To be sure, it is probably worth adding <pre>no-reply@#cgi.HTTP_HOST#</pre> to your safe senders list.</p>
						<p><a href="/login/index">Continue back to login &raquo;</a></p>		
					</div>								
					<br clear="all" />					
				</fieldset>
			</form>
			</cfoutput>
