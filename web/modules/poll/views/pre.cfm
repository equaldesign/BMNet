<cfoutput><form class="form form-horizontal" action="/admin/cdcq/id/#rc.id#" method="post">
  <fieldset>
    <legend>Create new Deal Commitment Questionnare (DCQ)</legend>
    <div class="control-group">
      <label class="control-label">Name</label>
      <div class="controls">
        <input name="name" type="text" /><span class="help-inline">The name for this DCQ</span>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label">Product Range</label>
      <div class="controls">
        <textarea name="description" rows="8">Product Range: Edit / Enter product range here.

Notes: Edit to add any useful notes here.</textarea>

      </div>
    </div>
    <div class="control-group">
      <label for="organiserID" class="control-label">Negotiator</label>
      <cfset memberContacts = getModel("contact").getCompanyTypeContacts("1,3")>
      <cfset orgID = rc.sess.eGroup.contactID>
      <div class="controls">
        <select name="organiserID" id="organiserID">
          <cfloop query="memberContacts">
          <option value="#id#" #vm(orgID,"#id#","select")#>#first_name# #surname# (#name#)</option>
          </cfloop>
        </select>
        <span class="help-inline">Negotiator and/or lead negotiator</span>
      </div>
    </div>
    <div class="control-group">
      <label for="CoOrdinatorID" class="control-label">Primary Contact</label>
      <cfset memberContacts = getModel("contact").getCompanyTypeContacts("1,3")>
      <cfset CoOrdinatorID = rc.sess.eGroup.contactID>
      <div class="controls">
        <select name="CoOrdinatorID" id="CoOrdinatorID">
          <cfloop query="memberContacts">
          <option value="#id#" #vm(CoOrdinatorID,"#id#","select")#>#first_name# #surname# (#name#)</option>
          </cfloop>
        </select>
        <span class="help-inline">Primary contact and/or administrator.</span>
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
              <option value="#id#">#name#</option>
            </cfif>
          </cfloop>
        </select>
      </div>
    </div>
  </fieldset>
  <div class="alert alert-info">
    <a href="##" class="close" data-dismiss="alert">&times;</a>
    <h3 class="alert-heading">Notice</h3>
    <p>If you require any non-standard questions to be included in this DCQ, please contact the administration team for further assistance, and <span class="label label-important">DO NOT CREATE THE DCQ AT THIS TIME</span> </p>
  </div>
  <div class="alert">
    <a href="##" class="close" data-dismiss="alert">&times;</a>
    <h3 class="alert-heading">Upload DCQ documents</h3>
    <p>If you need to upload documents relating to this DCQ, you can do this once you've created the DCQ from within the Documents tab</p>
  </div>
  <div class="form-actions">
    <input type="submit" class="btn btn-success" value="Create new DCQ" />
  </div>
</form>
</cfoutput>