<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","groups/administrator,tableSearch","tables,groupAdministrator")>

<h2 class="page-header">Group & Category Manager</h2>
<div class="row-fluid">
  <div class="span6 well">
    <label class="checkbox">
      <input type="checkbox" id="showUsers" value="true" />
      show users in tree?
    </label>
    <div id="groupTree" class="jstree-products"></div>
  </div>
  <div class="span6">
    <div id="groupList" class="accordion">
      <h5><a href="#">Groups</a></h5>
      <div>
      <table id="groupList" class="table table-striped table-condensed table-bordered table-rounded dataTable">
        <caption>Groups</caption>
        <thead>
          <tr>
            <th width="1"></th>
            <th>Name</th>
          </tr>
        </thead>
        <tbody>
          <cfoutput query="rc.groups">
          <tr id="group_#id#" class="jstree-draggable">
            <td><input type="checkbox" name="groupID" value="#id#" /></td>
            <td>#name#</td>
          </tr>
          </cfoutput>
        </tbody>
      </table>
      </div>
      <h5><a href="#">Users</a></h5>
      <div>
        <table id="userList" class="table table-striped table-bordered table-condensed table-rounded dataTable">
          <caption>Users</caption>
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
              <td><input type="checkbox" name="contactID" value="#id#" /></td>
              <td>#name#</td>
              <td>#known_as#</td>
            </tr>
            </cfoutput>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
