<cfset getMyPlugin(plugin="jQuery").getDepends("","menus","dashboard/overview")>
<cfoutput>#renderView("contact/supplierhomepagecontrols")#</cfoutput>
<cfset total = 0>
<cfoutput>
<div id="homepage">
  <h2><img class="gravatar" align="left" src="#paramImage('company/#rc.sess.eGroup.companyID#_square.jpg','website/unknown.png')#" alt="#rc.sess.eGroup.companyknown_as#" />
    This is your personalised dashboard for #rc.sess.eGroup.companyknown_as#</h2>
<br class="clear" />
<div id="tabs">
  <ul>
    <li><a class="dashboard_dashboard" href="#bl('dashboard.turnover')#"><span>Turnover</span></a></li>
    <li><a class="dashboard_rebatedue" href="#bl('dashboard.rebatedue')#"><span>Rebate due</span></a></li>
    <li><a class="dashboard_rebateready" href="#bl('dashboard.rebatepaid')#"><span>Rebate Paid</span></a></li>
  </ul>
</div>
</div>
</cfoutput>