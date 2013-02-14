<cfsavecontent variable="forH">
<!---<script src="https://www.buildingvine.com/includes/javascript/api/reviews.js" type="text/javascript" language="javascript"></script>--->
<script src="https://www.buildingvine.com/includes/javascript/api/js.js" type="text/javascript" language="javascript"></script>

<cfoutput><title>#rc.siteDB.title# #rc.product.detail.title#</title>
<link rel="canonical" href="http://www.buildingvine.com/products/productDetail?nodeRef=#rc.nodeRef#" />
</cfoutput>
</cfsavecontent>
<cfhtmlhead text="#forH#">
<!--- <cfset wikiParser = getPlugin("WikiText")> --->
<cfset getMyPlugin(plugin="jQuery").getDepends("mousewheel","secure/products/edit,secure/products/detail","jQuery/lightbox/style,secure/products/products,secure/products/admintools")>
<cfoutput>
    <div id="detail">
			<div class="productDetail">
				<div class="page-header">
          <!--- #renderView(view="api/productSnippet",args={nodeRef=rc.product.detail.nodeRef})# --->
			    <h1>#rc.product.detail.title#</h1>
					<cfif NOT rc.product.detail.productActive><span class="label label-important">DISCONTINUED</span></cfif>

			  </div>
        <div class="productBox">
  			  <div class="productImage">
            <cfif arrayLen(rc.product.detail.productImage) gte 1>
              <!--- we have a proper product image --->
              <a title="#rc.product.detail.title#" href="https://www.buildingvine.com/api/productImage?nodeRef=#rc.product.detail.productImage[1].nodeRef#&size=large" class="zoom thumbnail">
                <img alt="#rc.product.detail.title#" src="https://www.buildingvine.com/api/productImage?nodeRef=#rc.product.detail.productImage[1].nodeRef#&size=medium" class="glow smallImage">
              </a>
            <cfelseif rc.amazonExists>
              <!--- we have a proper product image --->
              <img src="#replace(rc.amazon.LargeImage.URL.xmlText,'http://ecx.images-amazon.com','https://images-na.ssl-images-amazon.com')#" class="glow smallImage">
            <cfelse>

                <img src="https://www.buildingvine.com/api/productImage?siteID=#rc.product.detail.site#&eancode=#rc.product.detail.eancode#&size=medium&supplierproductcode=#paramValue('rc.product.detail.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('rc.product.detail.attributes.manufacturerproductcode','')#&productName=#rc.product.detail.title#" title="#rc.product.detail.title#" class="glow smallImage">

            </cfif>
            <cfif isDefined("rc.reach")>
              
            
            <div class="reach">
              <i class="icon-megaphone"></i>
              Reach: #rc.reach# people
            </div>
            </cfif>
            <div id="hoverInfo" class="ills">Hover over image to zoom in<br /><span class="smaller">All images are shown for illustrative purposes only</span></div>
            <div id="productImages">
              <cfoutput>
                <cfif arrayLen(rc.product.detail.images) gte 1 OR (rc.amazonExists AND arrayLen(rc.amazon.ImageSets.ImageSet) gte 1)>
                <h4>Additional Images</h4>
                </cfif>
                <cfif arrayLen(rc.product.detail.images) gte 1>
                  <cfloop array="#rc.product.detail.images#" index="img">
                    <cfif arrayLen(rc.product.detail.productImage) gte 1 AND img.nodeRef neq rc.product.detail.productImage[1].nodeRef>
                      <a class="fancy" rel="additional" href="https://www.buildingvine.com/api/productImage?size=large&nodeRef=#img.nodeRef#">
                        <img class="glow" id="#img.nodeRef#" src="https://www.buildingvine.com/api/productImage?size=small&nodeRef=#img.nodeRef#" width="50" />
                      </a>
                    </cfif>
                  </cfloop>
                </cfif>
                <cfif rc.amazonExists>
                  <cfloop array="#rc.amazon.ImageSets.ImageSet#" index="mgSet">
                    <a class="fancy" rel="additional" href="#replace(mgSet.LargeImage.URL.xmlText,'http://ecx.images-amazon.com','https://images-na.ssl-images-amazon.com')#">
                      <img class="glow" id="#replace(mgSet.LargeImage.URL.xmlText,'http://ecx.images-amazon.com','https://images-na.ssl-images-amazon.com')#" src="#replace(mgSet.SmallImage.URL.xmlText,'http://ecx.images-amazon.com','https://images-na.ssl-images-amazon.com')#" width="50" />
                    </a>
                  </cfloop>
                </cfif>
              </cfoutput>
            </div>            
          </div>
  			  <div class="productInfo">
  			    <div class="productBasket">
            #paramValue("rc.product.detail.attributes.productdescription2","")#
            #paramValue("rc.product.detail.attributes.productdescription","")#
						<cfif isDefined("rc.product.detail.attributes.rrp") AND rc.product.detail.attributes.rrp neq "" AND NOT (rc.amazonExists AND rc.product.detail.attributes.rrp gt rc.amazon.OfferSummary.LowestNewPrice.FormattedPrice.xmlText)>
            <h4>RRP: &pound;#rc.product.detail.attributes.rrp#</h4>
            </cfif>

            <cfif rc.amazonExists>
                <ul>
                  <li>Amazon</li>
                <cfif isDefined("rc.amazon.ItemAttributes.Feature") AND ArrayLen(rc.amazon.ItemAttributes.Feature) gte 1>
                <cfloop array="#rc.amazon.ItemAttributes.Feature#" index="f">
                  <li>#f.xmlText#</li>
                </cfloop>
                </cfif>
                </ul>
            </cfif>
            </div>
            <div class="Aristo accordion" id="productAccordion">
  			      <cfif getAuthUser() neq "" AND isDefined("rc.product.detail.prices") AND arrayLen(rc.product.detail.prices) gte 1>
                <h5><a href="##">Customer Pricing</a></h5>
                <div class="accordion2">
                  <cfloop array="#rc.product.detail.prices#" index="price">
                    <h3><a href="##"><cfif price.permissions.edit AND isDefined('price.name')> #ListFirst(ListLast(price.name,"_"),".")# <cfif isDefined('price.versionLabel')>(#price.versionLabel#)</cfif></cfif></a></h3>
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
      	                  <div class="tcell">Quanty for price:</div>
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
                </div>
              </cfif>
              <cfif getAuthUser() neq "" AND isDefined("rc.product.detail.promotions") AND arrayLen(rc.product.detail.promotions) gte 1>
                <h5><a href="##">Promotions</a></h5>
                <div>
                  <cfloop array="#rc.product.detail.promotions#" index="promotion">
                    <div class="t">
                      <div class="trow">
                        <div class="tcell">
                          <cfif ArrayLen(promotion.files) gte 1>
                            <a target="_blank" href="https://www.buildingvine.com/alfresco#promotion.files[1].downloadUrl#?ticket=#trim(getModel('UserService').getUserTicket())#"><img class="glow" src="https://www.buildingvine.com/alfresco/service/#promotion.files[1].thumbnailUrl#doclib?ph=true&c=force&alf_ticket=#rc.buildingVine.admin_ticket#" border="0"></a>
                          </cfif>
                        </div>
                        <div class="tcell">
                          <h4>#promotion.name#</h4>
                          <h5>Valid for #DateDiff("d",now(),promotion.validTo)# more days</h5>
                          <p>#promotion.description#</p>
                        </div>
                      </div>
                    </div>
                  </cfloop>
                </div>
              </cfif>
              <h5><a href="##">Find a local stockist</a></h5>
              <div>
                <form class="form-inline">
                  <div class="input-append">                    
                    <input type="text" id="postcode" placeholder="Enter your postcode" /> 
                    <button type="button" id="doStockistSearch" data-siteid="#rc.product.detail.site#" class="btn">Find a stockist</button>
                  </div>                  
                </form>
                <div id="stockistsResult"></div>
              </div>
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
              <cfif isUserInRole("admin_#request.bvsiteID#")>
                <h5><a href="##">Tools</a></h5>
                <div class="rel">

                <cfif isDefined("rc.product.detail.attributes.featured") AND rc.product.detail.attributes.featured>
                  <a title="do not feature this product" href="/alfresco/service/bv/product/feature?nodeRef=#rc.product.detail.nodeRef#&alf_ticket=#request.user_ticket#" class="ttip feature false"></a>
                <cfelse>
                  <a title="Feature this product" href="/alfresco/service/bv/product/feature?nodeRef=#rc.product.detail.nodeRef#&alf_ticket=#request.user_ticket#" class="feature ttip true"></a>
                </cfif>
                <a title="edit the image associated with this product" href="/bv/products/editImage?nodeRef=#rc.product.detail.nodeRef#" class="dialog ttip editProductImage"></a>
                <a title="edit the documents associated with this product" href="/bv/products/editDocuments?nodeRef=#rc.product.detail.nodeRef#" class="dialog ttip editProductDocs"></a>
                <a title="Create new Priceset" name="Create New Price" class="dialogOK ttip editPrice" href="/bv/products/addprice?nodeRef=#rc.nodeRef#"></a>
                <a title="Edit External Links" name="Edit External Links" class="dialog ttip editVideo" href="/bv/products/editlinks?nodeRef=#rc.nodeRef#"></a>
                <a name="Edit this Product" title="Edit this product" href="/bv/products/edit?nodeRef=#rc.product.detail.nodeRef#" class="dialogOK ttip editProduct"></a>
                <a title="Delete this product" rel="#rc.product.detail.nodeRef#" href="/bvine/product?nodeRef=#rc.product.detail.nodeRef#&alf_ticket=#request.user_ticket#" class="ttip deleteProduct"></a>
                <br /><br /><p><small>Last modified on #rc.product.detail.attributes.modified# by #rc.product.detail.attributes.modifier#</small></p>
								</div>
              </cfif>
            </div>
						<div style="padding:10px;" data-show-video="true" id="bvinfo" data-use-accordion="true" data-accordion-target="productAccordion"  data-use-tabs="false" data-tab-target="bv_detailTabsContainer" data-tab-type="bootstrap" data-showdocuments="true" data-showdata="true"  data-src="nodeRef=#rc.product.detail.nodeRef#"></div>
            <cfoutput>#renderView(view="web/tags/list",args={nodeRef=rc.product.detail.attributes["node-uuid"],type="ProductDetail",siteID=rc.product.detail.site})#</cfoutput>
			    </div>
          <br class="clear" />

        </div>
			</div>
    </div>

</cfoutput>
 
<!---

 <cfif rc.amazonExists>
<cfdump var="#rc.amazon#">
</cfif>
 --->
 