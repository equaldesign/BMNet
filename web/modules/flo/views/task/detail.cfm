<cfset getMyPlugin(plugin="jQuery").getDepends("form","activity/new")>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-calendar-task"></i></span>
    <cfoutput>
    <h5>#rc.item.task.name#</h5>

    <div class="buttons btn-group pull-right" style="padding-right: 15px">
      <a href="#bl('item.delete','id=#rc.item.task.id#')#" class="btn btn-mini"><i class="icon-delete"></i>delete item</a>
      <a href="#bl('item.edit','id=#rc.item.task.id#')#" class="btn btn-mini"><i class="icon-pencil"></i>edit item</a>
    </div>
    </cfoutput>
  </div>
  <div class="widget-content">
    <cfoutput>
      <p>
      #rc.item.task.description#
      </p>
    </cfoutput>
    <div class="row-fluid">
      <div class="span6">
        <h3>Related to</h3>
        <!--- dependencies --->
        <cfloop array="#rc.item.relatedObject#" index="q">
          <cfoutput>#renderView(view="task/relationships/list/#q.system#/#q.type#",args=q.object)#</cfoutput>
        </cfloop>
      </div>
      <div class="span6">
        <h3>Participants</h3>
        <!---- participants --->
        <table class="table table-bordered table-striped table-rounded">
          <thead>
            <tr>
              <td>Name</td>
              <td>Email</td>
            </tr>
          </thead>
          <tbody>
            <cfoutput query="rc.item.dependencies">
            <tr>
              <td><img width="16" class="img-polaroid" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(emailaddress)))#?size=16&d=http://dev.buildersmerchant.net/modules/eunify/includes/images/blankAvatar.jpg" /><a href="/#system#/contact/index?id=#contactID#">#first_name# #surname#</td>
              <td>#emailaddress#</td>
            </tr>
            </cfoutput>
          </thead>
        </table>
      </div>
    </div>
    <div class="row-fluid">
      <div class="span12">
        <h3>Task list</h3>
        <!--- activity list --->
        <table class="table table-bordered table-striped table-condensed table-rounded">
          <thead>
            <tr>
              <th>Name</th>
              <th>Detail</th>
              <th>Due</th>
              <th>Reminder</th>
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
              <td>#dateFormat(duedate,"DD/MM/YYYY")# (<cfif tableClass neq "error">Due in </cfif>#DateDiff("d",now(),duedate)# days<cfif tableClass eq "error"> overdue</cfif>)</td>
              <td>#dateFormat(reminderdate,"DD/MM/YYYY")#</td>
              <td><cfif complete><i class="icon-tick"></i><cfelse><i class="icon-cross"></i></cfif></td>
              <td><cfif contactID eq 0><span class="label label-important">no actors</label><cfelse><span class="label label-success"><a href="#bl('contact.index','id=#contactID#')#">#first_name# #surname# (#companyName#)</a></span></cfif></td>
              <td>
                <cfif complete>
                  <span class="label">item complete</span>
                <cfelseif emailaddress eq getAuthUser()>
                  <a href="#bl('activities.markdone','id=#id#')#" class="btn btn-mini btn-info">mark done</a>
                <cfelse>
                  <a href="#bl('activities.assign','id=#rc.item.activities.id#&contactID=#request.bmnet.contactID#')#" class="btn btn-mini btn-warning">take ownership</a>
                </cfif>
              </td>
              <td>
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
              </td>
            </tr>
          </cfoutput>
          </tbody>
        </table>
      </div>
      <div class="span12">
        <form class="form form-horizontal form-smaller" action="/flo/activities/new">
          <fieldset>
            <legend>New Task</legend>
            <div class="control-group">
              <label class="control-label">Name</label>
              <div class="controls">
                <input type="text" name="activityname" id="activityname" />
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Activity Description</label>
              <div class="controls">
                <textarea id="activityDescription"  name="description"></textarea>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label">Due Date</label>
              <div class="controls">
                <div class="input-prepend">
                  <span class="add-on">
                    <i class="icon-date"></i>
                  </span>
                  <input type="text" name="dueDate" id="dueDate" class="date input-small" />
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
                  <input type="text" name="reminderDate" id="reminderDate" class="date input-small" />
                </div>
              </div>
            </div>
            <div class="form-actions">
              <input type="submit" id="addActivity" class="btn btn-warning" value="add Activity">
            </div>
          </fieldset>
          <cfoutput><input type="hidden" name="itemID" value="#rc.item.task.id#" /></cfoutput>
        </form>
        <cfset rc.relationshipURL = "/flo/item/detail?id=#rc.item.task.id#">
        <cfoutput>#renderView(view="comment/list",module="eunify")#</cfoutput>
      </div>
    </div>
  </div>
</div>
