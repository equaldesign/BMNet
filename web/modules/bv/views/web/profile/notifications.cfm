<cfset getMyPlugin(plugin="jQuery").getDepends("validate","secure/profile/emailnotifications","")>
<cfoutput>
	<ul id="myTab" class="nav nav-tabs">
    <li class="active"><a href="##home" data-toggle="tab"><i class="icon-building"></i>Site Specific Subscriptions</a></li>
    <li><a href="##profile" data-toggle="tab"><i class="icon-globe"></i>Global Subscriptions &amp; Email Settings</a></li>  
  </ul>
  <div id="myTabContent" class="tab-content">
    <div class="tab-pane fade in active" id="home">
      <cfloop array="#rc.siteList#" index="site">
      	<div class="media">
				  <a class="pull-left" href="/site/#site.shortName#">
			    <cfset uImage = paramImage2("/fs/sites/ebiz/buildersMerchant.net/1.4.buildersMerchant.net/web","/modules/bv/includes/images/companies/#site.shortName#/small.jpg","/modules/bv/includes/images/companies/generic.jpg")>
	        <img title="#xmlFormat(site.title)#" class="pull-left media-object img-polaroid" width="46" height="46" alt="#xmlFormat(site.title)#" src="#uImage#" />
			  	</a>
		  		<div class="media-body">
		    		<h4 class="media-heading">
							<a href="/site/#site.shortName#">#site.title#</a>
		    		</h4>		    		
		    		<div class="btn-toolbar">
			    		<div class="btn-group" data-toggle="buttons-checkbox">
							  <button data-site="#site.shortName#" data-appId="blog" type="button" class="changeFeed btn btn-mini #hasSubscription(rc.controls,site.shortName,"blog")#">Disable News Updates</button>
							  <button data-site="#site.shortName#" data-appId="products" type="button" class="changeFeed btn btn-mini #hasSubscription(rc.controls,site.shortName,"products")#">Disable Product Updates</button>
							  <button data-site="#site.shortName#" data-appId="promotions" type="button" class="changeFeed btn btn-mini #hasSubscription(rc.controls,site.shortName,"promotions")#">Disable Promotional Updates</button>						  
							</div>
							<div class="btn-group">
								<button data-site="#site.shortName#" data-toggle="button" data-appId="" type="button" class="changeFeed btn btn-mini btn-danger #hasSubscription(rc.controls,site.shortName)#">Disable All updates</button>
								<!--- <button data-site="#site.shortName#" data-toggle="button" data-appId="" type="button" class="unfollow btn btn-mini btn-danger">Unfollow</button>--->
							</div>
						</div>
		    		<!--- show opt controls --->
		    		
		    	</div>
		    </div>
      </cfloop>
    </div>
    <div class="tab-pane fade" id="profile">
      <form id="emailSettings" action="/slingshot/profile/userprofile" method="post" class="form form-horizontal">
				<fieldset>					
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
					<input type="hidden" id="userName" value="#request.buildingVine.username#" /> 
					<input type="hidden" id="ticket" value="#request.buildingVine.user_ticket#" /> 
				</fieldset>
			</form>
    </div>    
  </div>

</cfoutput>
<cffunction name="hasSubscription" output="true">
	<cfargument name="s" required="true">
	<cfargument name="siteName" required="true">
	<cfargument name="appID" required="true" default="">
	<cfloop array="#arguments.s#" index="a">
		<cfif a.siteId eq arguments.siteName>
			<cfif arguments.appID eq "">				
				<cfif a.appToolId eq "">
					<cfreturn "active">						
				</cfif>				
			<cfelse>
				<cfif a.appToolId eq arguments.appID>
					<cfreturn "active">
				</cfif>
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn "">
</cffunction>