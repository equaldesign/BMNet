<div class="container">
  <div class="widget">
    <div class="widget-header"><h3>#rc.item.task.name#</h3></div>
    <div class="widget-content">

    </div>
</div>
<div id="invoice">
  <div class="invoice_logo">
    <cfoutput>
    <div class="invoice_logo_text">
      <p class="bold">Turnbull</p>
    </div>
    </cfoutput>
  </div>
  <div class="invoiceright">
    <h1><cfif rc.invoice.line_total lt 0>Credit<cfelse>Invoice</cfif></h1>
    <p>Page 1 of 1</p>
    <cfoutput>
    <table width="250">
      <tr>
        <td class="tdark"><div>Account No.</div>
        <td class="tlight"><div>#rc.invoice.account_number#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Invoice Date</div>
        <td class="tlight"><div>#DateFormat(rc.invoice.invoice_date,"DD/MMM/YYY")#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Invoice No.</div>
        <td class="tlight"><div>#rc.invoice.branch_id#-#rc.invoice.invoice_number#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Sales Order No.</div>
        <td class="tlight"><div>#rc.invoice.order_number#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Customer Order No.</div>
        <td class="tlight"><div>#rc.invoice.customer_order_number#&nbsp;</div></td>
      </tr>
    </table>
    </cfoutput>
  </div>
  <br class="clearer" />
  <div class="invoice_header">
    <cfoutput><h2>Turnbull</h2></cfoutput>
    <div id="invoice_to">
      <h3><cfif rc.invoice.line_total lt 0>Credit<cfelse>Invoice</cfif> to:</h3>
      <cfoutput>
         <p>#rc.invoice.delivery_name#<br />
            #rc.invoice.company_address_1#
         <cfif rc.invoice.company_address_2 neq " "><br />#rc.invoice.company_address_2#</cfif>
         <cfif rc.invoice.company_address_3 neq " "><br />#rc.invoice.company_address_3#</cfif>
         <cfif rc.invoice.company_address_4 neq " "><br />#rc.invoice.company_address_4#</cfif>
         <cfif rc.invoice.company_address_5 neq " "><br />#rc.invoice.company_address_5#</cfif>
         <br />#rc.invoice.company_postcode#
         </p>
       </cfoutput>
    </div>
    <div id="delivery_address">
      <h3>Delivery Address:</h3>
      <cfoutput>
         <p>#rc.invoice.delivery_name#<br />
              #rc.invoice.delivery_address_1#
         <cfif rc.invoice.delivery_address_2 neq ""><br />#rc.invoice.delivery_address_2#</cfif>
         <cfif rc.invoice.delivery_address_3 neq ""><br />#rc.invoice.delivery_address_3#</cfif>
         <cfif rc.invoice.delivery_address_4 neq ""><br />#rc.invoice.delivery_address_4#</cfif>
         <cfif rc.invoice.delivery_address_5 neq ""><br />#rc.invoice.delivery_address_5#</cfif>
         <br />#rc.invoice.delivery_postcode#
         </p>
       </cfoutput>
    </div>
    <br class="clearer" />
  </div>
  <br class="clearer" />
  <div id="InvoiceDetails">
    <table width="100%">
      <thead>
        <tr>
          <td class="tdark"><div class="c">QTY. ORDER</div></td>
          <td class="tdark"><div class="c">DESCRIPTION</div></td>
          <td class="tdark"><div class="c">UNIT</div></td>
          <td class="tdark"><div class="c">PRICE</div></td>
          <td class="tdark"><div class="c">DISCOUNT %</div></td>
          <td class="tdark"><div class="c">VALUE</div></td>
          <td class="tdark"><div class="c">V</div></td>
        </tr>
      </thead>
      <tbody>
        <cfoutput query="rc.invoice">
        <tr>
          <td class="c">#quantity#</td>
          <td><a href="/products/detail?ID=#product_code#">#full_description#</a></td>
          <td class="c">#UNIT_OF_SALE#</td>
          <td class="c">#trim(numberFormat(line_total/quantity,"9999.00"))# #UNIT_OF_SALE#</td>
          <td class="c"></td>
          <td class="c">#line_total#</td>
          <td class="c">S</td>
        </tr>
        </cfoutput>
      </tbody>
    </table>
  </div>
  <div class="invoice_footer">
    <!---
    <div class="invoice_summary">
      <p>All prices are in Base currency</p>
      <table>
        <tr>
          <td class="tdark"><div>VAT Code</div></td>
          <td class="tdark"><div>VAT Rate</div></td>
          <td class="tdark"><div>Goods Value</div></td>
          <td class="tdark"><div>VAT Value</div></td>
        </tr>
        <cfoutput>
        <tr>
          <td class="tlight"><div>S</div></td>
          <td class="tlight"><div>20.00</div></td>
          <td class="tlight"><div>#rc.invoiceTotal.line_total#</div></td>
          <td class="tlight"><div><cfif rc.invoiceTotal.line_total lt 0>-</cfif> #Trim(NumberFormat(rc.invoiceTotal.vat_total,"9999.00"))#</div></td>
        </tr>
        </cfoutput>
      </table>
    </div>
    <div class="invoice_total">

      <table>
        <cfoutput>
        <tr>
          <td class="tdark"><div>Total Goods</div></td>
          <cftry><td class="tlight"><div>&pound;#rc.invoiceTotal.line_total#</div></td><cfcatch></cfcatch></cftry>
        </tr>
        <tr>
          <td class="tdark"><div>Total VAT</div></td>
          <cftry><td class="tlight"><div>&pound; <cfif rc.invoice.line_total lt 0>-</cfif> #Trim(NumberFormat(rc.invoiceTotal.vat_total,"9999.00"))#</div></td><cfcatch></cfcatch></cftry>
        </tr>
        <tr>
          <td class="tdark"><div>TOTAL</div></td>
          <cftry><td class="tlight"><div>
            &pound;<cfif rc.invoice.line_total lt 0>#rc.invoiceTotal.line_total-rc.invoiceTotal.vat_total#<cfelse>#rc.invoiceTotal.line_total+rc.invoiceTotal.vat_total#</cfif>
            </div></td><cfcatch></cfcatch></cftry>
        </tr>
        </cfoutput>
      </table>
    </div>
    --->
    <br class="clearer" />
    <hr />
    <br>
    <div class="terms">
      <cfoutput>
    <p>#ucase("Cash sale invoices are due for payment on receipt of invoice. Credit account invoices are due for payment by the 28th day of the month following date of dispatch and are subject to any agreed terms. Value added tax is calculated on discounted values and is nett.")#"</p>
    <p>#UCASE("This transaction is subject to our standard conditions of sale, further copies of which are available on request.")#"</p>
    <h4>#UCAsE("Vat registration No: GB 450 0260 04")#</h4>
    </cfoutput>
    </div>
    <div class="branch_address">
      <div class="goods">Goods Supplied From:</div>
      <div class="address"><cfoutput>

      </cfoutput>
      </div>
    </div>
    <br class="clearer" />
  </div>
</div>
<br class="clearer" />