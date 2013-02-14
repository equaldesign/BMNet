<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/products/standard",true,"bv")>
<cfoutput>
  <h2>Recommended Products for #rc.account.name#</h2></cfoutput>
  <div class="ui-widget">
    <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
      <p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
        The following products have been recommended based on the purchase history of this customer. Other people, when buying products
        this customer has bought in the past, have also bought the products below. This customer has never purchased the products below, despite them being
        relevent.
      </p>
    </div>
  </div>
  <cfoutput query="rc.recommendations">
  <div class="productList jstree-draggable">
  <div class="product">
     <div class="productImage">
      <img src="https://www.buildingvine.com/api/productImage?&eancode=#EANCode#&size=small&supplierproductcode=#manufacturers_product_code#&productName=#full_description#" />
     </div>
     <div class="left productInfo">
      <h2><a href="/products/detail?id=#product_code#" class="noAjax">#full_description#</a></h2>
      <cfif eanCode neq "">
        <h5><span class="EAN">EAN:</span> #eancode#</h5>
      </cfif>
      <h5><span class="code">Code:</span>#product_code#</h5
      <h4><span class="rrp">RRP:</span> &pound;#retail_price#</h4>
      <h4><span class="rrp">Trade:</span> &pound;#trade_price#</h4>
    </div>
   <br clear="all" class="clear" />
  </div>
  </div>
  </cfoutput>
