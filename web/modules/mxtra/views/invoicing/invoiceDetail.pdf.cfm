<cfoutput>
<cfdocument localurl="false"  format="PDF" pagetype="A4" orientation="portrait" unit="in"
encryption="none" fontembed="Yes" backgroundvisible="Yes" marginbottom="3" margintop="4">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<link href="http://#cgi.HTTP_HOST#/modules/mxtra/includes/style/sites/#request.siteID#/invoicingpdf.css" rel="stylesheet" media="print">
<title>Turnbull building Supplies </title>
</head>
<body >
	<div id="invoice">

    <br class="clearer" />
    <div id="InvoiceDetails">
      <table width="100%">
        <thead>
          <tr>
            <td class="tdark"><div class="c">QTY.</div></td>
            <td class="tdark"><div class="c">DESCRIPTION</div></td>
            <td class="tdark"><div class="c">UNIT</div></td>
            <td class="tdark"><div class="c">PRICE</div></td>
            <td class="tdark"><div class="c">DISCOUNT %</div></td>
            <td class="tdark"><div class="c">VALUE</div></td>
            <td class="tdark"><div class="c">V</div></td>
          </tr>
        </thead>
        <tbody>
          <cfloop query="rc.invoice">
        <tr>
          <td class="c">#lineQuantity#</td>
          <td><a href="/mxtra/shop/product?productID=#product_code#">#full_description#</a></td>
          <td class="c">#UNIT_OF_SALE#</td>
          <td class="c">#trim(decimalFormat(lineGoodsTotal/lineQuantity))# #UNIT_OF_SALE#</td>
          <td class="c"></td>
          <td class="c">#lineGoodsTotal#</td>
          <td class="c">S</td>
        </tr>
        </cfloop>
        </tbody>
      </table>
    </div>
    <cfdocumentitem type="header" evalAtPrint="true">
      <link href="http://#cgi.HTTP_HOST#/modules/mxtra/includes/style/sites/#request.siteID#/invoicingpdf.css" rel="stylesheet" media="print">
      <div class="invoice_logo">
      <img src="http://#cgi.HTTP_HOST#/modules/mxtra/includes/images/sites/#request.siteID#/invoicelogo.png">
      <div class="invoice_logo_text">
        <cfoutput>
        <p><!---#paragraphFormat(rc.sess.mxtra.invoiceAddress)#---></p>
        </cfoutput>
      </div>
      </div>
      <div class="invoiceright">
        <h1><cfif rc.invoice.line_total gte 0>INVOICE<cfelse>CREDIT</cfif></h1>
        <p>Page #CFDocument.currentPageNumber# of #CFDocument.TotalPageCount#</p>

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
      </div>
      <br class="clearer" />
      <div class="invoice_header">
        <h2><cfoutput><h2>Turnbull</h2></cfoutput></h2>
        <div id="invoice_to">
          <h3><cfif rc.invoice.line_total gte 0>Invoice<cfelse>Credit</cfif> to:</h3>
             <p>#rc.invoice.account_name#<br />
                #rc.invoice.company_address_1#
             <cfif rc.invoice.company_address_2 neq " "><br />#rc.invoice.company_address_2#</cfif>
             <cfif rc.invoice.company_address_3 neq " "><br />#rc.invoice.company_address_3#</cfif>
             <cfif rc.invoice.company_address_4 neq " "><br />#rc.invoice.company_address_4#</cfif>
             <cfif rc.invoice.company_address_5 neq " "><br />#rc.invoice.company_address_5#</cfif>
             <br />#rc.invoice.company_postcode#
             </p>
        </div>
        <div id="delivery_address">
          <h3>Delivery Address:</h3>
             <p>#rc.invoice.delivery_name#<br />
                  #rc.invoice.delivery_address_1#
             <cfif rc.invoice.delivery_address_2 neq ""><br />#rc.invoice.delivery_address_2#</cfif>
             <cfif rc.invoice.delivery_address_3 neq ""><br />#rc.invoice.delivery_address_3#</cfif>
             <cfif rc.invoice.delivery_address_4 neq ""><br />#rc.invoice.delivery_address_4#</cfif>
             <cfif rc.invoice.delivery_address_5 neq ""><br />#rc.invoice.delivery_address_5#</cfif>
             <br />#rc.invoice.delivery_postcode#
             </p>
        </div>
        <br class="clearer" />
      </div>
    </cfdocumentitem>

      <cfdocumentitem type="footer" evalAtPrint="true">
      <link href="http://#cgi.HTTP_HOST#/modules/mxtra/includes/style/sites/#request.siteID#/invoicingpdf.css" rel="stylesheet" media="print">
			<cfif CFDocument.currentPageNumber eq CFDocument.TotalPageCount>        
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
            <td class="tlight"><div>#DecimalFormat(rc.invoice.line_total)#</div></td>
            <td class="tlight"><div><cfif rc.invoice.line_total lt 0>-</cfif> #Trim(DecimalFormat(rc.invoice.vat_total))#</div></td>
          </tr>
        </table>
      </div>
      <div class="invoice_total">
        <table>
          <tr>
            <td class="tdark"><div>Total Goods</div></td>
            <td class="tlight"><div>&pound;#DecimalFormat(rc.invoice.line_total)#</div></td>
          </tr>
          <tr>
            <td class="tdark"><div>Total VAT</div></td>
            <td class="tlight"><div>&pound;<cfif rc.invoice.line_total lt 0>-</cfif> #Trim(DecimalFormat(rc.invoice.vat_total))#</div></td>
          </tr>
          <tr>
            <td class="tdark"><div>TOTAL</div></td>
            <td class="tlight"><div>&pound;
              <cfif rc.invoice.line_total lt 0>
              #DecimalFormat(rc.invoice.line_total-rc.invoice.vat_total)#
              <cfelse>
              #DecimalFormat(rc.invoice.line_total+rc.invoice.vat_total)#
              </cfif>
              </div></td>
          </tr>
        </table>
      </div>
      <cfelse>
      <p style="text-align:right;">Continued...</p>
      </cfif>
      <br class="clearer" />
      <hr />
      <br>
      <div class="terms">
      <p>#ucase("Cash sale invoices are due for payment on receipt of invoice. Credit account invoices are due for payment by the 28th day of the month following date of dispatch and are subject to any agreed terms. Value added tax is calculated on discounted values and is nett.")#"</p>
      <p>#UCASE("This transaction is subject to our standard conditions of sale, further copies of which are available on request.")#"</p>
      <h4>#UCAsE("Vat registration No: GB 450 0260 04")#</h4>
      </div>
      <div class="branch_address">
        <div class="goods">Good Supplied From:</div>
        <div class="address"><cfoutput><!---#paragraphFormat(rc.sess.mxtra.invoiceAddress)#---></cfoutput></div>
      </div>
      <br class="clearer" />
    </div>

      </cfdocumentitem>
  	</div>
  	<br class="clearer" />
  </div>
</body>
</html>
</cfdocument>
</cfoutput>