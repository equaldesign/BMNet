<cfset includeUDF('includes/helpers/mxtra.cfm')>
<cfdocument  format="PDF" pagetype="A4" orientation="portrait" unit="in"
encryption="none" fontembed="Yes" backgroundvisible="Yes" marginbottom="3" overwrite="true" filename="#rc.app.appRoot#/sites/#rc.sess.siteID#/mxtra/quotations/#rc.orderID#.pdf">
    <cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link href="http://#cgi.HTTP_HOST#/includes/styles/sites/11/invoicingpdf.css" rel="stylesheet">
<title>Turnbull building Supplies </title>
</head>
<body>
  <div id="invoice">
    <div class="invoice_logo">
    <img src="http://#cgi.HTTP_HOST#/includes/images/turnbull/turnbulllogo.png">
    <div class="invoice_logo_text">
      <p class="bold">Turnbull & Co. Limited</p>
      <p><strong>Registered Office</strong> 95 Southgate, Sleaford, Lincolnshire, NG34 7RQ</p>
      <p><strong>Accounts</strong> Tel: 01529 303025 Fax: 01529 413364</p>
      <p class="small">Registered in England No. 536685</p>
    </div>
  </div>
  <div class="invoiceright">
    <h1>Quotation</h1>
    <p>Page 1 of 1</p>

    <table width="250">
      <tr>
        <td class="tdark"><div>Account No.</div>
        <td class="tlight"><div>#rc.order.accountNumber#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Quotation Date</div>
        <td class="tlight"><div>#DateFormat(rc.order.date,"DD/MMM/YYY")#</div></td>
      </tr>
      <tr>
        <td class="tdark"><div>Quotation No.</div>
        <td class="tlight"><div>#rc.order.shoporderID#</div></td>
      </tr>
    </table>
  </div>
  <br class="clearer" />
  <div class="invoice_header">
    <h2>Turnbull & Co. Ltd</h2>
    <div id="invoice_to">
      <h3>Invoice to:</h3>
         <p>#rc.order.billingContact#<br />
           #rc.order.billingAddress#
         <br />#rc.order.billingPOstCode#
         </p>
    </div>
    <div id="delivery_address">
      <h3>Delivery Address:</h3>
         <p>#rc.order.deliveryContact#<br />
              #rc.order.deliveryAddress#
         <br />#rc.order.deliveryPOstCode#
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
          <td class="tdark"><div class="c">PRICE</div></td>
        </tr>
      </thead>
      <tbody>
        <cfloop query="rc.order">
        <tr>
          <td class="c">#itemNo#</td>
          <td class="c">#quantity#</td>
          <td>#full_description#</td>
          <td class="c">#trim(numberFormat(quotedPriceTotal*1.#rc.overage#,"9999.00"))#</td>
        </tr>
        </cfloop>
      </tbody>
    </table>
  </div>
    <cfdocumentitem type="footer">
      <link href="http://#cgi.HTTP_HOST#/includes/styles/sites/11/invoicingpdf.css" rel="stylesheet" media="print">
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
        <tr>
          <td class="tlight"><div>S</div></td>
          <td class="tlight"><div>20.00</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(rc.order.totalItemsPrice*1.#rc.overage#,"9,999,999.00")#</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(rc.order.totalPrice*1.#rc.overage#/100*20,"9,999,999.00")#</div></td>
        </tr>
      </table>
    </div>
    <div class="invoice_total">
      <p>&nbsp; </p>
      <table>
        <tr>
          <td class="tdark"><div>GOODS TOTAL</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(rc.order.totalItemsPrice*1.#rc.overage#,"9,999,999.00")#</div></td>
        </tr>
        <tr>
          <td class="tdark"><div>DELIVERY</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(rc.order.totalPrice*1.#rc.overage#-rc.order.totalItemsPrice*1.#rc.overage#,"9,999,999.00")#</div></td>
        </tr>
        <tr>
          <td class="tdark"><div>TOTAL INC VAT</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(rc.order.totalVATPrice*1.#rc.overage#,"9,999,999.00")#</div></td>
        </tr>
      </table>
    </div>
    <br class="clearer" />
    <hr />
    <br>
    <div class="terms">
    <p>#ucase("Cash sale invoices are due for payment on receipt of invoice. Credit account invoices are due for payment by the 28th day of the month following date of dispatch and are subject to to any agreed terms. Value added tax is calculated on discounted values and is nett.")#"</p>
    <p>#UCASE("This transaction is ubhect to our standard conditions of sale, further copies of which are available on request.")#"</p>
    <h4>#UCAsE("Vat registration No: GB 450 0260 04")#</h4>
    </div>
    <div class="branch_address">
      <div class="goods">Goods Supplied From:</div>
      <div class="address">turnbull & co ltd</div>
    </div>
    <br class="clearer" />
  </div>
    </cfdocumentitem>
  </div>
  <br class="clearer" />
  </div>
</body>
</html>
</cfoutput>
</cfdocument>