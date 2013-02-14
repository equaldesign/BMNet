<cfset getMyPlugin(plugin="jQuery").getDepends("highstock","sales/site/filter","charts,form")>
<cfoutput> 
<input type="hidden" id="filter" value="#rc.filter#" />

</cfoutput>
<div id="chart">
  <div id="overviewChart"></div>
</div>
