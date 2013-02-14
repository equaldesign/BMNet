<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/market/item","")>
<cfoutput>
<div class="page-header">
  <h3>#rc.item.title#</h3>
</div>
<div class="row">	
  <div style="width: 150px; float: left;">
		<cfif paramValue("rc.item.imageNode","") neq "">
      <img src="https://www.buildingvine.com/api/i?size=150&nodeRef=#rc.item.imageNode#" alt="" />
    <cfelseif ArrayLen(paramValue("rc.item.product.productImage",arrayNew(1))) gte 1>
      <img src="https://www.buildingvine.com/api/i?size=150&nodeRef=#rc.item.product.productImage[1].nodeRef#" alt="" />
    <cfelse>
      <img src="http://placehold.it/260x180" alt="" />
    </cfif> 
    </a>
	</div>	
	<div style="width: 300px; float: left;">
    <h2>&pound;#rc.item.price# <small>per #rc.item.packsizedescription#</small></h2>                  
    <p>#rc.item.summary#</p>  
		<a rev="marketplace" href="/bv/market/buy?nodeRef=#rc.item.nodeRef#" class="btn btn-info">Buy Now</a>
		<p><span class="label label-success">#rc.item.stockavailable# #rc.item.packsizedescription#<cfif rc.item.stockavailable GT 1>s</cfif> available.</span> <span class="label label-important">#rc.item.packsize# per #rc.item.packsizedescription#</span></p>
		<p>#rc.item.description#</p> 
  </div>
</div>
</cfoutput>
