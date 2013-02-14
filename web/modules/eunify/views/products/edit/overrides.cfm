<cfoutput>
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert" href="##">&times;</a>
    <h3 class="alert-heading">Information</h3>
    <p>These settings over-ride some settings on the core properties tab panel. You only need to use this panel if your data is automatically imported from your back office system.</p>
  </div>
    <fieldset>
      <legend>Extended Information</legend>
      <div class="control-group">
        <label for="surname" class="control-label">Web Name</label>
        <div class="controls">
          <input size="30" type="text" name="name" id="name" value="#rc.product.Web_Name#" />
        </div>
      </div>
      <div class="control-group">
        <label for="surname" class="control-label">Web Description</label>
        <div class="controls">
          <textarea name="web_description">#rc.product.web_description#</textarea>
        </div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Web Public Price</label>
        <div class="controls">
          <div class="input-prepend input-append">
            <span class="add-on">&pound;</span><input class="input-small" type="text" size="5" id="web_price" name="web_price" value="#rc.product.web_price#" /><span class="add-on">(ex VAT)</span>
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Web Trade Price</label>
        <div class="controls">
          <div class="input-prepend input-append">
            <span class="add-on">&pound;</span><input class="input-small" type="text" size="5" id="web_trade_price" name="web_trade_price" value="#rc.product.web_trade_price#" /><span class="add-on">(ex VAT)</span>
          </div>
        </div>
      </div>
    </fieldset>
</cfoutput>