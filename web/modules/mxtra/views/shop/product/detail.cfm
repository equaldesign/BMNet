<cfhtmlhead text='<title>Turnbull 24-7 - #showProd(rc.product.Full_Description,rc.product.Web_name)#</title>'>
<cfhtmlhead text='<link rel="canonical" href="http://#cgi.http_host#/mxtra/shop/#rc.product.pageslug#" />'>
<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>
<cfif isUserInRole("staff")>

  <cfset getMyPlugin(plugin="jQuery").getDepends("","main,products/detail","form,Aristo/jQueryUI",true,"eunify")>
</cfif>
<cfset getMyPlugin(plugin="jQuery").getDepends("form,cookie,labelover,tipsy","basket,sites/#request.siteID#/turnbull,sites/#request.siteID#/search","sites/#request.siteID#/productlist,sites/#request.siteID#/productdetail,sites/#request.siteID#/shop,sites/#request.siteID#/screenShotPreview")>
  <cfset rc.stockAvailable =  getModel("eunify.ProductService").getavailableBranchStock(rc.product.product_code,request.siteID)>
  <cfset rc.deliveryCost = getModel("eunify.ProductService").getDeliveryCost(rc.product.product_code,request.siteID)>
  <cfoutput>
    <input type="hidden" id="urlString" value="#URLEncodedFormat('#bsl("/mxtra/shop/product?productID=#rc.productID#")#')#" />
<cfoutput>#getModel("eunify.ProductService").breadcrumb(categoryID=rc.categoryID,productID=rc.productID,urlString="#bsl()#")#</cfoutput>
  <div class="row">

   <div class="span7 page-header">
      <h1>#showProd(rc.product.Full_Description,rc.product.Web_name)#</h1>
    </div>
  </div>
  <div class="row  productPage">
    <div class="span3">
      <a href="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&size=large&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#" class="zoom thumbnail" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#&imageplaceholder=http://#cgi.http_host#/includes/images/sites/1/holdingimage.jpg"><img alt="#showProd(rc.product.Full_Description,rc.product.Web_name)#"  width="270" src="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&size=medium&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#&imageplaceholder=http://#cgi.http_host#/includes/images/sites/1/holdingimage.jpg" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#"></a>
      <div class="ills">Images shown for illustrative purposes only</div>
    </div>
    <div class="span4" style="margin-right:-20px;">
      <div id="productPrice">
        <h2><cfset rc.price = showBestPrice(rc.product.Retail_Price,rc.product.Trade,rc.product.web_price,rc.product.web_trade_price,rc.product.subunit,rc.product.subsperunit)>
          Only &pound;#trim(VATPrice(rc.price))# <small>#doUnit(rc.product.unitDisplay,rc.product.subunit)# (Inc. VAT) </small></h2>
          <cfif rc.product.subunit neq "">
            <cfset args = {
                Retail_Price = rc.product.Retail_Price,
                Trade = rc.product.Trade,
                web_price = rc.product.web_price,
                web_trade_price = rc.product.web_trade_price,
                subunit = rc.product.subunit,
                subsperunit = rc.product.subsperunit,
                unitDisplay = rc.product.unitDisplay,
                deliveryUnit = rc.product.minimum_delivery_quantity_unit

            }>

            <cfoutput>#renderView(view="shop/product/subunits",args=args)#</cfoutput>
          </cfif>
          <cfif request.mxtra.quote.id neq 0>
            <cfoutput>#renderView("shop/quote/add")#</cfoutput>
          <cfelse>
           <cfoutput>#renderView("shop/basket/add")#</cfoutput>
          </cfif>
      </div>
    </div>
  </div>
  <div class="row">
    <div class="span7">
      <p>#paragraphFormat2(rc.product.web_description)#</p>
    </div>
  </div>
  <div class="row">
    <div id="detailTabs" class="span7">
      <ul class="nav nav-tabs">
        <cfif rc.product.youTube neq "">
          <li class="active"><a data-toggle="tab" href="##video">Video</a></li>
        </cfif>
        <cfif StructKeyExists(rc.metaData,"tabData")>
          <cfloop array="#rc.metaData.tabData#" index="t">
            <li class="active"><a data-toggle="tab" data-ref="#friendlyUrl(t.customProperties.metaTitle)#" href="##mt_#friendlyUrl(t.customProperties.metaTitle)#">#t.customProperties.metaTitle#</a></li>
          </cfloop>
        </cfif>
      </ul>
      <div class="tab-content">
        <cfif rc.product.youTube neq "">
         <div class="tab-pane" id="video">
          #rc.product.youTube#
         </div>
        </cfif>

        <cfif StructKeyExists(rc.metaData,"tabData")>
          <cfloop array="#rc.metaData.tabData#" index="t">
            <div class="tab-pane" id="mt_#friendlyUrl(t.customProperties.metaTitle)#">
              <h2>#t.customProperties.metaTitle#</h2>
              #HtmlUnEditFormat(t.customProperties.content)#
            </div><!-- // tab pane -->
          </cfloop>
        </cfif>
      </div><!-- // tab content -->
    </div><!-- // tab detailtabs -->
    <div id="bvinfo" data-use-tabs="true" data-show-video="true" data-tab-type="bootstrap" data-tab-target="detailTabs" data-showdata="true" style="padding: 5px;" data-showdocuments="true" data-src="eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&size=large&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#"></div>
  </div><!-- // row -->

</cfoutput>
<!---<cfif rc.recommendations.recordCount neq 0 AND isUserInAnyRole("staff,trade")>
<h2>Customers who bought this product also bought...</h2>
<cfoutput query="rc.recommendations">

  <div id="#product_code#" class="productlist">
      <div class="productImage">
        <a href="/mxtra/shop/product?productID=#product_code#" title="#Full_Description#" class="screenshot" rel="https://www.buildingvine.com/api/productImage?merchantCode=turnbull#product_code#&size=medium&key=654fgsjhndfchs7764&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#Full_Description#">
          <img src="https://www.buildingvine.com/api/productImage?eancode=#EANCode#&merchantCode=turnbull#product_code#&size=small&productCode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#Full_Description#" class="smallImage">
        </a>
      </div>
      <h2><a href="/mxtra/shop/product?productID=#product_code#">#Full_Description#</a></h2>
      <div class="productDesc">
        <h3 class="price">Only &pound;#trim(VATPrice(showBestPrice(Retail_Price,Trade_Price,"","")))# <span class="small">(Inc. VAT)</span></h3>
      </div>
      <br class="clear" clear="all" />
    </div>

  </cfoutput>
</cfif>--->
