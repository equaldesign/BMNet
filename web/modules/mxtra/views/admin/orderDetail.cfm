<cfset getMyPlugin(plugin="jQuery").getDepends("screenShotPreview,cookie,labelover,tipsy,validate.min,form","sites/#rc.sess.siteID#/turnbull,sites/#rc.sess.siteID#/admin","sites/#rc.sess.siteID#/checkout,sites/#rc.sess.siteID#/style,sites/#rc.sess.siteID#/shop,sites/#rc.sess.siteID#/screenShotPreview")>
<cfif NOT rc.order.quote>
<cfoutput><h2>This order is #rc.order.status# (<a target="_blank" href="/mxtra/admin/orders/orderDetail/id/#rc.order.id#?layout=print">Print</a>)</h2>
<label>Change status to:</label>
<select id="orderStatus" rel="#rc.order.id#">
  <option value="pending" #vm("pending",rc.order.status)#>Pending</option>
  <option value="confirmed" #vm("confirmed",rc.order.status)#>Payment Confirmed</option>
  <option value="cancelled" #vm("cancelled",rc.order.status)#>Cancelled (Payment Declined)</option>
  <option value="shipped" #vm("shipped",rc.order.status)#>Order Shipped</option>
</select>
</cfoutput>
<cfelse>
<cfoutput>
<form action="/mxtra/admin/orders/doQuote/id/#rc.order.id#" method="post">
  <input type="hidden" name="orderID" value="#rc.order.shopOrderID#" />
<h1>Quotation</h1>
<h3>This quotation is #rc.order.status#</h3>
</cfoutput>
</cfif>
<div class="productlist">
      <table class="tableCloth" width="100%" align="center">
        <tr class="basketHeader">
          <th width="60%">Product</th>
          <th>Code</th>
          <th>QTY</th>
          <th>Total</th>
        </tr>
        <cfoutput query="rc.order">
        <tr>
          <td>
            <a href="/mxtra/shop/product?productID=#itemNo#">#Full_Description#</a>
          </td>
          <td>#itemNo#</td>
          <td>#quantity#</td>
          <td nowrap><cfif rc.order.quote>&pound;<input class="add c" name="line_#lineID#" type="text" size="3" value="#quotedPriceTotal#"><cfelse>&pound;#NumberFormat(quotedPriceTotal,"9,999,999.00")#</cfif></td>
        </tr>
        </cfoutput>
        <cfoutput>
        <tr>
          <th class="bold" colspan="3" align="right">TOTAL</th>
          <th id="totalItemsPrice">&pound;#NumberFormat(rc.order.totalItemsPrice,"9,999,999.00")#</th>
        </tr>
        <tr>
          <th class="bold" colspan="3" align="right"><cfif rc.order.quote>DELIVERY<Cfelse>TOTAL + DELIVERY</cfif></th>
          <th><cfif rc.order.quote>&pound;<input class="add d" name="delivery" type="text" size="3" value="#rc.order.totalPrice-rc.order.totalItemsPrice#"><cfelse>&pound;#NumberFormat(rc.order.totalPrice,"9,999,999.00")#</cfif></th>
        </tr>
        <tr>
          <th class="bold" colspan="3" align="right">TOTAL + DELIVERY + VAT</th>
          <th id="totalPrice">&pound;#NumberFormat(VATPRice(rc.order.totalPrice),"9,999,999.00")#</th>
        </tr>
        </cfoutput>
      </table>
</div>
<cfoutput>
<div>
<table width="100%">
<cfif NOT rc.order.quote>
<tr>
  <td colspan="2" valign="top">
    <div class="summary">
      <table class="tableCloth">
      <thead>
        <tr>
          <th colspan="2">Payment Information</th>
        </tr>
      </thead>
        <tbody>
          <tr>
            <td>Card Type:</td>
            <td>#rc.order.paymentType#</td>
          </tr>
          <tr>
            <td>Card name:</td>
            <td>#rc.order.paymentName#</td>
          </tr>
          <cfif rc.order.status is "pending">
          <tr>
            <td>Card Number:</td>
            <td>#rc.order.paymentNumber#</td>
          </tr>
          <tr>
            <td>Start Date:</td>
            <td>#rc.order.paymentStartMonth#/#rc.order.paymentStartYear#</td>
          </tr>
          <tr>
            <td>Expiry Date:</td>
            <td>#rc.order.paymentExpireMonth#/#rc.order.paymentExpireYear#</td>
          </tr>
          <tr>
            <td>Issue Number:</td>
            <td>#rc.order.paymentIssueNumber#</td>
          </tr>
          <tr>
            <td>Security Code:</td>
            <td>#rc.order.paymentSecurityCode#</td>
          </tr>
          </cfif>
        </tbody>
      </table>
    </div>
  </td>
</tr>
</cfif>
<tr>
  <td valign="top">
  <div class="summary">
    <table class="tableCloth">
      <thead>
        <tr>
          <th colspan="2">Billing Information</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Name:</td>
          <td>#rc.order.billingContact#</td>
        </tr>
        <tr>
          <td>Address:</td>
          <td>#rc.order.billingAddress#</td>
        </tr>
        <tr>
          <td>Postcode:</td>
          <td>#rc.order.billingpostCode#</td>
        </tr>
        <tr>
          <td>Phone:</td>
          <td>#rc.order.billingphone#</td>
        </tr>
        <tr>
          <td>Email:</td>
          <td>#rc.order.billingemail#</td>
        </tr>
        <tr>
          <td>Mobile:</td>
          <td>#rc.order.billingmobile#</td>
        </tr>
      </tbody>
    </table>
  </div>
  </td>
  <td valign="top">
  <div class="summary">
    <table class="tableCloth">
      <thead>
        <tr>
          <th colspan="2">Delivery Information</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Name:</td>
          <td>#rc.order.deliveryContact#</td>
        </tr>
        <tr>
          <td>Address:</td>
          <td>#rc.order.deliveryaddress#</td>
        </tr>
        <tr>
          <td>Postcode:</td>
          <td>#rc.order.deliverypostCode#</td>
        </tr>
        <tr>
          <td>Phone:</td>
          <td>#rc.order.deliveryphone#</td>
        </tr>

        <tr>
          <td>Mobile:</td>
          <td>#rc.order.deliverymobile#</td>
        </tr>
      </tbody>
    </table>
  </div>
  </td>
</tr>
</table>
</div>
<cfif rc.order.quote>
  <label for="sendEmail">Send Customer Email?</label>
  <input type="checkbox" name="sendEmail" value="true" />
  <input type="submit" value="Process Quote &raquo;">
</form>
</cfif>
</cfoutput>