<cfset getMyPlugin(plugin="jQuery").getDepends("","map/request/merchant","")>
<cfoutput>
<cfif rc.quote.quoteResponses.interested eq "false">

<div class="alert alert-error">
  <h2 class="alert-heading">REJECTED!</h2>
  <p>The user rejected your quotation! Sorry!</p>
  <cfif rc.quote.quoteResponses.comment neq "">
   <p><strong>Reason:</strong> #rc.quote.quoteResponses.comment#</p>
  <cfelse>
   <h4>No reason was given</h4>
  </cfif>
</div>
<cfelseif rc.quote.quoteResponses.interested eq "true">
<div class="alert alert-success">
  <h2 class="alert-heading">SUCCESS!</h2>
  <p>The user accpeted your quotation!</p>
</div>
</cfif>
</cfoutput>
<cfif rc.quote.quoteResponses.recordCount neq 0 AND rc.quote.quoteResponses.interested neq "false">
<cfoutput>
	<div class="widget">
		<div class="widget-header">
      <i class="icon-info"></i>
      <h3>Customer Details</h3>
    </div>
		<div class="widget-content">
			<div class="row">
				<div class="span1">
					<div class="thumbnail">
						<img alt="Profile Picture" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(rc.quote.contact.email)))#?size=225&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" />
					</div>
				</div>
				<div class="span3">
					<h3>#rc.quote.contact.first_name# #rc.quote.contact.surname#</h3>
					<h4>#rc.quote.company.name#</h4>
				</div>
				<div class="span4">
					<dl class="dl-horizontal">
						<dt>Telephone:</dt>
						<dd>#rc.quote.company.company_phone#</dd>
						<dt>Address:</dt>
            <dd>#rc.quote.company.company_address_1#</dd>
						<dt>Post Code:</dt>
            <dd>#rc.quote.company.company_postcode#</dd>
					</dl>
				</div>
			</div>
		</div>
	</div>
</cfoutput>
</cfif>
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
		        <h4>Response slots available</h4>
		        <span class="value"><cfoutput>#rc.quote.slotsRemaining#</cfoutput></span>
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
              <cfif rc.quote.quoteRequest.delivered>
							<th>Delivery Date</th>
              <cfelse>
							<th>Collection Radius</th>
              </cfif>
							<th>Best Quote</th>
						</thead>
						<tbody>
							<tr>
                <td>
                  <i class="icon-delivered-#rc.quote.quoteRequest.delivered#"></i>
                  <cfif rc.quote.quoteRequest.delivered> delivery required<cfelse>collection</cfif>
                </td>
								<cfif rc.quote.quoteRequest.delivered>
                <td>#DateFormatOrdinal(rc.quote.quoteRequest.deliveryDate,"DDD D MMM")#</td>
                <cfelse>
								<td>#rc.quote.quoteRequest.pickupRadius#</td>
                </cfif>
								<td>#rc.quote.quoteRequest.bestQuote#</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
			<br />
			<cfif rc.quote.quoteResponses.recordCount eq 0>
			<p>
				<a  href="##continue" data-toggle="modal" class="btn btn-large btn-success"><i class="icon-tick"></i> Respond to this quotation</a>
				<a  href="##decline" data-toggle="modal" class="pull-right btn btn-large btn-danger"><i class="icon-cross"></i> Decline it</a>
			</p>

			<cfelse>
      <a  href="/quote/respond/view?id=#rc.quote.quoteResponses.responseID#" class="btn btn-large btn-success"><i class="icon-tick"></i> View  your response</a>
        <cfif rc.quote.quoteResponses.interested eq "notviewed">
  				<a  href="/quote/respond/edit?id=#rc.quote.quoteResponses.responseID#" class="btn btn-large btn-warning"><i class="icon-edit"></i> Edit  your response</a>
        </cfif>
      </cfif>
		</cfoutput>
	</div>
  <div class="span4">

	  <div class="widget">
		  <div class="widget-header">
	      <i class="icon-pendingquotes"></i>
	      <h3>Nearest: <cfoutput>#rc.nearestBranch.branches.name#</cfoutput></h3>
	    </div>
			<div class="widget-content">
		  	<cfoutput>
		  	<div style="width:100%; height:200px; margin-bottom:5px;" id="nearestMap" origin="#rc.nearEstBranch.origin[1]#,#rc.nearEstBranch.origin[2]#" destination="#rc.nearestBranch.branches.maplat#,#rc.nearestBranch.branches.maplong#"></div>
			  <div id="directions">
			  	<h4><i class="icon-directions"></i> Journey information: <span id="mapDirections"></span></h4>
			    <cfif rc.nearestBranch.branches.recordCount gt 1>
					  <p>You also have #rc.nearestBranch.branches.recordCount-1# other branches within a 15 mile radius of the <cfif rc.quote.quoteRequest.delivered>delivery<cfelse>collection origin</cfif> address...</p>
				  </cfif>
				</div>
				</cfoutput>
			</div>
		</div>
		<cfif rc.quote.quoteResponses.recordCount neq 0>
			<a  href="mailto:comment@tradebuildingsupplies.co.uk?subject=Question about your request: #rc.quote.quoteRequest.ticket#" class="pull-right btn"><i class="icon-email"></i> Got a query? email this buyer</a>
			<br /><br />
			<a href="##emailquestion" data-toggle="modal" class="pull-right">How do questions work?</a>
		</cfif>
  </div>
