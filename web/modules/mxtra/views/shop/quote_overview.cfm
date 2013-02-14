<cfset quote = getModel("modules.mxtra.model.quote")>
<cfset quoteTotal = quote.getTotalPrice()>
<cfset quoteLines = quote.getSize()>
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
    <h3><a href="/mxtra/shop/quote">Quotation<i class="icon-basket h3"></i></a></h3>
    <cfif quote.id eq 0>
      <a href="/mxtra/shop/quote/new" class="btn btn-success">Start New Quotation &raquo;</a>
    <cfelse>			
	      #quoteLines# Item<cfif quoteLines neq 1>s</cfif>&nbsp;
			<cfif quoteTotal neq 0>|&nbsp;&pound;#DecimalFormat(VATPrice(quoteTotal))#&nbsp	  
		  <div>
		  <br />
				<a href="/mxtra/shop/quote/email" class="btn btn-success">Email &raquo;</a>
		  </div>
		  <cfelse>
		  	  
			</cfif>
		  <br />
		</cfif>		
  </div>  
	
</cfoutput>
 