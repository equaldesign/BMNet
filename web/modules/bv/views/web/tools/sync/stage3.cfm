<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form,secure/tools")>
<h1>Merchant Product Syncronisation</h1>
<div class="glow greyStraight">
  <ul id="syncStatus">
    <li class="done">Upload your product file</li>
    <li class="done">Map fields</li>
    <li class="done">Sync options</li>
    <li>Search Fields</li>
  </ul>
</div>
<h2>Stage 3 - Sync options</h2>
<div class="Aristo ui-widget">
  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-highlight ui-corner-all">
    <p>Now enter the email address where Building Vine needs to send your updated spreadsheet to.</p>
    <p>You can also choose how it picks from the (possible) multiple prices it finds for each product. For example, there may be a trade price, and a price alloted to you as a member of a buying group. You can choose to either update your data with the lowest cost Building Vine has on record, or duplicate your data. The other alternative is to create a seperate worksheet for each set of prices. You can then choose which worksheet to import back into your ERM system.</p>
  </div>
</div>

<div class="form-signUp">
  <form enctype="multipart/form-data" action="/tools/syncStage4" method="post">
    <fieldset>
      <cfoutput>
      <legend>Options</legend>
      <div>
        <label class="o" for="save">Email file when done</label>
        <input type="text" name="emailaddress" id="emailaddress" value="#rc.buildingVine.username#" />
      </div>
    </fieldset>
    <fieldset>
      <legend>Price options</legend>
      <div>
        <label class="o" for="pricemethod">Choose lowest price</label>
        <input type="radio" checked="checked" name="pricemethod" value="lowest">
      </div>
      <div>
        <label class="o" for="pricemethod">Create seperate worksheet</label>
        <input type="radio" name="pricemethod" value="worksheet">
      </div>
      <div>
        <label class="o" for="pricemethod">Create duplicates</label>
        <input type="radio" name="pricemethod" value="duplicates">
      </div>
    </fieldset>
    <fieldset>
      <div class="buttonrow">
        <input type="submit" value="Confirm Sync Options &raquo;" class="doIt">
      </div>
      </cfoutput>
  </form>
</div>
