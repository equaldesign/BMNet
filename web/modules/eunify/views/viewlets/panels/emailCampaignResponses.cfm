<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-mail-send"></i></span>
    <h5>Email Campaigns</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-striped table-condensed">
      <thead>
        <tr>
          <th>Campaign</th>
          <th>Action</th>
          <th>Date</th>
          <th>Town</th>
        </tr>
      </thead>
      <tbody>

        <cfloop query="rc.emailCampaignResponses">
        <tr>
          <td><a href="/marketing/campaign/detail/id/#campaignID#">#name#</a></td>
          <td>#activity#</td>
          <td>#DateFormat(responsedate,"DD/MM/YY")#</td>
          <td>#city#</td>
        </tr>
        </cfloop>

      </tbody>
    </table>
  </div>
</div>
</cfoutput>