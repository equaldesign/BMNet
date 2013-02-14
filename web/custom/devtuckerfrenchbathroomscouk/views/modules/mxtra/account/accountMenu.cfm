<cfhtmlhead text='<title>Tucker French - Your Account</title>'></cfhtmlhead>
<cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/invoicing","sites/#request.siteID#/invoicing")>

<cfoutput>
    <cfset userCompany = getModel("modules.eunify.model.CompanyService").getCompany(rc.sess.BMNet.companyID,request.siteID)>
    <h2><a href="/mxtra/account">#userCompany.name#</a></h2>
    <h4>Your Details</h4>
    <address>
      #userCompany.company_address_1#
      <cfif userCompany.company_address_2 neq ""><br /></cfif>#userCompany.company_address_2#
      <cfif userCompany.company_address_3 neq ""><br /></cfif>#userCompany.company_address_3#
      <cfif userCompany.company_address_4 neq ""><br /></cfif>#userCompany.company_address_4#
      <cfif userCompany.company_address_5 neq ""><br /></cfif>#userCompany.company_address_5#
      #userCompany.company_postcode#
    </address>
    <hr />
    <h4>Credit Limit and Balance</h4>
    <p>Your current credit limit is &pound;#userCompany.creditLimit#</p>
    <p>Your outstanding balance is &pound;#userCompany.balance#</p>
		<div class="ui-widget">
			<cfif userCompany.late_121_days neq 0>
				<div class="alert alert-error">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
					<h4 class="alert-heading">Important!</h4>
				  <p>You have a &pound;#userCompany.late_121_days# balance that is over 3 months overdue!</p>
				</div>
			<cfelseif userCompany.late_91_120_days neq 0>
				<div class="alert alert-error">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
          <h4 class="alert-heading">Important!</h4>
		      <p>You have a &pound;#userCompany.late_91_120_days# balance that is over 2 months overdue!</p>
				</div>
			<cfelseif userCompany.late_61_90_days neq 0>
				<div class="alert">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
          <h4 class="alert-heading">Important!</h4>
		      <p>You have a &pound;#userCompany.late_61_90_days# balance that is over 1 month overdue!</p>
				</div>
			<cfelseif userCompany.late_31_60_days neq 0>
				<div class="alert alert-info">
				  <a href="##" class="close" data-dismiss="alert">&times;</a>
          <h4 class="alert-heading">Important!</h4>
		      <p>You have a &pound;#userCompany.late_31_60_days# balance that is overdue!</p>
				</div>
			</cfif>
		</div>
    <hr />
    <ul id="mainLinks" class="nav nav-tabs nav-stacked account">
      <li class="nav-header">Invoices</li>
      <li><a href="/mxtra/account/invoiceList?dateFrom=#URLEncodedFormat(LSDateFormat(DateAdd("yyyy",-50,now()),'DD/MM/YYYY'))#">Show All invoices<i class="icon-chevron-right"></i></a></li>
      <li><a href="/mxtra/account/invoiceList?dateFrom=#URLEncodedFormat(LSDateFormat(DateAdd("m",-1,now()),'DD/MM/YYYY'))#">Invoices this month<i class="icon-chevron-right"></i></a></li>
      <li class="nav-header">Quotations</li>
      <li><a href="/quote/do/new">Start a new Quotation<i class="icon-chevron-right"></i></a></li>
      <li><a href="/quote/do/new">Star a new Quotation<i class="icon-chevron-right"></i></a></li>
    </ul>
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
          <span class="add-on">From</span><input class="date input-small" name="fromDate" value="#LSDateFormat(paramValue('rc.fromDate',DateAdd("m",-1,now())),'DD/MM/YYYY')#" type="text">
        </div>
       </div>
       <div class="control-group">
        <div class="input-prepend">
          <span class="add-on">To: </span><input class="date input-small" value="#LSDateFormat(paramValue('rc.toDate',now()),'DD/MM/YYYY')#" name="toDate" type="text">
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
