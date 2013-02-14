<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-calendar-task"></i></span>
    <h5>Tasks</h5>
  </div>
  <div class="widget-content nopadding">
    <table class="table table-striped table-hover table-condensed">
      <thead>
        <tr>
          <th>Task</th>
          <th>Due</th>
          <cfif ListContains(ValueList(rc.tasks.typeName),"Sale")>
          <th>Amount</th>
          </cfif>
          <th>Actors</th>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="rc.tasks" group="activityID">
          <tr>
            <td nowrap="nowrap">
             <a title="#name# (#stageName#)" class="ttip" href="/flo/item/detail?id=#id#">#activityName#</a>
            </td>
            <td>#DateFormat(dueDate,"DD/MM/YY")#</td>
            <cfif ListContains(ValueList(rc.tasks.typeName),"Sale")>
            <td>&pound;#amount#</td>
            </cfif>
            <td>
              <div class="btn-group buttons">
                <a class="btn btn-mini" href="##"><i class="icon-user"></i></a>
                <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="##"><span class="caret"></span></a>
                <ul class="dropdown-menu">
                  <cfoutput>
                  <li><a class="noAjax" href="/eunify/contact/index/id/#contactid#">#first_name# #surname#</a></li>
                  </cfoutput>
                </ul>
              </div>
            </td>
          </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
</div>
</cfoutput>