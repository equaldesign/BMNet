<cfset getMyPlugin(plugin="jQuery").getDepends("dataTableAjaxReload","menus","tables",false)>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","extra",true)>
<cfoutput>
 <input type="hidden" id="currentModule" value="#event.getCurrentModule()#">
  <h1 class="page-title">
          <i class="icon-home"></i>
          Dashboard
  </h1>
<div class="widget big-stats-container">
  <div class="widget-content">
    <div id="big_stats" class="cf">
      <div class="stat">
        <h4>Tickets raised this month</h4>
        <span class="value">#rc.overviewData.issuedThisMonth.thisSite#</span>
      </div> <!-- .stat -->
      <div class="stat">
        <h4>Tickets closed this month</h4>
        <span class="value">#rc.overviewData.closedThisMonth.thisSite#</span>=
      </div> <!-- .stat -->
      <div class="stat">
        <h4>Tickets Raised in Total</h4>
        <span class="value">#rc.overviewData.issued.thisSite#</span>
      </div> <!-- .stat -->
      <div class="stat">
        <h4>Tickets closed in total</h4>
        <span class="value">#rc.overviewData.closed.thisSite#</span>
      </div> <!-- .stat -->
    </div>
  </div> <!-- /widget-content -->
</div>
</cfoutput>
