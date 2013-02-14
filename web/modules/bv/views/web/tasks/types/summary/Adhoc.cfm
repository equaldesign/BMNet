<cfoutput>
<div class="task greyBox clearfix">
  <cfif structKeyExists(task,"resources")><div class="left"></cfif>
  <h4><a class="ajax" href="/bv/tasks/viewtask/id/#task.id#">#task.description#</a></h4>
  <ul>
  <cfif DateDiff("y",now(),alfNice(task.dueDate)) LT 1>
    <li class="taskdue">Due Date: #DateFormat(alfNice(task.dueDate),"DD/MM/YY")#</li>
  </cfif>
  <li class="taskstatus #lcase(replace(task.status,' ','','all'))#">Status: #task.status#</li>
  <li class="taskstarted">Start Date: #DateFormat(alfNice(task.startDate),"DD/MM/YY")#</p>
  </ul>
  <cfif structKeyExists(task,"resources")>
    </div>
    <div class="relationships">
      <h5>Relationships</h5>
      <ul>
      <cfloop array="#task.resources#" index="resource">
        <cfoutput>#renderView("secure/tasks/types/resourceTypes/#replace(resource.nodeType,":","","ALL")#")#</cfoutput>
      </cfloop>
      </ul>
    </div>
  </cfif>
  <br class="clear" />
  <div>
  <cfloop array="#task.transitions#" index="outcomes">
    <input type="button" class="button submitTask" rev="#task.id#" rel="#outcomes.id#" value="#outcomes.label#?" />
  </cfloop>
  </div>
</div>
</cfoutput>