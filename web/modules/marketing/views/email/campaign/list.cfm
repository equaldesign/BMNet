<cfset getMyPlugin(plugin="jQuery").getDepends("","table","",false)>
<div class="widget-box">
  <div class="widget-title">
    <h5>Email Campaigns</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-striped dataTable">      
      <thead>
        <tr>
          <th>Name</th>
          <th>Subject</th>
          <th>Date Sent</th>
          <th>Recipients</th>
          <th>Clicks</th>
          <th>Reads</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="rc.campaigns">
          <tr>
            <td><a href="#bl('email.campaign.detail','id=#id#')#">#name#</a></td>
            <td>#subject#</td>
            <td>#DateFormat(dateSent,"DD/MM/YYYY")#</td>
            <td>#recipients#</td>
            <td>#clicks#</td>
            <td>#emailreads#</td>
          </tr>
        </cfoutput> 
      </tbody>
    </table>
  </div>
</div>