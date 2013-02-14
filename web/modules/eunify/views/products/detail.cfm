<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>
<cfset getMyPlugin(plugin="jQuery",module="bv").getDepends("","secure/products/detail","")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","products/detail","")>

<cfoutput>
<div class="Aristo">
    <div id="detail">
      <div class="productDetail">
        <h1>#rc.product.full_description#</h1>
        <cfif paramValue("rc.bvProduct.detail.attributes.productdescription2","") neq "">
        <p>#rc.bvProduct.detail.attributes.productdescription2#</p>
        </cfif>
        <div class="productImage">
          <img src="https://www.buildingvine.com/api/productImage?&eancode=#rc.product.EANCode#&size=medium&manufacturerproductcode=#rc.product.Manufacturers_Product_Code#&supplierproductcode=#rc.product.product_code#&productName=#rc.product.full_description#" class="glow smallImage"></a>
        </div>
        <div class="productInfo">
          <div class="Aristo accordion" id="productAccordion">
            <h5><a href="##">Pricing Information</a></h5>
            <div>
              <h4>RRP: &pound;#DecimalFormat(paramValue("rc.product.retail_price","0"))#</h4>
              <cfif rc.product.web_trade_price neq "">
              <h4>Web Trade Price: #rc.product.web_trade_price#</h4>
              </cfif>
              <cfif rc.product.web_price neq "">
              <h4>Web Public Price: #rc.product.web_price#</h4>
              </cfif>
              <cfif isDefined("rc.bvProduct.detail.prices")>
                <cfloop array="#rc.bvProduct.detail.prices#" index="price">
                  <div class="t">
                   <cfif isDefined("price.priceeffectivefromdate")>
                     <div class="trow">
                       <div class="tcell">Price Effective From:</div>
                       <div class="tcell">#paramValue("price.priceeffectivefromdate","")#</div>
                     </div>
                   </cfif>
                   <cfif isDefined("price.discountgroup")>
                     <div class="trow">
                       <div class="tcell">Discount Group:</div>
                       <div class="tcell">#paramValue("price.discountgroup","")#</div>
                     </div>
                   </cfif>
                   <cfif isDefined("price.rebategroup")>
                     <div class="trow">
                       <div class="tcell">Rebate Group:</div>
                       <div class="tcell">#paramValue("price.rebategroup","")#</div>
                     </div>
                   </cfif>
                   <cfif isDefined("price.supplierslistprice")>
                     <div class="trow">
                       <div class="tcell">Suppliers List Price:</div>
                       <div class="tcell">&pound;#paramValue("price.supplierslistprice","")#
                         <cfif isDefined("price.priceChange.change")>
                           (<span class="red">#price.priceChange.change.supplierslistprice#</span>
                           <span class="small"> was &pound;#price.priceChange.previous.supplierslistprice#</span>)
                          </cfif>
                        </div>
                     </div>
                   </cfif>
                     <cfif isDefined("price.merchantinvoiceprice")>
                   <div class="trow">
                       <div class="tcell">Merchant Invoice Price:</div>
                       <div class="tcell">&pound;#paramValue("price.merchantinvoiceprice","")#
                         <cfif isDefined("price.priceChange.change")>
                           (<span class="red">#price.priceChange.change.merchantinvoiceprice#</span>
                           <span class="small"> was &pound;#price.priceChange.previous.merchantinvoiceprice#</span>)
                          </cfif>
                        </div>
                     </div>
                   </cfif>
                   <cfif isDefined("price.priceunitofmeasurequantity")>
                     <div class="trow">
                       <div class="tcell">Quantities:</div>
                       <div class="tcell">#paramValue("price.priceunitofmeasurequantity","")# #paramValue("price.priceunitofmeasuredescription","")#</div>
                     </div>
                   </cfif>
                   <cfif isDefined("price.packquantity")>
                     <div class="trow">
                       <div class="tcell">Pack Quantity:</div>
                       <div class="tcell">#paramValue("price.packquantity","")#</div>
                     </div>
                   </cfif>
                   <cfif isDefined("price.vatcode")>
                     <div class="trow">
                       <div class="tcell">VAT Code:</div>
                       <div class="tcell">#paramValue("price.vatcode","")#</div>
                     </div>
                   </cfif>
                  </div>
                </cfloop>
              </cfif>
            </div>
            <h5><a href="##">Basic Information</a></h5>
            <div>
              <dl class="dl-horizontal">
                <dt>Manufacturer Product Code</dt>
                <dd>#paramValue("rc.product.manufacturer_product_code","")#</dd>
                <dt>Product Code</dt>
                <dd>#paramValue("rc.product.product_code","")#</dd>
                <dt>EAN Code</dt>
                <dd>#paramValue("rc.product.EANCode","")#</dd>
                <dt>Weight</dt>
                <dd>#paramValue("rc.bvProduct.detail.attributes.unitweight","")# <cfif isDefined('rc.bvProduct.detail.attributes.weightperunitofmeasure')>#lCase(rc.bvProduct.detail.attributes.weightperunitofmeasure)#</cfif></dd>
              </dl>
            </div>
            <h5><a href="##">Related Products</a></h5>
            <div>
              <div>
                <cfif rc.recommendedProducts.recordCount gte 1>
                  <h2>Customers who bought this product also bought</h2>

                  <cfloop query="rc.recommendedProducts">
                  <div class="row-fluid">
                    <div class="span2 thumbnail" >
                      <img src="https://www.buildingvine.com/api/productImage?&eancode=#EANCode#&size=small&supplierproductcode=#manufacturers_product_code#&productName=#full_description#" />
                    </div>
                    <div class="span10">
                      <h3><a href="/eunify/products/detail?id=#product_code#" class="noAjax">#full_description#</a></h3>
                      <dl class="dl-horizontal">
                      <cfif eanCode neq "">
                        <dt>EAN</dt>
                        <dd>#eancode#</dd>
                      </cfif>
                        <dt>Code</dt>
                        <dd>#product_code#</dd>
                        <dt>RRP</dt>
                        <dd>&pound;#retail_price#</dd>
                        <dt>Trade</dt>
                        <dd>&pound;#trade_price#</dd>
                      </dl>
                    </div>
                  </div>
                  </cfloop>
                </cfif>
              </div>
            </div>
            <h5><a href="##">Product Tools</a></h5>
            <div>
              <div class="productTools">
                <ul class="nav nav-list">
                  <li class="nav-header">Product options</li>
                  <li><a name="Edit Product" class="noAjax modaldialog edit" href="/eunify/products/edit?id=#rc.product.product_code#"><i class="icon-product-edit"></i>Edit Product Details</a></li>
                  <li><a target="_blank" name="View on website" class="noAjax view" href="/mxtra/shop/product?productID=#rc.product.product_code#"><i class="icon-globe"></i>View on website</a></li>
                  <li class="divider"></li>
                  <li class="nav-header">Building Vine</li>
                  <cfif rc.product.BVNodeRef eq "">
                    <li><a class="noAjax modaldialog search" href="/eunify/products/bvsearch?id=#rc.product.product_code#"><i class="icon-bv"></i>Find related Building Vine Product</a></li>
                  <cfelse>
                    <li><a class="noAjax sync" href="/eunify/products/bvupdate?id=#rc.product.product_code#"><i class="icon-bv"></i>Sync product with BuildingVine</a></li>
                    <li><a class="noAjax remove" href="/eunify/products/bvremove?id=#rc.product.product_code#"><i class="icon-bv"></i>Remove Building Vine Relationship</a></li>
                  </cfif>
                </ul>
              </div>
            </div>
          </div>

          <div id="bv_docs"></div>
        </div>
        <br clear="all" class="clear" />
      </div>
    </div>
</cfoutput>
</div>
