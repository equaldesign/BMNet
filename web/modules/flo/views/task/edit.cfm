<cfset getMyPlugin(plugin="jQuery").getDepends("","relationship/search")>
<form action="/flo/item/do" class="form form-horizontal" method="post">
  <fieldset>
    <legend>
      <cfif rc.id eq 0>Create<cfelse>Edit</cfif> Item
    </legend>
    <cfoutput>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <input name="name" id="itemName" value="#rc.task.task.name#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Amount</label>
      <div class="controls">
        <input name="amount" value="#rc.task.task.amount#" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Description</label>
      <div class="controls">
        <textarea name="description" id="itemDescription">#rc.task.task.description#</textarea>
      </div>
    </div>
    <cfif rc.id neq 0>
    <div class="control-group">
      <label class="control-label">Stage</label>
      <div class="controls">
        <select name="stage">
          <cfloop query="rc.stages">
            <option value="#id#" #vm(name,rc.task.task.stageName)#>#name#</option>
          </cfloop>
        </select>
      </div>
    </div>
    </cfif>
    <div class="control-group">
      <label class="control-label">Status</label>
      <div class="controls">
        <select name="status">

          <option #vm(rc.task.task.status, "pending")# value="pending">Pending</option>
          <option #vm(rc.task.task.status, "active")# value="active">Active</option>
          <option #vm(rc.task.task.status, "complete")# value="complete">Complete</option>
        </select>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Type</label>
      <div class="controls">
        <select name="itemType">
          <cfloop query="rc.itemTypes">
            <option #vm(rc.task.task.itemName,name)# value="#id#">#name# </option>
          </cfloop>
        </select>
      </div>
    </div>
    </cfoutput>
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
            <i class="icon-magnifier"></i>
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
          <cfset index = 1>
          <cfloop array="#rc.task.relatedObject#" index="o">
            <cfoutput>
            <tr>
              <td>
                <a class="del" href="##"><i class="icon-delete"></i></a>
                <input type="hidden" name="relationship[#index#].#o.type#" value="#o.object.id#">
                <input type="hidden" name="relationship[#index#].system" value="#o.system#">
                <input type="hidden" name="relationship[#index#].type" value="#o.type#">
              </td>
              <td>
                <cfif o.Type eq "contact">
                  #o.object.first_name# #o.object.surname#
                </cfif>
              </td>
              <td>#o.type#</td>
            </tr>
            </cfoutput>
            <cfset index++>
          </cfloop>
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
            <i class="icon-magnifier"></i>
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
            <cfoutput query="rc.task.dependencies">
            <tr>
              <td>
                <a class="del" href="##"><i class="icon-delete"></i></a>
                <input type="hidden" name="participant[#currentRow#].contact" value="#contactID#">
                <input type="hidden" name="participant[#currentRow#].system" value="#system#">
                <input type="hidden" name="participant[#currentRow#].type" value="contact">
              </td>
              <td>#first_name# #surname#</td>
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
          <tbody>
            <cfset i = 1>
            <cfoutput query="rc.task.activities">
              <tr>
                <td>
                  <a class="del" href="##"><i class="icon-delete"></i></a>
                  <input type="hidden" name="activity[#i#].id" value="#id#" />
                  <input type="hidden" name="activity[#i#].name" value="#name#" />
                  <input type="hidden" name="activity[#i#].description" value="#description#" />
                  <input type="hidden" name="activity[#i#].due" value="#DateFormat(dueDate,'DD/MM/YYY')#" />
                  <input type="hidden" name="activity[#i#].reminder" value="#DateFormat(reminderDate,'DD/MM/YYY')#" />
                </td>
                <td>#name#</td>
                <td>#DateFormat(dueDate,'DD/MM/YYY')#</td>
                <td>#DateFormat(reminderDate,'DD/MM/YYY')#</td>
              </tr>
              <cfset i++>
            </cfoutput>
          </tbody>
        </table>
      </div>
    </div>
  </fieldset>
  <cfoutput><input type="hidden" name="id" value="#rc.id#"></cfoutput>
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Save &raquo;">
  </div>
</form>
