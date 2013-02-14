<cfoutput>
<div class="row">
  <div class="span6 carousel">
  	<cfloop array="#rc.billboards.items#" index="bb">
	    <div class="row">         
	      <div class="span3">
	        <a class="thumbnail">
	        	<cfif paramValue("bb.imageNode","") neq "">
					    <img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#bb.imageNode#" alt="" />
					  <cfelseif ArrayLen(paramValue("bb.product.productImage",arrayNew(1))) gte 1>
					  	<img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#bb.product.productImage[1].nodeRef#" alt="" />
						<cfelse>
							<img src="http://placehold.it/260x180" alt="" />
				    </cfif>        	          
	        </a>
	      </div>
	      <div class="span3">
	        <div class="row">
	          <div class="span4">
	            <h2><a rev="marketplace" href="/bv/market/detail?nodeRef=#bb.nodeRef#">#bb.title#</a></h2>   
	          </div>
	        </div>
	        <div class="row">
	          <div class="span2">
	            <a rev="marketplace" href="/bv/market/buy?nodeRef=#bb.nodeRef#" class="btn btn-large btn-info">Buy Now</a>     
	          </div>
	          <div class="span3">
	            <p>
	            	<img width="25" border="0" class="gravatar" src="http://www.buildingvine.com/includes/images/companies/#bb.site#/small.jpg">
	            	#bb.summary#</p>  
							<h2>&pound;#bb.price# <small>per #bb.packsizedescription#</small></h2>                  
	            <p><span class="label label-success">#bb.stockavailable# #bb.packsizedescription#<cfif bb.stockavailable GT 1>s</cfif> available.</span> <span class="label label-important">#bb.packsize# per #bb.packsizedescription#</span></p> 
	          </div>
	        </div>            
	      </div>          
	    </div>
	  </cfloop>          
  </div>  
</div>
<hr />
<ul class="thumbnails carousel">
  <cfloop array="#rc.features.items#" index="feat">
	<li class="span2">
    <div class="thumbnail">
      <cfif paramValue("feat.imageNode","") neq "">
        <img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#feat.imageNode#" alt="" />
      <cfelseif ArrayLen(paramValue("feat.product.productImage",[])) gte 1>
        <img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#feat.product.productImage[1].nodeRef#" alt="" />
      <cfelse>
        <img src="http://placehold.it/260x180" alt="" />
      </cfif>  
      <div class="caption">
        <h5><a rev="marketplace" href="/bv/market/detail?nodeRef=#feat.nodeRef#">#feat.title#</a></h5>
        <p><img width="25" border="0" class="gravatar" src="http://www.buildingvine.com/includes/images/companies/#feat.site#/small.jpg">#feat.summary#</p>
				<h4>&pound;#feat.price# <small>per #feat.packsizedescription#</small></h4>
        <p><a rev="marketplace" href="/bv/market/buy?nodeRef=#feat.nodeRef#" class="btn btn-small btn-info">Buy</a></p>
      </div>
    </div>
  </li>
  </cfloop>
</ul>   
<hr />
<div id="marketListing" class="ajaxWindow">
#renderView("web/market/layout/#rc.marketLayout#")#
</div>
</cfoutput>