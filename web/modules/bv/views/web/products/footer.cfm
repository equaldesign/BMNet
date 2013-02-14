<cfoutput>
	<cfif ArrayLen(rc.products.results) gte 1>
  <div class="row-fluid">
    <div class="span4 pageCount">
      Showing #rc.products.startRow# to #rc.products.endRow# of #rc.products.products# Product<cfif rc.products.products neq 1>s</cfif>
    </div>
    <div class="span8">
      #rc.paging.renderit(replace(rc.products.products,",",""),"/bv/products?siteID=#request.bvsiteID#&layout=#rc.layout#&maxrows=#rc.maxrows#&nodeRef=#rc.nodeRef#&page=@page@","ajax")#
    </div>
  </div>
  </cfif>
</cfoutput>

