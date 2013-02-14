<cfset basket = getModel("basket")>
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
    <h2><a href="/mxtra/shop/basket">Your Basket</a></h2>
    Items (#basketLines#)&nbsp;|&nbsp;Total: &pound;#NumberFormat(VATPrice(basketTotal),"99.00")#&nbsp
  </div>
</cfoutput>
