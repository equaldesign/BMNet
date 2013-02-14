<cfset getMyPlugin(plugin="jQuery").getDepends("validate","secure/profile/emailnotifications","")>
<cfoutput>
<form id="emailSettings" action="/slingshot/profile/userprofile" method="post" class="form form-horizontal">
	<fieldset>
		<legend>Email settings</legend>
		<div class="control-group">
			<label class="control-label">Notifications</label>
			<div class="controls">
				<label class="checkbox">
					<input id="emailNotifications" type="checkbox" name="n" value="on" #vm(rc.user.emailFeedDisabled,false,"checkbox")# />
					Email me updates
					<p class="help-block">If you check this box, you will be sent a daily email with updates for <a href="/blog/item?nodeRef=blog/post/node/workspace/SpacesStore/4b798e11-4b75-4894-a0cf-39a8176869a2&siteID=buildingVine">sites you are following</a> - this could include press releases, promotions, product updates and price changes</p>
					<br /><div class="alert alert-info">
						<a href="##" class="close">&times;</a>
						<p><strong>Note: </strong>Whilst it is unlikely any sites will "spam you", we do not monitor or moderate content automatically, so the possiblity is not guaranteed. However, we do not condone spamming in any form; any case of perceived spamming should be reported to us and we will investigate immediately.</p>
						<p>You can also of course also "opt-out" of any sites by "unfollowing" them - which you can do from the companies page or from the company homepage. If you are receiving updates that you would classify as spam, and that do not benefit you, "unfollowing" these companies should resolve the issue.</p>
					</div>					
				</label>
			</div>
		</div>
		<div class="form-actions">
		  <input type="submit" class="btn btn-success" value="Save my preferences">
		</div>
		<input type="hidden" id="userName" value="#rc.buildingVine.username#" /> 
	</fieldset>
</form>
</cfoutput>