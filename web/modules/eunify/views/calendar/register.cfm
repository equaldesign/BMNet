<cfif rc.appointment.specialJScript>
  <cfset getMyPlugin(plugin="jQuery").getDepends("validate","calendar/special/#rc.appointment.ID#")>
<cfelse>
  <cfset getMyPlugin(plugin="jQuery").getDepends("validate","calendar/register")>
</cfif>
<div class="registration">
<cfoutput>
<h2>Confirm registration for #rc.appointment.name#</h2>
<div class="">
  #rc.appointment.description#
</div>
<form class="form form-horizontal" action="#bl('calendar.doRegister')#">
</cfoutput>
  <!--- get the registration groups --->
  <cfset metaData = rc.calendar.getEventGroups(rc.id)>
  <cfoutput query="metaData">
    <fieldset>
      <legend>#name#</legend>
      <cfif description neq "">
      <div class="alert">
          #description#
      </div>
      </cfif>
      <cfset fields = rc.calendar.getEventFields(metaData.id)>
      <cfloop query="fields">
      <div class="control-group">
        <label class="control-label">#fields.label#<cfif _required><em>*</em></cfif></label>

        <div class="controls">
        <cfswitch expression="#_type#">
          <cfcase value="radio">
            <cfset optionCount = 1>
            <cfset fieldOptions = rc.calendar.getEventFieldOptions(fields.id)>
            <cfloop query="fieldOptions">
              <label class="radio">
                <input class="<cfif fields._required>required</cfif>" #vm(optionCount,1,"checkbox")# type="radio" name="field_#fields.id#" value="#fieldOptions.id#" />
                #fieldOptions.label#
              </label>
            <cfset optionCount++>
            </cfloop>
          </cfcase>
          <cfcase value="checkbox">
              <label class="checkbox">
                <input type="checkbox" name="field_#fields.id#"  class="<cfif _required>required</cfif> field_#metaData.id#" value="true" />
                #label#
              </label>
              <cfset optionCount = 1>
              <cfset optionCount++>
          </cfcase>
          <cfcase value="text">
             <input class="input-medium <cfif _required>required</cfif>" type="text" id="field_#fields.id#" size="#_length#" name="field_#fields.id#" value="" />
          </cfcase>
          <cfcase value="textarea">
            <textarea class="<cfif _required>required</cfif>" id="field_#fields.id#" name="field_#fields.id#" value=""></textarea>
          </cfcase>
        </cfswitch>
        </div>
      </div>
      </cfloop>
    </fieldset>
  </cfoutput>
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Register &raquo;" />
  </div>
  <cfoutput>
  <form class="form" id="register" method="post" action="#bl('calendar.doRegister')#">
  <input type="hidden" id="appointmentID" name="appointmentID" value="#rc.id#">
  <input type="hidden" id="contactID" name="contactID" value="#rc.sess.eGroup.contactID#">
  </cfoutput>
  </form>
</div>
