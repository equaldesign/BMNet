<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-mail"></i></span>
    <h5>Emails</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-striped table-hover table-condensed">
      <thead>
        <tr>
          <th>From</th>
          <th>Subject</th>
          <th>Date</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="rc.emails">
          <tr>
            <td nowrap="nowrap"><a href="/eunify/contact/index/id/#contactID#">#first_name# #surname#</a></td>
            <td><a href="/eunify/email/detail/id/#id#">#subject#</a></td>
            <td><cfif isValid("date",messageDate)>#Duration(messageDate,now())#</cfif></td>
          </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>
</cfoutput>