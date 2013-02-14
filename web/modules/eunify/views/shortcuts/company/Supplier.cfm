
<div class="leftAccordion">
<h4><a class="sales_panel_stats" href="#">Purchasing Agreements</a></h4>
<div id="Statistics">
  <cfoutput>#getMyPLugin("jQuery").getDepends("","psa/tree","themes/classic/style")#
    <ul>
      <li class="fullList"><a href="#bl('psa.fullList')#">Full List of current Agreements</a></li>
      <cfif isUserInAnyRole("admin,edit,Categories")>
      <li class="clonePSA"><a title="Create a new PSA" href="#bl('psa.cloneDeal','PSAID=#rc.moduleSettings.eGroup.settings.rootGroupCategory#')#">new agreement</a></li>
      </cfif>
    </ul>
    <ul id="dealTree" rel="current" class="jstree-classic">
      <li>Tree</li>
    </ul>
    <ul id="historicTree"  rel="historic" class="jstree-classic">
      <li>Tree</li>
    </ul>
    <ul id="inProgressTree"  rel="future" class="jstree-classic">
      <li>Tree</li>
    </ul>
</cfoutput>
</div>
</div>