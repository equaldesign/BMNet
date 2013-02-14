<cfoutput>
<input type="hidden" name="figuresEntryID" value="0" />
    <legend>New input stream</legend>    
    <div>
      <label class="o" for="name">Turnover name<em>*</em></label>
      <input size="30" type="text" id="name" name="name" value="" />
    </div>  
    <div>
      <label class="o" for="inputTypeID">Input Type<em>*</em></label>
      <select name="inputTypeID">
        <cfloop query="rc.ut">
        <option value="#id#">#display#</option>
        </cfloop>
      </select>
    </div>  
    <div>
      <label class="o" for="description">Description</label>
      <textarea id="description" name="description"></textarea>
    </div>    
    <div class="controlset">
      <div>
        <input class="doIt" type="submit" value="Add new input stream &raquo;" />
      </div>
    </div>
</cfoutput>  