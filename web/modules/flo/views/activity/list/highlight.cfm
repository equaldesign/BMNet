<div class="buttons btn-group pull-right">
 <button class="btn btn-mini"><i class="icon-clock"></i></button>
 <button class="btn btn-mini dropdown-toggle" data-toggle="dropdown">
    <span class="caret"></span>
  </button>
  <ul class="dropdown-menu">
<cfoutput query="args">

  <cfif DateCompare(now(),duedate) gt 0 AND not complete>
    <!--- item is overdue --->
    <li><a href="/flo/activity/id/#id#"><i class="icon-clock--exclamation"></i>#name# is overdue!</a></li>
  <cfelseif not complete>
    <li><a href="/flo/activity/id/#id#" ><i class="icon-clipboard-invoice"></i>#name# is not complete</a></li>
  </cfif>
</cfoutput>
</ul>
</div>