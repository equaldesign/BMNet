<cfoutput>
<cfif rc.response.response.interested eq "false">
  <h2>This quotation was rejected</h2>
<cfelseif rc.response.response.interested eq "true">
  <h2>This quotation was accepted!</h2>
</cfif>
<div class="widget">
	<div class="widget-header">
		<i class="icon-info"></i>
    <a id="printQuote" href="/quote/respond/view?id=#rc.id#&PDF=true" class="pull-right"><i class=""></i></a>
    <h3>Detail</h3>
	</div>
	<div class="widget-content">
		<div class="row">
			<div class="span4">
				<address>
          <h3>Supplier Information</h3>
					<h4>#rc.response.seller.name#</h4>
					<cfif rc.response.seller.company_address_1 neq ""><div>#rc.response.seller.company_address_1#</div></cfif>
					<cfif rc.response.seller.company_address_2 neq ""><div>#rc.response.seller.company_address_2#</div></cfif>
					<cfif rc.response.seller.company_address_3 neq ""><div>#rc.response.seller.company_address_3#</div></cfif>
					<cfif rc.response.seller.company_address_4 neq ""><div>#rc.response.seller.company_address_4#</div></cfif>
					<cfif rc.response.seller.company_address_5 neq ""><div>#rc.response.seller.company_address_5#</div></cfif>
					<cfif rc.response.seller.company_postcode neq ""><div>#rc.response.seller.company_postcode#</div></cfif>
					<cfif rc.response.seller.company_phone neq ""><div><i class="icon-phone"></i> #rc.response.seller.company_phone#</div></cfif>
          <cfif rc.response.seller.company_website neq ""><div><i class="icon-web"></i> #rc.response.seller.company_website#</div></cfif>
				</address>
			</div>
			<div class="span4 pull-right">
        <dl class="dl-horizontal">
          <dt>Customer Ref:</dt>
          <dd>#rc.response.response.internalReference#</dd>
          <cfif rc.response.response.delivered>
          <dt>Delivery Date:</dt>
          <dd>#DateFormat(rc.response.response.responseDeliveryDate,"DD/MM/YYYY")#</dd>
          <dt>Delivery Address:</dt>
          <dd>
            <address>
              <cfif rc.response.response.deliveryAddress neq ""><div>#rc.response.response.deliveryAddress#</div></cfif>
              <cfif rc.response.response.deliveryPostcode neq ""><div>#rc.response.response.deliveryPostcode#</div></cfif>
            </address>
          </dd>
          <cfelse>
          <dt>Delivery:</dt>
          <dd>This order <strong>must be collected</strong></dd>
          </cfif>
          <dt>Valid Until:</dt>
          <dd>#DateFormatOrdinal(rc.response.response.validUntil,"DDD D MMM YYYY")#</dd>
          <dt>Deadline:</dt>
          <dd>#DateFormatOrdinal(rc.response.response.deadline,"DDD D MMM YYYY")#</dd>

        </dl>
			</div>
		</div>
	</div>
</div>
<div class="widget widget-table action-table">
  <div class="widget-header">
    <i class="icon-pendingquotes"></i>
    <h3>Products</h3>
  </div>
  <div class="widget-content">
    <table id="quoteTable" class="table table-striped table-bordered">
      <thead>
        <tr>
          <th nowrap="nowrap">Quant.</th>
          <th nowrap="nowrap">Unit</th>
          <th>Product</th>
          <th>Price</th>
        </tr>
      </thead>
      <tbody>
        <cfset t = 1>
        <cfloop query="rc.response.response">
        <tr>
          <td>#quantity#</td>
          <td>#unit#</td>
          <td>#product_name#</td>
          <td>&pound;#price#</td>
        </tr>
				<cfset t+=price>
        </cfloop>
        <tr>
        	<td colspan="3">DELIVERY CHARGE</td>
					<td>&pound;#DecimalFormat(rc.response.response.deliveryCharge)#</td>
        </tr>
      </tbody>
			<tfoot>
				<tr>
					<th colspan="3">TOTAL</th>
					<th>&pound;#DecimalFormat(t+rc.response.response.deliveryCharge)#</th>
				</tr>
			</tfoot>
    </table>
  </div> <!-- /widget-content -->
</div>

<cfif rc.response.buyer.id eq request.bmnet.companyID AND rc.response.response.interested eq "notviewed">
    <cfif rc.response.response.paymentMethod eq "paypal">
      <a href="/quote/respond/pay/id/#rc.id#" class="btn btn-success btn-large"><i class="icon-tick"></i>Accept this proposal and pay now</a>
    <cfelse>
      <a href="/quote/respond/accept/id/#rc.id#" class="btn btn-success btn-large"><i class="icon-tick"></i>Accept this proposal</a>
    </cfif>
    <a href="##reject" data-toggle="modal"  class="pull-right btn btn-danger btn-large"><i class="icon-cross"></i>Reject this proposal</a>
    <hr />
    <div class="modal hide fade" id="reject">
      <form action="/quote/respond/reject/id/#rc.id#" class="form-horizontal" method="post">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal">&times;</button>
        <h3>Reject this quotation?</h3>
      </div>
      <div class="modal-body">
        <h3>Sorry you don't approve!</h3>
        <div class="control-group">
          <label class="control-label">Add a reason:</label>
          <div class="controls">
            <textarea name="comment"></textarea>
            <p class="help-block">Why did you reject this quotation? You don't have to fill this in, but it might help the supplier win your business in the future.</p>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn" data-dismiss="modal">Cancel</button>
        <button type="submit" class="btn btn-danger" ><i class="icon-cross"></i> Reject it</button>
      </div>
      </form>
    </div>
</cfif>
</cfoutput>