<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/promotions/list","secure/promotions/view")>
<div class="page-header">
<h1>
  <cfswitch expression="#rc.type#">
    <cfcase value="current">Current</cfcase>
    <cfcase value="pending">Pending</cfcase>
    <cfcase value="expired">Expired</cfcase>
  </cfswitch> Promotions</h1>
</div>
<cfoutput>
<cfif arrayLen(rc.promotions) eq 0>
<div class="alert alert-info">
  <a class="close" data-dismiss="alert">&times;</a>
  <h4 class="alert-heading">What a shame!</h4>
  <p>There are no #rc.type# promotions available to view!</p>
</div>
</cfif>
<cfloop array="#rc.promotions#" index="promotion">
  <div class="row">
    <div class="pull-left span4">
      <ul class="thumbnails">
        <cfif arrayLen(promotion.files) gte 1>
         <li class="span4">
            <a class="ttip thumbnail" title="#promotion.files[1].title#" target="_blank" href="https://www.buildingvine.com/alfresco#promotion.files[1].downloadUrl#?ticket=#request.user_ticket#">
						  <img src="https://www.buildingvine.com/api/productImage?nodeRef=#promotion.files[1].nodeRef#&size=large">							
						</a>
				  </li>
        </cfif>        
        <cfif arrayLen(promotion.files) gte 2>
	        <cfloop from="2" to="#arrayLen(promotion.files)#" index="p">
				    <cfset files = promotion.files[p]>
				    <li class="span1">
		          <a target="_blank" title="#files.title#" class="ttip thumbnail" href="https://www.buildingvine.com/alfresco#files.downloadUrl#?ticket=#request.user_ticket#">
		            <img src="https://www.buildingvine.com/api/productImage?nodeRef=#files.nodeRef#&size=small">
		          </a>
						</li>
	        </cfloop>
		    </cfif>
      </ul>
		</div>
		<div class="span5">      
      <h2>#promotion.name#</h2>
      <h4 class="valid"><i class="icon-clock"></i>
      	<cfswitch expression="#rc.type#">
					<cfcase value="current">
					 Valid for #DateDiff("d",now(),promotion.validTo)# more day<cfif DateDiff("d",now(),promotion.validTo) neq 1>s</cfif>
					</cfcase>
					<cfcase value="pending">
						 Starts in #DateDiff("d",now(),promotion.validFrom)# day<cfif DateDiff("d",now(),promotion.validFrom) neq 1>s</cfif>
					</cfcase>
					<cfcase value="expired">
						 Expired on #DateFormat(promotion.validFrom,"full" )#
					</cfcase>     
		    </cfswitch>
			</h4>
      <p>#promotion.description#</p>
			<cfif promotion.permissions.edit>
				<div class="well">
          <a title="Edit this promotion" class="ttip dialogOK edit" name="1. Edit Promotion" href="/promotions/edit?nodeRef=#promotion.id#"><i class="icon-edit"></i>edit</a>
					<a class="confirm ttip deletep" title="Delete this promotion" href="/alfresco/service/bv/promotion?alf_ticket=#request.user_ticket#&nodeRef=#promotion.id#"><i class="icon-delete"></i>delete</a>
					<a class="dialogOK ttip noAjax" title="Edit Permissions" href="http://www.buildingvine.com/security/getSecurity?node=workspace://SpacesStore/#promotion.id#"><i class="icon-lock"></i>permissions</a>
					<cfif NOT promotion.isPublished>
						<a class="publish ttip" title="Publish this promotion" href="/alfresco/service/bv/promotion/publish?alf_ticket=#request.user_ticket#&nodeRef=#promotion.id#"><i class="icon-save"></i>publish</a>
					</cfif>
				</div>
			</cfif>      
    </div>
  </div>
</cfloop>
</cfoutput>