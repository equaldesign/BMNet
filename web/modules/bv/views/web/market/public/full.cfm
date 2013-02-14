<cfset getMyPlugin(plugin="jQuery").getDepends("","secure/market/item","")>
<cfoutput>
<div class="row">
	<div class="span6">
		<div class="page-heading">
			<h1>#rc.item.title#</h1>
			 <cfif rc.item.permissions.edit OR rc.item.permissions.delete>
			 	 <div class="btn-group pull-right">
			      <a class="btn" href="##"><i class="icon-user"></i> Manage this item</a>  
			      <a class="btn dropdown-toggle" data-toggle="dropdown" href="##"><span class="caret"></span></a>
			      <ul class="dropdown-menu">
			        <li><a class="deleteItem" href="/alfresco/service/market/item?nodeRef=#rc.item.nodeRef#&alf_ticket=#request.user_ticket#"><i class="icon-pencil"></i> Edit this item</a></li>
							<li><a class="dialog noAjax" href="/bv/market/embedCode?nodeRef=#rc.item.nodeRef#"><i class="icon-code"></i> Get Embed Code</a></li>
							<cfif rc.item.permissions.delete>
							<li><a class="deleteItem" href="/alfresco/service/market/item?nodeRef=#rc.item.nodeRef#&alf_ticket=#request.user_ticket#"><i class="icon-delete"></i> Delete this item</a></li>
							</cfif>
			      </ul>
			    </div>
			 </cfif>
			
		</div>
	</div>
</div>
<div class="row">
	<div class="span3">
		<a class="thumbnail">
		<cfif paramValue("rc.item.imageNode","") neq "">
      <img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#rc.item.imageNode#" alt="" />
    <cfelseif ArrayLen(paramValue("rc.item.product.productImage",arrayNew(1))) gte 1>
      <img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#rc.item.product.productImage[1].nodeRef#" alt="" />
    <cfelse>
      <img src="http://placehold.it/260x180" alt="" />
    </cfif> 
    </a>
	</div>
	<div class="row">
		<div class="span3">
      <a rev="marketplace" href="/bv/market/buy?nodeRef=#rc.item.nodeRef#" class="btn btn-large btn-info">Buy Now</a>     
    </div>
    <div class="span3">      
      <h2>&pound;#rc.item.price# <small>per #rc.item.packsizedescription#</small></h2>                  
      <p>#rc.item.summary#</p>  
			<p><span class="label label-success">#rc.item.stockavailable# #rc.item.packsizedescription#<cfif rc.item.stockavailable GT 1>s</cfif> available.</span> <span class="label label-important">#rc.item.packsize# per #rc.item.packsizedescription#</span></p>
			<p>#rc.item.description#</p> 
    </div>
		
		<!--- expires --->		 
	</div>
</div>
</cfoutput>
