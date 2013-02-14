<cfoutput>#getMyPLugin("jQuery").getDepends("tipsy,validate,form","dms/editInfo")#</cfoutput>
<cfoutput>
<h2>Information for #rc.category.name#</h2>
<div class="form-signUp">
  <form class="form" enctype="multipart/form-data" id="editDocument" method="post" action="#bl('documents.doEdit')#">
    <input type="hidden" name="type" value="category" />
    <input type="hidden" name="id" value="#rc.id#" />
  <fieldset>
    <legend> Folder Information</legend>
    <div>
      <label for="name" class="o">Name <em>*</em></label>
      <input size="30" type="text" name="name" id="name" value="#rc.category.name#" />
    </div>
    <div>
      <label for="description" class="o">Description</label>
      <textarea name="description" id="description">#rc.category.description#</textarea>
    </div>
  </fieldset>
  <fieldset>
    <legend> Relationship Information</legend>
    <div>
      <label for="parentID" class="o">Parent ID</label>
      <input size="30" type="text" name="parentID" id="parentID" value="#rc.category.parentID#" />
    </div>
    <div>
      <label for="relatedType" class="o">Related to <em>*</em></label>
      <select id="relatedType" name="relatedType" multiple="true">
        <option #vm(rc.category.relatedType,"none")# value="none"> none </option>
        <option #vm(rc.category.relatedType,"deal")# value="deal">Agreement</option>
        <option #vm(rc.category.relatedType,"company")# value="company">Company</option>
        <option #vm(rc.category.relatedType,"appointment")# value="appointment">Appointment</option>
        <option #vm(rc.category.relatedType,"contact")# value="contact">Contact</option>
      </select>
    </div>
    <div>
      <label for="relatedID" class="o">Related ID</label>
      <input size="30" type="text" name="relatedID" id="relatedID" value="#rc.category.relatedID#" />
    </div>
  </fieldset>
  <fieldset>
    <legend>Time Sensitive</legend>
    <div>
      <label for="timesensitive" class="o">Time Sensitive?</label>
      <input type="checkbox" name="timesensitive" id="timesensitive" #vm("true",rc.category.timesensitive,"checkbox")# value="true" />
    </div>
    <div>
      <label for="validFrom" class="o">From </label>
      <input type="text" name="validFrom" id="validFrom" class="dateP" value="#DateFormat(rc.category.validFrom,"DD/MM/YYYY")#" />
    </div>
    <div>
      <label for="validTo" class="o">To </label>
      <input type="text" name="validTo" id="validTo" class="dateP" value="#DateFormat(rc.category.validTo,"DD/MM/YYYY")#" />
    </div>
  </fieldset>
  <fieldset>
    <legend>Security</legend>
    <div>
      <label for="validFrom" class="o">From </label>
      <select id="permissions" name="permissions" multiple="true">
          <option #IIf(rc.permissions.recordCount eq 0,"'selected'","''")# value="0">--all--</option>
          <cfset securityGroups = getSetting("securityGroups")>
          <cfloop array="#securityGroups.group#" index="g">
              <option #vml(ValueList(rc.permissions.groupID),g.id)# value="#g.id#">#g.name#</option>
          </cfloop>
          <cfset gL = getModel("groups").fullGroupList(rc.sess.eGroup.companyID,getSetting("securityGroupIDs"))>
          <cfloop query="gL">
            <option #vml(ValueList(rc.permissions.groupID),id)# value="#id#"> #name# </option>
          </cfloop>
        </select>
    </div>
  </fieldset>
  <div class="rightControlSet">
      <div>
      <input class="doIt" type="submit" value="edit category &raquo;" />
      </div>
    </div>
  </form>
</div>
</cfoutput>