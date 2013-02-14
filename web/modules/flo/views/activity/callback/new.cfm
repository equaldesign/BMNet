<form action="/flo/callback/do" method="post" class="form form-horizontal">
  <fieldset>
    <legend>Create Callback</legend>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <input type="text" name="activityname" id="activityname" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Description</label>
      <div class="controls">
        <textarea name="activityDescription"></textarea>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Due Date</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">
            <i class="icon-date"></i>
          </span>
          <input type="text" name="dueDate" class="date input-small" />
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
          <input type="text" name="reminderDate" class="date input-small" />
        </div>
      </div>
    </div>
  </fieldset>
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Save &raquo;">
  </div>
  <cfoutput>
  <input type="hidden" name="related.ID" value="#rc.contactID#">
  <input type="hidden" name="related.Type" value="contact">
  <input type="hidden" name="related.System" value="#rc.system#">
  <input type="hidden" name="participant.ID" value="#request['#rc.system#'].contactID#">
  <input type="hidden" name="participant.System" value="#rc.system#">
  </cfoutput>
</form>