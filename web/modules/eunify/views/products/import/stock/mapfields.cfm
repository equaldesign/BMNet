<cfoutput>
  <legend>Spreadsheet field mappings</legend>
  <br />
  <div class="alert alert-info">
    <a class="close" data-dismiss="alert">&times;</a>
    Select the columns in your spreadsheet that match our pre-defined columns.
  </div>
  <div class="control-group">
    <label class="control-label" for="EANCode">BranchID<em>*</em></label>
    <div class="controls">
      <select name="object.branchID" id="branchID">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("branchID","stock").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Your Branch Code.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="Product_Code">Product Code<em>*</em></label>
    <div class="controls">
      <select name="object.Product_Code" id="branchID">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("Product_Code","stock").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Your Product Code.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="physical">Physical Stock<em>*</em></label>
    <div class="controls">
      <select name="object.physical" id="branchID">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("physical","stock").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline"><span class="label label-important">Required</span> Your Physical Stock level.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="reserved">Reserved Stock</label>
    <div class="controls">
      <select name="object.reserved" id="branchID">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("reserved","stock").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Resvered Stock levels.</p>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="onOrder">On Order Stock</label>
    <div class="controls">
      <select name="object.onOrder" id="branchID">
        <option value="">--no value--</option>
        <cfloop array="#rc.sheet.getMetaData().getColumnLabels()#" index="col">
          <option #vm(col,rc.iService.getFields("onOrder","stock").mapsTo)# value="#col#">#col#</option>
        </cfloop>
      </select>
      <p class="help-inline">Stock on order.</p>
    </div>
  </div>
<div class="form-actions">
  <button type="submit" class="btn btn-primary">Import Spreadsheet</button>
</div>
<input type="hidden" name="fileName" value="#rc.file#" />
</cfoutput>