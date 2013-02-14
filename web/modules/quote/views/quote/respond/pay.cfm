<cfoutput>
<div class="widget widget-table action-table">
  <div class="widget-header">
    <i class="icon-pendingquotes"></i>
    <h3>Products</h3>
  </div>
  <div class="widget-content">
    <table id="quoteTable" class="table table-striped table-bordered">
      <thead>
        <tr>
          <th nowrap="nowrap">Quant.</th>
          <th nowrap="nowrap">Unit</th>
          <th>Product</th>
          <th>Price</th>
        </tr>
      </thead>
      <tbody>
        <cfset t = 1>
        <cfloop query="rc.response.response">
        <tr>
          <td>#quantity#</td>
          <td>#unit#</td>
          <td>#product_name#</td>
          <td>&pound;#price#</td>
        </tr>
        <cfset t+=price>
        </cfloop>
        <tr>
          <td colspan="3">DELIVERY CHARGE</td>
          <td>&pound;#DecimalFormat(rc.response.response.deliveryCharge)#</td>
        </tr>
      </tbody>
      <tfoot>
        <tr>
          <th colspan="3">TOTAL</th>
          <th>&pound;#DecimalFormat(t+rc.response.response.deliveryCharge)#</th>
        </tr>
      </tfoot>
    </table>
  </div> <!-- /widget-content -->
</div>
<cfif rc.response.response.delivered>
<div class="alert alert-success">
  <h3 class="alert-heading">This order will be delivered</h3>
  <p>This order will be delivered on #DateFormatOrdinal(rc.response.response.responseDeliveryDate,"DDDD D MMMM YYYY")#</p>
</div>
<cfelse>
<div class="alert alert-error">
  <h3 class="alert-heading">This order will be NOT delivered</h3>
  <p>This order must be collected</p>
</div>
</cfif>
<cfif rc.response.buyer.id eq request.bmnet.companyID>
  <cfif rc.response.response.paymentMethod eq "paypal">
  <form action="/quote/buy?responseID=#rc.id#" method="post" class="form form-horizontal">
    <div class="widget">
      <div class="widget-header">
        <i class="icon-pendingquotes"></i>
        <h3>Pay now securely</h3>
      </div>
      <div class="widget-content">
        <fieldset>
          <legend>Payment Information</legend>

          <div class="control-group">
            <label class="control-label">
              Card Type
            </label>
            <div class="controls">
              <select name="creditCardType" class="input-small">
                <option value="Visa" selected>Visa</option>
                <option value="MasterCard">MasterCard</option>
                <option value="Discover">Discover</option>
                <option value="Amex">American Express</option>
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Name on Card
            </label>
            <div class="controls">
              <input type="text" name="card_name" value="#rc.response.contact.first_name# #rc.response.contact.surname#">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Card Number
            </label>
            <div class="controls">
              <input type="text" name="card_number" value="">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Security Code
            </label>
            <div class="controls">
              <div class="input-prepend">
                <span class="add-on"><i class="icon-securitycode"></i></span>
                <input type="text" class="input-mini" name="security_code" value="">
              </div>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Valid From
            </label>
            <div class="controls">
              <select name="validFromMonth" class="input-mini">
                <option value="01">01</option>
                <option value="02">02</option>
                <option value="03">03</option>
                <option value="04">04</option>
                <option value="05">05</option>
                <option value="06">06</option>
                <option value="07">07</option>
                <option value="08">08</option>
                <option value="09">09</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
              </select>
              <select name="validFromYear" class="input-small">
                <cfloop from="-7" to="0" index="y">
                  <option value="#DateFormat(DateAdd("y",y,now()),"YYYY")#">#DateFormat(DateAdd("y",y,now()),"YYYY")#</option>
                </cfloop>
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Expiry Date
            </label>
            <div class="controls">
              <select name="validToMonth" class="input-mini">
                <option value="01">01</option>
                <option value="02">02</option>
                <option value="03">03</option>
                <option value="04">04</option>
                <option value="05">05</option>
                <option value="06">06</option>
                <option value="07">07</option>
                <option value="08">08</option>
                <option value="09">09</option>
                <option value="10">10</option>
                <option value="11">11</option>
                <option value="12">12</option>
              </select>
              <select name="validToYear" class="input-small">
                <cfloop from="0" to="7" index="y">
                  <option value="#DateFormat(DateAdd("y",y,now()),"YYYY")#">#DateFormat(DateAdd("y",y,now()),"YYYY")#</option>
                </cfloop>
              </select>
            </div>
          </div>
        </fieldset>
        <fieldset>
          <legend>Billing Information</legend>
          <div class="control-group">
            <label class="control-label">
              Address 1
            </label>
            <div class="controls">
              <input type="text" name="address_1" value="#rc.response.buyer.company_address_1#">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Address 2
            </label>
            <div class="controls">
              <input type="text" name="address_2" value="#rc.response.buyer.company_address_2#">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Address 3
            </label>
            <div class="controls">
              <input type="text" name="address_3" value="#rc.response.buyer.company_address_3#">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Town
            </label>
            <div class="controls">
              <input type="text" name="town" value="#rc.response.buyer.company_address_4#">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              County
            </label>
            <div class="controls">
              <input type="text" name="county" value="#rc.response.buyer.company_address_5#">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">
              Post Code
            </label>
            <div class="controls">
              <input class="input-small" type="text" name="postcode" value="#rc.response.buyer.company_postcode#">
            </div>
          </div>
         </fieldset>
       </div>
       <div class="form-actions">
         <button type="submit" class="btn btn-success btn-large"><i class="icon-tick"></i> Pay and complete this order</button>
       </div>
    </form>
  </cfif>
</cfif>
</cfoutput>