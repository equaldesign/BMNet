<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form")>
<cfoutput>
<h2>Import Stockists</h2>
<div class="form">
  <form enctype="multipart/form-data" action="/bv/stockist/doImport" method="post">
    <input type="hidden" name="fileName" value="#rc.fileName#">
    <input type="hidden" name="siteID" value="#rc.siteID#">
    <fieldset>
      <legend>Field Mappings</legend>
      <cfloop query="rc.mappings">
      <div>
        <label class="o" for="#fieldName#">#fieldName#</label>
        <select id="#fieldName#" name="#fieldName#">
          <option value=""> -- ignore --</option>
          <cfloop list="#rc.ss.columnList#" index="col">
            <option #vm(col,mapsTo,'selected=selected')# value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      </cfloop>
    </fieldset>
    <input type="submit" value="Import &raquo;" class="button">
  </form>
</div>
</cfoutput>
