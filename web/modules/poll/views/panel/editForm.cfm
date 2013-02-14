<cfset getMyPlugin(plugin="jQuery").getDepends("","formbuilder/edit","formbuilder")>
<cfoutput>
<h2>Registration form for #rc.formData.name# (<a href="/poll/poll/submit/id/#rc.formData.id#" target="_blank">view &raquo;</a>)</h2>
</cfoutput>
<form class="form form-horizontal">
  <!--- get the registration groups --->
  <cfset metaData = rc.poll.getPollGroups(rc.id)>
  <cfoutput query="metaData">
    <div rel="pollGroup" id="pollGroup_#metaData.id#" class="draggable widget">
      <div class="widget-header">
        <a name="Delete This Group" title="Delete This Group" href="/poll/formbuilder/delete/id/#id#/type/pollGroup" class="deleteE"><i class="icon-cross-circle-frame"></i></a>
        <a class="collpase" href="##"><i class="icon-application-sidebar-collapse"></i></a>
        <a class="handle" href="##"><i class="icon-arrow-move"></i></a>
        <h3>#metaData.name#</h3>
      </div>
      <div class="widget-content">
        <!--- group edit options --->
        <div class="control-group">
          <label class="control-label" for="pollGroup_name_#metaData.ID#">Name</label>
          <div class="controls">
            <input class="instantUpdate" type="text" id="pollGroup_name_#metaData.ID#" value="#metaData.name#" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="pollGroup_description_#metaData.ID#">Description</label>
          <div class="controls">
            <textarea class="instantUpdate" id="pollGroup_description_#metaData.ID#">#metaData.description#</textarea>
          </div>
        </div>

        <cfset fields = rc.poll.getPollFields(metaData.id)>
        <cfloop query="fields">
          <div rel="pollField" id="pollField_#fields.id#" class="draggable widget">
            <div class="widget-header">
            <a name="Delete This Field" title="Delete This Field" href="/poll/formbuilder/delete/id/#id#/type/pollField" class="deleteE"><i class="icon-cross-circle-frame"></i></a>
            <a class="collpase" href="##"><i class="icon-application-sidebar-collapse"></i></a>
            <a class="handle" href="##"><i class="icon-arrow-move"></i></a>
            <h3>#fields.label#</h3>
            </div>
            <div class="widget-content">
              <div class="control-group">
                <!--- field name --->
                <label class="control-label">Field Name (display)</label>
                <div class="controls">
                  <input class="instantUpdate" type="text" id="pollField_label class="control-label"_#fields.ID#" value="#fields.label#" />
                </div>
              </div>
              <div class="control-group">
                <label class="control-label">Field name</label>
                <div class="controls">
                  <input class="instantUpdate" type="text" id="pollField_name_#fields.ID#" value="#fields.name#" />
                </div>
              </div>
              <div class="control-group">
                <label class="control-label">Required?</label>
                <div class="controls">
                  <input class="instantUpdate" #vm(_required,"true","checkbox")# type="checkbox" id="pollField_required_#fields.ID#" value="true" />
                </div>
              </div>
              <div class="control-group">
                <label class="control-label">Encrypt?</label>
                <div class="controls">
                  <input class="instantUpdate" #vm(encrypt,"true","checkbox")# type="checkbox" id="pollField_encrypt_#fields.ID#" value="true" />
                </div>
              </div>
              <div class="control-group">
                <label class="control-label">Require Numeric?</label>
                <div class="controls">
                  <input class="instantUpdate" #vm(requirenumeric,"true","checkbox")# type="checkbox" id="pollField_requirenumeric_#fields.ID#" value="true" />
                </div>
              </div>
              <div class="control-group">
                <label class="control-label">Field Type</label>
                <div class="controls">
                  <select class="fieldTypeSelection" id="pollField_type_#fields.id#">
                    <option #vm(_type,"text")# value="text">Input Text</option>
                    <option #vm(_type,"textarea")# value="textarea">Text Area</option>
                    <option #vm(_type,"radio")# value="radio">Selection group</option>
                    <option #vm(_type,"checkbox")# value="checkbox">Checkbox</option>
                    <option #vm(_type,"stepper")# value="stepper">Stepper</option>
                  </select>
                </div>
              </div>
              <cfif _type eq "radio">
                <cfset fieldOptions = rc.poll.getPollFieldOptions(fields.id)>
                <cfloop query="fieldOptions">
                <div class="draggable" id="pollFieldOption_#fieldOptions.id#" rel="pollFieldOption">
                  <a name="Delete This Field" title="Delete this option" href="/poll/formbuilder/delete/id/#id#/type/pollFieldOption" class="deleteE"><i class="icon-cross-circle-frame"></i></a>
                  <a class="handle" href="##"><i class="icon-arrow-move"></i></a>
                  <div class="control-group">
                    <label class="control-label">Field Option</label>
                    <div class="controls">
                      <input class="instantUpdate" type="text" id="pollFieldOption_label_#fieldOptions.ID#" value="#fieldOptions.label#" />
                    </div>
                  </div>
                </div>
                </cfloop>
                <div class="box" id="#fieldOptions.id#" rel="option">
                  <h4>Add option</h4>
                  <div class="control-group">
                    <label class="control-label">Field Option</label>
                    <div class="controls">
                      <input class="instantAdd" type="text" id="pollFieldOption_pollfieldID_#fields.ID#" value="" />
                    </div>
                  </div>
                </div>
              <cfelseif _type eq "text">
              <div class="control-group">
                <label class="control-label">Input Length</label>
                <div class="controls">
                  <input class="instantUpdate" type="text" id="pollField_length_#fields.ID#" value="#fields._length#" />
                </div>
              </div>
              <cfelseif _type eq "stepper">
              <div class="control-group">
                <label class="control-label">Increments</label>
                <div class="controls">
                  <input class="instantUpdate" type="text" id="pollField_increments_#fields.ID#" value="#fields._increments#" />
                </div>
              </div>
              <div class="control-group">
                <label class="control-label">Max</label>
                <div class="controls">
                  <input class="instantUpdate" type="text" id="pollField_max_#fields.ID#" value="#fields._max#" />
                </div>
              </div>
              </cfif>
            </div>
          </div>
        </cfloop>
        <div class="box">
          <h3>Add Field to Group</h3>
          <div class="control-group">
            <!--- field name --->
            <label class="control-label">Field Name (display)</label>
            <div class="controls">
              <input class="newField" type="text" id="new_pollField_label_#metaData.ID#_pollGroupID" value="" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Field name</label>
            <div class="controls">
              <input class="newField" type="text" id="new_pollField_name_#metaData.ID#_pollGroupID" value="" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Required?</label>
            <div class="controls">
              <input class="newField" type="checkbox" id="new_pollField_required_#metaData.ID#_pollGroupID" value="true" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Encrypt?</label>
            <div class="controls">
              <input class="newField" type="checkbox" id="new_pollField_encrypt_#metaData.ID#_pollGroupID" value="true" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Require Numeric?</label>
            <div class="controls">
              <input class="newField" type="checkbox" id="new_pollField_requirenumeric_#metaData.ID#_pollGroupID" value="true" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">Field Type</label>
            <div class="controls">
              <select class="newField" id="new_pollField_type_#metaData.id#_pollGroupID">
                <option value="text">Input Text</option>
                <option value="textarea">Text Area</option>
                <option value="radio">Selection group</option>
                <option value="checkbox">Checkbox</option>
                <option value="stepper">Stepper</option>
              </select>
            </div>
          </div>
          <div class="form-actions">
            <input type="button" value="Add Field" class="btn addField" />
          </div>
        </div>
      </div>
    </div>
  </cfoutput>
  <div class="box">
  <cfoutput>
    <h3>Add new Group</h3>
    <div class="control-group">
      <label class="control-label" for="new_pollGroup_name_pollID_#rc.id#">Name</label>
      <div class="controls">
        <input class="newField" type="text" id="new_pollGroup_name_pollID_#rc.id#" value="Group Name" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="pollGroup_description">Description</label>
      <div class="controls">
        <textarea class="newField" id="new_pollGroup_description_pollID_#rc.id#">Description</textarea>
      </div>
    </div>
    <div class="form-actions">
      <input type="button" value="Add Group" class="btn addGroup" />
    </div>
  </cfoutput>
  </div>
</form>
