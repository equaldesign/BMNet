<cfset basket = getModel("modules.mxtra.model.basket")>
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
    <h3><a href="/mxtra/shop/basket">Shopping List <i class="icon-list h3"></i></a></h3>
    #basketLines# Item<cfif basketLines neq 1>s</cfif>&nbsp;<cfif basketTotal neq 0>|&nbsp;Around: &pound;#DecimalFormat(VATPrice(basketTotal))#&nbsp
	  
	  <div>
	  <br />
			<a href="/mxtra/shop/checkout" class="btn btn-success">Get total cost &raquo;</a>
	  </div>
	  </cfif>
	  <br />		
  </div>  
	
</cfoutput>
 