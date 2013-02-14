<cfset getMyPlugin(plugin="jQuery").getDepends("","calendar/recipients","")>
<cfoutput>
<div class="row-fluid">
  <div class="span12">
    <h2>Attendee Management</h2>
    <form class="form form-horizontal" id="editInviteeList" method="post" action="#bl('calendar.doInvites')#">
      <fieldset>
        <legend>Email Settings</legend>
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
            <input size="60" name="subject" label="Email Subject" type="text" id="subject" value="#rc.templates.subject[1]#" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Notification Email</label>
          <div class="controls">
            <textarea name="template" id="template">#rc.templates.contents[1]#</textarea>
          </div>
        </div>
      </fieldset>
      <div class="form-actions">
        <input id="doSendInvites" type="button" class="btn btn-success" value="Send Invitations &raquo;">
      </div>
      <input type="hidden" id="inviteeID" name="inviteeID" />
      <input type="hidden" id="appointmentID" name="id" value="#rc.id#">
    </form>
  </div>
</div>
<div class="row-fluid">
  <div class="span5">
    <div class="accordion">
      <h5><a href="##">Group List</a></h5>
      <div>
        <div class="widget-box">
          <div class="widget-title">
            <h4>Group List</h4>
          </div>
          <div class="widget-content nopadding">
            <table id="groupList" class="table table-striped table-condensed table-hover table-rounded dataTable">
              <thead>
                <tr>
                  <th>Name</th>
                  <th width="1%"></th>
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
          </div>
        </div>
      </div>
      <h5><a href="##">Query Builder</a></h5>
      <div>
        <form class="form form-inline" action="/marketing/email/recipient/query" method="post">
          <label class="control-label" for="pre-list">Pre-defined Queries</label>
          <select name="queryList" id="queryList">
            <option>--select</option>
            <cfloop query="rc.prequeries">
            <option value="#id#">#name#</option>
            </cfloop>
          </select>
          <button data-target="##queryDesigner" type="button" class="btn btn-mini" data-toggle="modal"><i class="icon-pencil"></i>New</button>
        </form>
        <div class="widget-box">
          <div class="widget-title">
            <h4>Query List</h4>
          </div>
          <div class="widget-content nopadding">
            <table id="queryListTable" class="table table-striped table-hover table-condensed table-rounded">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Company</th>
                  <th width="1%"></th>
                </tr>
              </thead>
              <tbody>
              </tbody>
              <tfoot>
                <tr>
                  <th style="text-align: right" colspan="2">Add All</th>
                  <th><button data-type="all" data-id="#rc.id#" class="btn btn-small btn-sucess addall"><i class="icon-exclamation-red-frame"></i></button></th>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="span7">
    <div class="widget-box">
      <div class="widget-title">
        <h5>Recipient List</h5>
      </div>
      <div class="widget-content nopadding">
        <table id="recipientList" data-campaignID="#rc.id#" class="table table-striped table-hover table-condensed table-rounded">
          <thead>
            <tr>
              <th>Name</th>
              <th>Company</th>
              <th width="1%"></th>
            </tr>
          </thead>
          <tbody>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
</cfoutput>