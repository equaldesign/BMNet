<cfoutput>
<ul class="nav nav-list" id="mainLinks">
  <cfif isUserInRole("admin_#request.bvsiteID#")>
    <li class="nav-header">Manage Promotions</li>  
    <li><a name="1. Create New Promotion" class="shortcut dialogOK edit-promotions" href="/bv/promotions/edit">Create new promotion</a></li>
    <li><a name="Promotions" class="dialog shortcut help" href="/pages/Promotions">Help!</a></li>  
  </cfif>
  <li class="nav-header">View Promotions</li>  
  <li><a class="shortcut promotions" href="/bv/promotions">Current Promotions</a></li>
  <li><a class="shortcut pending-promotions" href="/bv/promotions?ptype=pending">Pending Promotions</a></li>
  <li><a class="shortcut expired-promotions" href="/bv/promotions?ptype=expired">Expired Promotions</a></li>

</ul>
</cfoutput>
