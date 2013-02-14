<cfhtmlhead text='<title>Turnbull 24-7 - Your Account</title>'>
<cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/invoicing","sites/#request.siteID#/invoicing")>

<cfoutput>
    <cfset rc.userCompany = getModel("eunify.CompanyService").getCompany(request.BMNet.companyID,request.siteID)>
    <h2>#rc.userCompany.name#</h2>
    <h4>Your Details</h4>
    <address>
      #rc.userCompany.company_address_1#
      <cfif rc.userCompany.company_address_2 neq ""><br /></cfif>#rc.userCompany.company_address_2#
      <cfif rc.userCompany.company_address_3 neq ""><br /></cfif>#rc.userCompany.company_address_3#
      <cfif rc.userCompany.company_address_4 neq ""><br /></cfif>#rc.userCompany.company_address_4#
      <cfif rc.userCompany.company_address_5 neq ""><br /></cfif>#rc.userCompany.company_address_5#
      #rc.userCompany.company_postcode#
    </address>
    <hr />
    <h4>Credit Limit and Balance</h4>
    <p>Your current credit limit is &pound;#rc.userCompany.creditLimit#</p>
    <p>Your outstanding balance is &pound;#rc.userCompany.balance#</p>
		<div class="ui-widget">
			<cfif rc.userCompany.late_121_days neq 0>
				<div class="alert alert-error">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
					<h4 class="alert-heading">Important!</h4>
				  <p>You have a &pound;#rc.userCompany.late_121_days# balance that is over 3 months overdue!</p>
				</div>
			<cfelseif rc.userCompany.late_91_120_days neq 0>
				<div class="alert alert-error">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
          <h4 class="alert-heading">Important!</h4>
		      <p>You have a &pound;#rc.userCompany.late_91_120_days# balance that is over 2 months overdue!</p>
				</div>
			<cfelseif rc.userCompany.late_61_90_days neq 0>
				<div class="alert">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
          <h4 class="alert-heading">Important!</h4>
		      <p>You have a &pound;#rc.userCompany.late_61_90_days# balance that is over 1 month overdue!</p>
				</div>
			<cfelseif rc.userCompany.late_31_60_days neq 0>
				<div class="alert alert-info">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
          <h4 class="alert-heading">Important!</h4>
		      <p>You have a &pound;#rc.userCompany.late_31_60_days# balance that is overdue!</p>
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
