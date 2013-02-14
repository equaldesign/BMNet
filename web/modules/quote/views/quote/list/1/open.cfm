<div class="widget widget-table action-table">
  <div class="widget-header">
    <i class="icon-pendingquotes"></i>
    <h3>Open Quotations</h3>
  </div> <!-- /widget-header -->
  <div class="widget-content">
    <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th>Reference</th>
          <th>Created</th>
					<th>Deadline</th>
					<th>Delivered?</th>
					<th>Delivery Postcode</th>
        </tr>
      </thead>
      <tbody>
      	<cfoutput query="rc.pendingQuotations">
        <tr>
          <td><a href="/quote/detail/trade?id=#id#">#internalReference#</a></td>
          <td>#DateFormatOrdinal(created,"DDDD D MMMM")#</td>
          <td>#DateFormatOrdinal(deadline,"DDDD D MMMM")#</td>
					<td class="td-actions">
            <i class="icon-delivered-#delivered#"></i>
          </td>
					<td>#deliveryPostcode#</td>
        </tr>
		    </cfoutput>
		    <cfif rc.pendingQuotations.recordCount eq 0>
				<tr>
					<td colspan="5">No pending Quotations</td>
				</tr>
			  </cfif>
      </tbody>
    </table>
  </div> <!-- /widget-content -->
</div>