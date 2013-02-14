
<cfoutput query="rc.products">
  <cfset rc.stockAvailable = getModel("modules.eunify.model.ProductService").getavailableBranchStock(Product_Code,request.siteID)>
  <cfset rc.deliveryCost = getModel("modules.eunify.model.ProductService").getDeliveryCost(Product_Code,request.siteID)>
  <div class="row">
  	<div class="span1">
  		<!--- image --->
	  	<a class="thumbnail" href="/mxtra/shop/product?productID=#product_code#">
        <img src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&size=200&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#">
      </a>
  	</div>
		<div class="span5">
			<h3><a href="/mxtra/shop/product?productID=#product_code#">#showProd(Full_Description,Web_Name)#</a></h3>
			<h3 class="price">
        <cfset price = showBestPrice(Retail_Price,Trade,web_price,web_trade_price)>
        Around &pound;#trim(VATPrice(price))# <small>#unitDisplay#</small>
      </h3>
			<cfset rc.product = rc.products>
      <cfset rc.productID = Product_Code>
      #renderView("shop/basket/add")#
      <p>#web_description#</p>
		</div>		
  </div>
</cfoutput>

