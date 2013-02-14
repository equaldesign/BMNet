<cfhtmlhead text='<title>BuildersMerchant.net - #showProd(rc.product.Full_Description,rc.product.Web_name)#</title>'></cfhtmlhead>
<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>
<cfif isUserInRole("staff")>	
	<cfset getMyPlugin(plugin="jQuery").getDepends("","main,products/detail","form,Aristo/jQueryUI",true,"eunify")>
</cfif>  
  <cfoutput>
    <input type="hidden" id="urlString" value="#URLEncodedFormat('/mxtra/shop/product?productID=#rc.productID#')#" />
   <cfoutput>#getModel("modules.eunify.model.ProductService").breadcrumb(categoryID=rc.categoryID,productID=rc.productID,urlString="&brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&itemsPerPage=#rc.itemsPerPage#&viewMode=#rc.viewMode#")#</cfoutput>
   
   <div class="row productPage">
    <cfif isUserInRole("trade")>
    <div id="layouts" style="float: right">
      <span class="rel">
      <label for="searchQuery" class="over">Search</label>
      <input type="text" id="searchQuery" class="iSearch">
      </span>
    </div>
    </cfif>
    <div class="span6 page-header">
      <h1>#showProd(rc.product.Full_Description,rc.product.Web_name)#</h1>
    </div>
    <div class="span3"> 
      <a href="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&size=large&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#" class="zoom thumbnail" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#"><img width="250" src="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&size=medium&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#"></a>
      <div class="ills">Images shown for illustrative purposes only</div>
    </div>
    <div class="span3">
      <div id="productPrice">
        <h2>
        	<cfif rc.amazonExists>          
            <cfif rc.amazon.OfferSummary.LowestNewPrice.Amount.xmlText LT VATPrice(showBestPrice(rc.product.Retail_Price,rc.product.Trade,rc.product.web_price,rc.product.web_trade_price))>
              <cfset price = rc.amazon.OfferSummary.LowestNewPrice.Amount.xmlText>
						<cfelse>
							<cfset price = VATPrice(showBestPrice(rc.product.Retail_Price,rc.product.Trade,rc.product.web_price,rc.product.web_trade_price))>
			       </cfif>
		      <cfelse>
			  	  <cfset price = VATPrice(showBestPrice(rc.product.Retail_Price,rc.product.Trade,rc.product.web_price,rc.product.web_trade_price))>  
          </cfif>					
        Around &pound;#trim(price)# <small>#rc.product.unitDisplay#<em>*</em> </small></h2>
        <cfoutput>#renderView("shop/basket/add")#</cfoutput>
        
      </div>
      <div class="descr">
        <p>#paragraphFormat2(rc.product.web_description)#</p>
				<cfif rc.amazonExists>
					
					<ul>
	        <cfif isDefined("rc.amazon.ItemAttributes.Feature") AND ArrayLen(rc.amazon.ItemAttributes.Feature) gte 1>
		        <cfloop array="#rc.amazon.ItemAttributes.Feature#" index="f">
		          <li>#f.xmlText#</li>
		        </cfloop>
	        </cfif>
          </ul>
					<p>#paragraphFormat2(rc.amazon.EditorialReviews.EditorialReview.Content.xmlText)#</p>   
				</cfif>				
        <div class="furtherInfo"> 
         <dl class="dl-horizontal">
           <cfif rc.product.eancode neq "">
           <dt>EANCode</dt>
           <dd>#rc.product.eancode#</dd>
           </cfif>
           <cfif rc.product.buildingVineID neq "">
           <dt>Supplier</dt>
           <dd><a target="_blank" href="http://www.buildingvine.com/sites/#rc.product.buildingVineID#">#rc.product.Supplier_Code#</a></dd>
           </cfif>
           <cfif rc.product.Manufacturers_Product_Code neq "">
           <dt>Part Code</dt>
           <dd>#rc.product.Manufacturers_Product_Code#
           </cfif>
           <dt>Product Code</dt>
           <dd>#rc.product.Product_Code#</dd>
         </dl>         
        </div>						
      </div>
			<div id="bvinfo" data-showdocuments="true" data-src="eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&size=large&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#"></div>
    </div>
    <div class="clearer"></div>
  </div>
</cfoutput>
<cfoutput>#renderView("shop/estimates")#</cfoutput>
<cfif rc.recommendations.recordCount neq 0>
<h2>Customers who bought this product also bought...</h2>
</cfif>
<cfset rc.products = rc.recommendations>
<ul id="productList" class="thumbnails">
<cfoutput query="rc.products">
  <li class="span2">
    <a class="thumbnail" href="/mxtra/shop/product?productID=#product_code#">     
      <img class="h100" src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&size=100&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#Full_Description#">      
      <h5 class="prodcatname">#Full_Description#</h5>
      <h3 class="price">
        <cfset price = Retail_Price>
        Around &pound;#trim(VATPrice(price))#
      </h3>     
    </a>
  </li>  
</cfoutput>
</ul>


