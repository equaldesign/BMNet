<cfoutput>

<table width="100%" cellpadding="4" border="0">
	<tr>

		<td>
			<h2>This Month</h2>
			<h3>Average ticket close time</h3>
			<p>#rc.overviewData.averageCloseTimeM.thisSite# Days (avg #rc.overviewData.averageCloseTimeM.average#)</p>
			<h3>Fastest ticket close time</h3>
			<p>#rc.overviewData.minCloseTimeM# Mins</p>
			<h3>Longest ticket close time</h3>
      <p>#rc.overviewData.maxCloseTimeM# Days</p>
			<h3>Average ticket response time</h3>
      <p>#rc.overviewData.avgResponseTimeM.thisSite# Hours (avg #rc.overviewData.avgResponseTimeM.average#)</p>
			<h3>Fastest ticket response time</h3>
      <p>#rc.overviewData.minResponseTimeM# Mins</p>
			<h3>Slowest ticket response time</h3>
      <p>#rc.overviewData.maxResponseTimeM# Days</p>
		</td>
		<td>
			<h2>All Time</h2>
      <h3>Average ticket close time</h3>
      <p>#rc.overviewData.averageCloseTime.thisSite# Days (avg #rc.overviewData.averageCloseTime.average#)</p>
      <h3>Fastest ticket close time</h3>
      <p>#rc.overviewData.minCloseTime# Mins</p>
      <h3>Longest ticket close time</h3>
      <p>#rc.overviewData.maxCloseTime# Days</p>
      <h3>Average ticket response time</h3>
      <p>#rc.overviewData.avgResponseTime.thisSite# Hours (avg #rc.overviewData.avgResponseTime.average#)</p>
      <h3>Fastest ticket response time</h3>
      <p>#rc.overviewData.minResponseTime# Mins</p>
      <h3>Slowest ticket response time</h3>
      <p>#rc.overviewData.maxResponseTime# Days</p>
		</td>
		</cfoutput>
  </tr>
</table>
