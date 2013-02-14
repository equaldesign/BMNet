<cfset getMyPlugin(plugin="jQuery").getDepends("","email/tableData","recipients")>
<cfoutput>
<ul class="nav nav-tabs" id="responseTabs">
  <li class="active"><a data-toggle="tab" href="##sent">Emails Sent</a></li>
  <li><a data-toggle="tab" href="##reads">Emails Read</a></li>
  <li><a data-toggle="tab" href="##clicks">Email Clicks Throughs</a></li>
  <li><a data-toggle="tab" href="##bounces">Bounced Emails</a></li>
  <li><a data-toggle="tab" href="##unsubscribes">Unsubscribes</a></li>
</ul>
<div class="tab-content">
  <div class="tab-pane active" id="sent">
    <div class="widget-box">
      <div class="widget-title">
        <h5>Emails Sent</h5>
      </div>
      <div class="widget-content nopadding">
        <table filter-type="" campaign-id="#rc.campaign.id#" class="eTable table table-condensed table-striped" id="emailsSent">          
          <thead>
            <tr>
              <th>Contact ID</th>
              <th>Company ID</th>
              <th>Name</th>
              <th>Company</th>
              <th>Email</th>
              <th>Date/Time Sent</th>
            </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="tab-pane" id="reads">
    <div class="widget-box">
      <div class="widget-title">
        <h5>Emails Read</h5>
      </div>
      <div class="widget-content nopadding">
        <table filter-type="read" campaign-id="#rc.campaign.id#" class="eTable table table-condensed table-striped" id="emailsRead"          
          <thead>
            <tr>
              <th>Contact ID</th>
              <th>Company ID</th>
              <th>Name</th>
              <th>Company</th>
              <th>Email</th>
              <th>Date/Time Read</th>
              <th>IP Address</th>
            </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="tab-pane" id="clicks">
    <div class="widget-box">
      <div class="widget-title">
        <h5>Email Click Throughs</h5>
      </div>
      <div class="widget-content nopadding">
        <table filter-type="click" campaign-id="#rc.campaign.id#" class="eTable table table-condensed table-striped" id="emailClicks">
          <thead>
            <tr>
              <th>Contact ID</th>
              <th>Company ID</th>
              <th>Name</th>
              <th>Company</th>
              <th>Email</th>
              <th>Date/Time Read</th>
              <th>IP Address</th>
              <th>Destination Address</th>
            </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="tab-pane" id="bounces">
    <div class="widget-box">
      <div class="widget-title">
        <h5>Emails Bounced</h5>
      </div>
      <div class="widget-content nopadding">
        <table filter-type="bounce" campaign-id="#rc.campaign.id#" class="eTable table table-condensed table-striped" id="emailsbounced">
          <thead>
            <tr>
              <th>Contact ID</th>
              <th>Company ID</th>
              <th>Name</th>
              <th>Company</th>
              <th>Email</th>
              <th>Date/Time</th>
            </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
  </div>
  <div class="tab-pane" id="unsubscribes">
    <div class="widget-box">
      <div class="widget-title">
        <h5>Emails Unsubscribes</h5>
      </div>
      <div class="widget-content nopadding">
        <table filter-type="unsubsribe" campaign-id="#rc.campaign.id#" class="eTable table table-condensed table-striped" id="removes">
          <thead>
            <tr>
              <th>Contact ID</th>
              <th>Company ID</th>
              <th>Name</th>
              <th>Company</th>
              <th>Email</th>
              <th>Date/Time</th>
            </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
  </div>
</div>
</cfoutput>