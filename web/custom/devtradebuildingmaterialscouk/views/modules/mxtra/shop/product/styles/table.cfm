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
			<cfset rc.stockAvailable = getModel("modules.eunify.model.ProductService").getavailableBranchStock(Product_Code,request.siteID)>
      <cfset rc.deliveryCost = getModel("modules.eunify.model.ProductService").getDeliveryCost(Product_Code,request.siteID)>
	    <tr>
	    	<td><img width="50" src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&size=50&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#" class="smallImage"></td>
				<td><a href="/mxtra/shop/product?productID=#product_code#">#showProd(Full_Description,Web_Name)#</a></td>
				<td>&pound;#trim(VATPrice(price))#<span class="small"> #unitDisplay# (Inc. VAT)</span>
				<cfset rc.product = rc.products>
        <cfset rc.productID = Product_Code>
        #renderView("shop/basket/add")#
				</td>				
	    </tr>
		</cfoutput>
	</tbody>
</table>