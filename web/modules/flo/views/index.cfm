<cfset getMyPlugin(plugin="jQuery").getDepends("","","main")>
<cfoutput>
<div class="subnav">
  <ul class="nav nav-pills">
    <li class="dropdown">
      <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-flo-sales"></i> Sales<b class="caret"></b></a>
      <ul class="dropdown-menu">
        <li><a href="#bl('stage.index','type=sale&system=#rc.system#')#" rev="flo"><i class="icon-flo-funnel"></i> Sales Funnel</a></li>
        <li><a href="#bl('stage.index','type=sale&system=#rc.system#&myTasks=true')#" rev="flo"><i class="icon-flo-funnel"></i> My Sales Funnel</a></li>
        <li><a href="#bl('item.new','system=BMNet&type=sale')#"><i class="icon-flo-sales-new"></i> New Opportunity</a></li>
      </ul>
    </li>
    <li><a href="#bl('item.myItems','system=#rc.system#')#" rev="flo"><i class="icon-flo-tasks"></i> My Items</a></li>
    <li><a href="#bl('activities.myActivities','system=#rc.system#')#" rev="flo"><i class="icon-flo-alarm"></i> My Reminders</a></li>
    <li><a href="#bl('item.list','system=#rc.system#')#" rev="flo"><i class="icon-flo-tasks"></i> All Items</a></li>
    <li><a href="#bl('feed','system=#rc.system#')#" rev="flo"><i class="icon-flo-log"></i> Flo log</a></li>
    <li class="pull-right"><a href="#bl('setup')#" rev="flo"><i class="icon-flo-settings"></i> Flo set-up</a></li>
  </ul>
</div>
<div id="flo" class="ajaxWindow"></div>
</cfoutput>