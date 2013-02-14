<cfset getMyPlugin(plugin="jQuery").getDepends("","formbuilder/edit","formbuilder",false,"poll")>
<cfoutput>
<h2>Registration form for #rc.appointment.name# (<a href="/eunify/calendar/register/id/#rc.appointment.id#" target="_blank">view &raquo;</a>)</h2>
</cfoutput>
<div>
  <!--- get the registration groups --->
  <cfset metaData = rc.calendar.getEventGroups(rc.id)>
  <cfoutput query="metaData">
    <div rel="eventRegGroup" id="eventRegGroup_#metaData.id#" class="box draggable">
      <a class="collpase" href="##"></a>
      <a class="handle" href="##"></a>
      <a name="Delete This Group" title="Delete This Group" href="/poll/formbuilder/delete/id/#id#/type/eventRegGroup" class="tooltip deleteIcon"></a>
      <h5>#metaData.name#</h5>
      <!--- group edit options --->
      <div class="f">
        <label for="eventRegGroup_name_#metaData.ID#">Name</label>
        <input class="instantUpdate" type="text" id="eventRegGroup_name_#metaData.ID#" value="#metaData.name#" />
      </div>
      <div class="f">
        <label for="eventRegGroup_description_#metaData.ID#">Description</label>
        <textarea class="instantUpdate" id="eventRegGroup_description_#metaData.ID#">#metaData.description#</textarea>
      </div>

      <cfset fields = rc.calendar.getEventFields(metaData.id)>
      <cfloop query="fields">
        <div rel="eventRegField" id="eventRegField_#fields.id#" class="draggable box">
          <a class="collpase" href="##"></a>
          <a class="handle" href="##"></a>
          <a name="Delete This Field" title="Delete This Field" href="/poll/formbuilder/delete/id/#id#/type/eventRegField" class="tooltip deleteIcon"></a>
          <h5>#fields.label#</h5>
          <div class="f">
            <!--- field name --->
            <label>Field Name (display)</label>
            <input class="instantUpdate" type="text" id="eventRegField_label_#fields.ID#" value="#fields.label#" />
          </div>
          <div class="f">
            <label>Field name</label>
            <input class="instantUpdate" type="text" id="eventRegField_name_#fields.ID#" value="#fields.name#" />
          </div>
          <div class="f">
            <label>Required?</label>
            <input class="instantUpdate" #vm(_required,"true","checkbox")# type="checkbox" id="eventRegField_required_#fields.ID#" value="true" />
          </div>
          <div class="f">
            <label>Encrypt?</label>
            <input class="instantUpdate" #vm(encrypt,"true","checkbox")# type="checkbox" id="eventRegField_encrypt_#fields.ID#" value="true" />
          </div>
          <div class="f">
            <label>Field Type</label>
            <select class="fieldTypeSelection" id="eventRegField_type_#fields.id#">
              <option #vm(_type,"text")# value="text">Input Text</option>
              <option #vm(_type,"textarea")# value="textarea">Text Area</option>
              <option #vm(_type,"radio")# value="radio">Selection group</option>
              <option #vm(_type,"checkbox")# value="checkbox">Checkbox</option>
            </select>
          </div>
          <cfif _type eq "radio">
            <cfset fieldOptions = rc.calendar.getEventFieldOptions(fields.id)>
            <cfloop query="fieldOptions">
            <div class="box draggable" id="eventRegFieldOption_#fieldOptions.id#" rel="eventRegFieldOption">
              <a class="handle" href="##"></a>
              <a name="Delete This Field" title="Delete this option" href="/poll/formbuilder/delete/id/#id#/type/eventRegFieldOption" class="tooltip deleteIcon"></a>
              <div class="f">
                <label>Field Option</label>
                <input class="instantUpdate" type="text" id="eventRegFieldOption_label_#fieldOptions.ID#" value="#fieldOptions.label#" />
              </div>
            </div>
            </cfloop>
            <div class="box" id="#fieldOptions.id#" rel="option">
              <h4>Add option</h4>
              <div class="f">
                <label>Field Option</label>
                <input class="instantAdd" type="text" id="eventRegFieldOption_erfID_#fields.ID#" value="" />
              </div>
            </div>
          <cfelseif _type eq "text">
          <div class="f">
            <label>Input Length</label>
            <input class="instantUpdate" type="text" id="eventRegField_length_#fields.ID#" value="#fields._length#" />
          </div>
          </cfif>
         </div>
      </cfloop>
      <div class="box">
        <h3>Add Field to Group</h3>
        <div class="f">
          <!--- field name --->
          <label>Field Name (display)</label>
          <input class="newField" type="text" id="new_eventRegField_label_#metaData.ID#_ergID" value="" />
        </div>
        <div class="f">
          <label>Field name</label>
          <input class="newField" type="text" id="new_eventRegField_name_#metaData.ID#_ergID" value="" />
        </div>
        <div class="f">
          <label>Required?</label>
          <input class="newField" type="checkbox" id="new_eventRegField_required_#metaData.ID#_ergID" value="true" />
        </div>
        <div class="f">
          <label>Encrypt?</label>
          <input class="newField" type="checkbox" id="new_eventRegField_encrypt_#metaData.ID#_ergID" value="true" />
        </div>
        <div class="f">
          <label>Field Type</label>
          <select class="newField" id="new_eventRegField_type_#metaData.id#_ergID">
            <option value="text">Input Text</option>
            <option value="textarea">Text Area</option>
            <option value="radio">Selection group</option>
            <option value="checkbox">Checkbox</option>
          </select>
        </div>
        <div class="f">
          <input type="button" value="Add Field" class="addField" />
        </div>
      </div>
    </div>
  </cfoutput>
  <div class="box">
  <cfoutput>
    <h3>Add new Group</h3>
    <div class="f">
      <label for="new_eventRegGroup_name_eventID_#rc.id#">Name</label>
      <input class="newField" type="text" id="new_eventRegGroup_name_eventID_#rc.id#" value="Group Name" />
    </div>
    <div class="f">
      <label for="eventRegGroup_description">Description</label>
      <textarea class="newField" id="new_eventRegGroup_description_eventID_#rc.id#">Description</textarea>
    </div>
    <div class="f">
      <input type="button" value="Add Group" class="addGroup" />
    </div>
  </cfoutput>
  </div>
</div>
