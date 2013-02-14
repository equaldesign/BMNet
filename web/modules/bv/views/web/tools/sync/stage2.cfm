<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form,secure/tools")>
<h1>Merchant Product Syncronisation</h1>
<div class="glow greyStraight">
  <ul id="syncStatus">
    <li class="done">Upload your product file</li>
    <li class="done">Map fields</li>
    <li>Sync options</li>
    <li>Search Fields</li>
  </ul>
</div>
<h2>Stage 2 - map your fields</h2>
<div class="Aristo ui-widget">
  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-highlight ui-corner-all">
    <p>Now choose the fields you want to update</p>
    <p>The fields have been extracted from the spreadsheet you uploaded. Pick the field that corresponds to the field Building Vine has in it's repository</p>
    <p>You can pick as few or as many fields as you wish.</p>
  </div>
</div>

<div class="form-signUp">
  <form enctype="multipart/form-data" action="/tools/syncStage3" method="post">
    <fieldset>
      <cfoutput>
      <legend>Field Mappings</legend>
      <cfloop query="rc.productFields">
      <div>
        <label class="o" for="#fieldName#">#fieldDescription#</label>
        <select id="#fieldName#" name="#fieldName#">
          <option value=""> -- ignore --</option>
          <cfloop list="#rc.columns#" index="c">
            <option value="#c#">#c#</option>
          </cfloop>
        </select>
      </div>
      </cfloop>
      </fieldset>
      <div class="buttonrow">
        <input type="submit" value="Confirm field Mappings &raquo;" class="doIt">
      </div>
      </legend>
      </cfoutput>
    </fieldset>
  </form>
</div>
