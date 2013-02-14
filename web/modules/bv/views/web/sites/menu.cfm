<div class="navbar">
  <div class="navbar-inner">    
    <ul class="nav">
      <cfoutput>
        <li><a href="/bv/blog?siteID=#request.bvsiteID#" rev="bvMain"><i class="icon-newspaper"></i>News</a></li>
        <li><a href="/bv/products?siteID=#request.bvsiteID#" rev="bvMain"><i class="icon-drill"></i>Products</a></li>
        <li><a href="/bv/documents?siteID=#request.bvsiteID#" rev="bvMain"><i class="icon-document-pdf"></i>Documents</a></li>
        <li><a href="/bv/promotions?siteID=#request.bvsiteID#" rev="bvMain"><i class="icon-store"></i>Promotions</a></li>
      </cfoutput>
    </ul>
  </div>
</div>
<div id="bvMain" class="ajaxWindow">
  <cfoutput>#renderView("web/sites/detail")#</cfoutput>
</div>