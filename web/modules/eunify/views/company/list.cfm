<cfset getMyPlugin(plugin="jQuery").getDepends("","company/#rc.type_id#/table","")>

<cfoutput>
  <input type="hidden" id="type_id" value="#rc.type_id#">
</cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <h5>Company List</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-striped table-condensed table-hover" id="<cfoutput>company_#rc.type_id#_List</cfoutput>">
      <caption></caption>
      <thead>
        <tr>
          <th width="1%" nowrap="true">ID</th>
          <th width="1%" nowrap="true">Account Number</th>
          <th width="40%">Name</th>
          <th>Address 1</th>
          <th>Postcode</th>
          <th>Trade?</th>
          <th>Credit Limit</th>
          <th>Balance</th>
        </tr>
      </thead>
      <tbody></tbody>
    </table>
  </div>
</div>