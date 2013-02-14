<cfset getMyPlugin(plugin="jQuery").getDepends("","calendar/edit")>

  <cfif rc.appointment.id eq ""><h1>Create appointment</h1><cfelse><h1>Edit appointment</h1></cfif>
  <cfoutput>
  <form class="form form-horizontal" id="editAppointment" method="post" action="#bl('calendar.doEdit')#">

    <fieldset>
      <legend>Appointment Information</legend>
      <div class="control-group">
        <label for="name"class="control-label">Name <em>*</em></label>
        <div class="controls">
          <input size="65" type="text" name="name" id="name" value="#rc.appointment.name#" />
        </div>
      </div>
      <div class="control-group">
        <label for="name"class="control-label">Private?</label>
        <div class="controls">
          <input type="checkbox" name="companyID" value="#rc.sess.eGroup.companyID#" #vm(rc.appointment.companyID,rc.sess.eGroup.companyID,"checkbox")# />
        </div>
      </div>
      <div class="control-group">
        <label for="description"class="control-label">Description</label>
        <div class="controls">
          <textarea rows="10"  name="description" id="description">#rc.appointment.description#</textarea>
        </div>
      </div>

      <div class="control-group">
        <label for="startDate"class="control-label">Start Date <em>*</em></label>
        <div class="controls">
          <div class="input-prepend"><span class="add-on"><i class="icon-calendar"></i></span><input size="10" class="Aristo date input-mini" type="text" name="startDate" id="startDate" value="#DateFormat(rc.startDate,'DD/MM/YYYY')#" /></div>
          <select class="input-mini" name="startHour" id="startHour">
            <cfloop from="0" to="23" index="h" step="1">
              <option #vm(hour(rc.startDate),h)# value="#h#">#numberFormat(h,"00")#</option>
            </cfloop>
          </select>
          <select class="input-mini" name="startMinute" id="startMinute">
            <cfloop from="0" to="60" index="m" step="15">
              <option #vm(minute(rc.startDate),m)# value="#m#">#numberFormat(m,"00")#</option>
            </cfloop>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="endDate"class="control-label">End Date <em>*</em></label>
        <div class="controls">
          <div class="input-prepend"><span class="add-on"><i class="icon-calendar"></i></span><input size="10" class="date input-mini" type="text" name="endDate" id="endDate" value="#DateFormat(rc.endDate,'DD/MM/YYYY')#" /></div>
          <select class="input-mini" name="endHour" id="endHour">
            <cfloop from="0" to="23" index="h" step="1">
              <option #vm(hour(rc.endDate),h)# value="#h#">#numberFormat(h,"00")#</option>
            </cfloop>
          </select>
          <select class="input-mini" name="endMinute" id="endMinute">
            <cfloop from="0" to="60" index="m" step="15">
              <option #vm(minute(rc.endDate),m)# value="#m#">#numberFormat(m,"00")#</option>
            </cfloop>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="Address"class="control-label">Address</label>
        <div class="controls">
          <textarea name="Address" id="Address">#rc.appointment.Address#</textarea>
        </div>
      </div>
      <div class="control-group">
        <label for="name"class="control-label">Post Code</label>
        <div class="controls">
          <input size="15" type="text" name="postCode" id="postCode" value="#rc.appointment.postCode#" />
        </div>
      </div>
      <div class="control-group">
        <label for="requireRegistration"class="control-label">Require Registration</label>
        <div class="controls">
          <select name="requireRegistration" id="requireRegistration">
            <option value="false" #vm(rc.appointment.requireRegistration,"false","select")#>no</option>
            <option value="true" #vm(rc.appointment.requireRegistration,"true","select")#>yes</option>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="organiserID"class="control-label">Organiser</label>
        <cfset memberContacts = getModel("ContactService").getCompanyTypeContacts("1,3")>
        <cfif rc.appointment.organiserID eq "">
          <cfset orgID = rc.sess.eGroup.contactID>
        <cfelse>
          <cfset orgID = rc.appointment.organiserID>
        </cfif>
        <div class="controls">
          <select name="organiserID" id="organiserID">
            <cfloop query="memberContacts">
            <option value="#id#" #vm(orgID,"#id#","select")#>#first_name# #surname# (#name#)</option>
            </cfloop>
          </select>
        </div>
      </div>
    </fieldset>
    #renderView(view="tags/create",args={relationship="blog",id="#rc.id#",delete=true})#
    #renderView(view="security/permissions",args={permissions=rc.permissions})#
    <div class="form-actions">
        <input id="submit" name="submit" class="btn btn-success" type="submit" value="#IIF(rc.appointment.id eq "", "'Create'","'Save'")# &raquo;" />
    </div>

  <input type="hidden" id="appointmentID" name="id" value="#rc.id#">
  <input type="hidden" id="inviteGuests" name="inviteGuests" value="false" />

  </form>
    </cfoutput>