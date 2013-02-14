<cfset groups = getModel("modules.eunify.model.GroupsService")>
<cfoutput>#getMyPLugin("jQuery").getDepends("","psa/tree","themes/classic/style")#
<input type="hidden" id="rootCategoryID" value="#groups.getGroupByName("PSA Categories")#">
    <ul>
      <li class="fullList"><a href="#bl('psa.fullList')#">Full List of current Agreements</a></li>
      <li class="clonePSA"><a title="Create a new PSA" href="#bl('psa.cloneDeal','PSAID=0')#">new agreement</a></li>
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