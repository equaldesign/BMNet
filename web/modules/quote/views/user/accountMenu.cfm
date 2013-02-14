<cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/invoicing","sites/#request.siteID#/invoicing")>
<div class="accountMenu">
<cfoutput>
    <cfset userCompany = getModel("modules.eunify.model.CompanyService").getCompany(rc.sess.BMNet.companyID,request.siteID)>
    <h2>#userCompany.name#</h2>
    <h4>Your Details</h4>
    <address>
      <p>#userCompany.company_address_1#</p>
      <p>#userCompany.company_address_2#</p>
      <p>#userCompany.company_address_3#</p>
      <p>#userCompany.company_address_4#</p>
      <p>#userCompany.company_address_5#</p>
      <p>#userCompany.company_postcode#</p>
    </address>
    <hr />
    <h4>Credit Limit and Balance</h4>
    <p>Your current credit limit it &pound;#userCompany.creditLimit#</p>
    <p>Your outstanding balance is &pound;#userCompany.balance#</p>
		<div class="ui-widget">
			<cfif userCompany.late_121_days neq 0>
				<div class="ui-state-error" style="padding: 5px;">
				  <h5>Important!</h5>
				  <p>You have a &pound;#userCompany.late_121_days# balance that is over 3 months overdue!</p>
				</div>
			<cfelseif userCompany.late_91_120_days neq 0>
				<div class="ui-state-error" style="padding: 5px;">
				  <h5>Important!</h5>
		      <p>You have a &pound;#userCompany.late_91_120_days# balance that is over 2 months overdue!</p>
				</div>
			<cfelseif userCompany.late_61_90_days neq 0>
				<div class="ui-state-error" style="padding: 5px;">
				  <h5>Important!</h5>
		      <p>You have a &pound;#userCompany.late_61_90_days# balance that is over 1 month overdue!</p>
				</div>
			<cfelseif userCompany.late_31_60_days neq 0> 	
				<div class="ui-state-error" style="padding: 5px;">
				  <h5>Important!</h5>
		      <p>You have a &pound;#userCompany.late_31_60_days# balance that is overdue!</p>
				</div>
			</cfif>
		</div>
    <hr />
    <h4>Search for Historic Invoices</h4>
    <div>
      <form class="form-horizontal" action="/mxtra/account/invoiceList">
       <div class="control-group">
			  <div class="input-prepend">
          <span class="add-on">Inv. Num</span><input class="input-small" name="invoice_number" type="text">
        </div>
			 </div>
			 <div class="control-group">	
				<div class="input-prepend">
          <span class="add-on">From</span><input class="date input-small" name="fromDate" value="#LSDateFormat(rc.fromDate,'DD/MM/YYYY')#" type="text">
        </div>
			 </div>
			 <div class="control-group">	
				<div class="input-prepend">
          <span class="add-on">To: </span><input class="date input-small" value="#LSDateFormat(rc.toDate,'DD/MM/YYYY')#" name="toDate" type="text">
        </div>					  				
			 </div>
        <div class="control-group">
          <input type="submit" class="btn btn-info" value="search for an invoice &raquo;">
        </div>
      </form>
    </div>    

  <cfif isUserInRole("staff")>
  <div>
    <form class="form-horizontal"  action="/mxtra/orders/becomeAccount">      
			<div class="control-group">
				<div class="input-append">
	       <input class="input-small" placeholder="Acc. Num." name="aNum" value="" id="aNum" type="text" /><button class="btn btn-success" type="submit">Go!</button>
	      </div>				      
			</div>
    </form>
  </div>
  </cfif>
</cfoutput>
</div>