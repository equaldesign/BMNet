<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form")>
<h2>Upload price file</h2>
<div class="Aristo ui-widget">
  <div style="padding: 0pt 0.7em; margin-top: 20px;" class="Aristo ui-state-highlight ui-corner-all">
      <p>To upload a price file, you need to choose your Supplier and Destination sites.
        The Source site is the supplier for the prices you are uploading,
        and the Destination is for the site users who should have access to the prices.</p>
      <p>Currently, you have to be an administrator of the Destination site to add prices.</p>
    </p>
  </div>
</div>
<div class="form">
  <cfoutput><form enctype="multipart/form-data" action="/bv/products/importPrices2/siteID/#rc.siteID#" method="post"></cfoutput>
    <fieldset>
      <cfoutput>
      <legend>Upload Information</legend>
      <div>
        <label class="o" for="name">Name</label>
        <input type="text" id="name" name="name" />
      </div>
      <div>
        <label class="o" for="security_group">Security</label>
        <div class="t" style="margin-left: 170px;">
        <cfloop array="#rc.sitemembers#" index="member">
          <div class="trow">
            <div class="tcell"><input type="checkbox" name="security_group" value="#member.authority.fullName#" /></div>
            <div class="tcell"><cfif member.authority.authorityType eq "USER"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/user.png"><cfelse><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/users.png"></cfif></div>
            <div class="tcell">
              <cfif member.authority.authorityType eq "USER">
                #member.authority.firstName# #member.authority.lastName#
                <cfif member.authority.organization neq "">(#member.authority.organization#)</cfif>
              <cfelse>
                #member.authority.displayName#
              </cfif>
            </div>
          </div>
        </cfloop>
        </div>
      </div>
      <div>
        <label class="o" for="columnRow">Column Headers Row</label>
        <select name="columnRow" id="columnRow">
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="3">3</option>
          <option value="4">4</option>
          <option value="5">5</option>
          <option value="6">6</option>
          <option value="7">7</option>
          <option value="8">8</option>
          <option value="9">9</option>
          <option value="10">10</option>
        </select>
      </div>
      <div>
        <label class="o" for="sheetNumber">Sheet Number</label>
        <select name="sheetNumber" id="sheetNumber">
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="3">3</option>
          <option value="4">4</option>
          <option value="5">5</option>
          <option value="6">6</option>
          <option value="7">7</option>
          <option value="8">8</option>
          <option value="9">9</option>
          <option value="10">10</option>
        </select>
      </div>
      <div>
        <label class="o" for="file">Choose File</label>
        <input type="file" name="file" id="file" />
      </div>
      </cfoutput>
    </fieldset>
    <input type="submit" value="Import Prices &raquo;" class="button">
  </form>
</div>
