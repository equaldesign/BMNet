<cfoutput>
<fieldset>
	<legend>Security</legend>
	<div class="control-group">
	  <label for="permissions" class="control-label">Permissions</label>
	  <div class="controls">
	    <select id="permissions" name="permissions" multiple="multiple" size="8">
	      <option #IIf(args.permissions.recordCount eq 0,"'selected'","''")# value="0">--all--</option>
	      <optgroup label="Permissions">
	      <cfset securityGroups = request.groupService.securityGroups>
	      <cfloop array="#securityGroups.group#" index="g">
	          <option #vml(ValueList(rc.permissions.groupID),g.id)# value="#g.id#">#g.name#</option>
	      </cfloop>
	      </optgroup>
	      <optgroup label="User Groups">
	      <cfset gL = getModel("groupService").fullGroupList(rc.sess.eGroup.companyID,request.groupService.securityGroupIDs)>
	      <cfloop query="gL">
	        <option #vml(ValueList(args.permissions.groupID),id)# value="#id#"> #name# </option>
	      </cfloop>
	      </optgroup>
	    </select>
	  </div>
	</div>
</fieldset>
</cfoutput>