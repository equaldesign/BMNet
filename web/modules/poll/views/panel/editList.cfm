<cfset getMyPlugin(plugin="jQuery").getDepends("","tableSearch,poll/editList","calendarList")>
  <cfoutput>
  <form class="form form-horizontal" id="editInviteeList" method="post" action="#bl('poll.doInvites')#">
    <fieldset>
      <legend>Attendee Management</legend>
      <div class="control-group">
        <label class="control-label">Who to Notify?</label>
        <div class="controls">
          <select name="whotonotify" id="whotonotify">
            <option value="newonly">Newly added attendees only</option>
            <option value="selected">Selected attendees</option>
            <option value="all">Everyone</option>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label class="control-label">Email Subject</label>
        <div class="controls">
          <input size="60" name="subject" label="Email Subject" type="text" id="subject" value="You are requested to complete this questionnaire" />
        </div>
      </div>
      <div class="control-group">
        <label class="control-label">Notification Email</label>
        <div class="controls">
          <textarea name="template" id="template"></textarea>
        </div>
      </div>
    </fieldset>
    <div class="form-actions">
      <input id="doSendInvites" type="button" class="btn btn-success" value="Send Invitations &raquo;">
    </div>
    <input type="hidden" id="inviteeID" name="inviteeID" />
    <input type="hidden" id="pollID" name="id" value="#rc.id#">
  </form>
  </cfoutput>

<div class="left small">
  <h3>Groups</h3>
  <table id="groupList" class="table table-condensed table-bordered table-striped dataTable">
    <thead>
      <tr>
        <th width="1"></th>
        <th>Name</th>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="rc.contactGroups">
      <tr id="group_#id#" class="jstree-draggable">
        <td><input class="group_check" type="checkbox" name="groupID" value="#id#" /></td>
        <td>#name#</td>
      </tr>
      </cfoutput>
    </tbody>
  </table>
  <button class="btn" id="addGroup">Add &raquo;</button>
  <h3>Users</h3>
  <table id="userList" class="table table-condensed table-bordered table-striped dataTable">
    <thead>
      <tr>
        <th width="1"></th>
        <th>Name</th>
        <th>Company</th>
      </tr>
    </thead>
    <tbody>
      <cfoutput query="rc.contacts">
      <tr id="contact_#id#" class="jstree-draggable">
        <td><input class="contact_check" type="checkbox" name="contactID" value="#id#" /></td>
        <td>#name#</td>
        <td>#known_as#</td>
      </tr>
      </cfoutput>
    </tbody>
  </table>
  <button class="btn" id="addUser">Add &raquo;</button>
</div>
<div class="small right">
  <h3>Atteendees</h3>
  <table id="currentList" class="table table-condensed table-bordered table-striped dataTable">
    <thead>
      <tr>
        <th></th>
        <th>Name</th>
        <th>Company</th>
      </tr>
    </thead>
    <tbody>
    <cfoutput query="rc.inviteList">
      <tr>
        <td><input class="invitee_check" type="checkbox" name="invitee" value="#contactid#" /></td>
        <td>#name#</td>
        <td>#known_as#</td>
      </tr>
    </cfoutput>
    </tbody>
  </table>
  <button class="btn" id="delInvitee">&laquo; Remove</button>
</div>
<div class="clear"></div>