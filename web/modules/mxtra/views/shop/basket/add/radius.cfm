<cfoutput>
  <cfif rc.product.minimum_delivery_quantity neq 1>
    <div class="alert alert-error">
      <h3 class="alert-heading">Minimum Delivery</h3>
      <p>
        <cfif rc.product.subunit neq "">
          This item is sold in #rc.product.minimum_delivery_quantity_unit#<cfif rc.product.minimum_delivery_quantity neq 1>s</cfif>.
        </cfif>
        The minimum quantity for delivery is #rc.product.minimum_delivery_quantity# #rc.product.minimum_delivery_quantity_unit#<cfif rc.product.minimum_delivery_quantity neq 1>s</cfif>, making the minimum delivery value
      <cfset rc.thisPrice = showBestPrice(rc.product.Retail_Price,rc.product.Trade,rc.product.web_price,rc.product.web_trade_price,"",0)>
      &pound;#DecimalFOrmat(VATPrice(rc.thisPrice*rc.product.minimum_delivery_quantity))#
      </p>
    </div>
  </cfif>
  <cfif rc.product.delivery_location_value eq "">
    <cfset rc.product.delivery_location_value = 10>
  </cfif>
  <cfif isDefined("request.geoInfo.zipcode") AND request.geoInfo.zipcode neq "">
    <cfif getModel("eunify.BranchService").getBranchesFromAddress(radius=rc.product.delivery_location_value,latitude=request.geoInfo.latitude,latitude=request.geoInfo.longitude).branches.recordCount neq 0>
    <!--- they are in the list --->
    <form class="form-horizontal doBasket" action="/mxtra/shop/basket/add" method="post">
      <input type="hidden" name="productID" value="#rc.productID#" />
      <input type="hidden" name="isdelivered" value="true">
      <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/product?productID=#rc.productID#')#" />
      <div class="input-prepend input-append">
        <span class="add-on">QTY.</span>
        <input id="quantity" data-minorder="#rc.product.minimum_delivery_quantity#" type="text" class="input-micro" maxlength="3" name="quantity" value="#rc.product.minimum_delivery_quantity#">
        <input class="btn btn-info" type="submit" value="Add to <cfif 0 eq 0>basket<cfelse>quotation</cfif> &raquo;">
      </div>
    </form>
    <cfelse>
      <div class="alert alert-error">
        <h3 class="alert-heading">Sorry!</h3>
        <p>We cannot deliver this product to #request.geoInfo.zipcode#. If this postcode is incorrect, please <a href="/mxtra/shop/basket/enterpostcode" class="dialog">update your postcode</a></p>
        <p>We can only deliver this product within a #rc.product.delivery_location_value# mile radius, and your nearest branch is #getModel("eunify.BranchService").getNearestBranch(latitude=request.geoInfo.latitude,latitude=request.geoInfo.longitude).branches.distance# miles away</p>
      </div>
    </cfif>
  <cfelse>
    #renderView("shop/basket/enterpostcode")#
  </cfif>
</cfoutput>