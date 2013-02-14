<div class="appointmentDetail">
  <dl class="meeting-attendees">
  <dd>
<dl class="regInfo">
  <cfoutput query="rc.results">
    <dt>#fieldLabel#</dt>
    <dd>
        <cfif optionlabel neq "">
          #optionlabel#
        <cfelse>
          <cfif isBoolean(encrypted) and encrypted>
            <cfif isUserInRole("egroup_admin")>
            #decrypt(fieldValue,"eggwah","CFMX_COMPAT")#
            </cfif>
          <cfelse>
            #fieldValue#
          </cfif>
        </cfif>
    </dd>
  </cfoutput>
</dl>
</dd>
</dl>
</div>
