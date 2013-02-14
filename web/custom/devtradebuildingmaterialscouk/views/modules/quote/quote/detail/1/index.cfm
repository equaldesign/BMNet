<cfset getMyPlugin(plugin="jQuery").getDepends("","map/request/merchant","")>
<div class="row">
  <div class="span5">
    <div class="widget big-stats-container">
      <div class="widget-header">
        <i class="icon-pendingquotes"></i>
        <h3><cfoutput>#rc.quote.quoteRequest.internalReference#</cfoutput></h3>
      </div>
      <div class="widget-content">
        <div id="big_stats" class="cf">
          <div class="stat">
            <h4>Products required</h4>
            <span class="value"><cfoutput>#rc.quote.quoteRequest.recordCount#</cfoutput></span>
          </div> <!-- .stat -->
          <div class="stat">
            <h4>Hours to deadline</h4>
            <span class="value"><cfoutput>#DateDiff("h",now(),rc.quote.quoteRequest.deadline)#</cfoutput></span>
          </div> <!-- .stat -->
          <div class="stat">
            <h4>Responses</h4>
            <span class="value"><cfoutput>#5-rc.quote.slotsRemaining#</cfoutput></span>
          </div> <!-- .stat -->
        </div>
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
  <div class="span4">
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
    <h3>Responses</h3>
  </div> <!-- /widget-header -->
  <div class="widget-content">
    <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th></th>
          <th width="80%">Supplier</th>
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
          <td><a href="/quote/respond/view?id=#responseID#">#companyName#</a> <cfif interested eq "false">(rejected)</CFIF></td>
          <td>&pound;#DecimalFormat(totalItems)#</td>
          <cfif rc.quote.quoteRequest.delivered>
          <td>&pound;#DecimalFormat(deliveryCharge)#</td>
          </cfif>
          <td>#DateFormat(validuntil,"DD/MM/YYYY")#</td>
          <td>#paymentMethod#</td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div> <!-- /widget-content -->
</div>
<hr />