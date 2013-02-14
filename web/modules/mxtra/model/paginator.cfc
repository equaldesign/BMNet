<cfcomponent name="paginator" hint="Deals with MerchantXtra Categories" extends="coldbox.system.Plugin" cache="false" cachetimeout="0">
  <cffunction name="init" access="public" returntype="paginator" output="false">
        <cfargument name="controller" type="any" required="true">
        <cfset super.Init(arguments.controller)>
        <cfset setpluginName("Template generator")>
        <cfset setpluginVersion("1.0")>
        <cfset setpluginDescription("A Very cool paginator plugin.")>
        <cfreturn this>
  </cffunction>

    <cffunction name="paginate" returntype="string" output="false">
      <cfargument name="durl" required="true" default="/mxtra/shop/category?">
    <cfset var event = controller.getRequestService().getContext()>
    <cfset var rc = event.getCollection()>
    <cfsavecontent variable="pager">
    <div id="productsheader">
    <div id="productsCount"><cfoutput>Showing #rc.sRow# - <cfif rc.sRow+9 lt rc.productCount>#rc.sRow+9#<cfelse>#rc.productCount#</cfif> of #rc.productCount# items</cfoutput></div>
    <div id="pageCount">
      <div id="pagedetail"><cfoutput>Page #rc.currentPage# of #rc.pages#</cfoutput></div>
      <div id="pageselector">
      <cfoutput>
      <cfif rc.currentPage neq 1><a title="first page" href="#durl#categoryID=#rc.categoryID#&sPage=1">&laquo;</a>&nbsp;<a title="previous page" href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-1#"><</a>&nbsp;</cfif>
        <cfif (rc.currentPage-4) gte 1 AND rc.currentPage eq rc.pages>
        <a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-4#">#rc.sPage-4#</a>
        </cfif>
        <cfif (rc.currentPage-3) gte 1 AND rc.currentPage gte (rc.pages-1)>
        <a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-3#">#rc.sPage-3#</a>
        </cfif>
        <cfif (rc.currentPage-2) gte 1>
        <a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-2#">#rc.sPage-2#</a>
        </cfif>
        <cfif (rc.currentPage-1) gte 1>
        <a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-1#">#rc.sPage-1#</a>
        </cfif>
        <cfif rc.pages gt 1>#rc.sPage#</cfif>
        <cfif rc.pages gte rc.sPage+1><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+1#">#rc.sPage+1#</a></cfif>
        <cfif rc.pages gte rc.sPage+2><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+2#">#rc.sPage+2#</a></cfif>
        <cfif rc.pages gte rc.sPage+2 AND rc.currentPage lte 2>
        <a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+3#">#rc.sPage+3#</a>
        </cfif>
        <cfif rc.pages gt rc.sPage+3 AND rc.currentPage lte 1>
        <a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+4#">#rc.sPage+4#</a>
        </cfif>
      <cfif rc.pages gte rc.currentPage+1>&nbsp;<a title="next page" href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+1#">></a>&nbsp;<a title="last page" href="#durl#categoryID=#rc.categoryID#&sPage=#rc.pages#">&raquo;</a></cfif>
      </cfoutput>
      </div>
      <div class="clearer"></div>
    </div>
    <div class="clearer"></div>
  </div>
  <cfoutput>
  <div id="filter">
    <div id="orderBy">
    Order by:
    <cfif rc.sess.mxtra.prefs.orderBy eq "name">
      <span class="byname">name</span> <span class="byprice"><a href="#durl#orderBy=price&categoryID=#rc.categoryID#&sPage=#rc.sPage#">price</a></span>
    <cfelse>
      <span class="byname"><a href="#durl#orderBy=name&categoryID=#rc.categoryID#&sPage=#rc.sPage#">name</a></span><span class="byprice">price</span>
    </cfif>
    </div>
    <div id="orderDir">
    Order direction:
    <cfif rc.sess.mxtra.prefs.orderDir eq "asc">
      <span class="az">A-z/Low-High</a> <span class="za"><a href="#durl#orderDir=desc&categoryID=#rc.categoryID#&sPage=#rc.sPage#">Z-A/High-Low</a></span>
    <cfelse>
      <span class="az"><a href="#durl#orderDir=asc&categoryID=#rc.categoryID#&sPage=#rc.sPage#">A-Z/Low-High</a></span><span class="za">Z-A/High-Low</span>
    </cfif>
    </div>
  </div>
  </cfoutput>
  </cfsavecontent>
  <cfreturn pager>
  </cffunction>
</cfcomponent>