<cfset getMyPlugin(plugin="jQuery").getDepends("","sales/person/overview","charts,form")>
<cfoutput>
<input type="hidden" id="filterColumn" value="#rc.filterColumn#" />
<input type="hidden" id="filterValue" value="#rc.filterValue#" />
</cfoutput>
<h2>Salesperson Analysis</h2>
<div id="personchart">
  <div id="overviewChart"></div>
  <div id="thisMonth"></div>
  <div id="lastMonth"></div>
</div>
<br class="clear" />
<cfoutput>#renderView("filter")#</cfoutput>