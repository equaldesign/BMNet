
<ul class="thumbnails">
<cfoutput query="rc.products">
  <li class="thumbnail span2">
  	<a href="/mxtra/shop/product/#pageslug#?productID=#product_code#">
      <img src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&size=200&crop=true&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#&imageplaceholder=http://#cgi.http_host#/includes/images/sites/1/holdingimage.jpg">
			<h5 class="prodcatname">#showProd(Full_Description,Web_Name)#</h5>
			<h3 class="price">
        <cfset rc.price = showBestPrice(Retail_Price,Trade,web_price,web_trade_price,subunit,subsperunit)>
        Only &pound;#trim(VATPrice(rc.price))# <small>#doUnit(unitDisplay,subunit)#</small>
      </h3>
  	</a>
  </li>
</cfoutput>
</ul>
