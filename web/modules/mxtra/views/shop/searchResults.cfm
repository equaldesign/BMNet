<cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy","sites/11/turnbull","sites/#rc.sess.siteID#/style,sites/#rc.sess.siteID#/productlist,sites/#rc.sess.siteID#/shop,sites/#rc.sess.siteID#/screenShotPreview")>
<cfset includeUDF('includes/helpers/mxtra.cfm')>
  <div id="productList">
  <cfoutput>#getMyPlugin(plugin="paginator",module="merchantXtra").paginate("/mxtra/shop/search?query=#URLEncodedFormat(query)#&")#</cfoutput>
  <div class="clearer"></div>

	<cfoutput query="rc.results" startrow="#rc.sRow#" maxrows="10">
  <cfset stockAvailable = rc.product.getavailableBranchStock(Product_Code)>
  <cfset deliveryInfo = rc.product.getDeliveryCost(StatusCode,Weight,stockAvailable.recordCount)>
  <cfset rc.del = deliveryInfo>
  <cfset rc.stock = stockAvailable>
  <div id="#product_code#" class="productlist">
	  	<div class="productImage">
	  			<a href="/mxtra/shop/product?productID=#product_code#" title="#Full_Description#" class="screenshot"  rel="https://www.buildingvine.com/api/productImage?merchantCode=#product_code#&size=medium&key=654fgsjhndfchs7764&productCode=#URLEncodedFormat(Manufacturers_Product_Code)#">
            <img src="https://www.buildingvine.com/api/productImage?merchantCode=turnbull#product_code#&size=small&key=654fgsjhndfchs7764&productCode=#URLEncodedFormat(Manufacturers_Product_Code)#" class="smallImage">
          </a>
	    </div>
	    <div class="productDesc">
	    	<div><a href="/mxtra/shop/product?productID=#product_code#">#showProd(Full_Description,Web_Description)#</a></div>
	      <cfset price = 0>
	      <cfif rc.sess.mxtra.account.number eq 0>
	      	<cfset price = Retail_Price>
	      <cfelse>
	     		<cfset price = Trade>
	      </cfif>

	      <div class="price">Only &pound;#trim(VATPrice(price))# <span class="small">(Inc. VAT)</span></div>
	    <form action="/mxtra/shop/#iif(rc.sess.mxtra.quote.id eq 0,"'basket'","'quote'")#/add" style="margin:0;padding:0;" method="post">
	    <input type="hidden" name="productID" value="#product_code#" />
	    <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/search?query=#URLEncodedFormat(query)#&categoryID=#rc.categoryID#&productID=#product_code#&sPage=#rc.sPage#&fPage=#rc.fPage#')#" />
	    	<div>QTY. <input <cfif not deliveryInfo.canOrder AND rc.sess.mxtra.quote.id eq 0> disabled="disabled"</cfif> type="text" width="2" size="1" maxlength="3" name="quantity" value="1"><input <cfif not deliveryInfo.canOrder AND rc.sess.mxtra.quote.id eq 0>  disabled="disabled" class="button disabled"<cfelse> class="button addbutton"</cfif> type="submit" value="Add to quotation &raquo;"></div>

	    </form>
	    </div>
	    <div class="deliveryDetails">
	    	<h3>Availability</h3>

	      <cfif deliveryInfo.canOrder>
        <table width="100%" cellspacing="0" cellpadding="2">
          <tr>
            <td colspan="2">
              <h5>DELIVERY</h5>
            </td>
          </tr>
          <tr>
            <td align="center" width="1">
              <cfif deliveryInfo.canDeliver>
                <img src="/images/icons/lorry_go.png" />
              <cfelse>
                <img border="0" hspace="4" align="left" src="/images/icons/lorry_error.png"  />
              </cfif>
            </td>
            <td>
              <cfif deliveryInfo.canDeliver>
                <cfif deliveryInfo.deliveryCost eq 0>
                  <span class="red bold">Free</span> Delivery!
                <cfelse>
                Delivery charged @ &pound;#deliveryInfo.deliveryCost#.
                </cfif>
                <br />Delivery Time is #leadTime(StatusCode)#
             <cfelse>
                #DeliveryInfo.reason#
              </cfif>
            </td>
          </tr>
          <tr>
            <td colspan="2">
              <h5>IN-STORE COLLECTION</h5>
            </td>
          </tr>
          <cfif StatusCode eq "I">
          <tr>
            <cfif stockAvailable.recordCount gte 1>
            <td valign="top"><img hspace="4" src="/images/icons/accept.png" /></td>
            <td>
             This item can be collected from:
              <ul class="branchListUL">
                <cfloop query="stockAvailable">
                    <li>#name#</li>

                </cfloop>
              </ul>
            </td>
            <cfelse>
              <td><img hspace="4" src="/images/icons/accept.png" /></td>
              <td>Collect from store can be arranged</td>
            </cfif>
          </tr>
          <cfelseif StatusCode eq "U" OR StatusCOde eq "V">
          <tr>
            <td><img src="/images/icons/error.png" /></td>
            <td>Not available to collect in-store </td>
          </tr>
          <cfelse>
          <tr>
            <td valign="top"><img hspace="4" src="/images/icons/accept.png" /></td>
            <td>
              This item can be collected from:
              <ul class="branchListUL">
                <cfloop query="stockAvailable">

                    <li>#name#</li>
                </cfloop>
              </ul>
            </td>
          </tr>
          </cfif>
          <cfelse>
            <tr>
              <td><img hspace="4" src="/images/icons/error.png" /></td>
              <td>This Item is currently out of stock &amp; cannot be delivered</td>
            </tr>
           </cfif>
         </table>
	    </div>
      <div class="clearer"></div>
    </div>
  </cfoutput>
  <cfoutput>#getMyPlugin("mxtra/shop/paginator").paginate("/mxtra/shop/search?query=#URLEncodedFormat(query)#&")#</cfoutput>
  <div class="clearer"></div>
  </div>
