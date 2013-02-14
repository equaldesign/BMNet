<cfoutput>
	<ul>
	  <li class="turnover_dashboard"><a class="ajax" href="#bl('figures.dashboard')#">Current Turnover Dashboard</a></li>
    <li class="company_dashboard"><a class="ajax" href="#bl('dashboard.index','cID=0')#">#rc.moduleSettings.eGroup.settings.siteName# Dashboard</a></li>
    <li class="company_dashboard"><a class="ajax" href="#bl('dashboard')#">#rc.sess.eGroup.companyknown_as# Dashboard</a></li>
    <li class="ye_targets"><a class="ajax" href="#bl('figures.targets')#">Year End Targets</a></li>
	</ul>
</cfoutput>