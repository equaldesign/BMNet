<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form")>
<cfoutput>
<h2>Import Stockists</h2>
<div class="Aristo ui-widget">
  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-highlight ui-corner-all">
      <p>You can import your stockists from an excel spreadsheet. Your spreadsheet can contain any columns you want, but be sure that the first row containers header items</p>
    </p>
  </div>
</div>
<div class="form">
  <form enctype="multipart/form-data" action="/bv/stockist/importUpload" method="post">
    <input type="hidden" name="siteID" value="#rc.siteID#">
    <fieldset>
      <legend>Upload Information</legend>
      <div>
        <label class="o" for="file">Spreadsheet</label>
        <input type="file" name="file" id="file" />
      </div>
    </fieldset>
    <input type="submit" value="Import &raquo;" class="button">
  </form>
</div>
</cfoutput>