<cfoutput>
<p style="margin-top:10px;margin-bottom:10px;margin-right:0;margin-left:0;">
  Hi #args.thisUser.first_name#
</p>
<p style="margin-top:10px;margin-bottom:10px;margin-right:0;margin-left:0;">
  You have been assigned the task: #args.activity.name#, relating to the item: <br />
  <strong>#args.task.task.name#</strong><br />
  #args.task.task.description#
</p>
<p style="margin-top:10px;margin-bottom:10px;margin-right:0;margin-left:0;">
This item is due on #DateFormat(args.activity.dueDate,"DD/MM/YYYY")#. Please add it to your calendar.
</p>
</cfoutput>