<cfoutput>
    <cfloop array="#rc.sites#" index="site">

      <div class="siteList">
        <div class="media">
          <cfif site.siteRole neq ""  OR site.visibility eq "PUBLIC"><a class="pull-left" href="/site/#site.shortName#"></cfif>
            <cfset uImage = paramImage2("/fs/sites/ebiz/buildersMerchant.net/1.4.buildersMerchant.net/web","/modules/bv/includes/images/companies/#site.shortName#/small.jpg","/modules/bv/includes/images/companies/generic.jpg")>
            <img title="#xmlFormat(site.title)#" class="pull-left media-object img-polaroid" width="46" height="46" alt="#xmlFormat(site.title)#" src="#uImage#" />           
          <cfif site.siteRole neq ""  OR site.visibility eq "PUBLIC"></a></cfif>
          <div class="media-body">
            <h4 class="media-heading">
              <cfif site.siteRole neq ""  OR site.visibility eq "PUBLIC"><a href="/site/#site.shortName#"></cfif>
              #site.title#</h4>
              <cfif site.siteRole neq ""  OR site.visibility eq "PUBLIC"><a href="/site/#site.shortName#"></a></cfif>
              <div>#ParagraphFormat(site.description)#</div>
              <div class="rating">

              <cfif site.siteRatingNodes.Quality.rating neq 0 OR site.siteRatingNodes.Freshness.rating neq 0 OR site.siteRatingNodes.Comprehensiveness.rating neq 0>
                <cfset averageOverAll = int(((site.siteRatingNodes.Quality.rating+site.siteRatingNodes.Freshness.rating+site.siteRatingNodes.Comprehensiveness.rating)/3))>
                <cfif averageOverAll gt 3>
                   <cfset label = "label-success">
                <cfelseif averageOverAll gt 1>
                  <cfset label = "label-warning">
                <cfelse>
                  <cfset label = "label-important">
                </cfif>
              <cfelse>
                <cfset averageOverAll = 0>
                <cfset label = "">
              </cfif>
              <span class="label #label#">Rating</span>
              <cfloop from="1" to="5" index="i">
                <cfif averageOverAll gte i>
                  <img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/star.png" />
                <cfelse>
                  <img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/star-empty.png" />
                </cfif>
              </cfloop>
              <cfif isDefined("site.customProperties.companyType.value")>
                <span class="label label-info pull-right">#site.customProperties.companyType.value#</span>
              </cfif>              
            </div><br />
            <cfif IsUserLoggedIn()>
              <!--- do they want to join or request to join? --->
              <cfif site.siteRole eq "">
                <cfif site.visibility eq "PUBLIC">
                  <a data-username="#request.buildingvine.username#" href="/alfresco/service/api/sites/#site.shortName#/memberships?alf_ticket=#request.buildingVine.user_ticket#" class="joinSite btn btn-success">Join/Follow</a>
                <cfelse>
                  <cfset thisInviteTicket = arrayOfStructsFind(rc.invitations.data,"resourceName",site.shortName)>
                  <cfif  thisInviteTicket eq 0>
                    <a data-username="#request.buildingvine.username#" href="/alfresco/service/api/sites/#site.shortName#/invitations?alf_ticket=#request.buildingVine.user_ticket#" class="requestAccess btn btn-warning">Request Access</a>
                  <cfelse>
                    <cfset inviteTicket = rc.invitations.data[thisInviteTicket].inviteID>
                    <a data-username="#rc.buildingvine.username#" href="/alfresco/service/api/invite/cancel?inviteId=#inviteTicket#&alf_ticket=#request.buildingVine.user_ticket#" class="cancelAccess btn btn-inverse">Cancel Request</a>
                  </cfif>
                </cfif>
              <cfelse>

                 <a href="/alfresco/service/api/sites/#site.shortName#/memberships/#request.buildingvine.username#?alf_ticket=#request.buildingVine.user_ticket#" class="leaveSite btn btn-info">Unfollow/Leave site</a>
                <cfif site.siteRole eq "SiteManager">
                <a href="/alfresco/service/api/sites/#site.shortName#?alf_ticket=#request.buildingVine.admin_ticket#" class="deleteSite pull-right btn btn-danger">Delete site</a> 
                </cfif>
              </cfif>
            </cfif>
          </div>          
        </div>        
      </div>
    </cfloop>
  </cfoutput>