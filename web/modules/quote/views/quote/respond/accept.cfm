<cfset getMyPlugin(plugin="jQuery").getDepends("","quote/respond","")>
<div class="page-header">
	<h1>Submit your quotation</h1>
</div>
<div class="alert alert-info">
	<a href="#" class="close" data-dismiss="alert">&times;</a>
	<h3 class="alert-heading">How to ensure you respond to a quotation request correctly</h3>
	<ol>
		<li>
			Enter the amounts for the products the buyer has requested (All prices should <strong>Include VAT</strong>).<br />
		  If you cannot provide the exact product the buyer has requested, you can add alternatives by removing their products and adding your own.
		</li>
		<li>Check the total adds up correctly</li>
		<li>Ammend the details to ensure any delivery charges are added, and payment methods are specified</li>
		<li>Submit your proposal!</li>
	</ol>
</div>
<form id="proposalForm" class="form form-horizontal" action="/quote/respond/do" method="post">
	<fieldset>
		<legend>Ammend Products and costs</legend>
		<div class="widget widget-table action-table">
		  <div class="widget-header">
		    <i class="icon-pendingquotes"></i>
		    <h3>Products Requested</h3>
		  </div>
		  <div class="widget-content">
		    <table id="quoteTable" class="table table-striped table-bordered">
		      <thead>
		        <tr>
		          <th nowrap="nowrap">Quant.</th>
		          <th nowrap="nowrap">Unit</th>
		          <th>Product</th>
							<th>Price</th>
							<th></th>
		        </tr>
		      </thead>
		      <tbody>
		      	<cfset x = 1>
		        <cfoutput query="rc.quote.quoteRequest">
		        <tr>
		          <td>
		          	<input type="hidden" name="product[#x#].quantity" value="#quantity#" />
		          	#quantity#</td>
		          <td>
		          	<input type="hidden" name="product[#x#].unit" value="#unit#" />
		          	#unit#</td>
		          <td>
		          	<input type="hidden" name="product[#x#].productName" value="#productName#" />
		          	#productName#</td>
							<td>
								<div class="input-prepend input-append">
									<span class="add-on">&pound;</span>
									<input type="text" class="input-mini totalamounts" name="product[#x#].amount" value="" />
									<span class="add-on">Inc. VAT</span>
								</div>
							</td>
							<td><a href="##" title="remove this item" class="btn btn-danger removeLine"><i class="icon-delete"></i> Remove</a></td>
		        </tr>
						<cfset x++>
		        </cfoutput>
		      </tbody>
					<tfoot>
						<tr>
		          <td>
		            <div class="input-prepend">
		              <span class="add-on">Quant.</span>
		              <input type="text" class="quant input-mini" name="q" value="" />
		            </div>
		          </td>
		          <td>
		            <div class="input-prepend">
		              <span class="add-on">Unit.</span>
		              <input type="text" class="unitType input-mini" name="u" value="" />
		            </div>
		          </td>
		          <td>
		            <div class="input-prepend">
		              <span class="add-on">Name.</span>
		              <input type="text" class="prodname" name="p" value="" />
		            </div>
		          </td>
		          <td>
		            <div class="input-prepend input-append">
		              <span class="add-on">&pound;</span>
		              <input type="text" class="amount input-mini" name="a" value="" />
		              <span class="add-on">Inc. VAT</span>
		            </div>
		          </td>
		          <td><a href="##" class="btn btn-success addLine"><i class="icon-tick"></i> Add</a></td>
		        </tr>
					</tfoot>
		    </table>
		  </div> <!-- /widget-content -->
			<h3 style="text-align:right;">TOTAL INC VAT<cfif rc.quote.quoteRequest.delivered> &amp; DELIVERY</cfif>: <span id="totalCost">&pound;0.00</span></h3>
		</div>
  </fieldset>
	<fieldset>
		<legend>Ammend Order Details</legend>
		<cfif rc.quote.quoteRequest.delivered>
		<div class="control-group">
			<label class="control-label">Delivery Charge</label>
			<div class="controls">
				<div class="input-prepend input-append">
          <span class="add-on">&pound;</span>
          <input type="text" class="totalamounts input-mini" name="deliverycharge" value="0.00" />
          <span class="add-on">Inc. VAT</span>
        </div>
			</div>
		</div>
		<div class="control-group">
      <label class="control-label">Delivery Date</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-date"></i></span>
          <cfoutput>
            <input type="text" class="ddate input-small" name="deliveryDate" value="#DateFormat(rc.quote.quoteRequest.deliveryDate,"DD/MM/YYYY")#" />
		      </cfoutput>
        </div>
      </div>
    </div>
		<cfelse>
    <div class="control-group">
      <label class="control-label">Collection Branch</label>
      <div class="controls">
        <select id="collectionBranch" class="input" name="collectionBranch">
          <option value="0">Any branch</option>
          <cfset branches = getModel("modules.eunify.model.BranchService").getAll(request.BMNet.companyID)>
          <cfoutput query="branches">
            <option value="#id#">#name# (#town#)</option>
          </cfoutput>
        </select>
      </div>
    </div>
    </cfif>
    <div class="control-group">
      <label class="control-label">Response Deadline</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-date"></i></span>
          <cfoutput>
            <input type="text" class="ddate input-small" name="deadline" value="#DateFormat(rc.quote.quoteRequest.deliveryDate,"DD/MM/YYYY")#" />
          </cfoutput>
        </div>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Quote Valid Until</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on"><i class="icon-date"></i></span>
          <cfoutput>
            <input type="text" class="ddate input-small" name="validUntil" value="#DateFormat(rc.quote.quoteRequest.deliveryDate,"DD/MM/YYYY")#" />
          </cfoutput>
        </div>
      </div>
    </div>
		<div class="control-group">
			<label class="control-label">Payment Method</label>
			<div class="controls">
				<select id="paymentChoose" class="input" name="paymentMethod">
					<option value="paypal">Paypal</option>
					<option value="cheque">Cheque</option>
					<option value="BACs">BACs</option>
					<option value="CNP">Credit Card</option>
				</select>
				<cfif rc.quote.quoteRequest.delivered>
				  <p class="help-block">The safest method of payment is either BACs or Paypal. Credit card payments (Card Holder Not Present) is risky as the buyer wants their items delivered, and therefore credit card details will have to be taken over the phone.</p>
				</cfif>
			</div>
		</div>
		<div id="paypalDetails" class="control-group">
      <label class="control-label">Paypal Details</label>
      <div class="controls">
        <div class="input-prepend">
				  <span class="add-on"><i class="icon-email"></i></span>
					<input type="text" name="paypalemail" value="" />
				</div>
				<p class="help-block">If you want payment via paypal, you can enter your paypal email address, and the buyer can pay direct online through our website when they view your quotation.</p>
      </div>
    </div>
	</fieldset>
	<div class="form-actions">
		<a href="#submitQuote" data-toggle="modal" class="btn btn-large btn-success"><i class="icon-tick"></i> Confirm and submit your quotation &raquo;</a>
	</div>

	<div class="modal hide fade" id="submitQuote">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal">&times;</button>
	    <h3>Are you sure everything is correct?</h3>
	  </div>
	  <div class="modal-body">
	    <p>Is everythink ok? If so, you can now submit your quotation.</p>
	  </div>
	  <div class="modal-footer">
	  	<a href="##" class="btn btn-danger" data-dismiss="modal"><i class="icon-cross"></i> Oops, I think I made a mistake!</a>
			<button class="btn btn-success" type="submit"><i class="icon-tick"></i> Yes! Submit my quotation! &raquo;</button>
	  </div>
	</div>
</div>
<cfoutput>
<input type="hidden" name="sentID" value="#rc.sentID#" />
<input type="hidden" name="id" value="#rc.id#" />
</cfoutput>
</form>