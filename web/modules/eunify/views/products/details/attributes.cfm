<div class="pforms">
  <cfoutput>
  <div class="row-fluid">
    <label for="CategoryID" class="span3">CategoryID</label>
    <div class="span9">
      <input size="30" type="text" name="CategoryID" id="CategoryID" value="#rc.product.CategoryID#" />
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Supplier_Code" class="span3">Supplier Code</label>
    <div class="span9">
      <input class="input-large" type="text" name="Supplier_Code" id="Supplier_Code" value="#rc.product.Supplier_Code#" />
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Weight" class="span3">Weight</label>
    <div class="span9">
      <div class="input-append">
        <input class="input-mini" type="text" size="5" id="Weight" name="Weight" value="#rc.product.Weight#" />
        <span class="add-on">Kg.</span>
      </div>
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Manufacturers_Product_Code" class="span3">Manufacturers Product Code</label>
    <div class="span9">
      <input class="input" type="text" id="Manufacturers_Product_Code" name="Manufacturers_Product_Code" value="#rc.product.Manufacturers_Product_Code#" />
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="EANCode" class="span3">EAN Code</label>
    <div class="span9">
      <input class="input" type="text" size="5" id="EANCode" name="EANCode" value="#rc.product.EANCode#" />
    </div>
  </div>
  </cfoutput>
</div>