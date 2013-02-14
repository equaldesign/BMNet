<cfset getMyPlugin(plugin="jQuery").getDepends("","branch/list")>
<div id="branchScreen" class="ajaxWindow branchScreen">
<cfif rc.branches.recordCount eq 0>
	<h2>No branches</h2>
	<p>This company does not have any branches.</p>
</cfif>
<Cfoutput><a href="#bl('branch.edit','companyID=#rc.company.id#')#" class="addBranch">add branch</a></Cfoutput>
<cfoutput query="rc.branches">
	<div class="row-fluid">
		<div style="height: 200px" id="b_#id#" class="span3 img-polaroid map_canvas" rel="#maplat#" rev="#maplong#"></div>
    <div class="span5">
  		<h2>#name#</h2>
  		<p>#address1# #IIF(address2 neq "","',#address2#'","")# #IIF(address3 neq "","',#address3#'","")#</p>
  		<p>#Town#</p>
  		<p>#county#</p>
  		<p>#PostCode#</p>
  		<p class="branch_tel">#tel#</p>
  		<p class="branch_email">#email#</p>
  		<cfif canEditCompany(rc.company.id,rc.company.type_id)>
  		<div class="branchEditingControls ui-state-highlight ui-corner-all">
  			<ul>
  				<li><a rel="#id#" href="##" class="deleteBranch">delete this branch</a></li>
  				<li><a href="#bl('branch.edit','id=#id#')#" class="editBranch">edit this branch</a></li>
  			</ul>
  		</div>
  		</cfif>
    </div>
	</div>
	<br clear="all">
</cfoutput>
</div>