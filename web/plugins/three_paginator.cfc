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
    <div id="productsCount"><cfoutput>Showing #rc.sRow# - <cfif rc.sRow+4 lt rc.productCount>#rc.sRow+4#<cfelse>#rc.productCount#</cfif> of #rc.productCount# items</cfoutput></div>
    <div id="pageCount">
      <div id="pagedetail"><cfoutput>Page #rc.currentPage# of #rc.pages#</cfoutput></div>
      <div class="pagination">
      	<ul>
		      <cfoutput>
		      <cfif rc.currentPage neq 1>
			  	  <li><a title="first page" href="#durl#categoryID=#rc.categoryID#&sPage=1">&laquo;</a>
					  <li><a title="previous page" href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-1#"><</a></li>
					</cfif>
		        <cfif (rc.currentPage-4) gte 1 AND rc.currentPage eq rc.pages>
		        <li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-4#">#rc.sPage-4#</a></li>
		        </cfif>
		        <cfif (rc.currentPage-3) gte 1 AND rc.currentPage gte (rc.pages-1)>
		        <li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-3#">#rc.sPage-3#</a></li>
		        </cfif>
		        <cfif (rc.currentPage-2) gte 1>
		        <li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-2#">#rc.sPage-2#</a></li>
		        </cfif>
		        <cfif (rc.currentPage-1) gte 1>
		        <li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage-1#">#rc.sPage-1#</a></li>
		        </cfif>
		        <cfif rc.pages gt 1><li><a href="##" class="active">#rc.sPage#</a></cfif>
		        <cfif rc.pages gte rc.sPage+1><li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+1#">#rc.sPage+1#</a></li></cfif>
		        <cfif rc.pages gte rc.sPage+2><li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+2#">#rc.sPage+2#</a></li></cfif>
		        <cfif rc.pages gte rc.sPage+2 AND rc.currentPage lte 2>
		        <li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+3#">#rc.sPage+3#</a></li>
		        </cfif>
		        <cfif rc.pages gt rc.sPage+3 AND rc.currentPage lte 1>
		        <li><a href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+4#">#rc.sPage+4#</a></li>
		        </cfif>
		        <cfif rc.pages gte rc.currentPage+1>
						  <li><a title="next page" href="#durl#categoryID=#rc.categoryID#&sPage=#rc.currentPage+1#">></a></li>
							<li><a title="last page" href="#durl#categoryID=#rc.categoryID#&sPage=#rc.pages#">&raquo;</a></li>
						</cfif>
		      </cfoutput>
        </ul>
      </div>
      <div class="clearer"></div>
    </div>
    <div class="clearer"></div>
  </div>
  </cfsavecontent>
  <cfreturn pager>
  </cffunction>
</cfcomponent>