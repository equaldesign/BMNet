<cfset getMyPlugin(plugin="jQuery").getDepends("form","activity/new,activity/log","",false,"flo")>
<h3>Task list</h3>
<!--- activity list --->
<table class="table table-bordered table-striped table-condensed table-rounded">
  <thead>
    <tr>
      <th>Name</th>
      <th>Detail</th>
      <cfif args.showDates>
      <th>Due</th>
      <th>Reminder</th>
      <th>T.Spent</th>
      </cfif>
      <th>Status</th>
      <th>Actor</th>
      <cfif isUserInRole("ebiz")><th></th></cfif>
      <cfif args.showDates>
      <th></th>
      <th></th>
      </cfif>
    </tr>
  </thead>
  <tbody>
  <cfoutput query="rc.item.activities">
    <cfset tableClass="">
    <cfif DateCompare(now(),duedate) gt 0 AND not complete>
      <cfset tableClass="error">
    </cfif>
    <tr class="#tableClass#">
      <td>#name#</td>
      <td>#description#</td>
      <cfif args.showDates>
      <td>#dateFormat(duedate,"DD/MM/YYYY")# <cfif not complete>(<cfif tableClass neq "error">Due in </cfif>#DateDiff("d",now(),duedate)# days<cfif tableClass eq "error"> overdue</cfif>)</cfif></td>
      <td>#dateFormat(reminderdate,"DD/MM/YYYY")#</td>
      <td>#hours#</td>      
      </cfif>
      <td><cfif complete><i class="icon-tick"></i><cfelse><i class="icon-cross"></i></cfif></td>
      <td><cfif contactID eq 0><span class="label label-important">no actors</label><cfelse><span class="label label-success">#first_name# #surname# (#companyName#)</span></cfif></td>
      <cfif isUserInRole("ebiz")>
        <td>
        <cfset activeWorklog = rc.worklogService.getActiveWorklog(id)>
        <cfif activeWorkLog.recordCount eq 0>
          <!--- enable starting of log --->
          <a href="##" class="startTracking" data-activityID="#id#"><i class="icon-clock"></i></a>
        <cfelse>
          <a href="##" title="Started on #DateFormat(activeWorkLog.startTS,'short')# @ #TimeFormat(activeWorkLog.startTS,'medium')#" class="ttip stopTracking" data-activityID="#id#" data-trackingID="#activeWorkLog.id#"><img src="/includes/images/spinner.gif" border="0"></a>
        </cfif>
        </td>
      </cfif>
      <cfif args.showDates>

      <td>
        <cfif complete>
          
        <cfelseif emailaddress eq getAuthUser() AND isUserInRole("staff")>
          <a href="#bl('activities.markdone','id=#id#')#" class="btn btn-mini btn-info">mark done</a>
        <cfelseif isUserInRole("staff")>
          <a href="#bl('activities.assign','id=#rc.item.activities.id#&contactID=#request.bmnet.contactID#')#" class="btn btn-mini btn-warning">take ownership</a>
        </cfif>
      </td>
      <td>
        <cfif isUserInRole("staff")>
        <div class="btn-group">
          <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="##">
            Assign to
            <span class="caret"></span>
          </a>
          <ul class="dropdown-menu pull-right">
            <cfloop query="rc.item.dependencies">
              <li><a href="#bl('activities.assign','id=#rc.item.activities.id#&contactID=#contactID#')#">
                <img width="16" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(emailaddress)))#?size=16&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
                #first_name# #surname#</a></li>
            </cfloop>
            <!-- dropdown menu links -->
          </ul>
        </div>
        </cfif>
      </td>
      </cfif>
    </tr>
  </cfoutput>
  </tbody>
</table>