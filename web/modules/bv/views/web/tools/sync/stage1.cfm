<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form,secure/tools")>
<h1>Merchant Product Syncronisation</h1>
<div class="glow greyStraight">
  <ul id="syncStatus">
    <li class="done">Upload your product file</li>
    <li>Map fields</li>
    <li>Sync options</li>
    <li>Search Fields</li>
  </ul>
</div>
<h2>Stage 1 - upload your product file</h2>
<div class="Aristo ui-widget">
  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-highlight ui-corner-all">
    <p>To get started, export your entire product file from your system (BisTrack, Kerridge etc. etc.) and save it somewhere on your computer/server (where you can find it easily!)</p>
    <p>Your data needs to be in Excel format - so if your system exported your data as a CSV or text file, import it into Excel first, and then save your data as an .xls file</p>
    <p>Once you've got the data in excel and have saved it, click "Choose File" and select the excel file from your computer.</p>
  </div>
</div>
<div class="form-signUp">
  <form enctype="multipart/form-data" action="/tools/syncStage2" method="post">
    <fieldset>
      <cfoutput>
        <input type="hidden" name="siteID" value="#rc.siteID#" />
      <legend>Upload Information</legend>
      <div>
        <label class="o" for="file">Choose File</label>
        <input type="file" name="file" id="file" />
      </div>
      <div class="buttonrow">
        <input type="submit" value="Upload Product File &raquo;" class="doIt">
      </div>
      </legend>
      </cfoutput>
    </fieldset>
  </form>
</div>
