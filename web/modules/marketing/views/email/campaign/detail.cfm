<cfset getMyPlugin(plugin="jQuery").getDepends("","menus","tables",true,"eunify")>
<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-mail"></i></span>
    <h5>#rc.campaign.name#</h5>    
  </div>
</div>

  <div class="tabs-vertical row-fluid tabs-left">
    <ul class="nav nav-tabs">
      <cfif isBoolean(rc.campaign.sent) AND rc.campaign.sent>
        <li><a class="noAjax" href="#bl('email.campaign.view','view=detail&id=#rc.id#')#"><i class="icon-email"></i><span>Detail</span></a></li>
        <li><a class="noAjax" href="#bl('email.campaign.view','view=interactions&id=#rc.id#')#"><span><i class="icon-list"></i>Detailed Interactions</span></a></li>
        <li><a class="noAjax" href="#bl('email.campaign.view','view=mapView&id=#rc.id#')#"><span><i class="icon-pushpin"></i>Map View</span></a></li>
      <cfelseif isUserInRole("CreateCampaign")>
        <li><a class="noAjax" href="#bl('email.campaign.view','view=editdetail&id=#rc.id#')#"><span><i class="icon-pencil"></i>Edit Detail</span></a></li>
        <cfif isNUmeric(rc.campaign.id)>
          <li><a class="noAjax" href="#bl('email.campaign.view','view=recipients&id=#rc.id#')#"><span><i class="icon-mails-stack"></i>Email Recipients</span></a></li>
          <li><a class="noAjax" href="#bl('email.campaign.view','view=template&id=#rc.id#')#"><span><i class="icon-mail--pencil"></i>Email Template</span></a></li>
          <cfif IsUserInRole("SendCampaign")>
            <li><a class="noAjax" href="#bl('email.campaign.view','view=send&id=#rc.id#')#"><span><i class="icon-mail--arrow"></i>Send Campaign</span></a></li>
          </cfif>
        </cfif>
      </cfif>
    </ul>
</div>
</cfoutput>

