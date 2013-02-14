<cfoutput>
<div id="ippb" class="pull-right btn-group">
  <div class="btn-group">
    <cfset var vm = rc.viewMode>
    <cfset rc.viewMode = "grid">
    <a class="#IIf(vm eq "grid",'"active"','""')# btn btn-mini" href="#bsl('/mxtra/shop/category/#rc.slug#?categoryID=#rc.categoryID#&page=#rc.page#')#"><i class="icon-layout-6"></i></a>
    <cfset rc.viewMode = "list">
    <a class="#IIf(vm eq "list",'"active"','""')# btn btn-mini" href="#bsl('/mxtra/shop/category/#rc.slug#?categoryID=#rc.categoryID#&page=#rc.page#')#"><i class="icon-layout-2"></i></a>
    <cfset rc.viewMode = "table">
    <a class="#IIf(vm eq "table",'"active"','""')# btn btn-mini" href="#bsl('/mxtra/shop/category/#rc.slug#?categoryID=#rc.categoryID#&page=#rc.page#')#"><i class="icon-application-table"></i></a>
    <cfset rc.viewMode = vm>
  </div>
</div>
</cfoutput>