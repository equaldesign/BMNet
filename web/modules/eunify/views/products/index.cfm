<!--- just a nice tabbed panel --->
<cfoutput>
<div class="widget-box">
  <div class="widget-title">
    <span class="icon"><i class="icon-drill"></i></span>
    <h5><cfoutput>#rc.product.full_description#</cfoutput></h5>
  </div>
</div>
  <div class="tabs-vertical row-fluid tabs-left">
    <ul class="nav nav-tabs ">
      <li><a class="overview noAjax" href="#bl('products.overview','id=#rc.id#')#"><span><i class="icon-drill"></i>Overview</span></a></li>
      <li><a class="overview noAjax" href="#bl('products.sales','id=#rc.id#')#"><span><i class="icon-chart-pie"></i>Product Sales</span></a></li>
      <li><a class="overview noAjax" href="#bl('products.stock','id=#rc.id#')#"><span><i class="icon-truck-flatbed"></i>Stock Information</span></a></li>
      <li><a class="overview noAjax" href="#bl('products.bv','id=#rc.id#')#"><span><i class="icon-truck-bv"></i>Building Vine</span></a></li>
    </ul>
  </div>
</cfoutput>