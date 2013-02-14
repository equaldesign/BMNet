<cfoutput>


  <ul class="breadcrumb">
  <cfloop from="#arrayLen(rc.requestData.page.parents)#" to="1" index="i" step="-1">
  <li><a href="/html/#rc.requestData.page.parents[i].name#">#rc.requestData.page.parents[i].title#</a> <span class="divider">/</span></li>
  </cfloop>
  <li><a href="/html/#rc.requestData.page.name#">#rc.requestData.page.title#</a> <span class="divider">/</span></li>

    <cfset m = ArrayLen(rc.product.detail.parentStruct)>
    <cfloop from="1" to="#m#" index="i">
      <cfset cat = rc.product.detail.parentStruct[m]>
      <li><a href="/html/#rc.requestData.page.name#?bvnodeRef=#cat.nodeRef#">#cat.name#</a><span class="divider">/</span></li>
      <cfset m-->
    </cfloop>
    <li class="active">#rc.product.detail.title#</li>
  </ul>

</cfoutput>
<cfset wikiParser = getPlugin("WikiText")>
<cfset getMyPlugin(plugin="jQuery").getDepends("mousewheel","secure/products/edit,secure/products/detail","jQuery/lightbox/style,secure/products/products,secure/products/admintools",true,"bv")>
<cfoutput>
    <div id="detail">
      <div class="productDetail">
        <div class="page-header">
          <h1>#rc.product.detail.title#</h1>
          <cfif NOT rc.product.detail.productActive><span class="label label-important">DISCONTINUED</span></cfif>
        </div>
        <div class="productBox">
          <div class="productImage">
            <cfif arrayLen(rc.product.detail.productImage) gte 1>
              <!--- we have a proper product image --->
              <a title="#rc.product.detail.title#" href="https://www.buildingvine.com/api/productImage?nodeRef=#rc.product.detail.productImage[1].nodeRef#&size=large" class="zoom thumbail">
                <img alt="#rc.product.detail.title#" src="https://www.buildingvine.com/api/productImage?nodeRef=#rc.product.detail.productImage[1].nodeRef#&size=medium" class="glow smallImage">
              </a>
            <cfelseif rc.amazonExists>
              <!--- we have a proper product image --->
              <img src="#replace(rc.amazon.LargeImage.URL.xmlText,'http://ecx.images-amazon.com','https://images-na.ssl-images-amazon.com')#" class="glow smallImage">
            <cfelse>

                <img src="https://www.buildingvine.com/api/productImage?siteID=#rc.product.detail.site#&eancode=#rc.product.detail.eancode#&size=medium&supplierproductcode=#paramValue('rc.product.detail.attributes.supplierproductcode','')#&manufacturerproductcode=#paramValue('rc.product.detail.attributes.manufacturerproductcode','')#&productName=#rc.product.detail.title#" title="#rc.product.detail.title#" class="glow smallImage">

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
            #wikiParser.toHTML(paramValue("rc.product.detail.attributes.productdescription2","")).html#
            #wikiParser.toHTML(paramValue("rc.product.detail.attributes.productdescription","")).html#
            <cfif isDefined("rc.product.detail.attributes.rrp") AND rc.product.detail.attributes.rrp neq "" AND NOT (rc.amazonExists AND rc.product.detail.attributes.rrp gt rc.amazon.OfferSummary.LowestNewPrice.FormattedPrice.xmlText)>
            <h4>RRP: &pound;#rc.product.detail.attributes.rrp#</h4>
            </cfif>

            <cfif rc.amazonExists>
                <ul>
                <cfif isDefined("rc.amazon.ItemAttributes.Feature") AND ArrayLen(rc.amazon.ItemAttributes.Feature) gte 1>
                <cfloop array="#rc.amazon.ItemAttributes.Feature#" index="f">
                  <li>#f.xmlText#</li>
                </cfloop>
                </cfif>
                </ul>
            </cfif>
            </div>
            <div class="Aristo accordion" id="productAccordion">
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

            </div>
            <div style="padding:10px;" data-show-video="true" id="bvinfo" data-use-accordion="true" data-accordion-target="productAccordion"  data-use-tabs="false" data-tab-target="bv_detailTabsContainer" data-tab-type="bootstrap" data-showdocuments="true" data-showdata="true"  data-src="nodeRef=#rc.product.detail.nodeRef#"></div>
          </div>
          <br class="clear" />
        </div>
      </div>
    </div>
</cfoutput>