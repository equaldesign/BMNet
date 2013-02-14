<cfset basket = getModel("mxtra.basket")>
<cfset basketTotal = basket.getTotalPrice()>
<cfset basketLines = basket.getSize()>
<Cfset categoryID = event.getValue('categoryID',0)>
<cfset query = event.getValue('query','')>
<!--- <div id="quicksearch">
  <div>
	<cfset sTree = Trim(getModel("shop/category").catTree(categoryID))>
	<form action="/mxtra/shop/search" method="post" style="padding:0; margin:0;">
		<cfoutput><input type="hidden" name="tree" value="#sTree#"></cfoutput>
		<cfoutput><input type="hidden" name="categoryID" value="#categoryID#"></cfoutput>
		<label class="hint over" for="query">Search<cfif categoryID neq 0> within this category</cfif></label>
		<cfoutput><input class="inputshadow" name="query" type="text" id="query" value="#query#" /></cfoutput>
    <input type="image" class="imgbutton" src="/includes/images/turnbull/searchbutton.png" />
	</form>
  </div>
</div> --->
<cfoutput>
  <div id="basketO"  class="basket">
    <span class="hidden-phone">Call us on 01529 303025 | </span><a href="#bsl('/mxtra/shop/basket')#"><i class="icon-basket"></i>Your Basket</a>
    #basketLines# Item<cfif basketLines neq 1>s</cfif>&nbsp;<cfif basketTotal neq 0>|&nbsp;&pound;#DecimalFormat(basketTotal)#&nbsp

			<a href="/mxtra/shop/checkout" class="btn btn-success btn-mini">Checkout &raquo;</a>
	  </cfif>
  </div>
</cfoutput>