</div>
<hr />
<div class="widget widget-table action-table">
  <div class="widget-header">
    <i class="icon-pendingquotes"></i>
    <h3>Products Requested</h3>
  </div> <!-- /widget-header -->
  <div class="widget-content">
    <table class="table table-striped table-bordered">
      <thead>
        <tr>
          <th nowrap="nowrap">Quant.</th>
          <th nowrap="nowrap">Unit</th>
          <th width="80%">Product</th>
          <th nowrap="nowrap">EAN</th>
          <th nowrap="nowrap">Part Code</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="rc.quote.quoteRequest">
        <tr>
          <td>#quantity#</td>
          <td>#unit#</td>
          <td>#productName#</td>
          <td>#eancode#</td>
          <td>#manufacturerProductCode#</td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div> <!-- /widget-content -->
</div>
<cfif rc.quote.quoteResponses.recordCount eq 0>
	<hr />
	<div class="widget">
	  <div class="widget-header">
	    <i class="icon-tick"></i>
	    <h3>Respond to this Quotation</h3>
	  </div> <!-- /widget-header -->
	  <div class="widget-content">
	    <div class="row">
				<div class="span5">
					<div class="alert alert-success">
					  <h1 class="alert-heading"><cfoutput>#rc.quote.quoteRequest.credits#</cfoutput> Credits</h1>
					  <p>Responding to this quotation will cost you <cfoutput>#rc.quote.quoteRequest.credits#</cfoutput> credits (You currently have <cfoutput>#rc.company.balance#</cfoutput> remaining).</p>
						<p>When you respond, the user will receive your quotation response, along with your contact details and company information.</p>
						<p>You will get the users name, email and contact telephone number so you can pursue the lead if required.</p>
					</div>


					<cfoutput>
					<p>
						<a href="##continue" data-toggle="modal" class="btn btn-large btn-success"><i class="icon-tick"></i> Respond to this quotation</a>&nbsp;&nbsp;
					  <a href="##decline" data-toggle="modal" class="btn btn-large btn-danger"><i class="icon-cross"></i> Decline to respond</a>
					</p>
					</cfoutput>
				</div>
				<div class="span3 pull-right">
		      <h3><i class="icon-note"></i> Responding to a quote</h3>
		      <p>You can respond to a quote even if you cannot provide all the products the user wants.</p>
		      <p>You can also respond and suggest alternative products for the user.</p>
					<h3></h3>
		    </div>
			</div>
	  </div> <!-- /widget-content -->
	</div>
	<br />
	<cfoutput>
	<div class="modal hide fade" id="continue">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal">&times;</button>
	    <h3>Respond to this quotation request</h3>
	  </div>
	  <div class="modal-body">
	    <h3><cfoutput>#rc.quote.quoteRequest.credits#</cfoutput> Credits</h3>
			<p>Responding to this quotation request will cost <cfoutput>#rc.quote.quoteRequest.credits#</cfoutput> credits. You currently have <cfoutput>#rc.company.balance#</cfoutput> credits remaining.</p>
			<p>When you respond, you'll be asked to enter a cost for each of the product lines (if you can fulfill them). You can suggest alternative products to the user, or miss some ranges out.</p>
			<p>Once your response has been saved, it will be packaged up into a nice PDF, and sent to the user. The email will contain your quote, delivery charges (if applicable), a breif overview of your company, and any previous reviews from other tradebuild users.</p>
			<p>You will receive the contact details of the user (email address, phone), so you can pursue the lead if you so desire.</p>
	  </div>
	  <div class="modal-footer">
	    <a href="##" class="btn" data-dismiss="modal">Close</a>
	    <a href="/quote/respond?id=#rc.id#&sentID=#rc.sentID#" class="btn btn-success">Continue</a>
	  </div>
	</div>
	</cfoutput>

	<cfoutput>
	<div class="modal hide fade" id="decline">
	  <div class="modal-header">
	    <button type="button" class="close" data-dismiss="modal">&times;</button>
	    <h3>Decline this quotation request?</h3>
	  </div>
	  <div class="modal-body">
	    <h3>Sure?</h3>
	    <p>If you decline this quotation request, you will not be able to view it again.</p>
	  </div>
	  <div class="modal-footer">
	    <a href="##" class="btn" data-dismiss="modal">Close</a>
	    <a href="/quote/repond/decline?id=#rc.id#" class="btn btn-danger">Yep, I'm sure - we're not interested!</a>
	  </div>
	</div>
	</cfoutput>
</cfif>
<cfoutput>
<div class="modal hide fade" id="emailquestion">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal">&times;</button>
    <h3>How do email questions work?</h3>
  </div>
  <div class="modal-body">
    <h3>Simple!</h3>
    <p>Just click the "Got a query..." button, and your email client will start-up automatically. The subject line will have a key (in the format xxx-xxxx-xxxx)</p>
		<p><strong>Do not delete this key from the subject line!</strong></p>
		<p>When emailing the buyer, you should only query the products or delivery information. It is not permitted to disclose company information until you have officially responded to the quotation request.</p>
  </div>
  <div class="modal-footer">
    <a href="##" class="btn" data-dismiss="modal">Close</a>
  </div>
</div>
</cfoutput>