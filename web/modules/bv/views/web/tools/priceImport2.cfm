<cfset getMyPlugin(plugin="jQuery").getDepends("form","","secure/form")>
<h2>Upload price file Stage 2</h2>
<div class="form">
  <form enctype="multipart/form-data" action="/bv/products/doImportPrices" method="post">
    <fieldset>
      <cfoutput>
      <legend>Column Mappings Information</legend>
      <input type="hidden" name="siteID" value="#rc.siteID#" />
      <input type="hidden" name="security_group" value="#rc.security_group#" />
      <input type="hidden" name="columnRow" value="#rc.columnRow#" />
      <input type="hidden" name="sheetNumber" value="#rc.sheetNumber#" />
      <input type="hidden" name="name" value="#rc.name#" />
      <input type="hidden" name="file" value="#rc.file#" />
      <div>
        <label for="eanCode">EAN</label>
        <select name="eanCode" id="eanCode">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="supplierproductcode">Product Code</label>
        <select name="supplierproductcode" id="supplierproductcode">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="manufacturerproductcode">Manufacturer Product Code</label>
        <select name="manufacturerproductcode" id="manufacturerproductcode">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="priceeffectivefromdate">Price Effective From Date</label>
        <select name="priceeffectivefromdate" id="priceeffectivefromdate">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="priceeffectivetodate">Price Effective To Date</label>
        <select name="priceeffectivetodate" id="priceeffectivetodate">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="discountgroup">Discount Group</label>
        <select name="discountgroup" id="discountgroup">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="rebategroup">Rebate Group</label>
        <select name="rebategroup" id="rebategroup">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="supplierslistprice">Suppliers List Price</label>
        <select name="supplierslistprice" id="supplierslistprice">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="merchantinvoiceprice">Merchant Invoice Price</label>
        <select name="merchantinvoiceprice" id="merchantinvoiceprice">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="priceunitofmeasuredescription">Price UOM</label>
        <select name="priceunitofmeasuredescription" id="priceunitofmeasuredescription">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="priceunitofmeasurequantity">Price UOM Quantity</label>
        <select name="priceunitofmeasurequantity" id="priceunitofmeasurequantity">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="packquantity">Pack Quantity</label>
        <select name="packquantity" id="packquantity">
          <option value="">--no value--</option>
          <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
            <option value="#col#">#col#</option>
          </cfloop>
        </select>
      </div>
      </cfoutput>
    </fieldset>
    <input type="submit" value="Import Prices &raquo;" class="button">
  </form>
</div>
