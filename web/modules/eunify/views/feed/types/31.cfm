<!--- email unsubscribe

@ sourceID = contactID for respondent
@ targetID = contact Company
@ relatedID = campaignID
@message - the reason, and whether it was a full unsubscribe
--->
<cfoutput>
 <cfset cs = getModel("marketing.CampaignService")>
 <cfset co = getModel("eunify.ContactService")>
 <cfset cm = getModel("eunify.CompanyService")>
 <cfset user = co.getContact(args.data.sourceID[currentRow])>
 <cfset usercompany = getModel("eunify.CompanyService").getCompany(user.company_id)>
 <cfset emailCampaign = cs.getCampaign(args.data.relatedID[currentRow])>
  <div class="media">
    <a class="pull-left" href="/marketing/email/campaign/detail/id/#emailCampaign.id#">
      <img width="32" height="32" class="media-object img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(user.email)))#?size=32&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
    </a>
    <div class="media-body">
       <h4 class="media-heading"><i class="icon-mail-mail--exclamation"></i><a href="/marketing/email/campaign/detail/id/#emailCampaign.id#">#emailCampaign.name#</a></h4>
         <a href="#bl('contact.index','id=#user.id#')#">#user.first_name# #user.surname#</a>
         unsubscribed from #ListFirst(args.data.tstamp[currentRow],":")# because #listLast(args.data.tstamp[currentRow],":")#
         <i>#Duration(args.data.tstamp[currentRow],now())#</i>
         <cfif itemCount neq 1>
          <span class="itemCount">plus #itemCount-1# other very similar item<cfif itemCount neq 2>s</cfif></span>
         </cfif>
    </div>
  </div>
</cfoutput>