<cfset getMyPlugin(plugin="jQuery").getDepends("","email/table","")>
<cfoutput>
<div id="emailView"></div>
<input type="hidden" id="contactID" value="#rc.contactID#">
<input type="hidden" id="companyID" value="#rc.companyID#">
</cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <h5>Historic Emails</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-striped table-condensed table-hover dataTable" id="emailList">
    <thead>
      <tr>
        <th width="16"></th>
        <th>From</th>
        <th>Subject</th>
        <th>Date</th>

      </tr>
    </thead>
    <tbody></tbody>
  </table>
  </div>
</div>