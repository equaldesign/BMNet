<cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy","sites/#rc.sess.siteID#/turnbull","sites/#rc.sess.siteID#/style,sites/#rc.sess.siteID#/productlist,sites/#rc.sess.siteID#/productdetail,sites/#rc.sess.siteID#/shop,sites/#rc.sess.siteID#/screenShotPreview")>
    <h2>Clearance Items</h2>
    <cfif rc.products.recordCount eq 0>
      <p>There are no clearance items available at this time.</p>
    </cfif>
<cfoutput query="rc.products">
  <cfset stockAvailable = rc.product.getavailableBranchStock(Product_Code)>
  <cfset deliveryInfo = rc.product.getDeliveryCost(Weight)>
  <div id="#product_code#" class="productlist">
      <div class="productImage">
        <a href="/mxtra/shop/product?productID=#product_code#" title="#Full_Description#" class="screenshot" rel="https://www.buildingvine.com/api/productImage?merchantCode=turnbull#product_code#&size=medium&key=654fgsjhndfchs7764&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#Full_Description#">
          <img width="100" src="https://www.buildingvine.com/api/productImage?merchantCode=turnbull#product_code#&size=small&key=654fgsjhndfchs7764&supplierproductcode=#URLEncodedFormat(Manufacturers_Product_Code)#&productName=#Full_Description#" class="smallImage">
        </a>
      </div>
      <h2><a href="/mxtra/shop/product?productID=#product_code#">#showProd(Full_Description,Web_Name)#</a></h2>
      <div class="productDesc">
        <h3 class="price">
          <cfset price = showBestPrice(Retail_Price,Trade,web_price,web_trade_price)>
          Only &pound;#trim(VATPrice(price))# <span class="small">(Inc. VAT)</span>
        </h3>
        <form action="/mxtra/shop/#iif(rc.sess.mxtra.quote.id eq 0,"'basket'","'quote'")#/add" style="margin:0;padding:0;" method="post">
          <input type="hidden" name="productID" value="#product_code#" />
          <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/category?categoryID=#rc.categoryID#&productID=#product_code#&sPage=#rc.sPage#&fPage=#rc.fPage#')#" />
          <div>QTY. <input type="text" width="2" size="1" maxlength="3" name="quantity" value="1"><input class="button addbutton" type="submit" value="Add to <cfif rc.sess.mxtra.quote.id eq 0>basket<cfelse>quotation</cfif> &raquo;"></div>
        </form>
        <p>#web_description#</p>
      </div>
      <div class="deliveryDetails">
        <h3>Availability</h3>

        <table width="100%" cellspacing="0" cellpadding="2">
          <tr>
            <td>
              <h5 class="candeliver">DELIVERY</h5>
            </td>
          </tr>
          <tr>
            <td>
              <cfif rc.sess.mxtra.account.trade eq "Y">
                <cfif delivery_charge_trade eq "none">
                  <span class="red bold">Free</span> Delivery!
                <cfelseif delivery_charge_trade eq "fixed">
                Delivery charged @ &pound;#delivery_charge_value_trade#.
                <cfelse>
                 Delivery charged @ &pound;#deliveryInfo#.
                </cfif>
                <br />Delivery Time is #delivery_time_trade# days
              <cfelse>
                <cfif delivery_charge eq "none">
                    <span class="red bold">Free</span> Delivery!
                  <cfelseif delivery_charge eq "fixed">
                  Delivery charged @ &pound;#delivery_charge_value#.
                  <cfelse>
                   Delivery charged @ &pound;#deliveryInfo#.
                  </cfif>
                  <br />Delivery Time is #delivery_time# days
              </cfif>

            </td>
          </tr>
          <tr>
            <td>
              <h5 class="#IIf(collectable,"'cancollect'","'cannotcollect'")#">COLLECT IN-STORE</h5>
            </td>
          </tr>
          <cfif collectable>
          <tr>
            <td>
              This item can be collected in-store
            </td>
          </tr>
          <cfelse>
          <tr>
            <td>Not available to collect in-store </td>
          </tr>
          <!---
          <cfelse>
          <tr>
            <td>
              This item can be collected from:
              <ul class="branchListUL">
                <cfloop query="stockAvailable">
                  <cfif physical gte 1>
                    <li>#name#</li>
                  </cfif>
                </cfloop>
              </ul>
            </td>
          </tr>
          --->
          </cfif>

         </table>
      </div>
      <div class="clearer"></div>
    </div>
  </cfoutput>