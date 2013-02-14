<cfset getMyPlugin(plugin="jQuery").getDepends("fusioncharts","sales/site/overview","charts,form")>
<cfoutput>
<input type="hidden" id="filterColumn" value="#rc.filterColumn#" />
<input type="hidden" id="filterValue" value="#rc.filterValue#" />
</cfoutput>
<div id="chart">
  <div id="overviewChart"></div>
</div>
<div id="overviewTable"></div>
<cfoutput>#renderView("filter")#</cfoutput>