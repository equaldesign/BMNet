<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form,secure/tools")>
<h1>Merchant Product Syncronisation</h1>
<div class="glow greyStraight">
  <ul id="syncStatus">
    <li class="done">Upload your product file</li>
    <li class="done">Map fields</li>
    <li class="done">Sync options</li>
    <li class="done">Search Fields</li>
  </ul>
</div>
<h2>Stage 4 - Search options</h2>
<div class="Aristo ui-widget">
  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-highlight ui-corner-all">
    <p>You now need to chooose which fields to use to find products. Building Vine can find products based on </p>
    <p>You can also choose how it picks from the (possible) multiple prices it finds for each product. For example, there may be a trade price, and a price alloted to you as a member of a buying group. You can choose to either update your data with the lowest cost Building Vine has on record, or duplicate your data. The other alternative is to create a seperate worksheet for each set of prices. You can then choose which worksheet to import back into your ERM system.</p>
  </div>
</div>

<div class="form-signUp">
  <form enctype="multipart/form-data" action="/tools/doSync" method="post">
    <fieldset>
      <cfoutput>
      <legend>Search Fields</legend>
			<div class="Aristo ui-widget">
			  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-highlight ui-corner-all">
			    <p>If your data includes the Building Vine Supplier ID, choose this in the following field.</p>
			    <p>This will eliminate the possibility of false positives when searching for matches for your products.</p>
			  </div>
			</div>
      <div>
        <label class="o" for="BVsiteID">Building Vine Supplier ID</label>
        <select id="BVsiteID" name="BVsiteID">
          <option value=""> -- ignore --</option>
          <cfloop list="#rc.buildingVine.syncOptions.columns#" index="c">
            <option value="#c#">#c#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label class="o" for="search_eancode">EAN Code</label>
        <select id="search_eancode" name="search_eancode">
          <option value=""> -- ignore --</option>
          <cfloop list="#rc.buildingVine.syncOptions.columns#" index="c">
            <option value="#c#">#c#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label class="o" for="search_supplierproductcode">Supplier Code</label>
        <select id="search_supplierproductcode" name="search_supplierproductcode">
          <option value=""> -- ignore --</option>
          <cfloop list="#rc.buildingVine.syncOptions.columns#" index="c">
            <option value="#c#">#c#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label class="o" for="search_manufacturerproductcode">Manufacturer Code</label>
        <select id="search_manufacturerproductcode" name="search_manufacturerproductcode">
          <option value=""> -- ignore --</option>
          <cfloop list="#rc.buildingVine.syncOptions.columns#" index="c">
            <option value="#c#">#c#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label class="o" for="search_description">Product Description</label>
        <select id="search_description" name="search_description">
          <option value=""> -- ignore --</option>
          <cfloop list="#rc.buildingVine.syncOptions.columns#" index="c">
            <option value="#c#">#c#</option>
          </cfloop>
        </select>
      </div>
    </fieldset>
    <fieldset>
      <div class="buttonrow">
        <input type="submit" value="Confirm Search Options and run Sync! &raquo;" class="doIt">
      </div>
      </cfoutput>
  </form>
</div>
