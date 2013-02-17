<cfset getMyPlugin(plugin="jQuery").getDepends("dataTableAjaxReload","menus","tables",false)>
<cfset getMyPlugin(plugin="jQuery").getDepends("","buglist","extra,icons",true)>
<cfoutput><input type="hidden" id="currentModule" value="#event.getCurrentModule()#"></cfoutput>
<div id="listToolBar" class="btn-group pull-right" data-toggle="buttons-checkbox">
  <cfoutput>
  <a data-ref="hideClosed" href="#bl('bugs.list')#" class="noAjax #iif(rc.hideClosed,"'active'","''")# btn">Hide closed tickets?</a>
  <a data-ref="showMine" href="#bl('bugs.list')#" id="showMyTickets" class="noAjax btn">My tickets only</a>
  <a href="#bl('bugs.edit')#" class="btn">Create new Ticket</a></cfoutput>
</div>
<br />
<hr />
<cfoutput>
  <input type="hidden" id="hideClosed" value="#rc.hideClosed#" />
  <input type="hidden" id="showMine" value="#rc.mine#" />
</cfoutput>
<div class="widget widget-table small">
<table class="table table-striped table-bordered table-condensed" id="bugsList">
  <thead>
    <tr>
      <th nowrap="nowrap">ID</th>
      <th nowrap="nowrap"></th>
      <th nowrap="nowrap"></th>
      <th nowrap="nowrap" width="70"></th>
      <th width="100">Issuer</th>
      <th width="300">Title</th>
      <th>Created</th>
      <th>Modified</th>
      <th width="1"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/balloon.png" /></th>
      <cfif isUserInRole("ebiz")><th>Site</th></cfif>
    </tr>
  </thead>
  <tbody>

  </tbody>
</table>
</div>
