<cfset getMyPlugin(plugin="jQuery").getDepends("","map/request/merchant","")>
<div class="row-fluid">
  <div class="span6">
    <div class="widget big-stats-container">
      <div class="widget-header">
        <i class="icon-pendingquotes"></i>
        <h3><cfoutput>#rc.quote.quoteRequest.internalReference#</cfoutput></h3>
      </div>
      <div class="widget-content">
        <dl class="dl-horizontal">
          <dt>Products required</dt>
          <dd><cfoutput>#rc.quote.quoteRequest.recordCount#</cfoutput></dd>
          <dt>Hours to deadline</dt>
          <dd><cfoutput>#DateDiff("h",now(),rc.quote.quoteRequest.deadline)#</cfoutput></dd>
          <dt>Response?</dt>
          <dd><cfoutput>#5-rc.quote.slotsRemaining#</cfoutput></dd>
        </dl>
      </div> <!-- /widget-content -->
    </div>
    <br />
    <cfoutput>
      <div class="widget widget-table">
        <div class="widget-header">
          <i class="icon-info"></i>
          <h3>Overview</h3>
        </div>
        <div class="widget-content">
          <table class="table table-bordered table-striped table-condensed">
            <thead>
              <th>Delivery?</th>
              <th>Delivery Date</th>
              <th>Collection Radius</th>
              <th>Best Quote</th>
            </thead>
            <tbody>
              <tr>
                <td><i class="icon-delivered-#rc.quote.quoteRequest.delivered#"></i></td>
                <td>#DateFormatOrdinal(rc.quote.quoteRequest.deliveryDate,"DDD D MMM")#</td>
                <td>#rc.quote.quoteRequest.pickupRadius#</td>
                <td>#rc.quote.quoteRequest.bestQuote#</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

    </cfoutput>
  </div>
  <div class="span6">
    <div class="widget widget-table action-table">
      <div class="widget-header">
        <i class="icon-pendingquotes"></i>
        <h3>Products Requested</h3>
      </div>
      <div class="widget-content">
		    <table class="table table-striped table-bordered">
		      <thead>
		        <tr>
		          <th nowrap="nowrap">Quant.</th>
		          <th nowrap="nowrap">Unit</th>
		          <th width="80%">Product</th>
		        </tr>
		      </thead>
		      <tbody>

		        <cfoutput query="rc.quote.quoteRequest">
		        <tr>
		          <td>#quantity#</td>
		          <td>#unit#</td>
		          <td>#productName#</td>
		        </tr>
		        </cfoutput>
		      </tbody>
		    </table>
		  </div> <!-- /widget-content -->
    </div>
  </div>
</div>
<hr />
<div class="widget widget-table action-table">
  <div class="widget-header">
    <i class="icon-pendingquotes"></i>
    <h3>Response</h3>
  </div> <!-- /widget-header -->
  <div class="widget-content">
    <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th></th>
          <th></th>
          <th nowrap="nowrap">Cost</th>
          <cfif rc.quote.quoteRequest.delivered>
          <th nowrap="nowrap">Delivery</th>
          </cfif>
          <th nowrap="nowrap">Deadline</th>
          <th nowrap="nowrap">Payment Method</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="rc.quote.responseSummaries">
        <tr>
          <td><cfif interested eq "false"><i class="icon-cross"></i><cfelseif interested eq "true"><i class="icon-tick"></i></cfif></td>
          <td><a href="/quote/respond/view?id=#responseID#" class="btn">view details</a> <cfif interested eq "false">(rejected)</CFIF></td>
          <td>&pound;#DecimalFormat(totalItems)#</td>
          <cfif rc.quote.quoteRequest.delivered>
          <td>&pound;#DecimalFormat(deliveryCharge)#</td>
          </cfif>
          <td>#DateFormat(validuntil,"DD/MM/YYYY")#</td>
          <td>#paymentMethod#</td>
        </tr>
        </cfoutput>
        <cfif rc.quote.responseSummaries.recordCount eq 0>
        <tr>
          <td colspan="6">This quote has not been responded to yet.</td>
        </tr>
        </cfif>
      </tbody>
    </table>
  </div> <!-- /widget-content -->
</div>
<hr />