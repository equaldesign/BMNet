<cfset getMyPlugin(plugin="jQuery").getDepends("cookie","secure/contact/detail","secure/contact/index")>
<cfoutput>
	<div class="page-header">
    <cfif rc.username eq request.buildingvine.username>
		  <h1>Hey there, #paramValue("rc.user.firstName","")# #paramValue("rc.user.lastName","")#!</h1>
		<cfelse>
		  <h1>#paramValue("rc.user.firstName","")# #paramValue("rc.user.lastName","")#</h1>
	  </cfif>
	</div>
	<div class="row-fluid">
		<div class="span9">			 
      <div class="page-header">
      	<h3>Contact Information</h3>
      </div>
	    <dl class="dl-horizontal">
	      <dt>Company:</dt>
	        <dd>#paramValue("rc.user.organization","")#</a>&nbsp;</dd>
				<dt>Job Title:</dt>
          <dd>#paramValue("rc.user.jobtitle","")#</a>&nbsp;</dd>
				<dt>Work Address:</dt>
          <dd>
          	<address>
							#paramValue("rc.user.companyaddress1","")#<br />
							#paramValue("rc.user.companyaddress2","")#<br />
							#paramValue("rc.user.companyaddress3","")#<br />
            </address>
          </dd>
				<dt>Phone</dt>
          <dd>#paramValue("rc.user.telephone","")#&nbsp;</dd>
        <dt>Mobile</dt>
          <dd>#paramValue("rc.user.mobile","")#&nbsp;</dd>
        <dt>Phone 2</dt>
          <dd>#paramValue("rc.user.companytelephone","")#&nbsp;</dd>
				<dt>Skype&reg;</dt>
          <dd>#paramValue("rc.user.skype","")#&nbsp;</dd>
				<dt>Google&reg; Account</dt>
          <dd>#paramValue("rc.user.googleusername","")#&nbsp;</dd>				
			</dl>
			<div class="page-header">
        <h3>Account Information</h3>
      </div>
	    <dl class="dl-horizontal">
			  <dt>Storage Quota:</dt>
	        <cfset quotaUsed = (100 - (rc.user.sizeCurrent/rc.user.quota * 100))>
	        <dd>#decimalFormat(quotaUsed)#% free&nbsp;</dd>
	      <dt>Email / Username</dt>
	        <dd><a href="mailto:#rc.user.email#">#rc.user.email#</a>&nbsp;</dd>	      
	    </dl>
    </div>
		<div class="span3">
			<div class="pull-right">
		    <img class="thumbnail" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(rc.user.email)))#?size=200&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" />
		    <br />
        <a href="/site/#paramValue("rc.userPreferences.defaultSite","buildingVine")#">Main Building Vine Site</a>
        <br />
				<a href="http://www.gravatar.com" class="btn btn-warning">Change image &raquo;</a>
		    <p>You can change this image at Gravatar.com (<small>It's free!</small>)</p>
		  </div>
		</div>
  </div>
</cfoutput>
