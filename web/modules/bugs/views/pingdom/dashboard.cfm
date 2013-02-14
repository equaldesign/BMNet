<cfset getMyPlugin(plugin="jQuery").getDepends("","","extra",true)>
<cfset getMyPlugin(plugin="jQuery").getDepends("highcharts,highstock","chart/serverStatus","")>
<cfoutput><input type="hidden" id="currentModule" value="#event.getCurrentModule()#"></cfoutput>
<h1 class="page-title">
  <i class="icon-home"></i>
  Current Status
</h1>
<div class="widget big-stats-container">
  <div class="widget-content">
    <div id="big_stats" class="cf">
      <cfoutput>
      <div class="stat">
        <h4>Server 1</h4>
        <a href="##" class="pop" title="Outages today" data-content="#getOutages(rc.server1.summary.status.totaldown)#"><img src="http://help.ebiz.co.uk/includes/images/#getToday(rc.server1.summary.status.totaldown)#.png" /></a>
        <div><span class="value">#decimalFormat(rc.server1.summary.responsetime.avgresponse/1000)#</span> sec avg</div>
      </div> <!-- .stat -->
      <div class="stat">
        <h4>Server 2</h4>
        <a href="##" class="pop" title="Outages today" data-content="#getOutages(rc.server2.summary.status.totaldown)#"><img src="http://help.ebiz.co.uk/includes/images/#getToday(rc.server2.summary.status.totaldown)#.png" /></a>
        <div><span class="value">#decimalFormat(rc.server2.summary.responsetime.avgresponse/1000)#</span> sec avg</div>
      </div> <!-- .stat -->
      <div class="stat">
        <h4>Server 3</h4>
        <a href="##" class="pop" title="Outages today" data-content="#getOutages(rc.server3.summary.status.totaldown)#"><img src="http://help.ebiz.co.uk/includes/images/#getToday(rc.server3.summary.status.totaldown)#.png" /></a>
        <div><span class="value">#decimalFormat(rc.server3.summary.responsetime.avgresponse/1000)#</span> sec avg</div>
      </div> <!-- .stat -->
      <div class="stat">
        <h4>Load Balancer</h4>
        <a href="##" class="pop" title="Outages today" data-content="#getOutages(rc.loadBalancer.summary.status.totaldown)#"><img src="http://help.ebiz.co.uk/includes/images/#getToday(rc.loadBalancer.summary.status.totaldown)#.png" /></a>
        <div><span class="value">#decimalFormat(rc.loadBalancer.summary.responsetime.avgresponse/1000)#</span> sec avg</div>
      </div> <!-- .stat -->
      </cfoutput>
    </div>
  </div> <!-- /widget-content -->
</div>
<div class="widget">
  <div class="widget-header">
    <i class="icon-star"></i>
    <h3>Average Response</h3>
  </div> <!-- /widget-header -->
  <div class="widget-content">
    <div id="chartData-average"></div>
  </div> <!-- /widget-content -->
</div>
<div class="widget">
  <div class="widget-header">
    <i class="icon-star"></i>
    <h3>Response Times</h3>
  </div> <!-- /widget-header -->
  <div class="widget-content">
    <div id="chartData-server"></div>
  </div> <!-- /widget-content -->
</div>
<cffunction name="getToday" returntype="string" output="false">
  <cfargument name="down" required="true">
  <cfif arguments.down eq 0>
    <cfreturn "green">
  <cfelseif arguments.down lte 5000>
    <cfreturn "orange">
  <cfelse>
    <cfreturn "red">
  </cfif>
</cffunction>
<cffunction name="getOutages" returntype="string" output="false">
  <cfargument name="mins">
  <cfif arguments.mins eq 0>
    <cfreturn "No outages today">
  <cfelse>
    <cfreturn "#decimalFormat(arguments.mins/60)# mins downtime today">
  </cfif>
</cffunction>
