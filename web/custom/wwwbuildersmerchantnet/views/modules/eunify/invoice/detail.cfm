<cfoutput>
<div class="container">
  <div class="widget">
    <div class="widget-header"><h3>#rc.invoice.name#</h3></div>
    <div class="widget-content">
      <div class="row-fluid">
        <div class="span8">
          <!--- logo --->
        </div>
        <div class="span4">
          <address>
            <strong>eBiz</strong><br />
            Centurion House, London Road<br />
            Staines, Middlesex<br />
            TW18 4AX<br />
            <abbr title="Phone">P:</abbr> (08448) 045046
          </address>
        </div>
      </div>
      <div class="row-fluid">
        <div class="span7">
          <strong>Bill To:</strong><br />
          <address>
          #rc.invoice.name#
          <cfif rc.invoice.delivery_address_1 eq 0 OR rc.invoice.delivery_address_1 eq "">
            <cfif rc.invoice.company_address_1 neq "" AND rc.invoice.company_address_1 neq 0>
              #rc.invoice.company_address_1#<br />
            </cfif>
          <cfelse>
            #rc.invoice.delivery_address_1#<br />
          </cfif>
          <cfif rc.invoice.delivery_address_2 eq 0 OR rc.invoice.delivery_address_2 eq "">
            <cfif rc.invoice.company_address_2 neq "" AND rc.invoice.company_address_2 neq 0>
              #rc.invoice.company_address_2#<br />
            </cfif>
          <cfelse>
            #rc.invoice.delivery_address_2#<br />
          </cfif>
          <cfif rc.invoice.delivery_address_3 eq 0 OR rc.invoice.delivery_address_3 eq "">
            <cfif rc.invoice.company_address_3 neq "" AND rc.invoice.company_address_3 neq 0>
              #rc.invoice.company_address_3#<br />
            </cfif>
          <cfelse>
            #rc.invoice.delivery_address_3#<br />
          </cfif>
          <cfif rc.invoice.delivery_address_4 eq 0 OR rc.invoice.delivery_address_4 eq "">
            <cfif rc.invoice.company_address_4 neq "" AND rc.invoice.company_address_4 neq 0>
              #rc.invoice.company_address_4#<br />
            </cfif>
          <cfelse>
            #rc.invoice.delivery_address_4#<br />
          </cfif>
          <cfif rc.invoice.delivery_address_5 eq 0 OR rc.invoice.delivery_address_5 eq "">
            <cfif rc.invoice.company_address_5 neq "" AND rc.invoice.company_address_5 neq 0>
              #rc.invoice.company_address_5#<br />
            </cfif>
          <cfelse>
            #rc.invoice.delivery_address_5#<br />
          </cfif>
          <cfif rc.invoice.delivery_postcode eq 0 OR rc.invoice.delivery_postcode eq "">
            <cfif rc.invoice.company_postcode neq "" AND rc.invoice.company_postcode neq 0>
              #rc.invoice.company_address_1#<br />
            </cfif>
          <cfelse>
            #rc.invoice.delivery_postcode#<br />
          </cfif>
          </address>
        </div>
        <div class="span5">
          <dl class="dl-horizontal">
            <dt>Invoice ##</dt>
            <dd>#rc.invoice.invoice_number#</dd>
            <dt>Invoice Date</dt>
            <dd>#DateFormat(rc.invoice.invoice_date,"DD/YY/YYYY")#</dd>
            <dt>Due Date</dt>
            <dd>#DateFormat(DateAdd("d",30,rc.invoice.invoice_date),"DD/YY/YYYY")#</dd>
          </dl>
        </div>
      </div>
      <h1 class="page-header">Invoice</h1>
      <table class="table table-bordered table-striped table-rounded">
        <thead>
          <tr>
            <th>Description</th>
            <th>Hours/Qty</th>
            <th>U/M</th>
            <th>Rate</th>
            <th>Amount</th>
          </tr>
        </thead>
        <tbody>
          <cfloop query="rc.invoice">
          <tr>
            <td>#full_description#</td>
            <td>#lineQuantity#</td>
            <td>EA</td>
            <td style="text-align: right">&pound;#decimalFormat(lineGoodsTotal)#</td>
            <td style="text-align: right">&pound;#decimalFormat(lineTotal)#</td>
          </tr>
          </cfloop>
        </tbody>
        <tfoot>
          <tr>
            <th style="text-align:right" colspan="4">TOTAL</th>
            <td style="text-align: right">&pound;#decimalFormat(rc.invoice.invoice_total)#</td>
          </tr>
          <tr>
            <th style="text-align:right" colspan="4">VAT</th>
            <td style="text-align: right">&pound;#decimalFormat(rc.invoice.vat_total)#</td>
          </tr>
          <tr>
            <th style="text-align:right" colspan="4">Balance Due</th>
            <td style="text-align: right">&pound;#decimalFormat(rc.invoice.invoice_total+rc.invoice.vat_total)#</td>
          </tr>
        </tfoot>
      </table>
    <h2>How to pay</h2>
    <h3>By Cheque</h3>
    <p><strong>Cheques in UK Pounds made payable to eBiz</strong></p>
    <h3>By BACS</h3>
    <p><strong>Direct into our Natwest Bank Account:</strong><br />Sort Code: 60-24-77<br />
    Account Number: 18802451</p>
    </div>
  </div>
</div>

</cfoutput>

