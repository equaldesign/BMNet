<cfoutput>#getMyPlugin(plugin="jQuery").getDepends("","sites/13/homepage","jQuery/sr/default",false)#</cfoutput>
<cfset ProductService = getModel("eunify.ProductService")>
<div class="hidden-tablet fullwidthbanner-container">
   <div class="fullwidthbanner">
     <ul>
      <cfset features = ProductService.getProducts(featured=true)>
      <cfoutput query="features">
         <li data-transition="boxslide" data-slotamount="7" data-link="#bsl('/mxtra/shop/product/#pageslug#?productID=#product_code#')#">
           <img src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&size=1000&crop=true&aspect=2:1&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#">
           <div class="caption sft big_white"  data-x="390" data-y="80" data-speed="700" data-start="1700" data-easing="easeOutBack">#showProd(Full_Description,Web_Name)#</div>
           <cfset rc.price = showBestPrice(Retail_Price,Trade,web_price,web_trade_price,subunit,subsperunit)>
           <div class="caption sfb big_orange"  data-x="400" data-y="142" data-speed="500" data-start="1900" data-easing="easeOutBack">Only &pound;#trim(VATPrice(rc.price))# <small>#doUnit(unitDisplay,subunit)#</small></div>
           <div class="caption lfl" data-x="400" data-y="215" data-speed="500" data-start="2100" data-easing="easeOutBack"><a href="/mxtra/shop/product/#pageslug#?productID=#product_code#" class="btn btn-success"><strong>more info</strong></a></div>
           <div class="caption randomrotate"
             data-x="14"
             data-y="129"
             data-speed="600"
             data-start="1300"
             data-easing="easeOutExpo"  >
             <img class="img-polaroid" src="https://www.buildingvine.com/api/productImage?eancode=#eancode#&merchantCode=turnbull#product_code#&size=250&crop=true&&manufacturerproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#showProd(Full_Description,Web_Name)#">
           </div>

         </li>
       </cfoutput>
     </ul>
   </div>
</div>

<section id="container">
    <section id="welcome" name="welcome" #isE()#>
        <cfoutput>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.welcome",""))#</cfoutput>
    </section>
    <cfset rc.products = ProductService.getProducts(featured=true)>
    <cfoutput>#renderView(view="shop/product/styles/grid",module="mxtra")#</cfoutput>
    <div name="blog"  #isE()# class="row our-blog">
        <cfoutput>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.blog",""))#</cfoutput>
    </div>
    <hr>
</section>