<cfset getMyPlugin(plugin="jQuery").getDepends("ratings","secure/sites/rating","jQuery/jQuery.ratings")>
<cfset site = rc.site>
<cfoutput>
<div class="page-header">
	<h1>#site.title#</h1>
</div>
<div class="row-fluid">
	<div class="span8">
    <p>#paragraphFormat(site.description)#</p>
		
	</div>
	<div class="span4">
		<img src="/modules/bv/includes/images/companies/#request.bvsiteID#/large.jpg" class="img-polaroid">		
		<br />
		<div id="raitings">
			<h4>Product Data Rating</h4>
			<table class="table table-condensed">
				<tr>
					<td>Quality</td>
					<td>
						<input data-url="#site.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(site.siteRatingNodes.Quality.rating,1,"checkbox")# value="1" />
			      <input data-url="#site.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(site.siteRatingNodes.Quality.rating,2,"checkbox")# value="2"/>
			      <input data-url="#site.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(site.siteRatingNodes.Quality.rating,3,"checkbox")# value="3"/>
			      <input data-url="#site.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(site.siteRatingNodes.Quality.rating,4,"checkbox")# value="4"/>
			      <input data-url="#site.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(site.siteRatingNodes.Quality.rating,5,"checkbox")# value="5"/>
			    </td>
			  </tr>
			  <tr>
			  	<td>Freshness</td>
			  	<td>
			  		<input data-url="#site.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(site.siteRatingNodes.freshNess.rating,1,"checkbox")# value="1" />
			      <input data-url="#site.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(site.siteRatingNodes.freshNess.rating,2,"checkbox")# value="2"/>
			      <input data-url="#site.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(site.siteRatingNodes.freshNess.rating,3,"checkbox")# value="3"/>
			      <input data-url="#site.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(site.siteRatingNodes.freshNess.rating,4,"checkbox")# value="4"/>
			      <input data-url="#site.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(site.siteRatingNodes.freshNess.rating,5,"checkbox")# value="5"/>
			  	</td>
			  </tr>
			  <tr>
			  	<td>Comprehensiveness</td>
			  	<td>
			  		<input data-url="#site.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(site.siteRatingNodes.Comprehensiveness.rating,1,"checkbox")# value="1" />
			      <input data-url="#site.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(site.siteRatingNodes.Comprehensiveness.rating,2,"checkbox")# value="2"/>
			      <input data-url="#site.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(site.siteRatingNodes.Comprehensiveness.rating,3,"checkbox")# value="3"/>
			      <input data-url="#site.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(site.siteRatingNodes.Comprehensiveness.rating,4,"checkbox")# value="4"/>
			      <input data-url="#site.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(site.siteRatingNodes.Comprehensiveness.rating,5,"checkbox")# value="5"/>
			  	</td>
			  </tr>
			</table>			 
		 	<cfif IsUserLoggedIn()>
			  <!--- do they want to join or request to join? --->
			  <cfif site.siteRole eq "">
			    <cfif site.visibility eq "PUBLIC">
			      <a data-username="#rc.buildingvine.username#" href="/alfresco/service/api/sites/#site.shortName#/memberships?user_ticket=#request.buildingVine.user_ticket#" class="joinSite btn btn-success">Join/Follow</a>
			    <cfelse>
			      <cfset thisInviteTicket = arrayOfStructsFind(rc.invitations.data,"resourceName",site.shortName)>
			      <cfif  thisInviteTicket eq 0> 
			        <a data-username="#rc.buildingvine.username#" href="/alfresco/service/api/sites/#site.shortName#/invitations?user_ticket=#request.buildingVine.user_ticket#" class="requestAccess btn btn-warning">Request Access</a>
			      <cfelse>
			        <cfset inviteTicket = rc.invitations.data[thisInviteTicket].inviteID>
			        <a data-username="#rc.buildingvine.username#" href="/alfresco/service/api/invite/cancel?inviteId=#inviteTicket#&user_ticket=#request.buildingVine.user_ticket#" class="cancelAccess btn btn-inverse">Cancel Request</a>
			      </cfif>
			    </cfif>    
			  <cfelse>
			    
			     <a href="/alfresco/service/api/sites/#site.shortName#/memberships/#request.buildingvine.username#?user_ticket=#request.buildingVine.user_ticket#" class="leaveSite btn btn-mini btn-info">Unfollow/Leave site</a>                 
			    <cfif site.siteRole eq "SiteManager">
			    <a href="/alfresco/service/api/sites/#site.shortName#?user_ticket=#request.buildingVine.user_ticket#" class="deleteSite btn-mini pull-right btn btn-danger">Delete site</a>
			    </cfif>  
			  </cfif>
			</cfif>
			<br /><br />
			<div class="thumbnail">
			  <img src="http://maps.googleapis.com/maps/api/staticmap?center=<cfif paramValue("rc.site.customProperties.address1.value","") neq "">#rc.site.customProperties.address1.value#,</cfif><cfif paramValue("rc.site.customProperties.address2.value","") neq "">#rc.site.customProperties.address2.value#,</cfif><cfif paramValue("rc.site.customProperties.address3.value","") neq "">#rc.site.customProperties.address3.value#,</cfif><cfif paramValue("rc.site.customProperties.town.value","") neq "">#rc.site.customProperties.town.value#,</cfif><cfif paramValue("rc.site.customProperties.county.value","") neq "">#rc.site.customProperties.county.value#,</cfif><cfif paramValue("rc.site.customProperties.postcode.value","") neq "">#rc.site.customProperties.postcode.value#,</cfif>&zoom=13&size=250x250&markers=color:green%7C<cfif paramValue("rc.site.customProperties.address1.value","") neq "">#rc.site.customProperties.address1.value#,</cfif><cfif paramValue("rc.site.customProperties.address2.value","") neq "">#rc.site.customProperties.address2.value#,</cfif><cfif paramValue("rc.site.customProperties.address3.value","") neq "">#rc.site.customProperties.address3.value#,</cfif><cfif paramValue("rc.site.customProperties.town.value","") neq "">#rc.site.customProperties.town.value#,</cfif><cfif paramValue("rc.site.customProperties.county.value","") neq "">#rc.site.customProperties.county.value#,</cfif><cfif paramValue("rc.site.customProperties.postcode.value","") neq "">#rc.site.customProperties.postcode.value#,</cfif>&sensor=false" />
			  <div class="caption">
			  	<address>
			      <strong>#paramValueBR("rc.site.title","")#</strong> 
			      #paramValueBR("rc.site.customProperties.address1.value","")#     
			      #paramValueBR("rc.site.customProperties.address2.value","")#
			      #paramValueBR("rc.site.customProperties.address3.value","")#
			      #paramValueBR("rc.site.customProperties.town.value","")#
			      #paramValueBR("rc.site.customProperties.county.value","")#
			      #paramValueBR("rc.site.customProperties.postcode.value","")#
			      <strong>Tel: </strong>#paramValue("rc.site.customProperties.telephone.value","")#<br />
						<strong>Email: </strong>#paramValue("rc.site.customProperties.email.value","")#<br />
			    </address>
			  </div>
			</div>
		</div>
	</div>
</div>
</cfoutput>
