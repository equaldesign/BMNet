<table class="table table-striped table-bordered">
	<thead>
		<tr>
			<th></th>
			<th>Product</th>
			<th>Price</th>
		</tr>
	</thead>
	<tbody>
		<cfoutput query="rc.products">
			<cfset rc.stockAvailable = getModel("eunify.ProductService").getavailableBranchStock(Product_Code,request.siteID)>
      <cfset rc.deliveryCost = getModel("eunify.ProductService").getDeliveryCost(Product_Code,request.siteID)>
	    <tr>
	    	<td><img width="50" src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&crop=true&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&size=50&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#" class="smallImage"></td>
				<td><a href="#bsl('/mxtra/shop/product?productID=#product_code#')#">#showProd(Full_Description,Web_Name)#</a></td>
				<td>&pound;#trim(VATPrice(price))#<span class="small"> #unitDisplay# (Inc. VAT)</span>
				</td>
	    </tr>
		</cfoutput>
	</tbody>
</table>