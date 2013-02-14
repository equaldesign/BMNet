<div class="btn-group pull-right">
      <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">
        Items per page
        <span class="caret"></span>
      </a>
      <cfoutput>
      <ul class="dropdown-menu">
        <li><a href="/mxtra/shop/product/search?itemsPerPage=5&q=#rc.q#&page=#rc.page#">5 items per page</a></li>
        <li><a href="/mxtra/shop/product/search?itemsPerPage=10&q=#rc.q#&page=#rc.page#">10 items per page</a></li>
        <li><a href="/mxtra/shop/product/search?itemsPerPage=25&q=#rc.q#&page=#rc.page#">25 items per page</a></li>
        <li><a href="/mxtra/shop/product/search?itemsPerPage=50&q=#rc.q#&page=#rc.page#">50 items per page</a></li>
        <li><a href="/mxtra/shop/product/search?itemsPerPage=100&q=#rc.q#&page=#rc.page#">100 items per page</a></li>        
      </ul>
      </cfoutput>
    </div>
    <div class="btn-group pull-right">
      <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="#">
        View Style
        <span class="caret"></span>
      </a>
      <cfoutput>
      <ul class="dropdown-menu">
        <li><a href="/mxtra/shop/product/search?viewMode=list&q=#rc.q#&page=#rc.page#"><i class="icon-view_list"></i> List view</a></li>
        <li><a href="/mxtra/shop/product/search?viewMode=table&q=#rc.q#&page=#rc.page#"><i class="icon-view_table"></i> Table view</a></li>
        <li><a href="/mxtra/shop/product/search?viewMode=grid&q=#rc.q#&page=#rc.page#"><i class="icon-view_grid"></i> Grid view</a></li>
      </ul>
      </cfoutput>
    </div>  