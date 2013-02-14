<cfset getMyPlugin(plugin="jQuery").getDepends("","","tables",false,"eunify")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","products/table","")>
<div class="widget widget-table">
  <table class="table table-bordered table-striped dataTable" id="productList">
	  <thead>
	    <tr>
	      <th width="60%">Description</th>
	      <th>Quant.</th>
	      <th></th>
	    </tr>
	  </thead>
	  <tbody>
      <cfoutput>
	  	<cfloop query="rc.results">
		  	<tr>
					<td><h4><a class="modalProduct" data-toggle="modal" data-target="##productDetailModal" href="/quote/product/productDetail?product_code=#product_code#">#Full_description#</a></h4>
					 <!--- <p>#custom2#</p>  --->
					</td>
					<td nowrap="nowrap">
						<input type="hidden" class="pcode" value="#product_code#" />
						<input type="hidden" class="utype" value="EA" />
						<input type="hidden" class="pname" value="#full_description#" />
						<div class="input-prepend">
              <span class="add-on">QTY.</span><input type="text" class="input-micro quant" maxlength="3" value="1">
            </div>
					</td>
					<td><button type="button" class="addProduct btn btn-info">Add to list &raquo;</button></td>
		  	</tr>
		  </cfloop>
      </cfoutput>
	  </tbody>
	</table>
</div>
<form class="form form-horizontal">
	<fieldset>
		<legend>Can't find what you're looking for? Don't worry, you can add your products manually!</legend>
		<div class="control-group">
			<label class="control-label">Quantity</label>
			<div class="controls">
        <div class="input-append">
  				<input type="text" class="input-small" value="1" id="manualQuantity">
  				<select class="input-small" id="manualUnits">
  					<option value="bags">Bags</option>
  					<option value="unit">unit</option>
  					<option value="packs">Packs</option>
  					<option value="roll">Roll</option>
  					<option value="kg">Kg</option>
  					<option value="box">Box</option>
  					<option value="sheet">Sheet</option>
  					<option value="tonne">Tonne</option>
  					<option value="M2">M&sup2;</option>
  					<option value="M3">M&sup3;</option>
  					<option value="Metre">Metre</option>
  					<option value="Litre">Litre</option>
  				</select>
        </div>
			</div>
		</div>
	</fieldset>
	<div class="control-group">
		<label class="control-label">Product Name</label>
		<div class="controls">
			<div class="input-append">
				<input type="text" id="manualProductName" value="" placeholder="i.e cement" />
				<button type="button" class="btn btn-success" id="manualProductAdd">Add Product to your list</button>
			</div>
			<p class="help-block">When entering products manually, try to be as descriptive as you can, to ensure we can match the products you need with products in the marketplace.</p>
		</div>
	</div>
</form>
<div class="modal hide fade" id="productDetailModal">
    <div class="modal-header">
      <button type="button" class="close" data-dismiss="modal">&times;</button>
      <h3>Product Information</h3>
    </div>
    <div class="modal-body">
      <p>Is everythink ok? If so, you can now submit your quotation.</p>
    </div>
    <div class="modal-footer">
      <a href="##" class="btn" data-dismiss="modal">Close</a>
    </div>
  </div>