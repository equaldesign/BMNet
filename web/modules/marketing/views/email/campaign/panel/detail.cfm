<cfset getMyPlugin(plugin="jQuery").getDepends("highcharts,highstock","email/responses","recipients")>
<cfoutput>
<h3>Campaign Detail</h3>
<div class="row-fluid">
  <div class="span6">
    <div class="widget">
      <div class="widget-header">
        <h3>Summary of user Interactions for this campaign</h3>
      </div>
      <div class="widget-content">
        <div campaign-id="#rc.campaign.id#" id="campaignPie"></div>
      </div>
    </div>
  </div>
  <div class="span6">
    <div class="widget">
      <div class="widget-header">
        <h3>Users Interactions for this campaign over time</h3>
      </div>
      <div class="widget-content">
        <div campaign-id="#rc.campaign.id#" id="campaignDetail"></div>
      </div>
    </div>
  </div>
</div>
</cfoutput>