<cfoutput>
   <cfif rc.product.product_code neq "">
   <div class="alert alert-error fade-in">
    <a class="close" data-dismiss="alert" href="##">&times;</a>
    <h3 class="alert-heading">Warning</h3>
    <p>If you automatically syncronise data between your back-office system and BuildersMerchant.net, changes within this tab panel may be overwritten each morning by the syncronisation routine</p>
   </div>
   </cfif>
    <fieldset>
      <legend>Category</legend>
      <div class="control-group">
        <label for="CategoryID" class="control-label">CategoryID</label>
        <div class="controls">
				  <input size="30" type="text" name="CategoryID" id="CategoryID" value="#rc.product.CategoryID#" />
				</div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Basic Information</legend>
      <div class="control-group">
        <label for="product_code" class="control-label">Product Code<em>*</em></label>
        <div class="controls">
          <input size="30" type="text" name="product_code" id="product_code" value="#rc.product.product_code#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Full_Description" class="control-label">Product Name<em>*</em></label>
        <div class="controls">
        	<input size="30" type="text" name="Full_Description" id="Full_Description" value="#rc.product.Full_Description#" />
				</div>
      </div>
      <div class="control-group">
        <label for="Description2" class="control-label">Description</label>
        <div class="controls">
          <textarea name="Description2">#rc.product.Description2#</textarea>
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Pricing</legend>
      <div class="control-group">
        <label for="List_Price" class="control-label">List Price</label>
        <div class="controls">
          <input class="input-small" type="text" name="List_Price" id="List_Price" value="#rc.product.List_Price#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Unit_of_Sale" class="control-label">Unit of Sale</label>
        <div class="controls">
          <input size="30" type="text" name="Unit_of_Sale" id="Unit_of_Sale" value="#rc.product.Unit_of_Sale#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Retail_Price" class="control-label">Retail Price</label>
        <div class="controls">
          <input class="input-small" type="text" name="Retail_Price" id="Retail_Price" value="#rc.product.Retail_Price#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Unit_of_Price" class="control-label">Unit of Price</label>
        <div class="controls">
          <input class="input-small" type="text" name="Unit_of_Price" id="Unit_of_Price" value="#rc.product.Unit_of_Price#" />
        </div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Trade Price</label>
        <div class="controls">
          <input class="input-small" type="text" name="Trade" id="Trade" value="#rc.product.Trade#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Cost_Price" class="control-label">Cost Price</label>
        <div class="controls">
          <input class="input-small" type="text" name="Cost_Price" id="Cost_Price" value="#rc.product.Cost_Price#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Unit_of_Buy" class="control-label">Unit of Buy</label>
        <div class="controls">
          <input class="input-small" type="text" name="Unit_of_Buy" id="Unit_of_Buy" value="#rc.product.Unit_of_Buy#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Unit_of_Cost" class="control-label">Unit of Cost</label>
        <div class="controls">
          <input class="input-small" type="text" name="Unit_of_Cost" id="Unit_of_Cost" value="#rc.product.Unit_of_Cost#" />
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Additional Information</legend>
      <div class="control-group">
        <label for="Supplier_Code" class="control-label">Supplier Code</label>
        <div class="controls">
          <input class="input-small" type="text" name="Supplier_Code" id="Supplier_Code" value="#rc.product.Supplier_Code#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Weight" class="control-label">Weight</label>
        <div class="controls">
          <input class="input-small" type="text" size="5" id="Weight" name="Weight" value="#rc.product.Weight#" />
        </div>
      </div>
      <div class="control-group">
        <label for="Manufacturers_Product_Code" class="control-label">Manufacturers Product Code</label>
        <div class="controls">
          <input class="input-small" type="text" size="5" id="Manufacturers_Product_Code" name="Manufacturers_Product_Code" value="#rc.product.Manufacturers_Product_Code#" />
        </div>
      </div>
      <div class="control-group">
        <label for="EANCode" class="control-label">EAN Code</label>
        <div class="controls">
          <input class="input-small" type="text" size="5" id="EANCode" name="EANCode" value="#rc.product.EANCode#" />
        </div>
      </div>
    </fieldset>
</cfoutput>
