<cfoutput>
<form action="/bugs/status" class="form form-horizontal" id="changeStatus">
  <fieldset>
  	<legend>Edit Status</legend>
		<div class="control-group">
			<label class="control-label">Current Status</label>
			<div class="controls">
				<select name="status">
					<option value="open" #vm(rc.bug.getstatus(),"open")#>Open</option>
					<option value="open" #vm(rc.bug.getstatus(),"open")#>Pending</option>
					<option value="closed" #vm(rc.bug.getstatus(),"closed")#>Closed</option>
				</select>
			</div>
		</div>
		<div class="control-group">
			<label class="control-label">Fix Version</label>
			<div class="controls">
				<select name="fixVersion">
          <option value="eGroup1.4.2e" #vm(rc.bug.getfixVersion(),"eGroup1.4.2e")#>eGroup1.4.2e</option>
          <option value="eGroup1.4.2f" #vm(rc.bug.getfixVersion(),"eGroup1.4.2f")#>eGroup1.4.2f</option>
          <option value="eGroup1.4.2g" #vm(rc.bug.getfixVersion(),"eGroup1.4.2g")#>eGroup1.4.2g</option>
					<option value="eGroup1.4.2h" #vm(rc.bug.getfixVersion(),"eGroup1.4.2h")#>eGroup1.4.2h</option>
					<option value="eGroup1.4.2i" #vm(rc.bug.getfixVersion(),"eGroup1.4.2i")#>eGroup1.4.2i</option>
					<option value="eGroup1.4.2j" #vm(rc.bug.getfixVersion(),"eGroup1.4.2j")#>eGroup1.4.2j</option>
					<option value="eGroup1.4.3" #vm(rc.bug.getfixVersion(),"eGroup1.4.3")#>eGroup1.4.3</option>
					<option value="eGroup1.5" #vm(rc.bug.getfixVersion(),"eGroup1.5")#>eGroup1.5</option>
        </select>
			</div>
		</div>
		<div class="control-group">
      <label class="control-label">Fix Date</label>
      <div class="controls">
        <div class="input-prepend">
        	<span class="add-on"><i class="icon-date"></i></span>
					<input type="text" class="input-small date" name="fixDate" value="#rc.bug.getfixDate()#" />
        </div>
      </div>
    </div>
		<div class="control-group">
      <label class="control-label">Notify</label>
      <div class="controls">
        <label class="checkbox">
          <input type="checkbox" name="notify" value="true" checked="checked" />
					Notify the issuer of the ticket this status change?
        </label>
      </div>
    </div>
  </fieldset>
	<input type="hidden" name="id" value="#rc.id#" />
</form>
</cfoutput>