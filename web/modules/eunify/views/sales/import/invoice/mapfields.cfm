<cfoutput>
  <legend>Spreadsheet field mappings</legend>
  <br />
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>
    Select the columns in your spreadsheet that match our pre-defined columns.
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Invoice Number<em>*</em></label>
    <div class="controls">
      <select name="invoice.line.invoice_num" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("invoice_num","invoice.line").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Your Invoice Number.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Product Code<em>*</em></label>
    <div class="controls">
      <select name="invoice.line.product_code" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("product_code","invoice.line").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Item Product Code.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Product Name</label>
    <div class="controls">
      <select name="invoice.line.full_description" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("full_descriptiont_code","invoice.line").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Item Product Name.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Quantity<em>*</em></label>
    <div class="controls">
      <select name="invoice.line.quantity" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("quantity","invoice.line").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Item Quantity.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Item Cost<em>*</em></label>
    <div class="controls">
      <select name="invoice.line.goods_total" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("goods_total","invoice.line").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Item Cost.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Vat Cost<em>*</em></label>
    <div class="controls">
      <select name="invoice.line.vat_total" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("vat_total","invoice.line").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> VAT Cost.</p>
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Header Information</legend>
  <div class="control-group">
    <label class="control-label" for="EANCode">Branch ID<em>*</em></label>
    <div class="controls">
      <select name="invoice.header.branch_id" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("branch_id","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Your Branch ID.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Account Number<em>*</em></label>
    <div class="controls">
      <select name="invoice.header.account_number" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("account_number","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Customer Account Number.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Order Number<em>*</em></label>
    <div class="controls">
      <select name="invoice.header.order_number" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("order_number","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Customer Order Number.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Invoice Date<em>*</em></label>
    <div class="controls">
      <select name="invoice.header.invoice_date" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("invoice_date","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Invoice Date.</p>
    </div>
  </div>
</fieldset>
<fieldset>
  <legend>Delivery Information</legend>
  <div class="control-group">
    <label class="control-label" for="EANCode">Customer Name</label>
    <div class="controls">
      <select name="invoice.header.account_name" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("account_name","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Delivery Name</label>
    <div class="controls">
      <select name="invoice.header.delivery_name" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_name","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Delivery Address 1</label>
    <div class="controls">
      <select name="invoice.header.delivery_address_1" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_address_1","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Delivery Address 2</label>
    <div class="controls">
      <select name="invoice.header.delivery_address_2" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_address_2","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Delivery Address 3</label>
    <div class="controls">
      <select name="invoice.header.delivery_address_3" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_address_3","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Delivery Address 4</label>
    <div class="controls">
      <select name="invoice.header.delivery_address_4" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_address_4","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Delivery Address 5</label>
    <div class="controls">
      <select name="invoice.header.delivery_address_5" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_address_5","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Delivery PostCode</label>
    <div class="controls">
      <select name="invoice.header.delivery_postcode" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("delivery_postcode","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">Customer Order Number</label>
    <div class="controls">
      <select name="invoice.header.customer_order_number" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("customer_order_number","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">SalesMan</label>
    <div class="controls">
      <select name="invoice.header.salesman" id="p_Product_Code">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("salesman","invoice.header").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
    </div>
  </div>
<div class="form-actions">
  <button type="submit" class="btn btn-primary">Import Spreadsheet</button>
</div>
<input type="hidden" name="fileName" value="#rc.file#" />
</cfoutput>