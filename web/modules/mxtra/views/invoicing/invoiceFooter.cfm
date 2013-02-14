<div class="invoice_footer">
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
          <td class="tlight"><div>17.50</div></td>
          <td class="tlight"><div>#rc.invoiceTotal.goods_total#</div></td>
          <td class="tlight"><div>#Trim(NumberFormat(rc.invoiceTotal.vat_total#,"9999.00"))#</div></td>
        </tr>
        </cfoutput>
      </table>
    </div>
    <div class="invoice_total">
      <table>
        <cfoutput>
        <tr>
          <td class="tdark"><div>Total Goods</div></td>
          <td class="tlight"><div>&pound;#rc.invoiceTotal.goods_total##</div></td>
        </tr>
        <tr>
          <td class="tdark"><div>Total VAT</div></td>
          <td class="tlight"><div>&pound;#Trim(NumberFormat(rc.invoiceTotal.vat_total#,"9999.00"))#</div></td>
        </tr>
        <tr>
          <td class="tdark"><div>TOTAL</div></td>
          <td class="tlight"><div>&pound;#gTotal+gVAT#</div></td>
        </tr>
        </cfoutput>
      </table>
    </div>
    <br class="clearer" />
    <hr />
    <div class="terms">
      <cfoutput>
    <p>#ucase("Cash sale invoices are due for payment on receipt of invoice. Credit account invoices are due for payment by the 28th day of the month following date of dispatch and are subject to to any agreed terms. Value added tax is calculated on discounted values and is nett.")#"</p>
    <p>#UCASE("This transaction is ubhect to our standard conditions of sale, further copies of which are available on request.")#"</p>
    <h4>#UCAsE("Vat registration No: GB 450 0260 04")#</h4>
    </cfoutput>
    </div>
    <div class="branch_address">
      <div class="goods">Good Supplied From:</div>
      <div class="address">turnbull & co ltd</div>
    </div>
    <br class="clearer" />
  </div>