<cfset getMyPlugin(plugin="jQuery").getDepends("","relationship/search")>
<form action="/flo/item/do" class="form form-horizontal" method="post">
  <fieldset>
    <legend>
      Create new Item
    </legend>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <cfoutput>
        <input type="text" name="name" id="itemName" value="#rc.itemName#" />
        </cfoutput>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Amount</label>
      <div class="controls">
        <input type="text" name="amount" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Description</label>
      <div class="controls">
        <textarea name="description" id="itemDescription"></textarea>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Status</label>
      <div class="controls">
        <select name="status">

          <option value="pending">Pending</option>
          <option value="active">Active</option>
          <option value="complete">Complete</option>
        </select>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Type</label>
      <div class="controls">
        <select name="itemType">
          <cfoutput query="rc.itemTypes">
            <option #vm(rc.relatedType,name)# value="#id#">#name#</option>
          </cfoutput>
        </select>
      </div>
    </div>
  </fieldset>

  <fieldset>
    <legend>Relationships</legend>
    <div class="control-group">
      <label class="control-label">
        Search
      </label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">
            <i class="icon-search"></i>
          </span>
          <input type="text" id="relationshipSearch" data-url="/eunify/search/index" />
        </div>
      </div>
    </div>
    <div class="control-group">
      <div class="controls" id="relationship">
        <table class="table table-striped table-bordered table-condensed">
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Type</th>
            </tr>
          </thead>
          <tbody>
          <cfoutput query="rc.relatedObject">
            <tr>
              <td>
                <a class="del" href="##"><i class="icon-delete"></i></a>
                <input type="hidden" name="relationship[1].#rc.relatedType#" value="#id#">
                <input type="hidden" name="relationship[1].system" value="#rc.system#">
              </td>
              <td>
                <cfif rc.relatedType eq "contact">
                  #rc.relatedObject.first_name# #rc.relatedObject.surname#
                </cfif>
              </td>
              <td>#rc.relatedType#</td>
            </tr>
          </cfoutput>
          </tbody>
        </table>
      </div>
    </div>
  </fieldset>

  <fieldset>
    <legend>Participants</legend>
    <div class="control-group">
      <label class="control-label">
        Search
      </label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">
            <i class="icon-search"></i>
          </span>
          <input type="text" id="participantSearch" data-url="/eunify/search/index" />
        </div>
      </div>
    </div>
    <div class="control-group">
      <div class="controls" id="participant">
        <table class="table table-striped table-bordered table-condensed">
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
            </tr>
          </thead>
          <tbody>
            <cfoutput>
            <tr>
              <td>
                <a class="del" href="##"><i class="icon-delete"></i></a>
                <input type="hidden" name="participant[1].contact" value="#rc.contactObject.id#">
                <input type="hidden" name="participant[1].type" value="contact">
                <input type="hidden" name="participant[1].system" value="#rc.system#">
              </td>
              <td>#rc.contactObject.first_name# #rc.contactObject.surname#</td>
            </tr>
            </cfoutput>
          </tbody>
        </table>
      </div>
    </div>
  </fieldset>

  <fieldset>
    <legend>Activities</legend>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <input type="text" name="activityname" id="activityname" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Activity Description</label>
      <div class="controls">
        <textarea id="activityDescription"></textarea>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Due Date</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">
            <i class="icon-date"></i>
          </span>
          <input type="text" id="dueDate" class="date input-small" />
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
          <input type="text" id="reminderDate" class="date input-small" />
        </div>
      </div>
    </div>
    <div class="form-actions">
      <input type="button" id="addActivity" class="btn btn-warning" value="add Activity">
    </div>
    <div class="control-group">
      <div class="controls" id="activities">
        <table class="table table-striped table-bordered table-condensed">
          <thead>
            <tr>
              <th></th>
              <th>Name</th>
              <th>Due</th>
              <th>Reminder</th>
            </tr>
          </thead>
          <tbody></tbody>
        </table>
      </div>
    </div>
  </fieldset>
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Save &raquo;">
  </div>
</form>
