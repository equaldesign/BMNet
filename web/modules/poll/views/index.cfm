<cfset getMyPlugin(plugin="jQuery").getDepends("","","poll")>
<div id="poll">
<cfoutput>
  <h2>Questionnaire List</h2>
  <div id="tabs" class="tabs Aristo">
    <ul>
      <li><a class="currentPolls" href="#bl('poll.list','filter=open')#"><span>Open Questionnaires</span></a></li>
      <li><a class="historicPolls" href="#bl('poll.list','filter=closed')#"><span>Closed Questionnaires</span></a></li>
      <li><a class="pendingPolls" href="#bl('poll.list','filter=pending')#"><span>Pending Questionnaires</span></a></li>
    </ul>
  </div>
</cfoutput>
</div>
