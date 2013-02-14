<cfset getMyPlugin(plugin="jQuery").getDepends("highstock","sales/site/overview","charts,form")>
<!---<div class="well btn-primary">
  <div class="row">
    <div class="span4">
      <h1>Sales</h1>                           
    </div>
    <div class="span2">
      <h1>$25</h1>
      today                     
    </div>
    <div class="span2">
      <h1>$550</h1>
      this week                     
    </div>
    <div class="span2">
      <h1>$750</h1>
      this month                      
    </div>
  </div>
</div>--->
<div id="chart">
  <div id="overviewChart"></div>
</div>
<cfoutput>
	<input type="hidden" id="filterValue" value="#rc.filterValue#" />
	<input type="hidden" id="filterColumn" value="#rc.filterColumn#" />
</cfoutput>
