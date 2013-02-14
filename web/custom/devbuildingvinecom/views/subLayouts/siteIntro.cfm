<cfset getMyPlugin(plugin="jQuery").getDepends("ratings","secure/sites/rating","jQuery/jQuery.ratings")>
<cfoutput>
<cfif isDefined("rc.siteDetail.customProperties.siteBanner.value")>
  <cfset imageNode = ListLast(rc.siteDetail.customProperties.siteBanner.value,"/")>
<cfelse>
  <cfset imageNode = "e71f2bd0-1f5d-4497-80b8-aeaf359b99dd">
  <cfif ArrayLen(rc.products.results) gte 1>
    <cfloop array="#rc.products.results#" index="product">
      <cfif arrayLen(product.productImage) gte 1>
        <cfset imageNode = product.productImage[1].nodeRef>
        <cfbreak>
      </cfif>
    </cfloop>
  </cfif>
  
</cfif>

<div style="margin-top: -60px; padding:20px; margin-bottom: 10px; background: url('http://www.buildingvine.com/api/i?nodeRef=#imageNode#&size=1900&crop=true&aspect=16:5') top right; background-size:100%; height: 100%; display: block">
  <div class="container siteIntro">
    <div class="row">
      <div class="span8">
        <div class="media">
          <a class="pull-left" href="##">
            <img src="#defImage#" width="46" height="46" class="media-object img-polaroid" />
          </a>
          <div class="media-body">
            <h4 class="media-heading">#rc.siteDetail.title#</h4>
            #rc.siteDetail.description#
            <cfif ArrayLen(rc.products.results) gte 1>
              <h4>Featured Products</h4>            
              <!--- product listings --->
              <ul class="thumbnails">
                <cfloop array="#rc.products.results#" index="product" maxrows="6">                     
                  <li class="span1">
                  <a class="ttip" title="#product.title#" href="#bl("products.productDetail","siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#product.nodeRef#")#">
                    <cfif ArrayLen(product.productImage) gte 1>
                      <img class="img-polaroid media-object" src="https://www.buildingvine.com/api/productImage?nodeRef=#product.productImage[1].nodeRef#&size=90&crop=true&aspect1:1" />
                    <cfelse>
                      <img class="img-polaroid media-object" src="https://www.buildingvine.com/api/productImage?siteID=#rc.siteID#&eancode=#product.eancode#&size=90&supplierproductcode=#paramValue('product.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('product.attributes.manufacturerproductcode','')#&productName=#product.title#&crop=true&aspect1:1" />
                    </cfif>                    
                  </a>                        
                  </li>                              
                </cfloop>
              </ul>
            </cfif>
          </div>
        </div>
      </div>
      <div class="span4">
        <br />
        <h4>Product Data Rating</h4>
        <table class="table table-condensed">
          <tr>
            <td>Quality</td>
            <td>
              <input data-url="#rc.siteDetail.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Quality.rating,1,"checkbox")# value="1" />
              <input data-url="#rc.siteDetail.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Quality.rating,2,"checkbox")# value="2"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Quality.rating,3,"checkbox")# value="3"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Quality.rating,4,"checkbox")# value="4"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.Quality.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Quality" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Quality.rating,5,"checkbox")# value="5"/>
            </td>
          </tr>
          <tr>
            <td>Freshness</td>
            <td>
              <input data-url="#rc.siteDetail.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.freshNess.rating,1,"checkbox")# value="1" />
              <input data-url="#rc.siteDetail.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.freshNess.rating,2,"checkbox")# value="2"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.freshNess.rating,3,"checkbox")# value="3"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.freshNess.rating,4,"checkbox")# value="4"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.freshNess.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="freshNess" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.freshNess.rating,5,"checkbox")# value="5"/>
            </td>
          </tr>
          <tr>
            <td>Comprehensiveness</td>
            <td>
              <input data-url="#rc.siteDetail.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Comprehensiveness.rating,1,"checkbox")# value="1" />
              <input data-url="#rc.siteDetail.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Comprehensiveness.rating,2,"checkbox")# value="2"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Comprehensiveness.rating,3,"checkbox")# value="3"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Comprehensiveness.rating,4,"checkbox")# value="4"/>
              <input data-url="#rc.siteDetail.siteRatingNodes.Comprehensiveness.nodeRef#/ratings?alf_ticket=#request.buildingVine.user_ticket#" name="Comprehensiveness" type="radio" class="rate" #vm(rc.siteDetail.siteRatingNodes.Comprehensiveness.rating,5,"checkbox")# value="5"/>
            </td>
          </tr>
        </table>  
        <div>
          <img class="img-polaroid" src="http://maps.googleapis.com/maps/api/staticmap?center=<cfif paramValue("rc.siteDetail.customProperties.address1.value","") neq "">#rc.siteDetail.customProperties.address1.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.address2.value","") neq "">#rc.siteDetail.customProperties.address2.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.address3.value","") neq "">#rc.siteDetail.customProperties.address3.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.town.value","") neq "">#rc.siteDetail.customProperties.town.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.county.value","") neq "">#rc.siteDetail.customProperties.county.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.postcode.value","") neq "">#rc.siteDetail.customProperties.postcode.value#,</cfif>&zoom=13&size=450x150&markers=color:green%7C<cfif paramValue("rc.siteDetail.customProperties.address1.value","") neq "">#rc.siteDetail.customProperties.address1.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.address2.value","") neq "">#rc.siteDetail.customProperties.address2.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.address3.value","") neq "">#rc.siteDetail.customProperties.address3.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.town.value","") neq "">#rc.siteDetail.customProperties.town.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.county.value","") neq "">#rc.siteDetail.customProperties.county.value#,</cfif><cfif paramValue("rc.siteDetail.customProperties.postcode.value","") neq "">#rc.siteDetail.customProperties.postcode.value#,</cfif>&sensor=false" />
          <div class="caption">
            <address>
              <strong>#paramValueBR("rc.siteDetail.title","")#</strong> 
              #paramValueComma("rc.siteDetail.customProperties.address1.value","")#     
              #paramValueComma("rc.siteDetail.customProperties.address2.value","")#
              #paramValueComma("rc.siteDetail.customProperties.address3.value","")#
              #paramValueComma("rc.siteDetail.customProperties.town.value","")#
              #paramValueComma("rc.siteDetail.customProperties.county.value","")#
              #paramValueComma("rc.siteDetail.customProperties.postcode.value","")#
              <strong>Tel: </strong>#paramValue("rc.siteDetail.customProperties.telephone.value","")#<br />
              <strong>Email: </strong>#paramValue("rc.siteDetail.customProperties.email.value","")#<br />
            </address>
          </div>
        </div>
      </div>
    
      <div class="bannerFollow">
        <cfif IsUserLoggedIn()>
          <!--- do they want to join or request to join? --->
          <cfif rc.siteDetail.siteRole eq "">
            <cfif rc.siteDetail.visibility eq "PUBLIC">
              <a data-username="#request.buildingvine.username#" href="/alfresco/service/api/sites/#rc.siteDetail.shortName#/memberships?user_ticket=#request.buildingVine.user_ticket#" class="joinSite btn btn-success">Join/Follow</a>
            <cfelse>
              <cfset thisInviteTicket = arrayOfStructsFind(rc.invitations.data,"resourceName",rc.siteDetail.shortName)>
              <cfif  thisInviteTicket eq 0> 

                <a data-username="#request.buildingvine.username#" href="/alfresco/service/api/sites/#rc.siteDetail.shortName#/invitations?user_ticket=#request.buildingVine.user_ticket#" class="requestAccess btn btn-warning">Request Access</a>
              <cfelse>
                <cfset inviteTicket = rc.invitations.data[thisInviteTicket].inviteID>
                <a data-username="#request.buildingvine.username#" href="/alfresco/service/api/invite/cancel?inviteId=#inviteTicket#&user_ticket=#request.buildingVine.user_ticket#" class="cancelAccess btn btn-inverse">Cancel Request</a>
              </cfif>
            </cfif>    
          <cfelse>
            
             <a href="/alfresco/service/api/sites/#rc.siteDetail.shortName#/memberships/#request.buildingvine.username#?user_ticket=#request.buildingVine.user_ticket#" class="leaveSite btn btn-mini btn-info">Unfollow/Leave site</a>                 
          </cfif>
          <cfif isUserInRole("admin_#rc.siteDetail.shortName#")>
            <div class="btn-group">
            <button class="btn btn-mini"><i class="icon-pencil"></i> Manage</button>
            <button class="btn dropdown-toggle" data-toggle="dropdown">
              <span class="caret"></span>
            </button>
            <ul class="dropdown-menu pull-right">
              <li class="nav-header">Manage Site Users</li>
              <li><a class="shortcut manageusers" href="/bv/site/manage?siteID=#request.bvsiteID#"><i class="icon-user--pencil"></i> Edit Users/Groups</a></li>
              <li><a class="shortcut inviteusers" href="/bv/site/invite?siteID=#request.bvsiteID#"><i class="icon-user--plus"></i> Invite new Users</a></li>
              <li><a class="shortcut existingusers" href="/bv/site/invite?inviteType=existingUser&siteID=#request.bvsiteID#"><i class="icon-user--plus"></i> Invite existing Users</a></li>
              <li><a class="shortcut userlist" href="/bv/site/fullUserList?siteID=#request.bvsiteID#"><i class="icon-users"></i> Full User List</a></li>
              <li class="nav-header">Manage Site Details</li>
              <li><a class="shortcut sitecolour" href="/bv/site/settings?siteID=#request.bvsiteID#"><i class="icon-pencil"></i> Edit Details</a></li>
              <li><a class="shortcut sitelogo" href="/bv/site/logo?siteID=#request.bvsiteID#"><i class="icon-picture"></i> Change Logo</a></li>  
              <cfset siteType = paramValue("request.buildingVine.site.customProperties.companyType.value","Merchant")> 
              <!---
              <li class="nav-header">Order Fulfillment</li>
              <cfif siteType eq "Manufacturer" OR siteType eq "Distributor">      
                <li><a class="shortcut fullfilment" href="/delivery/siteoptions">Fullfilment options</a></li>
              <cfelseif siteType eq "Merchant">
                <li><a class="shortcut fullfilment" href="/delivery/overage">Fulfillment options</a></li> 
              </cfif>
              --->
              <li class="nav-header">Integration</li>
              <li><a class="shortcut siteBuyingGroups" href="/bv/site/buyinggroups?siteID=#request.bvsiteID#"><i class="icon-truck"></i> Buying Group Integration</a></li>
              <cfif rc.siteDetail.siteRole eq "SiteManager">
                <li><a href="/alfresco/service/api/sites/#rc.siteDetail.shortName#?user_ticket=#request.buildingVine.user_ticket#" class="deleteSite"><i class="icon-exclamation"></i> Delete site</a></li>
              </cfif>
            </ul>
          </div>
          </cfif>
        </cfif>
      </div>   
    </div>       
  </div>
</div>            
</cfoutput>     
<div>
  <div class="container">
    <div class="row">
      <div class="span4">
        <cfif event.getCurrentModule() eq "bv">
          <cfoutput>#renderView("web/shortcuts/#ListLast(event.getCurrentHandler(),":")#")#</cfoutput>
        </cfif>
      </div>
      <div class="span8">
        <div class="productMain">
        <cfoutput>#renderView()#</cfoutput>
        </div>
      </div>
    </div>
  </div>
</div>