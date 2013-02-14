<cfset getMyPlugin(plugin="jQuery").getDepends("cookie","secure/tasks/create","secure/contact/index")>
<cfoutput>
<input type="hidden" id="contactNodeRef" value="#rc.nodeRef#">
<label for="date">Date</label>
<input type="text" class="date" id="date">
<input type="text" id="hour">
<input type="text" id="minute">
<input type="button" value="shcedule call" id="sched">

<cfloop array="#rc.tasks.data#" index="task">
  <div>
    <h3>#task.message#</h3>
    <h4>#task.dueDate#</h4>
  </div>
</cfloop>
<cfdump var="#rc.tasks#">
</cfoutput>