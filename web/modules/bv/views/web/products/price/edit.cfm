<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/products/price/edit","")>
<cfoutput>
<form class="form-horizontal" id="editPrice" action="/alfresco/service/bv/prices?alf_ticket=#request.user_ticket#&nodeRef=#rc.nodeRef#" method="post">
  <fieldset>
    <legend>Core Information</legend>
    <div class="control-group">
      <label class="control-label" for="priceeffectivefromdate">Price Effective From</label>
      <div class="controls">
        <input class="date input-small" type="text" name="priceeffectivefromdate" id="priceeffectivefromdate" value="" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="priceeffectivetodate">Price Effective To</label>
      <div class="controls">
        <input class="date input-small" type="text" name="priceeffectivetodate" id="priceeffectivetodate" value="" />
      </div>
    </div>

    <div class="control-group">
      <label class="control-label" for="discountgroup">Discount Group</label>
      <div class="controls">
        <input type="text" name="discountgroup" id="discountgroup" value=""  />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="rebategroup">Rebate Group</label>
      <div class="controls">
        <input type="text" name="rebategroup" id="rebategroup" value="" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="supplierslistprice">List Price</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">&pound;</span>
          <input class="input-mini" size="4" type="text" name="supplierslistprice" id="supplierslistprice" value="" />
        </div>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="merchantinvoiceprice">Merchant Invoice Price</label>
      <div class="controls">
        <div class="input-prepend">
          <span class="add-on">&pound;</span>
          <input class="input-mini" size="6" type="text" name="merchantinvoiceprice" id="merchantinvoiceprice" value="" />
        </div>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="priceunitofmeasuredescription">Price UOM</label>
      <div class="controls">
        <select id="priceunitofmeasuredescription" name="priceunitofmeasuredescription" class="span2 valid">
          <option value="units">units</option>
          <option value="tonnes">tonnes</option>
          <option value="packs">packs</option>
          <option value="pallets">pallets</option>
          <option value="cubic metres">cubic metres</option>
          <option value="litres">litres</option>
          <option value="sqaure metres">square metres</option>
          <option value="bricks">bricks</option>
        </select>
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="priceunitofmeasurequantity">Price UOM Quantity</label>
      <div class="controls">
        <input size="4" class="input-mini" type="text" name="priceunitofmeasurequantity" id="priceunitofmeasurequantity" value="" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" class="control-label" for="packquantity">Pack UOM Quantity</label>
      <div class="controls">
        <input size="4" class="input-mini" type="text" name="packquantity" id="packquantity" value="" />
      </div>
    </div>
    <div class="control-group">
      <label class="control-label" for="vatcode">VAT Code</label>
      <div class="controls">
        <input size="4" class="input-mini" type="text" name="vatcode" id="vatcode" value="" />
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>Security <small>(who should see this price)</small></legend>
      <div class="control-group">
        <label class="control-label" for="priceunitofmeasurequantity">Security</label>
        <div class="controls">
          <cfloop array="#rc.sitemembers#" index="member">
            <label class="checkbox">
              <input type="checkbox" name="security_group" value="#member.authority.fullName#" />
              <cfif member.authority.authorityType eq "USER"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/user.png"><cfelse><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/users.png"></cfif>
              <cfif member.authority.authorityType eq "USER">
                #member.authority.firstName# #member.authority.lastName#
                <cfif member.authority.organization neq "">(#member.authority.organization#)</cfif>
              <cfelse>
                #member.authority.displayName#
              </cfif>
            </label>
          </cfloop>
        </div>
      </div>
  </fieldset>
</form>
</cfoutput>