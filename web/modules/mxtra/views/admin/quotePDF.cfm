<cfdocument  format="PDF" pagetype="A4" orientation="portrait" unit="in"
encryption="none" fontembed="Yes" backgroundvisible="Yes" marginbottom="3" overwrite="true" filename="#rc.app.appRoot#/quotations/#rc.id#.pdf">
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
<!---      <div class="invoice_logo_text">
        #rc.sess.mxtra.invoiceAddress#
      </div>--->
    </div>
    <div class="invoiceright">
      <h1>Quotation</h1>
      <p>Page 1 of 1</p>
      <table width="250">
        <tr>
          <td class="tdark"><div>Account No.</div></td>
          <td class="tlight"><div>#rc.order.account_number#</div></td>
        </tr>
        <tr>
          <td class="tdark"><div>Quotation Date</div></td>
          <td class="tlight"><div>#DateFormat(rc.order.date,"DD/MMM/YYY")#</div></td>
        </tr>
        <tr>
          <td class="tdark"><div>Quotation No.</div></td>
          <td class="tlight"><div>#rc.order.shoporderID#</div></td>
        </tr>
      </table>
    </div>
    <br class="clearer" />
    <div class="invoice_header">
      <h2>Turnbull &amp; Co. Ltd</h2>
      <div id="invoice_to">
        <h3>Quotation Prepared For:</h3>
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
            <td class="tdark"><div class="c">EA.</div></td>
            <td class="tdark"><div class="c">PRICE</div></td>
          </tr>
        </thead>
        <tbody>
          <cfloop query="rc.order">
          <tr>
            <td class="c">#itemNo#</td>
            <td class="c">#quantity#</td>
            <td>#full_description#</td>
            <td class="c">#trim(numberFormat(addOverage(quotedPriceEach,rc.overage),"9999.00"))#</td>
            <td class="c">#trim(numberFormat(addOverage(quotedPriceTotal,rc.overage),"9999.00"))#</td>
          </tr>
          </cfloop>
        </tbody>
      </table>
    </div>

    <cfdocumentitem type="footer">
    <link href="http://#cgi.HTTP_HOST#/includes/styles/sites/11/invoicingpdf.css" rel="stylesheet" media="print">
    <div class="invoice_footer">
    <div class="invoice_summary">
      <p>Prices quoted are subject to the current rate of VAT at the time of invoice.</p>
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
          <td class="tlight"><div>&pound;#NumberFormat(addOverage(rc.order.totalItemsPrice,rc.overage),"9,999,999.00")#</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(addOverage(rc.order.totalPrice/100*20,rc.overage),"9,999,999.00")#</div></td>
        </tr>
        </cfoutput>
      </table>
    </div>
    <div class="invoice_total">
      <table>
        <cfoutput>
        <tr>
          <td class="tdark"><div>GOODS TOTAL</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(addOverage(rc.order.totalItemsPrice,rc.overage),"9,999,999.00")#</div></td>
        </tr>
        <tr>
          <td class="tdark"><div>TOTAL INC VAT</div></td>
          <td class="tlight"><div>&pound;#NumberFormat(addOverage(rc.order.totalVATPrice,rc.overage),"9,999,999.00")#</div></td>
        </tr>
        </cfoutput>
      </table>
    </div>
    <br class="clearer" />
    <hr />
    <div class="terms">

      <cfoutput>
    <p>#UCASE("All prices are in Base currency. This transaction is subject to our standard conditions of sale, further copies of which are available on request.")#</p>
    <h4>#UCAsE("Vat registration No: GB 450 0260 04")#</h4>
    </cfoutput>
    </div>
    <div class="branch_address">
      <!---<div class="address">#rc.sess.mxtra.invoiceAddress#</div>--->
    </div>
    <br class="clearer" />
  </div>

    </cfdocumentitem>

</body>
</html>
</cfoutput>
</cfdocument>
<cfscript>
function addOverage(price,perc) {
 return (((price/100)*perc)+price);

}
</cfscript>