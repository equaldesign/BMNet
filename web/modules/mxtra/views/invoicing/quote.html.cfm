<cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy,validate.min,form","sites/#rc.sess.siteID#/search,sites/#rc.sess.siteID#/quote,sites/#rc.sess.siteID#/turnbull,sites/#rc.sess.siteID#/checkout","sites/#rc.sess.siteID#/quote,sites/#rc.sess.siteID#/checkout,sites/#rc.sess.siteID#/style,sites/#rc.sess.siteID#/shop,sites/#rc.sess.siteID#/screenShotPreview")>
<cfoutput>
  <h2>Your Quick Quotation</h2>
  <!--- <cfif rc.order.status eq "pending">
  <p>Your quotation is currently <span class="red bold">pending review</span> by a #rc.sess.siteName# employee. Therefore, stock
  availability and order fulfiment cannot be guaranteed.</p>
  </cfif> --->
  <div class="quoteHeader">
    <div class="quoteProducts">
      <div class="invoiceForm">
        <form action="/mxtra/shop/search">
          <fieldset>
            <cfif rc.order.recordCount eq 0>
            <legend>Add products</legend>
            <p>Your quotation is currently empty. You can add products to this quotation by using the following search box. You can search by product name or product code.</p>
            <cfelse>
            <legend>Add more products</legend>
            <p>You can add more products to this quotation by using the following search box. You can search by product name or product code.</p>
            </cfif>
            <p>You can search over 30,000 active product lines.</p>
            <div class="rel">
              <label class="over" for="searchQuery">Search for a product</label>
              <input size="48" type="text" name="query" id="searchQuery" />
            </div>
          </fieldset>
        </form>
      </div>
    </div>
    <cfif rc.order.recordCount neq 0>
    <div class="emailQuote">
      <div class="invoiceForm">
        <form action="/mxtra/shop/quote/email/id/#rc.order.id#">
          <fieldset>
            <legend>Email this quick quotation</legend>
            <p>You can email this quick quotation, and add a percentage of markup to the cost.</p>
            <p>The quick quotation will be converted into a PDF and attached to an email</p>
            <div>
            <button type="submit"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/mail-send-receive.png" alt="" />email this quotation</button>
            </div>
          </fieldset>
          <div class="buttonRow"></div>
        </form>
      </div>
    </div>
    </cfif>
    <div class="clear"></div>
  </div>


  <div id="invoice">
    <div class="invoice_logo">
    <img src="/includes/images/sites/#rc.sess.siteID#/logo.png">
    <div class="invoice_logo_text">
      #rc.sess.mxtra.invoiceAddress#
    </div>
  </div>
  <div class="invoiceright">
    <h1><!--- <cfif rc.order.status eq "pending"><span class="red">PENDING</span> </cfif> ---> Quick Quotation</h1>
    <p>Page 1 of 1</p>

    <table width="250">
      <tr>
        <td class="tdark"><div>Account No.</div></td>
        <td class="tlight"><div>#rc.order.accountNumber#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Quotation Date</div></td>
        <td class="tlight"><div>#DateFormat(rc.order.date,"DD/MMM/YYY")#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Quotation No.</div></td>
        <td class="tlight"><div>#rc.order.shoporderID#</div></td>
      </tr>
      <cfif rc.order.reference neq "">
      <tr>
        <td class="tdark"><div>Your Ref.</div></td>
        <td class="tlight"><div>#rc.order.reference#</div></td>
      </tr>
      </cfif>
    </table>
  </div>
  <br class="clearer" />
  <div class="invoice_header">
    <h2>#rc.sess.siteName#</h2>
    <div id="invoice_to">
      <h3>Quotation prepared for:</h3>
         <p>#rc.order.billingContact#<br />
           #rc.order.billingAddress#
         <br />#rc.order.billingPOstCode#
         </p>
    </div>
    <div id="delivery_address">
      <h3>Delivery Address:</h3>
         <p>#rc.order.deliveryContact#<br />
         #paragraphFormat(rc.order.deliveryAddress)#
         <br />#rc.order.deliveryPOstCode#
         <cfif rc.order.deliveryDate neq "">
          <br />Delivery Date Requested: #DateFormat(rc.order.deliveryDate,"DD/MM/YYYY")#
          </cfif>
         </p>
    </div>
    <br class="clearer" />
  </div>
  <br class="clearer" />
  <div id="InvoiceDetails">
    <table width="100%">
      <thead>
        <tr>
          <td class="tdark"><div class="c">CODE</div></td>
          <td class="tdark"><div class="c">QTY. ORDER</div></td>
          <td class="tdark"><div class="c">DESCRIPTION</div></td>
          <td class="tdark"><div class="c">EA.</div></td>
          <td class="tdark"><div class="c">PRICE</div></td>
        </tr>
      </thead>
      <tbody>
        <cfloop query="rc.order">
        <tr>
          <td class="c">#itemNo#</td>
          <td class="c">
              <form action="/mxtra/shop/quote/update/id/#rc.order.id#" class="udq" method="post">
                <input type="hidden" name="lineID" value="#lineID#">
                <input class="updateB" type="text" width="2" size="1" maxlength="3" name="quantity" value="#quantity#">
              </form>
          </td>
          <td>#full_description#</td>
          <td class="c">#trim(numberFormat(quotedPriceEach,"9999.00"))#</td>
          <td class="c">#trim(numberFormat(quotedPriceTotal,"9999.00"))#</td>
        </tr>
        </cfloop>
      </tbody>
    </table>
  </div>
    <div class="invoice_footer">
    <div class="invoice_summary">
      <p>Prices quoted are subject to the current rate of VAT at the time of invoice. </p>
      <table>
        <tr>
          <td class="tdark"><div>VAT Code</div></td>
          <td class="tdark"><div>VAT Rate</div></td>
          <td class="tdark"><div>Goods Value</div></td>
          <td class="tdark"><div>VAT Value</div></td>
        </tr>
        <tr>
          <td class="tlight"><div>S</div></td>
          <td class="tlight"><div>20.00</div></td>
          <td class="tlight"><div><cfif rc.order.totalItemsPrice neq "">&pound;#NumberFormat(rc.order.totalItemsPrice,"9,999,999.00")#</cfif></div></td>
          <td class="tlight"><div><cfif rc.order.totalPrice neq "">&pound;#NumberFormat(rc.order.totalPrice/100*20,"9,999,999.00")#</cfif></div></td>
        </tr>
      </table>
    </div>
    <div class="invoice_total">
      <table>
        <tr>
          <td class="tdark"><div>GOODS TOTAL</div></td>
          <td class="tlight"><div><cfif rc.order.totalItemsPrice neq "">&pound;#NumberFormat(rc.order.totalItemsPrice,"9,999,999.00")#</cfif></div></td>
        </tr>
        <tr>
          <td class="tdark"><div>DELIVERY</div></td>
          <td class="tlight"><div><cfif rc.order.totalItemsPrice neq "">&pound;#NumberFormat(rc.order.totalPrice-rc.order.totalItemsPrice,"9,999,999.00")#</cfif></div></td>
        </tr>
        <tr>
          <td class="tdark"><div>TOTAL INC VAT</div></td>
          <td class="tlight"><div><cfif rc.order.totalVATPrice neq "">&pound;#NumberFormat(rc.order.totalVATPrice,"9,999,999.00")#</cfif></div></td>
        </tr>
      </table>
    </div>
    <br class="clearer" />
    <hr />
    <br>
    <br class="clearer" />
  </div>
</cfoutput>
<cfif rc.order.status eq "pending">
<cfif rc.order.recordCount neq 0>
  <div class="ui-widget">
    <div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;">
      <p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
      <strong>Your quote gets saved automatically.</strong></p>
      <p>Each time you add more products to your quotation, they are automatically saved.</p>
      <p>Once you have finished adding items to your quotation you can simply logout or close your browser.</p>
    </div>
  </div>
</cfif>
</cfif>
</form>