<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/market/item","")>
<cfoutput>
<div class="page-heading">
	<h4>#rc.item.title#</h4>			 			
</div>
<cfif paramValue("rc.item.imageNode","") neq "">
  <img style="margin-right: 5px;" align="left" src="https://www.buildingvine.com/api/i?size=50&nodeRef=#rc.item.imageNode#" alt="" />
<cfelseif ArrayLen(paramValue("rc.item.product.productImage",arrayNew(1))) gte 1>
  <img style="margin-right: 5px;" align="left" src="https://www.buildingvine.com/api/i?size=50&nodeRef=#rc.item.product.productImage[1].nodeRef#" alt="" />
<cfelse>
  <img style="margin-right: 5px;" align="left" src="http://placehold.it/260x180" alt="" />
</cfif>   	              
<h4>&pound;#rc.item.price# <small>per #rc.item.packsizedescription#</small></h4>                  
<a rev="marketplace" target="_blank" href="https://www.buildingvine.com/market/buy?nodeRef=#rc.item.nodeRef#" class="btn btn-mini btn-info">Buy Now</a>
</cfoutput>
