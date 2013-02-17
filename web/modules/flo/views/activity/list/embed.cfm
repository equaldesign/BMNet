<cfset getMyPlugin(plugin="jQuery").getDepends("form","activity/new")>
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
      </cfif>
      <th>Status</th>
      <th>Actor</th>
      <th></th>
      <th></th>
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
      </cfif>
      <td><cfif complete><i class="icon-tick"></i><cfelse><i class="icon-cross"></i></cfif></td>
      <td><cfif contactID eq 0><span class="label label-important">no actors</label><cfelse><span class="label label-success">#first_name# #surname# (#companyName#)</span></cfif></td>
      <td>
        <cfif complete>
          
        <cfelseif emailaddress eq getAuthUser()>
          <a href="#bl('activities.markdone','id=#id#')#" class="btn btn-mini btn-info">mark done</a>
        <cfelseif isUserLoggedIn()>
          <a href="#bl('activities.assign','id=#rc.item.activities.id#&contactID=#request.bmnet.contactID#')#" class="btn btn-mini btn-warning">take ownership</a>
        </cfif>
      </td>
      <td>
        <cfif isUserLoggedIn()>
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
    </tr>
  </cfoutput>
  </tbody>
</table>