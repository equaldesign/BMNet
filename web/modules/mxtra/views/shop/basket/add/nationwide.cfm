<cfoutput>
  <cfif rc.product.minimum_delivery_quantity neq 1>
    <div class="alert alert-error">
      <h3 class="alert-heading">Minimum Delivery</h3>
      <p>
        <cfif rc.product.subunit neq "">
          This item is sold in #rc.product.minimum_delivery_quantity_unit#<cfif rc.product.minimum_delivery_quantity neq 1>s</cfif>.
        </cfif>
        The minimum quantity for delivery is #rc.product.minimum_delivery_quantity# #rc.product.minimum_delivery_quantity_unit#<cfif rc.product.minimum_delivery_quantity neq 1>s</cfif>.

        
      </p>
    </div>
  </cfif>
  <form class="form-horizontal doBasket" action="/mxtra/shop/basket/add" method="post">
    <input type="hidden" name="productID" value="#rc.productID#" />
    <input type="hidden" name="isdelivered" value="true">
    <input type="hidden" name="refURL" value="#URLEncodedFormat('/mxtra/shop/product?productID=#rc.productID#')#" />
    <div class="input-prepend input-append">
      <span class="add-on">QTY.</span>
      <input id="quantity" data-minorder="#rc.product.minimum_delivery_quantity#" type="text" class="input-micro" maxlength="3" name="quantity" value="#rc.product.minimum_delivery_quantity#">
      <input class="btn btn-info" type="submit" value="Add to <cfif 0 eq 0>basket<cfelse>quotation</cfif> &raquo;">
    </div>
    <cfif rc.product.delivery_location_value neq "">
      <a class="pull-right" id="delWarning" href="##" rel="popover" data-original-title="Locations" data-content="This product can be delivered nationally, but with exceptions. If you live in the following postcode areas, unfortunately delivery will not be possible: <cfloop list="#rc.product.delivery_location_value#" index="p"><cfif left(p,1) eq "-">#right(p,len(p)-1)# </cfif></cfloop>"><i class="icon-delivery-alert"></i> Delivery info</a>
    </cfif>
  </form>
</cfoutput>