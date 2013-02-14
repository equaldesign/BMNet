<cfset getMyPlugin(plugin="jQuery").getDepends("","accordion,poll/results","poll/chart")>
<div class="accordion">
  <h5><a href="#">Users Invited/Completed</a></h5>
  <div>
    <cfoutput>#renderView("poll/panel/results/invitations")#</cfoutput>
  </div>
  <h5><a href="#">Pollable answers</a></h5>
  <div>
    <cfoutput>#renderView("poll/panel/results/chart")#</cfoutput>
  </div>
	<h5><a href="#">Numeric answers</a></h5>
  <div>
    <cfoutput>#renderView("poll/panel/results/sums")#</cfoutput>
  </div>
  <h5><a href="#">Text Answers</a></h5>
  <div>
    <cfoutput>#renderView("poll/panel/results/answers")#</cfoutput>
  </div>
</div>

