
<cfoutput>
#getMyPlugin("Paging").renderit(FoundRows=rc.marketItems.total,PagingMaxRows=5,link="/market/list?page=@page@&minPrice=#rc.minPrice#&maxPrice=#rc.maxPrice#")#
<!--- current full list --->
<cfloop array="#rc.marketItems.items#" index="item">
<div class="row">
  <div class="span6">
    <div class="row">
      <div class="span1">
        <a rev="marketplace" href="/bv/market/detail?nodeRef=#item.nodeRef#" class="thumbnail">
          <cfif paramValue("item.imageNode","") neq "">
              <img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#item.imageNode#" alt="" />
            <cfelseif ArrayLen(paramValue("item.product.productImage",arrayNew(1))) gte 1>
              <img src="https://www.buildingvine.com/api/i?size=260&nodeRef=#item.product.productImage[1].nodeRef#" alt="" />
            <cfelse>
              <img src="http://placehold.it/260x180" alt="" />
            </cfif> 
        </a>
      </div>
      <div class="row">
        <div class="span5">
          <h3><a rev="marketplace" href="/bv/market/detail?nodeRef=#item.nodeRef#">#item.title#</p></h3> 
          <img width="25" border="0" class="gravatar" src="http://www.buildingvine.com/includes/images/companies/#item.site#/small.jpg"><a href="/bv/market/buy?nodeRef=#item.nodeRef#" class="btn btn-mini">Buy &raquo;</a>
        </div>            
      </div>
      <div class="span5">                       
        <p>#item.summary#</p>
      </div>
    </div>
  </div>
</div>
<hr />
</cfloop>
</cfoutput>