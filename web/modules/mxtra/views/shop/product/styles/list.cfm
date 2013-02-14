
<cfoutput query="rc.products">
  <cfset rc.stockAvailable = getModel("eunify.ProductService").getavailableBranchStock(Product_Code,request.siteID)>
  <cfset rc.deliveryCost = getModel("eunify.ProductService").getDeliveryCost(Product_Code,request.siteID)>
  <div class="row-fluid">
  	<div class="span4">
  		<!--- image --->
	  	<a class="thumbnail" href="#bsl('/mxtra/shop/product?productID=#product_code#')#">
        <img src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&size=400&crop=true&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#">
      </a>
  	</div>
		<div class="span8">
			<h3><a href="#bsl('/mxtra/shop/product/#pageslug#?productID=#product_code#')#">#showProd(Full_Description,Web_Name)#</a></h3>
			<h3 class="price">
        <cfset price = showBestPrice(Retail_Price,Trade,web_price,web_trade_price,subunit,subsperunit)>
        Only &pound;#trim(VATPrice(price))# <small>#unitDisplay#</small>
      </h3>
			<cfset rc.product = rc.products>
      <cfset rc.productID = Product_Code>
      <cfif request.mxtra.quote.id neq 0>
        #renderView("shop/quote/add")#
      <cfelse>
       #renderView("shop/basket/add")#
      </cfif>
      <p>#web_description#</p>
		</div>
  </div>
</cfoutput>

