<h3><cfif isNumeric(rc.campaign.id)>Edit<Cfelse>Create</cfif> Campaign</h3>
<cfoutput>
<form action="#bl("email.campaign.edit")#" method="post" class="form form-horizontal">
  <fieldset>
    <legend>Overview</legend>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <input type="text" name="name" value="#rc.campaign.name#" />
        <span class="help-inline">The name of your campaign - for you own reference only</span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Subject</label>
      <div class="controls">
        <input type="text" name="subject" value="#rc.campaign.subject#" />
        <span class="help-inline">The subject line for your campaign. This is what recipients will see in their inbox when they receive your email.</span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">From Name</label>
      <div class="controls">
        <input type="text" name="fromName" value="#rc.campaign.fromName#" />
       <span class="help-inline">Your name (or company name). This is what recipients will see in the inbox when they receive your campaign.</span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">From Email</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">@</span>
          <input type="text" name="fromEmail" value="#IIF(rc.campaign.fromEmail eq '',"'mailinglist@buildersmerchant.net'","'#rc.campaign.fromEmail#'")#" />
        </div>
        <span class="help-inline">The from email - recipients will see this when they receive your email.</span>
        <p class="help-block"><span class="label label-important">Be careful!</span> If you use your real personal email, users may be able to reply directly to you. If you do not want this, use the default email we have already provided</p>
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Schedule Options</legend>
    <div class="control-group">
      <label class="control-label">Scheduled</label>
      <div class="controls">
        <label class="checkbox">
          <input #vm(rc.campaign.scheduled,true)# type="checkbox" name="scheduled" value="true" />
          Do you want to send the email campaign at a specific time?
        </label>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Schedule Date / Time</label>
      <div class="controls">
        <input type="text" class="date input-small" name="scheduleTime" value="" />
        <select class="input-mini" name="scheduleHour">
          <cfloop from="0" to="23" index="h">
            <option value="#h#">#numberFormat(h,"00")#</option>
          </cfloop>
        </select>
        <select class="input-mini" name="scheduleMinute">
          <cfloop from="0" to="59" index="m">
            <option value="#m#">#numberFormat(m,"00")#</option>
          </cfloop>
        </select>
      </div>
    </div>
  </fieldset>
  <input type="hidden" name="id" value="#rc.campaign.id#" />
  <div class="form-actions">
    <button type="submit" class="btn btn-success"><i class="icon-save"></i>save campaign detail</button>
  </div>
</form>
</cfoutput>