<cfset getMyPlugin(plugin="jQuery").getDepends("","menus","dashboard/overview")>
<cfoutput>#renderView("contact/homepagecontrols")#</cfoutput>
<cfset total = 0>
<cfoutput>
<div id="homepage">
  <h2>#getSetting("groupName")# dashboard</h2>
<br class="clear" />
<div id="tabs">
  <ul>
    <li><a class="dashboard_dashboard" href="#bl('dashboard.turnover','cID=0')#"><span>Turnover</span></a></li>
    <li><a class="dashboard_rebatedue" href="#bl('dashboard.rebatedue','cID=0')#"><span>Rebate due</span></a></li>
    <li><a class="dashboard_rebategroup" href="#bl('dashboard.rebatewaiting','cID=0')#"><span>Paid to Group</span></a></li>
    <li><a class="dashboard_rebatepartpaid" href="#bl('dashboard.rebatepartpaid','cID=0')#"><span>Rebate Part-Paid</span></a></li>
    <li><a class="dashboard_rebateready" href="#bl('dashboard.rebatepaid','cID=0')#"><span>Rebate Paid</span></a></li>
  </ul>
</div>
</div>
</cfoutput>