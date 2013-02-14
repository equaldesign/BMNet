<cfset getMyPlugin(plugin="jQuery").getDepends("validate","poll/edit")>
	<cfif rc.poll.id eq ""><h1>Create Questionnaire</h1><cfelse><h1>Edit Questionnaire</h1></cfif>
  <cfoutput>
	<form class="form form-horizontal" id="editPoll" method="post" action="#bl('poll.doEdit')#">
	<input type="hidden" id="pollID" name="id" value="#rc.id#">
  <input type="hidden" id="inviteGuests" name="inviteGuests" value="false" />
  </cfoutput>
  <cfoutput>
	<p>Required fields are are denoted by <em>*</em></p>
	  <fieldset>
		  <legend>Questionnaire Information</legend>
		  <div class="control-group">
		    <label for="name" class="control-label">Name <em>*</em></label>
        <div class="controls">
  		    <input size="35" type="text" name="name" id="name" value="#rc.poll.name#" />
        </div>
		  </div>
			<div class="control-group">
		    <label for="description" class="control-label">Description</label>
        <div class="controls">
  		    <textarea name="description" id="description">#rc.poll.description#</textarea>
        </div>
		  </div>
      <div class="control-group">
        <label for="status" class="control-label">Status</label>
        <div class="controls">
          <select name="status" id="status">
            <option #vm(rc.poll.status,"pending")# value="pending">Pending</option>
            <option #vm(rc.poll.status,"open")# value="open">Open</option>
            <option #vm(rc.poll.status,"closed")# value="closed">Closed</option>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="protection" class="control-label">Who can fill in?</label>
        <div class="controls">
          <select name="protection" id="protection">
            <option #vm(rc.poll.protection,"none")# value="none">Anyone</option>
            <option #vm(rc.poll.protection,"invited")# value="invited">Invited Participants only</option>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="protection" class="control-label">Mutiple reponses per company?</label>
        <div class="controls">
          <select name="allowMultipleResponses" id="allowMultipleResponses">
            <option #vm(rc.poll.allowMultipleResponses,"true")# value="true">True</option>
            <option #vm(rc.poll.allowMultipleResponses,"false")# value="false">False - only one reponse allowed per company</option>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="organiserID" class="control-label">Organiser</label>
        <div class="controls">
          <cfset memberContacts = getModel("eunify.ContactService").getCompanyTypeContacts("1,3")>
          <cfif rc.poll.OrganiserID eq "">
            <cfset orgID = rc.sess.eGroup.contactID>
          <cfelse>
            <cfset orgID = rc.poll.OrganiserID>
          </cfif>
          <select name="organiserID" id="organiserID">
            <cfloop query="memberContacts">
            <option value="#id#" #vm(orgID,"#id#","select")#>#first_name# #surname# (#name#)</option>
            </cfloop>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="CoOrdinatorID" class="control-label">Primary Contact</label>
        <div class="controls">
          <cfset memberContacts = getModel("eunify.ContactService").getCompanyTypeContacts("1,3")>
          <cfif rc.poll.CoOrdinatorID eq "">
            <cfset CoOrdinatorID = rc.sess.eGroup.contactID>
          <cfelse>
            <cfset CoOrdinatorID = rc.poll.CoOrdinatorID>
          </cfif>
          <select name="CoOrdinatorID" id="CoOrdinatorID">
            <cfloop query="memberContacts">
            <option value="#id#" #vm(CoOrdinatorID,"#id#","select")#>#first_name# #surname# (#name#)</option>
            </cfloop>
          </select>
        </div>
      </div>
      <div class="control-group">
	      <label class="control-label" for="categoryID">Category</label>
        <div class="controls">
  	      <select multiple="true" name="categoryID" id="categoryID">
  	        <!--- TODO <cfset buyingTeam = arrangement.getBuyingTeam('building')> --->
  	        <option value="">-- choose a Category --</option>
  	        <cfset groups = getModel("groupService")>
  	        <cfset bTeams = groups.getCommittees(true)>
  	        <cfloop query="bTeams">
  	          <cfif IsUserInAnyRole("egroup_admin,egroup_edit,egroup_#name#")>
  	            <option #vml(valueList(rc.poll.categoryID),id)# value="#id#">#name#</option>
  	          </cfif>
  	        </cfloop>
  	      </select>
        </div>
      </div>
		</fieldset>
    #renderView(view="security/permissions",args={permissions=rc.permissions},module="eunify")#
    <div class="form-actions">
        <input id="submit" name="submit" class="btn btn-success" type="submit" value="#IIF(rc.poll.id eq "", "'Create'","'Save'")# &raquo;" />
    </div>
    </cfoutput>
	</form>
</div>
