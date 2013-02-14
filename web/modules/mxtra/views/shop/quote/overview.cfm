
<cfset basket = getModel("shop/basket").init()>
<cfset basketTotal = basket.getTotalPrice()>
<cfset basketLines = basket.getSize()>
  <div id="basketO" class="quote">
  <cfoutput>
    <h2><a href="/mxtra/account/orderDetail/id/#rc.sess.mxtra.quote.id#">Your Quotation</a></h2>

    Items (#basketLines#)
	</cfoutput>
  </div>