<cfset getMyPlugin(plugin="jQuery").getDepends("form","activity/new","",false,"flo")>
<form class="form form-horizontal form-smaller" action="/flo/activities/new">
  <fieldset>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <input type="text" name="activityname" id="activityname" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Activity Description</label>
      <div class="controls">
        <textarea id="activityDescription"  name="description"></textarea>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Due Date</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">
            <i class="icon-date"></i>
          </span>
          <input type="text" name="dueDate" id="dueDate" class="date input-small" />
        </div>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Reminder Date</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">
            <i class="icon-date"></i>
          </span>
          <input type="text" name="reminderDate" id="reminderDate" class="date input-small" />
        </div>
      </div>
    </div>
    <div class="form-actions">
      <input type="submit" id="addActivity" class="btn btn-warning" value="add Activity">
    </div>
  </fieldset>
  <cfif args.hasItem>
  <cfoutput><input type="hidden" name="itemID" value="#rc.item.task.id#" /></cfoutput>
  </cfif>
</form>