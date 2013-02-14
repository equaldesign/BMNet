<cfset totalPrice = showBestPrice(args.Retail_Price,args.Trade,args.web_price,args.web_trade_price,"",0)>
<cfif args.deliveryUnit neq "">
  <cfset thisUnit = args.deliveryUnit>
<cfelse>
  <cfset thisUnit = args.unitDisplay>
</cfif>
<cfoutput>
  <table class="table table-striped table-bordered table-condensed">
    <thead>
      <tr>
        <th>Total</th>
        <th>&pound;/#args.subunit#</th>
        <th>&pound;/#thisUnit#</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>#NumberFormat(args.subsperunit,"999.00")# #args.subunit# Per #thisUnit#</td>
        <td>&pound;#VATPrice(totalPrice/args.subsperunit)# Per #args.subunit#</td>
        <td>&pound;#VATPrice(totalPrice)#</td>
      </tr>
    </tbody>
  </table>
</cfoutput>