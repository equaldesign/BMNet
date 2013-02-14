<cfset getMyPlugin(plugin="jQuery").getDepends("","","poll")>
<div id="poll">
<cfoutput>
  <h2><cfif rc.poll.organiserID eq request.bmnet.contactID or isUserInAnyRole("egroup_admin,egroup_edit")>
      <a class="deleteIcon tooltip confirm" href="/poll/delete/id/#rc.id#" title="delete this Questionnaire"></a>
      <a class="cloneIcon tooltip noAjax" href="/poll/clone/id/#rc.id#" title="Clone this Questionnaire"></a>
    </cfif>
    #rc.poll.name#
  </h2>
  <p>#rc.poll.description#</p>
  <div id="pollTabs" class="tabs Aristo">
    <ul>
      <cfif getModel("poll.PollService").userCanComplete(request.bmnet.contactID,rc.id)>
      <li><a class="register" href="#bl('poll.submit','id=#rc.id#')#">Fill it in!</a></li>
      </cfif>
      <cfif rc.poll.organiserID eq request.bmnet.contactID OR rc.poll.CoOrdinatorID eq request.bmnet.contactID or isUserInAnyRole("egroup_admin,egroup_edit")>
      <li><a class="edit" href="#bl('poll.edit','id=#rc.id#')#">Edit</a></li>
      </cfif>
      <cfif isUserInAnyRole("admin")>
      <li><a class="editFields" href="#bl('poll.editForm','id=#rc.id#')#"><span>Edit Fields</span></a></li>
      <li><a class="editInvitees" href="#bl('poll.editList','id=#rc.id#')#"><span>Edit Invitees</span></a></li>
      </cfif>
      <li><a class="results" href="#bl('poll.results','id=#rc.id#')#"><span>Results</span></a></li>
      <li><a class="chart" href="#bl('poll.pdf','id=#rc.id#')#"><span>Full Report</span></a></li>
      <li><a class="documents" href="#bl('documents.relatedCategories','relatedID=#rc.id#&type=poll')#"><span>Documents</span></a></li>
      <li><a class="commentIcon" href="#bl('comment.list','relatedID=#rc.id#&relatedType=poll')#"><span>Notes</span></a></li>
    </ul>
  </div>
</cfoutput>
</div>
