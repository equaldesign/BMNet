<cfset getMyPlugin(plugin="jQuery").getDepends("","tabs2")>
<cfoutput>
	<div id="figs" class="tabs2 Aristo">
		<ul>
			<cfif isUserInARole("Categories,figures") OR rc.panelData.psa.company_id eq rc.sess.eGroup.companyID><li><a class="calculations" href="#bl('psa.view','panel=earnings&psaID=#rc.panelData.psa.id#')#"><span>earnings</span></a></li></cfif>
			<cfif isUserInARole("Categories,figures") OR rc.panelData.psa.company_id eq rc.sess.eGroup.companyID><li><a class="spreadsheets" href="#bl('psa.view','panel=turnover&psaID=#rc.panelData.psa.id#')#"><span>turnover spreadsheets</span></a></li></cfif>
			<cfif isUserInARole("Categories,figures")><li><a class="charts" href="#bl('chart.index','psaID=#rc.panelData.psa.id#')#"><span>charts &amp; comparisons</span></a></li></cfif>
		</ul>
	</div>
</cfoutput>