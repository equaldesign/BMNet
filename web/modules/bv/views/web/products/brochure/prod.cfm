<cfoutput>
    <div id="detail">
      <div class="productDetail">
        <h1>#rc.product.detail.title#</h1>
        <div class="productBox">
          <div class="productImage">

          </div>
          <div class="productInfo">
            <div class="productBasket">
            <cfif isDefined("rc.product.detail.attributes.rrp") AND rc.product.detail.attributes.rrp neq "" AND NOT (rc.amazonExists AND rc.product.detail.attributes.rrp gt rc.amazon.OfferSummary.LowestNewPrice.FormattedPrice.xmlText)>
            <h4>RRP: &pound;#rc.product.detail.attributes.rrp#</h4>
            </cfif>
            </div>
            <div class="Aristo accordion">
              <cfif isDefined("rc.product.detail.prices") AND arrayLen(rc.product.detail.prices) gte 1>
                <h5><a href="##">Customer Pricing</a></h5>
                <div class="accordion2">
                  <cfloop array="#rc.product.detail.prices#" index="price">
                    <h3><a href="##"> #ListFirst(ListLast(price.name,"_"),".")# <cfif isDefined('price.versionLabel')>(#price.versionLabel#)</cfif></a></h3>
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
              <h5><a href="##">Custom Product Information</a></h5>
              <div>
                <div class="t">
                  <cfoutput>
                  <div class="t">
                  <cfset productStruct= rc.product.detail.attributes.customProperties>
                  <cfloop collection="#productStruct#" item="x">
                  <cfif productStruct[x] neq "NULL" AND productStruct[x] neq "">
                    <cfif x neq "fake">
                    <div class="trow">
                      <div class="tcell">#x#</div>
                      <div class="tcell">#productStruct[x]#</div>
                    </div>
                    </cfif>
                  </cfif>
                  </cfloop>
                  </div>
                </cfoutput>
                </div>
              </div>

              <h5><a href="##">Related Documents</a></h5>
              <div>
                <div id="bv_docs">
                <cfif StructKeyExists(rc.product.detail,"productDocuments")>
                  <h4>Documents</h4>
                  <cfloop array="#rc.product.detail.productDocuments#" index="doc">
                    <div class="t">
                      <div class="trow">
                        <div class="tcell"><a target="_blank" href="https://www.buildingvine.com/alfresco#doc.downloadUrl#?ticket=#trim(getModel('UserService').getUserTicket())#"><img class="glow" src="https://www.buildingvine.com/alfresco/service/#doc.thumbnailUrl#doclib?ph=true&c=force&alf_ticket=#rc.buildingVine.admin_ticket#" border="0"></a></div>
                        <div class="tcell">
                            <h4><a target="_blank" href="https://www.buildingvine.com/alfresco#doc.downloadUrl#?ticket=#trim(getModel('UserService').getUserTicket())#">#doc.title#</a></h4>
                            <div class="t">
                              <div class="trow">
                                <div class="tcell">
                                  <img align="left" src="https://www.buildingvine.com/alfresco/#doc.icon#" />
                                </div>
                                <div class="tcell">
                                  <h5>#doc.size#</h5>
                                </div>
                              </div>
                            </div>
                        </div>
                      </div>
                    </div>
                  </cfloop>
                  <cfif ArrayLen(rc.product.detail.productDocuments) eq 0>
                  <p>No documents relating to this product</p>
                  </cfif>
                </cfif>
                </div>
              </div>
            </div>
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
