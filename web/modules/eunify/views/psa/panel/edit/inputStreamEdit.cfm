<cfoutput>
<input type="hidden" name="figuresEntryID" value="#rc.inputStreamID#" />
    <legend>Edit #rc.inputStreams.inputName#</legend>
    <div>
      <label class="o" for="name">Turnover name<em>*</em></label>
      <input size="30" type="text" id="name" name="name" value="#rc.inputStreams.inputName#" />
    </div>
    <div>
      <label class="o" for="inputTypeID">Input Type<em>*</em></label>
      <select name="inputTypeID">
        <cfloop query="rc.ut">
        <option #vm(id,rc.inputStreams.inputTypeID)# value="#id#">#display#</option>
        </cfloop>
      </select>
    </div>
    <div>
      <label class="o" for="description">Description</label>
      <textarea id="description" name="description">#rc.inputStreams.description#</textarea>
    </div>
    <div class="controlset">
      <div>
        <input class="doIt" type="submit" value="Save input stream &raquo;" />
      </div>
    </div>
</cfoutput>