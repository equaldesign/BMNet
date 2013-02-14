<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>
  <cfoutput>
    <h2>#showProd(rc.product.Full_Description,rc.product.Web_name)#</h2>
    <div class="row-fluid">
      <div class="span5">
      <div id="productImage">
          <a href="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&size=large&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#" class="zoom" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#"><img src="https://www.buildingvine.com/api/productImage?eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&size=medium&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#" title="#showProd(rc.product.Full_Description,rc.product.Web_name)#"></a>
          <div class="ills">All images are shown for illustrative purposes only</div>
      </div>
      </div>
      <div class="span7">
        <div id="productDesc">
          <div class="descr">
            <p>#paragraphFormat2(rc.product.web_description)#</p>
            <div class="furtherInfo">
             <dl>
               <cfif rc.product.eancode neq "">
               <dt>EANCode</dt>
               <dd>#rc.product.eancode#</dd>
               </cfif>
               <cfif rc.product.Supplier_Code neq "" AND NOT isNumeric(rc.product.Supplier_Code)>
               <dt>Supplier</dt>
               <dd>#rc.product.Supplier_Code#</dd>
               </cfif>
               <cfif rc.product.Manufacturers_Product_Code neq "">
               <dt>Part Code</dt>
               <dd>#rc.product.Manufacturers_Product_Code#
               </cfif>
               <dt>Product Code</dt>
               <dd>#rc.product.Product_Code#</dd>
             </dl>
            </div>
          </div>
        <div id="bvinfo" style="padding: 5px;" data-showdocuments="true" data-src="eancode=#rc.product.eancode#&merchantCode=turnbull#rc.product.product_code#&size=large&manufacturerproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&supplierproductcode=#URLEncodedFormat(rc.product.Manufacturers_Product_Code)#&productName=#showProd(rc.product.Full_Description,rc.product.Web_name)#"></div>
        </div>
      </div>
    </div>
  </cfoutput>
