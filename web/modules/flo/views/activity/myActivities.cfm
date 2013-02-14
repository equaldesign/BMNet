<cfset getMyPlugin(plugin="jQuery").getDepends("","reminders","")>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-calendar-task"></i></span>
    <h5>My Activities</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-hover table-condensed table-striped">
      <thead>
        <tr>
          <th></th>
          <th>Name</th>
          <th>Description</th>
          <th>Reminder</th>
          <th>Due Date</th>
          <th>Item</th>
          <th>Action</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="rc.activities">
          <cfset headerclass = "">
          <cfif DateDiff("d",dueDate,now()) lte 0>
            <cfset headerclass = "overdue">
          </cfif>
          <tr class="grabbable #headerclass#" rel="#activityid#">
            <td><a href="##" class="changePriority ttip" title="change priority" data-priority="#priority#" data-id="#activityid#" >
              <cfswitch expression="#priority#">
                <cfcase value="3">
                  <i class="icon-flag-green"></i>
                </cfcase>
                <cfcase value="2">
                  <i class="icon-flag-yellow"></i>
                </cfcase>
                <cfcase value="1">
                  <i class="icon-flag"></i>
                </cfcase>
              </cfswitch>
            </td>
            <td><a href="#bl('item.detail','id=#id#')#" class="noAjax">#activityName#</a></td>
            <td>#activityDescription#</td>
            <td>#LSDateFormat(reminderDate,"DD/MM/YYYY")#</td>
            <td>#LSDateFormat(dueDate,"DD/MM/YYYY")#</td>
            <td><a href="#bl('item.detail','id=#id#')#">#name#</td>
            <td>
              <div class="btn-group">
                <button class="btn btn-mini">Action</button>
                <button class="btn btn-mini dropdown-toggle" data-toggle="dropdown">
                  <span class="caret"></span>
                </button>
                <ul class="dropdown-menu pull-right">
                  <li><a href="##" class="pushback" data-id="#activityid#" data-time="#DateAdd("d",1,now())#"><i class="icon-calendar-next"></i>push back a day</a></li>
                  <li><a href="##" class="pushback" data-id="#activityid#" data-time="#DateAdd("d",2,now())#"><i class="icon-calendar-next"></i>push back two days</a></li>
                  <li><a href="##" class="pushback" data-id="#activityid#" data-time="#DateAdd("d",7,now())#"><i class="icon-calendar-next"></i>push back a week</a></li>
                  <li><a href="##" class="pushback" data-id="#activityid#" data-time="0"><i class="icon-tick"></i>mark done</a></li>
                </ul>
              </div>
            </td>
          </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>
