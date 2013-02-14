<ul class="thumbnails">
<cfoutput query="rc.products">
  <li class="span2">
  	<a class="thumbnail" href="/mxtra/shop/product/#pageslug#?productID=#product_code#">  		
      <img class="h100" src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&size=100&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#">      
			<h5 class="prodcatname">#showProd(Full_Description,Web_Name)#</h5>
			<h3 class="price">
        <cfset price = showBestPrice(Retail_Price,Trade,web_price,web_trade_price)>
        Only &pound;#trim(VATPrice(price))# <small>#unitDisplay#</small>
      </h3>			
  	</a>
  </li>  
</cfoutput>
</ul>