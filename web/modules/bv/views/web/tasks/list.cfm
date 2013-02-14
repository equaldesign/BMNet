<cfset getMyPlugin(plugin="jQuery").getDepends("UISelect","secure/tasks/list","secure/tasks/list")>
<cfoutput>
  <h2>Your current tasks <cfif rc.filter neq "all">for #rc.filter#</cfif></h2>
  <select name="filter" id="taskFilter">
    <option #vm(rc.filter,'all')# value="all"> show all tasks </option>
    <option #vm(rc.filter,'today')# value="today"> Today </option>
    <option #vm(rc.filter,'tomorrow')# value="tomorrow"> Tomorrow </option>
    <option #vm(rc.filter,'this-week')# value="this-week"> This week </option>
    <option #vm(rc.filter,'next-week')# value="next-week"> Next week </option>
    <option #vm(rc.filter,'overdue')# value="overdue"> Overdue </option>
    <option #vm(rc.filter,'no-due-date')# value="no-due-date"> No due date </option>
  </select>
<cfloop array="#rc.tasks.tasks#" index="task">
<div class="task clearfix">
    <cfoutput>#renderView("secure/tasks/types/summary/#ListFirst(task.type," ")#")#</cfoutput>
</div>
</cfloop>
</cfoutput>
