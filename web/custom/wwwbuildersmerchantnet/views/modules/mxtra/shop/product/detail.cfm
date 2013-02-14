<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>
<cfif isUserInRole("staff")>

	<cfset getMyPlugin(plugin="jQuery").getDepends("","main,products/detail","form,Aristo/jQueryUI",true,"eunify")>
</cfif>
<cfset getMyPlugin(plugin="jQuery").getDepends("form,cookie,labelover,tipsy","basket,sites/#request.siteID#/turnbull,sites/#request.siteID#/search","sites/#request.siteID#/productlist,sites/#request.siteID#/productdetail,sites/#request.siteID#/shop,sites/#request.siteID#/screenShotPreview")>
  <cfoutput>
  <div class="productPage">
    <h2>#showProd(rc.product.Full_Description,rc.product.Web_name)#</h2>

    <div id="productDetail">
    <div id="productImage">
        <a href="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=#rc.product.product_code#&size=large&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#" class="zoom" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#"><img src="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=#rc.product.product_code#&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&size=medium&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#"></a>
				<div class="ills">All images are shown for illustrative purposes only</div>


    </div>
    <div id="productDesc">
      <div id="productPrice">
        <h2>
          <cfif ArrayLen(request.fullBasket.items) eq 0>
            &pound;2,990 <span class="small">For first module (Inc. VAT) </span></h2>
          <cfelse>
            &pound;990 <span class="small">For additional module (Inc. VAT) </span></h2>
          </cfif>
          <cfoutput>#renderView("shop/basket/add")#</cfoutput>
      </div>
      <div class="descr">
        <p>#paragraphFormat2(rc.product.web_description)#</p>
      </div>
    </div>
    <div class="clearer"></div>
  </div>
</div>
</cfoutput>
