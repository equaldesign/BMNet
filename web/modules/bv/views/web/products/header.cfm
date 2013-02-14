<cfoutput>
  <cfif ArrayLen(rc.products.results) gte 1>
  <div class="row">
    <div class="span3 pageCount">
      Showing #rc.products.startRow# to #rc.products.endRow# of #rc.products.products#
    </div>
    <div class="span6">
      #rc.paging.renderit(replace(rc.products.products,",",""),"/bv/products?siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#rc.nodeRef#&page=@page@","ajax")#
    </div>
  </div>
  </cfif>
<div class="btn-toolbar pull-right">
  <div class="btn-group">
    <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="##">Items Per Page<span class="caret"></span></a>
    <ul class="dropdown-menu">
      <li><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&nodeRef=#rc.nodeRef#&maxrows=5")#">5</a></li>
      <li><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&nodeRef=#rc.nodeRef#&maxrows=10")#">10</a></li>
      <li><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&nodeRef=#rc.nodeRef#&maxrows=25")#">25</a></li>
      <li><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&nodeRef=#rc.nodeRef#&maxrows=50")#">50</a></li>
      <li><a href="#bl("products.index","siteID=#request.siteID#&layout=#rc.layout#&nodeRef=#rc.nodeRef#&maxrows=100")#">100</a></li>
    </ul>
  </div>
</div>
<div class="btn-toolbar pull-right">
  <div class="btn-group">
    <a class="btn btn-mini dropdown-toggle" data-toggle="dropdown" href="##">View Type<span class="caret"></span></a>
    <ul class="dropdown-menu">
      <li><a href="#bl("products.index","siteID=#request.siteID#&maxrows=#rc.maxrows#&nodeRef=#rc.nodeRef#&layout=list")#">List View</a></li>
      <li><a href="#bl("products.index","siteID=#request.siteID#&maxrows=#rc.maxrows#&nodeRef=#rc.nodeRef#&layout=grid")#">Grid View</a></li>
    </ul>
  </div>
</div>
<cfif ArrayLen(rc.products.categories) gte 1>
<cfif rc.nodeRef eq 0>
<div class="page-header">
  <h1>Product Categories</h1>
</div>
<cfelse>
<div class="page-header">
  <h1>Sub Categories</h1>
</div>
</cfif>
</cfif>
</cfoutput>