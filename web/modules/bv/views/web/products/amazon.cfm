<cfsavecontent variable="forH">
<cfoutput><title>Building Vine - #rc.product.title#</title>
<link rel="canonical" href="http://www.buildingvine.com/products/az/id/#rc.id#" />
<link href="https://www.buildingvine.com/includes/style/jQuery/jqzoom.css" rel="stylesheet">
<script src="https://www.buildingvine.com/includes/javascript/api/zoom.js" type="text/javascript" language="javascript"></script>
<script src="https://www.buildingvine.com/includes/javascript/jQuery/jQuery.zoom.js" type="text/javascript" language="javascript"></script>
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#forH#">
<div id="furtherSearch">
  <form method="get" action="/search/az">
    <div class="l searchDiv">
      <label class="over furtherSearchBox" for="furtherSearchBox" style="display: block; ">Product Search...</label>
      <input type="text" name="query" id="furtherSearchBox">
      <button type="submit">
        <p><span class="search"></span> Search</p>
      </button>
    </div>
    <br class="clear" />
  </form>
</div>
<cfset getMyPlugin(plugin="jQuery").getDepends("lightbox,mousewheel","secure/products/edit,secure/products/detail","jQuery/lightbox/style,secure/products/products,secure/products/admintools")>
<cfoutput>
    <div id="detail">
			<div class="productDetail">
        <h1>#rc.product.title#</h1>
        <div class="productBox">
  			  <div class="productImage">
            <!--- we have a proper product image --->
            <img title="Large" src="#rc.product.MediumImage#" class="glow smallImage">
            <div id="hoverInfo" class="ills">Hover over image to zoom in<br /><span class="smaller">All images are shown for illustrative purposes only</span></div>
            <div id="productImages">
              <cfoutput>
                <cfif arrayLen(rc.product.ImageSet.ImageSet) gte 1>
                <h4>Additional Images</h4>
                </cfif>
                <cfloop array="#rc.product.ImageSet.ImageSet#" index="mgSet">
                  <a class="fancy" rel="additional" href="#mgSet.LargeImage.URL.xmlText#">
                    <img class="glow" id="#mgSet.LargeImage.URL.xmlText#" src="#mgSet.LargeImage.URL.xmlText#" width="50" />
                  </a>
                </cfloop>
              </cfoutput>
            </div>
          </div>
  			  <div class="productInfo">
  			    <div class="productBasket">
                  <h3>Only #rc.product.OfferSummary.LowestNewPrice.FormattedPrice.xmlText#</h3>
                  <p>#rc.product.OfferSummary.totalNew# available</p>
                  <cfif isDefined("rc.product.offers.offer") AND arrayLen(rc.product.Offers.offer) gte 1>
                  <p>#rc.product.Offers.offer[1].OfferListing.Availability#</p>
                  </cfif>
                  <form action="/basket/add/type/az/id/#rc.id#">
                    <label for="quantity">QTY:</label>
                    <input type="text" size="3" id="quantity" name="quantity" value="1" />
                    <button class="glow basketbutton" type="submit">
                      <p><span class="basket"></span>Add to basket</p>
                    </button>
                  </form>
                <ul>
                <cfif isDefined("rc.product.ItemAttributes.Feature") AND ArrayLen(rc.product.ItemAttributes.Feature) gte 1>
                <cfloop array="#rc.product.ItemAttributes.Feature#" index="f">
                  <li>#f.xmlText#</li>
                </cfloop>
                </cfif>
                </ul>

            </div>
            <div class="Aristo accordion">
  			      <cfif isDefined("rc.product.detail.prices") AND arrayLen(rc.product.detail.prices) gte 1>
              <h5><a href="##">Pricing Information</a></h5>
              <div>
                  <cfloop array="#rc.product.detail.prices#" index="price">
                    <div class="t form">
                    <form>
                    <fieldset><legend><cfif price.permissions.edit AND isDefined('price.title')> #price.title# <cfif isDefined('price.versionLabel')>(#price.versionLabel#)</cfif></cfif></legend>
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
                     <cfif price.permissions.edit>
                      <a href="##" title="Edit this Priceset" class="ttip editPrice" rel="#price.nodeRef#"></a>
                     </cfif>
                     <cfif price.permissions.delete>
                      <a href="##" title="Remove this Priceset" class="deletePrice" rel="#price.nodeRef#"></a>
                     </cfif>
                    </fieldset>
                    </form>
                    </div>
                  </cfloop>
              </div>
              </cfif>
              <h5><a href="##">Basic Information</a></h5>
  			      <div>
  			        <div class="t">
                  <div class="trow">
  			           <div class="tcell">Manufacturer Product Code:</div>
  			           <div class="tcell">#paramValue("rc.product.detail.attributes.manufacturerproductcode","")#</div>
                  </div>
                  <div class="trow">
                   <div class="tcell">Supplier Product Code:</div>
                   <div class="tcell">#paramValue("rc.product.detail.attributes.supplierproductcode","")#</div>
                  </div>
                  <div class="trow">
  			           <div class="tcell">EAN Code</div>
  			           <div class="tcell">#paramValue("rc.product.detail.attributes.eancode","")#</div>
                  </div>
                  <div class="trow">
  			           <div class="tcell">Weight</div>
  			           <div class="tcell">#paramValue("rc.product.detail.attributes.unitweight","")# <cfif isDefined('rc.product.detail.attributes.weightperunitofmeasure')>#lCase(rc.product.detail.attributes.weightperunitofmeasure)#</cfif></div>
                  </div>
  			        </div>
  			      </div>
  			      <cfif paramValue("rc.product.detail.attributes.productdescription2","") neq "">
                <h5><a href="##">Full Description</a></h5>
                <div><p>#rc.product.detail.attributes.productdescription2#</p></div>
              </cfif>
              <h5><a href="##">Specifications</a></h5>
              <div>
                <div class="t">
                  <div class="trow">
                    <div class="tcell">COSSH Data URL:</div>
                    <div class="tcell">#paramValue("rc.product.detail.attributes.coshhurl","")#</div>
                  </div>
                  <div class="trow">
                    <div class="tcell">Specification URL:</div>
                    <div class="tcell">#paramValue("rc.product.detail.attributes.specificationurl","")#</div>
                  </div>
                  <div class="trow">
                    <div class="tcell">Image URL</div>
                    <div class="tcell"><cfif paramValue("rc.product.detail.attributes.imageurl","") neq ""><a href="#rc.product.detail.attributes.imageurl#" target="_blank"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/globe.png" border="0" title="view image" class="ttip"></a></cfif></div>
                  </div>
                </div>
              </div>
              <h5><a href="##">Related Documents</a></h5>
              <div>
                <div id="bv_docs"></div>
              </div>
            </div>
			    </div>
          <br class="clear" />
        </div>

			</div>
    </div>
    <cfif arrayLen(rc.product.relatedProducts) gte 1>
      <div id="relatedProducts">
      <h2>Products you may also be interested in...</h2>
      <div id="relatedProductList">
        <cfloop array="#rc.product.relatedProducts#" index="relatedProduct">
        <div class="p">
          <a href="/products/az/id/#relatedProduct.ASIN#">
            <h3>#relatedProduct.title#</h3>
            <h4>#relatedProduct.price#</h4>
            <img src="#relatedProduct.image#">
          </a>
        </div>
        </cfloop>
      </div>
      </div>
    </cfif>

</cfoutput>

<!---

 <cfif rc.productExists>
<cfdump var="#rc.product#">
</cfif>
 --->
