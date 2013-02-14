<div class="pull-left hidden-phone btn-group">
  <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
    Items per page
    <span class="caret"></span>
  </a>
  <cfoutput>
  <ul class="dropdown-menu">
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=#rc.viewMode#&itemsPerPage=5&categoryID=#rc.categoryID#&page=#rc.page#">5 items per page</a></li>
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=#rc.viewMode#&itemsPerPage=10&categoryID=#rc.categoryID#&page=#rc.page#">10 items per page</a></li>
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=#rc.viewMode#&itemsPerPage=25&categoryID=#rc.categoryID#&page=#rc.page#">25 items per page</a></li>
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=#rc.viewMode#&itemsPerPage=50&categoryID=#rc.categoryID#&page=#rc.page#">50 items per page</a></li>
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=#rc.viewMode#&itemsPerPage=100&categoryID=#rc.categoryID#&page=#rc.page#">100 items per page</a></li>        
  </ul>
  </cfoutput>
</div> 
<div id="viewStyle" class="pull-left hidden-phone btn-group">
  <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
    View Style
    <span class="caret"></span>
  </a>
  <cfoutput>
  <ul class="dropdown-menu">
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=list&itemsPerPage=#rc.itemsPerPage#&categoryID=#rc.categoryID#&page=#rc.page#"><i class="icon-view_list"></i> List view</a></li>
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=table&itemsPerPage=#rc.itemsPerPage#&categoryID=#rc.categoryID#&page=#rc.page#"><i class="icon-view_table"></i> Table view</a></li>
    <li><a href="/mxtra/shop/category/?brands=#rc.brands#&priceFrom=#rc.priceFrom#&priceTo=#rc.priceTo#&viewMode=grid&itemsPerPage=#rc.itemsPerPage#&categoryID=#rc.categoryID#&page=#rc.page#"><i class="icon-view_grid"></i> Grid view</a></li>
  </ul>
  </cfoutput>
</div>  