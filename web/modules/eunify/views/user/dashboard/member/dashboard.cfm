<cfset getMyPlugin(plugin="jQuery").getDepends("","menus","dashboard/overview")>
<cfoutput>#renderView("contact/homepagecontrols")#</cfoutput>
<cfset total = 0>
<cfoutput>
<div id="homepage">
  <h2><img align="left"  src="#paramImage('company/#rc.sess.eGroup.companyID#_small.jpg','company/default.png')#" alt="#rc.sess.eGroup.companyknown_as#" />
    This is your personalised dashboard for #rc.sess.eGroup.companyknown_as#</h2>
<br class="clear" />
<div id="tabs">
  <ul>
    <li><a class="dashboard_dashboard" href="#bl('dashboard.turnover')#"><span>Turnover</span></a></li>
    <li><a class="dashboard_rebatedue" href="#bl('dashboard.rebatedue')#"><span>Rebate due</span></a></li>
    <li><a class="dashboard_rebategroup" href="#bl('dashboard.rebatewaiting')#"><span>Paid to Group</span></a></li>
    <li><a class="dashboard_rebatepartpaid" href="#bl('dashboard.rebatepartpaid')#"><span>Rebate Part-Paid</span></a></li>
    <li><a class="dashboard_rebateready" href="#bl('dashboard.rebatepaid')#"><span>Rebate Paid</span></a></li>
    <li><a class="commentIcon" href="#bl('comment.userlist')#"><span>Notes/comments</span></a></li>
  </ul>
</div>
</div>
</cfoutput>