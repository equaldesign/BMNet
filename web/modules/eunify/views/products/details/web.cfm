<div class="pforms">
  <cfoutput>
  <div class="row-fluid">
    <label for="surname" class="span3">Web Name</label>
    <div class="span9">
      <input size="30" type="text" name="name" id="name" value="#rc.product.Web_Name#" />
    </div>
  </div>
  <div class="row-fluid">
    <label for="surname" class="span3">Web Description</label>
    <div class="span9">
      <textarea name="web_description">#rc.product.web_description#</textarea>
    </div>
  </div>
  <div class="row-fluid">
    <label for="tel" class="span3">Web Public Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span><input class="input-small" type="text" size="5" id="web_price" name="web_price" value="#rc.product.web_price#" /><span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <div class="row-fluid">
    <label for="tel" class="span3">Web Trade Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span><input class="input-small" type="text" size="5" id="web_trade_price" name="web_trade_price" value="#rc.product.web_trade_price#" /><span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <div class="row-fluid">
    <label for="surname" class="span3">Web Page Slug</label>
    <div class="span9">
      <input size="30" type="text" name="pageslug" id="pageslug" value="#rc.product.pageslug#" />
    </div>
  </div>

  <div class="row-fluid">
    <label for="subunit" class="span3">Sub Unit</label>
    <div class="span9">
      <input class="input-small" type="text" size="5" id="subunit" name="subunit" value="#rc.product.subunit#" />
    </div>
  </div>
  <div class="row-fluid">
    <label for="subsperunit" class="span3">Subs Per Unit</label>
    <div class="span9">
      <input class="input-small" type="text" size="5" id="subsperunit" name="subsperunit" value="#rc.product.subsperunit#" />
    </div>
  </div>
  <div class="row-fluid">
    <label for="tel" class="span3">Attributes</label>
    <div class="span9">
      <label class="checkbox">
        <input type="checkbox" id="featured" name="feature" value="true" #vm("#rc.product.feature#","true","checkbox")#>
        Featured?
      </label>
      <label class="checkbox">
        <input type="checkbox" id="publicWebEnabled" name="publicWebEnabled" value="true" #vm("#rc.product.publicWebEnabled#","true","checkbox")#>
        Public enabled
      </label>
      <label class="checkbox">
       <input type="checkbox" id="webEnabled" name="webEnabled" value="true" #vm("#rc.product.webEnabled#","true","checkbox")#>
       Trade enabled?
      </label>
      <label class="checkbox">
        <input type="checkbox" id="collectable" name="collectable" value="true" #vm("#rc.product.collectable#","true","checkbox")#>
        Collect in store?
      </label>
      <label class="checkbox">
        <input type="checkbox" id="special" name="special" value="true" #vm("#rc.product.special#","true","checkbox")#>
        Special offer?
      </label>
      <label class="checkbox">
        <input type="checkbox" id="clearance" name="clearance" value="true" #vm("#rc.product.clearance#","true","checkbox")#>
        Clearance item?
      </label>
    </div>
  </div>
  </cfoutput>
</div>