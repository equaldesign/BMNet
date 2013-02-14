<cfoutput>
<div class="pforms">
  <div class="row-fluid control-group warning">
    <label for="List_Price" class="span3">List Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span>
        <input class="input-mini" type="text" name="List_Price" id="List_Price" value="#rc.product.List_Price#" />
        <span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Retail_Price" class="span3">Retail Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span>
        <input class="input-mini" type="text" name="Retail_Price" id="Retail_Price" value="#rc.product.Retail_Price#" />
        <span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="tel" class="span3">Trade Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span>
        <input class="input-mini" type="text" name="Trade" id="Trade" value="#rc.product.Trade#" />
        <span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Cost_Price" class="span3">Cost Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span>
        <input class="input-mini" type="text" name="Cost_Price" id="Cost_Price" value="#rc.product.Cost_Price#" />
        <span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Unit_of_Sale" class="span3">Unit of Sale</label>
    <div class="span9">
      #renderUnits(rc.product.Unit_of_Sale,rc.product.product_code,"Unit_of_Sale")#
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Unit_of_Price" class="span3">Unit of Price</label>
    <div class="span9">
      #renderUnits(rc.product.unit_of_price,rc.product.product_code,"unit_of_price")#
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Unit_of_Buy" class="span3">Unit of Buy</label>
    <div class="span9">
      #renderUnits(rc.product.Unit_of_Buy,rc.product.product_code,"Unit_of_Buy")#
    </div>
  </div>
  <div class="row-fluid control-group warning">
    <label for="Unit_of_Cost" class="span3">Unit of Cost</label>
    <div class="span9">
      #renderUnits(rc.product.Unit_of_Cost,rc.product.product_code,"Unit_of_Cost")#
    </div>
  </div>
  <div class="row-fluid">
    <label for="tel" class="span3">Web Public Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span><input class="input-small" type="text" size="5" id="web_price" name="web_price" value="#rc.product.web_price#" /><span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <div class="row-fluid">
    <label for="tel" class="span3">Web Trade Price</label>
    <div class="span9">
      <div class="input-prepend input-append">
        <span class="add-on">&pound;</span><input class="input-small" type="text" size="5" id="web_trade_price" name="web_trade_price" value="#rc.product.web_trade_price#" /><span class="add-on">(ex VAT)</span>
      </div>
    </div>
  </div>
  <!---
  <cfif isDefined("rc.bvProduct.detail.prices")>
    <cfloop array="#rc.bvProduct.detail.prices#" index="price">

       <cfif isDefined("price.priceeffectivefromdate")>
        <div class="row-fluid">
          <label for="tel" class="span3">Price Effective From</label>
          <div class="span9">
            <div class="input-prepend input-append">
              <span class="add-on">&pound;</span><input class="disabled input-small" type="text" size="5" value="#paramValue("price.priceeffectivefromdate","")#" />
            </div>
          </div>
        </div>
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
      </div>
    </cfloop>
  </cfif>
  --->
</div>
</cfoutput>